#!/bin/bash

# Quick switch to Claude Code
source "$(dirname "$0")/../config/models.conf"

MODEL="${1:-$DEFAULT_CLAUDE_MODEL}"

echo "Switching to Claude Code: ${MODEL}"
claude --model "${MODEL}"
