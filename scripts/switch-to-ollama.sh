#!/bin/bash

# Quick switch to Ollama
source "$(dirname "$0")/../config/models.conf"

MODEL="${1:-$DEFAULT_OLLAMA_MODEL}"

echo "Switching to Ollama: ${MODEL}"
ollama run "${MODEL}"
