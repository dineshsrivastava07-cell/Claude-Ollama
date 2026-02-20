#!/usr/bin/env python3
"""
Gemini CLI Bridge — Translates Anthropic API format → Gemini CLI calls
Sits between LiteLLM proxy and Gemini CLI (OAuth, no API key needed)
Port: 4001
"""

import subprocess
import json
import os
import re
import uuid
import time
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse

GEMINI_AUTH = "GOOGLE_GENAI_USE_GCA=true"

# Model routing based on complexity signals in request
MODEL_MAP = {
    "fast":   "gemini-2.0-flash",
    "pro":    "gemini-2.5-pro",
    "flash3": "gemini-3-flash-preview",
    "pro3":   "gemini-3-pro-preview",
    "default":"gemini-3-flash-preview"
}

def detect_gemini_model(request_body: dict) -> str:
    """Pick Gemini model based on original Claude model requested"""
    model = request_body.get("model", "")
    max_tokens = request_body.get("max_tokens", 1000)

    # Map Claude model names to Gemini equivalents
    if "opus" in model or max_tokens > 8000:
        return MODEL_MAP["pro3"]   # gem3-pro — most capable
    elif "sonnet" in model and max_tokens > 4000:
        return MODEL_MAP["pro"]    # gem-25
    elif "sonnet" in model:
        return MODEL_MAP["flash3"] # gem3
    else:
        return MODEL_MAP["fast"]   # gem-flash

def extract_prompt(request_body: dict) -> str:
    """Extract prompt text from Anthropic messages format"""
    messages = request_body.get("messages", [])
    system = request_body.get("system", "")

    parts = []
    if system:
        parts.append(f"SYSTEM: {system}\n")

    for msg in messages:
        role = msg.get("role", "user")
        content = msg.get("content", "")

        if isinstance(content, list):
            # Handle content blocks
            text_parts = []
            for block in content:
                if block.get("type") == "text":
                    text_parts.append(block.get("text", ""))
            content = " ".join(text_parts)

        if role == "user":
            parts.append(f"USER: {content}")
        elif role == "assistant":
            parts.append(f"ASSISTANT: {content}")

    return "\n".join(parts)

def call_gemini_cli(prompt: str, model: str, max_tokens: int = 4096) -> str:
    """Call Gemini CLI with OAuth auth"""
    # Escape prompt for shell
    safe_prompt = prompt.replace("'", "'\"'\"'")

    cmd = f"{GEMINI_AUTH} gemini -p '{safe_prompt}' --model {model}"

    try:
        result = subprocess.run(
            cmd,
            shell=True,
            capture_output=True,
            text=True,
            timeout=120,
            env={**os.environ, "GOOGLE_GENAI_USE_GCA": "true"}
        )

        if result.returncode == 0:
            return result.stdout.strip()
        else:
            error = result.stderr.strip()
            return f"[Gemini CLI Error]: {error}"

    except subprocess.TimeoutExpired:
        return "[Gemini CLI Error]: Request timed out after 120s"
    except Exception as e:
        return f"[Gemini CLI Error]: {str(e)}"

def build_anthropic_response(text: str, model: str, input_tokens: int = 100) -> dict:
    """Wrap Gemini response in Anthropic API response format"""
    return {
        "id": f"msg_{uuid.uuid4().hex[:24]}",
        "type": "message",
        "role": "assistant",
        "content": [{"type": "text", "text": text}],
        "model": model,
        "stop_reason": "end_turn",
        "stop_sequence": None,
        "usage": {
            "input_tokens": input_tokens,
            "output_tokens": len(text.split())
        }
    }

class GeminiBridgeHandler(BaseHTTPRequestHandler):

    def log_message(self, format, *args):
        """Custom logging"""
        timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
        print(f"[{timestamp}] GEMINI-BRIDGE: {format % args}")

    def send_json(self, status: int, data: dict):
        body = json.dumps(data).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", len(body))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        if self.path == "/health":
            # Check if gemini CLI is available
            result = subprocess.run("which gemini", shell=True, capture_output=True)
            gemini_ok = result.returncode == 0
            self.send_json(200, {
                "status": "healthy" if gemini_ok else "degraded",
                "bridge": "gemini-cli",
                "port": 4001,
                "gemini_cli": "available" if gemini_ok else "not found"
            })
        else:
            self.send_json(404, {"error": "not found"})

    def do_POST(self):
        if self.path in ["/v1/messages", "/messages"]:
            # Anthropic format
            try:
                length = int(self.headers.get("Content-Length", 0))
                body = json.loads(self.rfile.read(length))

                prompt = extract_prompt(body)
                gemini_model = detect_gemini_model(body)
                max_tokens = body.get("max_tokens", 4096)

                print(f"  → [Anthropic fmt] Routing to Gemini model: {gemini_model}")
                print(f"  → Prompt length: {len(prompt)} chars")

                response_text = call_gemini_cli(prompt, gemini_model, max_tokens)
                response = build_anthropic_response(response_text, gemini_model, len(prompt.split()))
                self.send_json(200, response)

            except json.JSONDecodeError:
                self.send_json(400, {"error": "invalid JSON"})
            except Exception as e:
                self.send_json(500, {"error": str(e)})

        elif self.path in ["/v1/chat/completions", "/chat/completions"]:
            # OpenAI format (used by LiteLLM when model=openai/...)
            try:
                length = int(self.headers.get("Content-Length", 0))
                body = json.loads(self.rfile.read(length))

                # Extract prompt from OpenAI messages format
                messages = body.get("messages", [])
                parts = []
                for msg in messages:
                    role = msg.get("role", "user")
                    content = msg.get("content", "")
                    if isinstance(content, list):
                        content = " ".join(b.get("text", "") for b in content if b.get("type") == "text")
                    if role == "system":
                        parts.append(f"SYSTEM: {content}")
                    elif role == "user":
                        parts.append(f"USER: {content}")
                    elif role == "assistant":
                        parts.append(f"ASSISTANT: {content}")
                prompt = "\n".join(parts)

                gemini_model = detect_gemini_model(body)
                max_tokens = body.get("max_tokens", 4096)

                print(f"  → [OpenAI fmt] Routing to Gemini model: {gemini_model}")
                print(f"  → Prompt length: {len(prompt)} chars")

                response_text = call_gemini_cli(prompt, gemini_model, max_tokens)

                # Return in OpenAI chat completions format
                response = {
                    "id": f"chatcmpl-{uuid.uuid4().hex[:24]}",
                    "object": "chat.completion",
                    "created": int(time.time()),
                    "model": gemini_model,
                    "choices": [{
                        "index": 0,
                        "message": {"role": "assistant", "content": response_text},
                        "finish_reason": "stop"
                    }],
                    "usage": {
                        "prompt_tokens": len(prompt.split()),
                        "completion_tokens": len(response_text.split()),
                        "total_tokens": len(prompt.split()) + len(response_text.split())
                    }
                }
                self.send_json(200, response)

            except json.JSONDecodeError:
                self.send_json(400, {"error": "invalid JSON"})
            except Exception as e:
                self.send_json(500, {"error": str(e)})

        else:
            self.send_json(404, {"error": "endpoint not found"})

if __name__ == "__main__":
    port = int(os.environ.get("GEMINI_BRIDGE_PORT", 4001))
    server = HTTPServer(("0.0.0.0", port), GeminiBridgeHandler)
    print(f"🌉 Gemini CLI Bridge running on port {port}")
    print(f"   Auth: Google OAuth (GOOGLE_GENAI_USE_GCA=true)")
    print(f"   Models: flash → flash3 → pro → pro3")
    print(f"   Health: http://localhost:{port}/health")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n🛑 Gemini bridge stopped")
