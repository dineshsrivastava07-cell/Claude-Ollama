#!/bin/bash
# Claude Code Launcher — Full 4-Tier Routing
# T1: Qwen 7B → T2: Qwen 480B → T3: Gemini CLI Bridge → T4: Claude (ask first)

export ANTHROPIC_BASE_URL=http://localhost:4000
export ANTHROPIC_API_KEY=local-4tier-routing-active

CONFIG=~/litellm-proxy/config.yaml
PROXY_PID=~/litellm-proxy/proxy.pid
BRIDGE_PID=~/litellm-proxy/gemini-bridge.pid
LOG=~/litellm-proxy/logs/proxy.log

echo "🔄 Checking 4-Tier infrastructure..."

# Start LiteLLM proxy (T1/T2 routing)
if ! curl -s http://localhost:4000/health > /dev/null 2>&1; then
  echo "  Starting LiteLLM proxy (T1/T2)..."
  UVICORN_LOOP=asyncio nohup litellm --config "$CONFIG" --port 4000 --host 0.0.0.0 > "$LOG" 2>&1 &
  echo $! > "$PROXY_PID"
  sleep 4
fi

# Start Gemini bridge (T3 routing)
if ! curl -s http://localhost:4001/health > /dev/null 2>&1; then
  echo "  Starting Gemini CLI bridge (T3)..."
  nohup python3 ~/litellm-proxy/gemini-bridge/gemini_bridge.py \
    > ~/litellm-proxy/logs/gemini-bridge.log 2>&1 &
  echo $! > "$BRIDGE_PID"
  sleep 2
fi

# Check ollama
OLLAMA_STATUS="✅"
if ! curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
  OLLAMA_STATUS="⚠️  NOT RUNNING (start with: ollama serve)"
fi

# Check gemini CLI
GEMINI_STATUS="✅"
if ! which gemini > /dev/null 2>&1; then
  GEMINI_STATUS="⚠️  NOT FOUND"
fi

echo ""
echo "╔══════════════════════════════════════╗"
echo "║      4-TIER ROUTING ACTIVE           ║"
echo "╠══════════════════════════════════════╣"
echo "║  T1 → Qwen 2.5 Coder 7B   $OLLAMA_STATUS"
echo "║  T2 → Qwen 3 Coder 480B   $OLLAMA_STATUS"
echo "║  T3 → Gemini CLI Bridge    $GEMINI_STATUS"
echo "║  T4 → Claude (ask first)  🔒"
echo "╠══════════════════════════════════════╣"
echo "║  Proxy:  localhost:4000              ║"
echo "║  Bridge: localhost:4001              ║"
echo "╚══════════════════════════════════════╝"
echo ""

claude "$@"
