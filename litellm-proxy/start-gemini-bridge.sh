#!/bin/bash
BRIDGE=~/litellm-proxy/gemini-bridge/gemini_bridge.py
LOG=~/litellm-proxy/logs/gemini-bridge.log
PID_FILE=~/litellm-proxy/gemini-bridge.pid

if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
  echo "✅ Gemini bridge already running (PID: $(cat $PID_FILE))"
  exit 0
fi

# Verify gemini CLI exists
if ! which gemini > /dev/null 2>&1; then
  echo "❌ Gemini CLI not found. Install it first:"
  echo "   npm install -g @google/generative-ai-cli"
  echo "   OR check: https://github.com/google-gemini/gemini-cli"
  exit 1
fi

echo "🌉 Starting Gemini CLI Bridge on port 4001..."
nohup python3 "$BRIDGE" > "$LOG" 2>&1 &
echo $! > "$PID_FILE"
sleep 2

if curl -s http://localhost:4001/health > /dev/null 2>&1; then
  echo "✅ Gemini bridge running (PID: $(cat $PID_FILE))"
  curl -s http://localhost:4001/health | python3 -m json.tool
else
  echo "❌ Bridge failed. Check: $LOG"
fi
