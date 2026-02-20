#!/bin/bash
PID_FILE=~/litellm-proxy/proxy.pid
if [ -f "$PID_FILE" ]; then
  kill $(cat "$PID_FILE") && rm "$PID_FILE"
  echo "🛑 LiteLLM proxy stopped"
else
  echo "⚠️  No proxy running"
fi
