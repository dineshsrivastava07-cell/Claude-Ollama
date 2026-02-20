#!/bin/bash
# 4-Tier LiteLLM Proxy Launcher

LOG=~/litellm-proxy/logs/proxy.log
PID_FILE=~/litellm-proxy/proxy.pid
CONFIG=~/litellm-proxy/config.yaml

# Check if already running
if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
  echo "✅ LiteLLM proxy already running (PID: $(cat $PID_FILE))"
  exit 0
fi

echo "🚀 Starting LiteLLM 4-Tier proxy on port 4000..."
UVICORN_LOOP=asyncio nohup litellm --config "$CONFIG" --port 4000 --host 0.0.0.0 > "$LOG" 2>&1 &
echo $! > "$PID_FILE"
sleep 3

# Verify startup
if curl -s http://localhost:4000/health > /dev/null 2>&1; then
  echo "✅ Proxy running — PID: $(cat $PID_FILE)"
  echo "📋 Logs: $LOG"
else
  echo "❌ Proxy failed to start. Check: $LOG"
fi
