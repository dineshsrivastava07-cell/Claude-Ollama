#!/bin/bash
# Route prompts to Qwen 2.5 Coder via Ollama API
# Usage: qwen-api.sh "your prompt here"

PROMPT="$1"
MODEL="${2:-qwen2.5-coder:7b}"

curl -s http://localhost:11434/api/generate \
  -d "{\"model\": \"$MODEL\", \"prompt\": $(echo "$PROMPT" | jq -Rs .), \"stream\": false}" \
  | jq -r '.response'
