# Claude Code + Ollama Automation System

## 🎯 Overview

Complete automation framework for Mac Mini (dsr-ai-lab) that integrates Claude Code (Pro subscription) with Ollama local models, providing seamless AI-powered development environment with full terminal access.

## ✨ Features

### 🤖 3-Tier AI Routing System
- **Tier 1 — Qwen 2.5 Coder 7B** (Local): Default for all tasks — fast, free, private
- **Tier 2 — Qwen 3 Coder 480B** (Cloud via Ollama): Escalation for complex tasks — near Opus-level reasoning
- **Tier 3 — Claude Opus/Sonnet** (Cloud): Last resort — only with explicit user approval
- **Also available** (Local): Llama 3.1, Phi 3.5, Gemma, Mistral

### 🚀 Automation Capabilities
- **Code Review**: Automated comprehensive code analysis
- **Documentation**: Auto-generate project docs
- **Refactoring**: Intelligent code improvements
- **Testing**: Automated test execution
- **Deployment**: Streamlined deployment workflows

### 🔧 System Integration
- **Full Mac Access**: Complete terminal and system access
- **Model Switching**: Seamless switching between models
- **MCP Servers**: Extended capabilities via Model Context Protocol
- **Logging**: Comprehensive session tracking
- **CLI Interface**: User-friendly command-line menu

## 📦 Package Contents

```
claude-ollama-automation/
├── deploy-claude-ollama.sh              # Master deployment script
├── setup-claude-ollama-automation.sh    # Main setup script
├── advanced-automation.sh               # Advanced task automation
├── mcp-integration.sh                   # MCP server setup
├── QUICKSTART.md                        # Quick start guide
└── README.md                            # This file
```

## 🚀 Quick Installation

### Method 1: Direct Deployment (Recommended)

1. **Transfer files to Mac Mini** (use AirDrop, USB, or network):
   ```bash
   # Create deployment directory
   mkdir -p ~/claude-ollama-deploy
   cd ~/claude-ollama-deploy
   
   # Copy all files to this directory
   ```

2. **Run master deployment**:
   ```bash
   chmod +x deploy-claude-ollama.sh
   ./deploy-claude-ollama.sh
   ```

3. **Follow prompts** - the script will:
   - Verify system
   - Install dependencies
   - Configure Claude Code
   - Setup Ollama integration
   - Create automation framework
   - Install MCP servers
   - Configure shell

4. **Authenticate Claude**:
   ```bash
   claude auth login
   ```

5. **Reload shell**:
   ```bash
   source ~/.zshrc
   ```

6. **Launch**:
   ```bash
   co
   ```

### Method 2: Manual Installation

If you prefer to install components individually:

```bash
# 1. Main setup
chmod +x setup-claude-ollama-automation.sh
./setup-claude-ollama-automation.sh

# 2. Advanced automation
cp advanced-automation.sh ~/Claude-Ollama/scripts/
chmod +x ~/Claude-Ollama/scripts/advanced-automation.sh

# 3. MCP integration
chmod +x mcp-integration.sh
./mcp-integration.sh

# 4. Copy documentation
cp QUICKSTART.md ~/Claude-Ollama/

# 5. Reload shell
source ~/.zshrc
```

## 📖 Usage

### Main Interface

Launch the main menu:
```bash
co
```

Or use the desktop shortcut: **Claude-Ollama.command**

### Quick Commands

#### Model Switching
```bash
# Claude models
cc-opus          # Most capable
cc-sonnet        # Balanced (default)
cc-haiku         # Fastest

# Ollama models (local)
ol-qwen          # Best for coding
ol-llama         # General purpose
ol-phi           # Efficient
ol-gemma         # Lightweight
ol-mistral       # Strong general
```

#### Automation
```bash
code-review /path/to/project     # Automated code review
gen-docs /path/to/project        # Generate documentation
refactor /path/to/file.py        # Refactor code
```

#### System Info
```bash
co-status        # System status
co-models        # List all models
co-help          # Show help
```

## 🎯 Workflow Examples

### Example 1: Full Development Workflow (3-Tier)

```bash
# 1. Scaffold with Tier 1 (Qwen 7B — local, fast)
ol-qwen
# "Generate a FastAPI project structure with auth endpoints"

# 2. Complex architecture — escalate to Tier 2 (Qwen 480B)
# Route via Ollama API: model=qwen3-coder:480b-cloud
# "Design the auth middleware, JWT flow, and RBAC system"

# 3. Review & document with Tier 1
code-review ~/projects/api
gen-docs ~/projects/api

# 4. Only if Qwen can't handle it → Tier 3 (Claude, with approval)
cc-opus  # Rare — deep security audit, advanced multi-step reasoning
```

### Example 2: Quick Bug Fix (Tier 1 Only)

```bash
# Analyze and fix with Qwen 7B
ol-qwen
# Paste error and code — Qwen handles most bug fixes

# Test
pytest
```

### Example 3: Complex Module Build (Tier 1 → Tier 2)

```bash
# Start with Tier 1 — scaffold files
ol-qwen
# "Generate signal extraction engine with event consumers"

# Escalate to Tier 2 — refine complex logic
# Route: qwen3-coder:480b-cloud
# "Design confidence scoring algorithm with weighted signals"

# Review with Tier 1
code-review ~/projects/synaptiq
```

## 🛠️ Configuration

### 3-Tier Model Routing (Mandatory)

All tasks follow a strict escalation path: **Tier 1 → Tier 2 → Tier 3**

```
┌─────────────────────────────────────────────────────────────────┐
│                   3-TIER MODEL ROUTING                          │
├──────────┬──────────────────────────┬──────────────────────────┤
│  TIER 1  │  Qwen 2.5 Coder 7B      │  DEFAULT — all tasks     │
│  (Local) │  localhost:11434          │  code, docs, scripts,    │
│          │                          │  configs, schemas, Q&A   │
├──────────┼──────────────────────────┼──────────────────────────┤
│  TIER 2  │  Qwen 3 Coder 480B      │  ESCALATION — complex    │
│  (Cloud) │  localhost:11434          │  multi-file builds,      │
│          │                          │  architecture, advanced  │
│          │                          │  logic, signal extraction│
├──────────┼──────────────────────────┼──────────────────────────┤
│  TIER 3  │  Claude Opus / Sonnet    │  LAST RESORT — only      │
│  (Cloud) │  Anthropic API           │  when Tier 2 fails,      │
│          │                          │  requires user approval  │
└──────────┴──────────────────────────┴──────────────────────────┘
```

Edit: `~/Claude-Ollama/config/models.conf`

```bash
# 3-Tier Routing
TIER1_MODEL="qwen2.5-coder:7b"          # Default — local, fast
TIER2_MODEL="qwen3-coder:480b-cloud"    # Escalation — cloud, powerful
TIER3_MODEL="claude-sonnet-4-5-20250929" # Last resort — user approval required
```

### System Settings

Edit: `~/Claude-Ollama/config/settings.conf`

```bash
# Workspace
WORKSPACE_DIR="/Users/dsr-ai-lab/Claude-Ollama/workspace"

# Logging
VERBOSE_LOGGING=false
LOG_RETENTION_DAYS=30

# Auto-update
AUTO_UPDATE=true
```

## 🔌 MCP Server Integration

Model Context Protocol servers extend Claude Code with additional capabilities:

### Available MCP Servers

- **Filesystem**: Read/write files, list directories
- **Git**: Repository operations, commits, history
- **GitHub**: Issues, PRs, repository management
- **Database**: PostgreSQL, SQLite support
- **Web**: Brave Search, Puppeteer automation
- **Communication**: Slack integration
- **Memory**: Persistent context storage

### Configuration

Edit: `~/Claude-Ollama/config/mcp-servers.json`

See: `~/Claude-Ollama/mcp-servers/README.md` for details

## 📊 Directory Structure

```
~/Claude-Ollama/
├── config/                  # Configuration files
│   ├── models.conf         # Model definitions
│   ├── settings.conf       # System settings
│   └── mcp-servers.json    # MCP configuration
├── scripts/                 # Automation scripts
│   ├── claude-ollama.sh    # Main interface
│   ├── switch-to-claude.sh # Claude switcher
│   ├── switch-to-ollama.sh # Ollama switcher
│   ├── auto-code-review.sh # Code review
│   ├── auto-generate-docs.sh # Documentation
│   └── auto-refactor.sh    # Refactoring
├── logs/                    # Session logs
├── workspace/              # Working directory
├── templates/              # Project templates
├── tools/                  # Additional tools
├── mcp-servers/            # MCP server integrations
│   ├── custom-server/     # Custom server template
│   └── README.md          # MCP documentation
├── README.md              # Main documentation
└── QUICKSTART.md          # Quick start guide
```

## 🔐 Security

### Credentials
- User: `dsr-ai-lab`
- No plaintext passwords in config files — use macOS Keychain or env vars
- Keep config files secure (chmod 600)

### Best Practices
1. Use Tier 1 (Qwen 7B local) for sensitive/private code — never leaves your machine
2. Tier 2 (Qwen 480B cloud) — review what you send, it's cloud-routed
3. Tier 3 (Claude) — only with approval, for non-sensitive tasks
4. Review generated code before execution
5. Keep logs for audit trail
6. Never commit credentials to version control

## 🔍 System Requirements

### Hardware
- Mac Mini (M1 or later recommended)
- 16GB+ RAM recommended
- 50GB+ free disk space

### Software
- macOS 12.0 or later
- Homebrew (auto-installed)
- Node.js 18+ (auto-installed)
- Claude Code CLI (auto-installed)
- Ollama with models (pre-installed)

### Pre-installed Ollama Models
- qwen2.5-coder:7b (Tier 1 — default)
- qwen3-coder:480b-cloud (Tier 2 — escalation)
- llama3.1:8b
- phi3.5
- gemma2:2b
- mistral:7b

## 🚨 Troubleshooting

### Claude Code Issues

**Not authenticated**:
```bash
claude auth login
```

**Version issues**:
```bash
npm install -g @anthropic-ai/claude-code@latest
```

### Ollama Issues

**Model not found**:
```bash
ollama list
ollama pull qwen2.5-coder:7b
```

**Service not running**:
```bash
ollama serve
```

### Shell Issues

**Commands not found**:
```bash
source ~/.zshrc
# Or restart terminal
```

**Permission denied**:
```bash
chmod +x ~/Claude-Ollama/scripts/*.sh
```

### General Issues

**Check status**:
```bash
co-status
```

**View logs**:
```bash
tail -f ~/Claude-Ollama/logs/automation.log
```

**Get help**:
```bash
co-help
```

## 📚 Documentation

- **Quick Start**: `~/Claude-Ollama/QUICKSTART.md`
- **Main Docs**: `~/Claude-Ollama/README.md`
- **MCP Servers**: `~/Claude-Ollama/mcp-servers/README.md`

## 🎓 Tips & Best Practices

### Model Selection Guide (3-Tier Routing)

| Task Type | Tier | Model | Reason |
|-----------|------|-------|--------|
| Quick code gen, scripts | **Tier 1** | Qwen 2.5 Coder 7B | Fast, local, free |
| Configs, schemas, docs | **Tier 1** | Qwen 2.5 Coder 7B | Handles easily |
| Git, DevOps, templates | **Tier 1** | Qwen 2.5 Coder 7B | Standard tasks |
| Multi-file module builds | **Tier 2** | Qwen 3 Coder 480B | Complex reasoning |
| Architecture decisions | **Tier 2** | Qwen 3 Coder 480B | Advanced logic |
| Signal extraction, ML logic | **Tier 2** | Qwen 3 Coder 480B | Deep understanding |
| Qwen 480B can't handle it | **Tier 3** | Claude Opus/Sonnet | Last resort, user approval |
| Offline / air-gapped | — | Llama 3.1 / Phi 3.5 | No network needed |

### Optimization Tips (Qwen-First Workflow)

1. **Always start with Tier 1** (Qwen 7B) — code, plan, scaffold
2. **Escalate to Tier 2** (Qwen 480B) — only if 7B output is insufficient
3. **Tier 3 is rare** (Claude) — only with explicit user approval
4. **Review locally** — use Qwen for code review before pushing
5. **Test locally** (native tools — pytest, npm test, etc.)

### Prompting Best Practices

- Be specific and detailed
- Provide context and examples
- Iterate and refine
- Use appropriate model for task
- Combine models for best results

## 🔄 Updates

### Manual Update
```bash
cd ~/Claude-Ollama
# Update scripts as needed
```

### Check for Updates
```bash
co-status
```

## 📞 Support

### Self-Help Resources
1. Run: `co-help`
2. Check: `~/Claude-Ollama/logs/`
3. Read: `~/Claude-Ollama/QUICKSTART.md`
4. Status: `co-status`

### External Resources
- [Claude Documentation](https://docs.anthropic.com)
- [Claude Code Docs](https://docs.anthropic.com/claude/docs/claude-code)
- [Ollama Documentation](https://ollama.ai/docs)
- [MCP Documentation](https://github.com/anthropics/anthropic-sdk-typescript)

## 📄 License

This automation framework is provided as-is for personal use on Mac Mini (dsr-ai-lab).

## 👤 System Information

- **Mac Mini**: dsr-ai-lab
- **User**: Dinesh Srivastava
- **Installation**: /Users/dsr-ai-lab/Claude-Ollama
- **Ollama Models**: /Users/dsr-ai-lab/.ollama/models

## 🎉 Getting Started

Ready to go? Just run:

```bash
co
```

And start building with the power of Claude Code + Ollama! 🚀

---

**Version**: 1.1.0
**Date**: February 2026
**Status**: Production Ready
**Routing**: 3-Tier (Qwen 7B → Qwen 480B → Claude)
