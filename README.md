# Claude Code + Ollama Automation System

## Overview

Complete automation framework for Mac Mini (dsr-ai-lab) that integrates Claude Code with local and cloud AI models via a **LiteLLM proxy interception layer**. All Claude API calls are routed through a local proxy at `localhost:4000`, which dispatches to the correct tier automatically — no Anthropic balance consumed for T1/T2/T3 tasks.

---

## 4-Tier AI Routing System (Hard Mandate — Active Every Session)

All tasks follow a strict escalation path. **Never skip tiers.** Claude (T4) requires explicit user approval every time.

```
Claude Code
    │
    ▼
localhost:4000  ← LiteLLM Proxy (intercepts ALL Anthropic API calls)
    │
    ├── claude-haiku-*   ──→  T1: Qwen 2.5 Coder 7B    @ localhost:11434  (Ollama local)
    │
    ├── claude-sonnet-*  ──→  T2: Qwen 3 Coder 480B    @ localhost:11434  (Ollama cloud)
    │
    ├── claude-opus-4-6  ──→  T3: Gemini CLI Bridge    @ localhost:4001
    │                              └──→ gemini CLI  ──→  Google OAuth  ──→  Response
    │
    └── claude-real-*    ──→  T4: Real Claude (Anthropic API — user approval required)
```

### Tier Definitions

| Tier | Model | Endpoint | Trigger | Cost |
|------|-------|----------|---------|------|
| **T1 DEFAULT** | Qwen 2.5 Coder 7B | `localhost:11434` | Session start, all code/docs/scripts/configs | Free, local |
| **T2 ESCALATION** | Qwen 3 Coder 480B | `localhost:11434` | Complex builds, architecture, multi-file, advanced logic | Free, cloud-routed via Ollama |
| **T3 GEMINI** | Gemini (flash/pro/pro3) | `localhost:4001` → Gemini CLI | Long context, multimodal, complex reasoning, when T2 insufficient | Free, Google OAuth |
| **T4 LAST RESORT** | Claude Opus/Sonnet | Anthropic API | Only after T2+T3 both fail — **user approval required every time** | Paid |

### Escalation Rule
```
T1 → T2 → T3 → T4     (NEVER jump tiers)
```

### Git Commit Attribution
| Model Used | Co-author Tag |
|---|---|
| Qwen 7B | `Co-Authored-By: Qwen 2.5 Coder <ollama@local>` |
| Qwen 480B | `Co-Authored-By: Qwen 3 Coder <ollama@cloud>` |
| Gemini | `Co-Authored-By: Gemini <gemini@google>` |
| Claude | `Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>` |

---

## LiteLLM Proxy + Gemini Bridge (Infrastructure)

### Architecture

The LiteLLM proxy intercepts Claude Code's API calls before they reach Anthropic. Claude Code sets:
```bash
ANTHROPIC_BASE_URL=http://localhost:4000
ANTHROPIC_API_KEY=local-4tier-routing-active
```

LiteLLM maps Claude model names to local models:

```yaml
# T1 — Haiku maps to Qwen 7B
claude-haiku-4-5-20251001  →  ollama/qwen2.5-coder:7b
claude-3-haiku-20240307    →  ollama/qwen2.5-coder:7b

# T2 — Sonnet maps to Qwen 480B
claude-3-5-sonnet-20241022 →  ollama/qwen3-coder:480b-cloud
claude-sonnet-4-6          →  ollama/qwen3-coder:480b-cloud

# T3 — Opus routes to Gemini CLI Bridge
claude-opus-4-6            →  openai/gemini-proxy @ localhost:4001

# T4 — Real Claude (needs REAL_ANTHROPIC_KEY env var set)
claude-real-fallback        →  anthropic/claude-sonnet-4-6
```

### Gemini CLI Bridge (Port 4001)

The bridge (`litellm-proxy/gemini-bridge/gemini_bridge.py`) is a lightweight HTTP server that:
- Accepts both **Anthropic format** (`/v1/messages`) and **OpenAI format** (`/v1/chat/completions`)
- Converts the request to a `gemini -p "..."` CLI call using Google OAuth (no API key)
- Auto-selects Gemini model based on request complexity:

| Condition | Gemini Model Selected |
|---|---|
| `opus` in model name OR `max_tokens > 8000` | `gemini-3-pro-preview` |
| `sonnet` + `max_tokens > 4000` | `gemini-2.5-pro` |
| `sonnet` model | `gemini-3-flash-preview` |
| Default / haiku | `gemini-2.0-flash` |

### Service Ports

| Service | Port | Process |
|---|---|---|
| Ollama | `11434` | `ollama serve` |
| LiteLLM Proxy | `4000` | `litellm --config config.yaml` |
| Gemini CLI Bridge | `4001` | `python3 gemini_bridge.py` |

---

## Quick Start

### Launch Claude Code with Full 4-Tier Routing

```bash
claude-local
```

This alias (from `~/litellm-proxy/claude-local.sh`):
1. Starts LiteLLM proxy on `:4000` (if not already running)
2. Starts Gemini CLI Bridge on `:4001` (if not already running)
3. Verifies Ollama at `:11434`
4. Sets `ANTHROPIC_BASE_URL` + `ANTHROPIC_API_KEY`
5. Launches `claude`

### Manual Service Control

```bash
# Proxy (T1/T2)
proxy-start           # Start LiteLLM proxy on :4000
proxy-stop            # Stop proxy
proxy-logs            # Tail live proxy logs

# Gemini Bridge (T3)
gemini-bridge-start   # Start Gemini CLI bridge on :4001
gemini-bridge-stop    # Stop bridge
gemini-bridge-logs    # Tail bridge logs
```

### Health Checks

```bash
curl http://localhost:4000/health   # LiteLLM proxy
curl http://localhost:4001/health   # Gemini bridge
curl http://localhost:11434/api/tags  # Ollama
```

---

## Installation

### Prerequisites

- macOS 12.0+, Mac Mini (M1+), 16GB+ RAM, 50GB+ disk
- Ollama installed: `/usr/local/bin/ollama`
- Gemini CLI installed: `/opt/homebrew/bin/gemini` (Google OAuth authenticated)
- Python 3.10+ (Python 3.14 supported — uvloop patch included)
- Node.js 18+ (for Claude Code CLI)

### Install Dependencies

```bash
pip install 'litellm[proxy]' httpx
# Note: uvloop is auto-patched for Python 3.14 compatibility
```

### Deploy from Repo

```bash
git clone https://github.com/dineshsrivastava07-cell/Claude-Ollama.git ~/Claude-Ollama
cd ~/Claude-Ollama

# Run master deployment
chmod +x deploy-claude-ollama.sh
./deploy-claude-ollama.sh

# Copy litellm proxy to home
cp -r litellm-proxy ~/litellm-proxy
chmod +x ~/litellm-proxy/*.sh

# Authenticate Claude
claude auth login

# Authenticate Gemini (Google OAuth)
gem-login

# Add aliases
cat >> ~/.zshrc << 'EOF'
alias claude-local="~/litellm-proxy/claude-local.sh"
alias proxy-start="~/litellm-proxy/start-proxy.sh"
alias proxy-stop="~/litellm-proxy/stop-proxy.sh"
alias proxy-logs="tail -f ~/litellm-proxy/logs/proxy.log"
alias gemini-bridge-start="~/litellm-proxy/start-gemini-bridge.sh"
alias gemini-bridge-stop="~/litellm-proxy/stop-gemini-bridge.sh"
alias gemini-bridge-logs="tail -f ~/litellm-proxy/logs/gemini-bridge.log"
EOF
source ~/.zshrc
```

### Start the System

```bash
claude-local
```

---

## Usage

### All Shell Aliases

#### Claude Code Launcher
```bash
claude-local          # Launch Claude Code with full 4-tier routing
```

#### Proxy Control
```bash
proxy-start           # Start LiteLLM proxy (:4000)
proxy-stop            # Stop proxy
proxy-logs            # Live proxy log stream
```

#### Gemini Bridge Control
```bash
gemini-bridge-start   # Start Gemini CLI bridge (:4001)
gemini-bridge-stop    # Stop bridge
gemini-bridge-logs    # Live bridge log stream
```

#### Ollama Direct (bypass proxy)
```bash
ol-qwen               # Qwen 2.5 Coder 7B
ol-llama              # Llama 3.1 8B
ol-phi                # Phi 3.5
ol-gemma              # Gemma 3 4B
ol-mistral            # Mistral 7B
```

#### Gemini CLI Direct (bypass proxy)
```bash
gem-flash "prompt"    # gemini-2.0-flash — fast
gem-25 "prompt"       # gemini-2.5-pro — advanced
gem3 "prompt"         # gemini-3-flash-preview
gem3-pro "prompt"     # gemini-3-pro-preview — most capable
```

#### Automation
```bash
code-review /path     # Automated code review
gen-docs /path        # Generate documentation
refactor /path        # Refactor code
co                    # Main Claude-Ollama menu
co-status             # System status
co-models             # List all models
co-help               # Help
```

---

## Workflow Examples

### Example 1: Full Development Workflow

```bash
# Launch with full routing active
claude-local

# Claude Code now routes automatically:
# Simple tasks   → T1 (Qwen 7B, haiku model)
# Complex tasks  → T2 (Qwen 480B, sonnet model)
# Very complex   → T3 (Gemini, opus model)
# Last resort    → T4 (Claude, ask user first)
```

### Example 2: Quick Bug Fix (T1 stays local)

```bash
claude-local
# "Fix the TypeError in auth.py line 42"
# Routes via haiku → T1 Qwen 7B — local, private, instant
```

### Example 3: Multi-file Architecture (T1 → T2)

```bash
claude-local
# "Design and implement a full RAG pipeline with vector store"
# Claude Code uses sonnet model → T2 Qwen 480B
```

### Example 4: Long Context / Multimodal (T3 Gemini)

```bash
claude-local
# "Analyze this 200-page codebase and design a refactor plan"
# Routes via opus → T3 Gemini Bridge → gemini-3-pro-preview (1M context)
```

### Example 5: Offline / Air-gapped

```bash
ol-qwen     # Direct Ollama — no proxy, no internet
# All computation stays on-device
```

---

## Directory Structure

```
~/Claude-Ollama/
├── litellm-proxy/                    # 4-Tier routing infrastructure
│   ├── config.yaml                  # LiteLLM model routing config
│   ├── start-proxy.sh               # Start LiteLLM on :4000
│   ├── stop-proxy.sh                # Stop LiteLLM proxy
│   ├── claude-local.sh              # Claude Code launcher (full 4-tier)
│   ├── start-gemini-bridge.sh       # Start Gemini bridge on :4001
│   ├── stop-gemini-bridge.sh        # Stop Gemini bridge
│   ├── gemini-bridge/
│   │   └── gemini_bridge.py         # Gemini CLI bridge server
│   └── logs/                        # Runtime logs (gitignored)
│       ├── proxy.log
│       └── gemini-bridge.log
├── config/                          # System configuration
│   ├── models.conf                  # Model definitions
│   ├── settings.conf                # System settings
│   └── mcp-servers.json             # MCP configuration
├── scripts/                         # Automation scripts
│   ├── claude-ollama.sh             # Main interface
│   ├── auto-code-review.sh
│   ├── auto-generate-docs.sh
│   └── auto-refactor.sh
├── mcp-servers/                     # MCP server integrations
├── logs/                            # Session logs
├── workspace/                       # Working directory
├── templates/                       # Project templates
├── tools/                           # Additional tools
├── README.md                        # This file
└── QUICKSTART.md                    # Quick start guide
```

---

## Configuration

### LiteLLM Proxy Config (`litellm-proxy/config.yaml`)

```yaml
litellm_settings:
  drop_params: true
  set_verbose: false

model_list:
  # T1 — Qwen 7B (default, local)
  - model_name: claude-haiku-4-5-20251001
    litellm_params:
      model: ollama/qwen2.5-coder:7b
      api_base: http://localhost:11434

  # T2 — Qwen 480B (escalation, cloud)
  - model_name: claude-sonnet-4-6
    litellm_params:
      model: ollama/qwen3-coder:480b-cloud
      api_base: http://localhost:11434

  # T3 — Gemini via CLI Bridge
  - model_name: claude-opus-4-6
    litellm_params:
      model: openai/gemini-proxy
      api_base: http://localhost:4001
      api_key: gemini-bridge-local

  # T4 — Real Claude (set REAL_ANTHROPIC_KEY env var)
  - model_name: claude-real-fallback
    litellm_params:
      model: anthropic/claude-sonnet-4-6
      api_key: os.environ/REAL_ANTHROPIC_KEY
```

### System Settings (`config/settings.conf`)

```bash
WORKSPACE_DIR="/Users/dsr-ai-lab/Claude-Ollama/workspace"
VERBOSE_LOGGING=false
LOG_RETENTION_DAYS=30
AUTO_UPDATE=true
```

---

## MCP Server Integration

Model Context Protocol servers extend Claude Code with additional capabilities:

| Server | Capability |
|---|---|
| **Filesystem** | Read/write files, list directories |
| **Git** | Repository operations, commits, history |
| **Memory** | Persistent context storage across sessions |

Config: `~/Claude-Ollama/config/mcp-servers.json`

---

## Security

- **T1 (Qwen 7B)** — fully local, data never leaves device
- **T2 (Qwen 480B)** — cloud-routed via Ollama; review sensitive data before sending
- **T3 (Gemini)** — Google OAuth, no API key; respect data privacy
- **T4 (Claude)** — Anthropic cloud; only with explicit user approval
- No plaintext passwords in config files — use macOS Keychain or env vars
- Never commit credentials to version control
- `REAL_ANTHROPIC_KEY` set via environment variable only, never in config files

---

## Troubleshooting

### Proxy won't start (Python 3.14 + uvloop)

The `uvloop` package is incompatible with Python 3.14. Fix (already applied in this repo):

```python
# /Library/Frameworks/Python.framework/.../uvicorn/loops/uvloop.py
import asyncio
def uvloop_setup(use_subprocess: bool = False) -> None:
    asyncio.set_event_loop_policy(asyncio.DefaultEventLoopPolicy())
```

Or uninstall uvloop: `pip uninstall uvloop`

### Services not running

```bash
ollama serve                    # Start Ollama
proxy-start                     # Start LiteLLM proxy
gemini-bridge-start             # Start Gemini bridge
```

### Gemini bridge errors

```bash
gemini-bridge-logs              # Check live logs
curl http://localhost:4001/health   # Verify health
which gemini                    # Confirm CLI installed
```

### Claude Code not routing through proxy

Ensure env vars are set:
```bash
export ANTHROPIC_BASE_URL=http://localhost:4000
export ANTHROPIC_API_KEY=local-4tier-routing-active
# Or just use: claude-local
```

### Shell commands not found

```bash
source ~/.zshrc
```

### Ollama model not found

```bash
ollama list
ollama pull qwen2.5-coder:7b
ollama pull qwen3-coder:480b-cloud
```

---

## Model Selection Guide

| Task | Tier | Model | Why |
|---|---|---|---|
| Scripts, configs, schemas | **T1** | Qwen 7B | Fast, local, free |
| Quick code gen, bug fixes | **T1** | Qwen 7B | Handles easily |
| Git, DevOps, docs | **T1** | Qwen 7B | Standard tasks |
| Multi-file module builds | **T2** | Qwen 480B | Complex reasoning |
| Architecture decisions | **T2** | Qwen 480B | Advanced logic |
| ML logic, E2E wiring | **T2** | Qwen 480B | Deep understanding |
| Long context (>32K), multimodal | **T3** | Gemini Pro | 1M context window |
| Complex agent tasks | **T3** | Gemini Pro | Strong reasoning |
| T2+T3 both insufficient | **T4** | Claude | Last resort, ask user |
| Offline / air-gapped | — | Llama/Phi direct | No network needed |

---

## System Requirements

### Hardware
- Mac Mini (M1 or later)
- 16GB+ RAM recommended
- 50GB+ free disk space

### Software
- macOS 12.0+
- Python 3.10+ (3.14 supported)
- Node.js 18+
- Homebrew
- Ollama (models pre-installed)
- Gemini CLI (Google OAuth authenticated)

### Pre-installed Ollama Models
| Model | Alias | Tier |
|---|---|---|
| `qwen2.5-coder:7b` | `ol-qwen` | T1 default |
| `qwen3-coder:480b-cloud` | — | T2 escalation |
| `llama3.1:8b-instruct-q4_K_M` | `ol-llama` | Alt local |
| `phi3.5:latest` | `ol-phi` | Alt local |
| `gemma3:4b` | `ol-gemma` | Alt local |
| `mistral:7b-instruct` | `ol-mistral` | Alt local |

---

## Documentation

- **Quick Start**: `~/Claude-Ollama/QUICKSTART.md`
- **MCP Servers**: `~/Claude-Ollama/mcp-servers/README.md`
- **Proxy Config**: `~/Claude-Ollama/litellm-proxy/config.yaml`
- **External**: [Claude Docs](https://docs.anthropic.com) · [Ollama Docs](https://ollama.ai/docs) · [LiteLLM Docs](https://docs.litellm.ai)

---

## License

This automation framework is provided as-is for personal use on Mac Mini (dsr-ai-lab).

## System Information

- **Machine**: Mac Mini — dsr-ai-lab (Apple Silicon)
- **User**: Dinesh Srivastava
- **Installation**: `/Users/dsr-ai-lab/Claude-Ollama`
- **Proxy**: `~/litellm-proxy/` (symlinked from repo)
- **Ollama Models**: `/Users/dsr-ai-lab/.ollama/models`

---

**Version**: 2.0.0
**Date**: February 2026
**Status**: Production Ready
**Routing**: 4-Tier (Qwen 7B → Qwen 480B → Gemini CLI → Claude)
**Proxy**: LiteLLM @ localhost:4000 + Gemini Bridge @ localhost:4001
