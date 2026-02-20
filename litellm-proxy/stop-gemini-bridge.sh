#!/bin/bash
PID_FILE=~/litellm-proxy/gemini-bridge.pid
if [ -f "$PID_FILE" ]; then
  kill $(cat "$PID_FILE") && rm "$PID_FILE"
  echo "🛑 Gemini bridge stopped"
else
  echo "⚠️  No bridge running"
fi
