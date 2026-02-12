# Claude Code + Ollama Automation System

## 🎯 Overview

Complete automation framework for Mac Mini (dsr-ai-lab) that integrates Claude Code (Pro subscription) with Ollama local models, providing seamless AI-powered development environment with full terminal access.

## ✨ Features

### 🤖 Dual AI System
- **Claude Code** (Cloud): Opus 4.5, Sonnet 4.5, Haiku 4.5, and earlier models
- **Ollama** (Local): Qwen 2.5 Coder, Llama 3.1, Phi 3.5, Gemma, Mistral

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

### Example 1: Full Development Workflow

```bash
# 1. Design with Claude Opus (complex reasoning)
cc-opus
# "Design architecture for a REST API with authentication"

# 2. Implement with Qwen Coder (local, fast)
ol-qwen
# "Implement the authentication endpoints"

# 3. Review with automation
code-review ~/projects/api

# 4. Document
gen-docs ~/projects/api
```

### Example 2: Quick Bug Fix

```bash
# Analyze with Claude Sonnet
cc-sonnet
# Paste error and code

# Fix locally with Qwen
ol-qwen
# Apply suggested fix

# Test
pytest
```

### Example 3: Learning

```bash
# Learn concept with Claude Opus
cc-opus
# "Explain async/await in Python with examples"

# Practice with local model
ol-qwen
# "Generate practice exercises"

# Review implementation
code-review my_async_code.py
```

## 🛠️ Configuration

### Model Preferences

Edit: `~/Claude-Ollama/config/models.conf`

```bash
# Default Claude model
DEFAULT_CLAUDE_MODEL="claude-sonnet-4-5-20250929"

# Default Ollama model
DEFAULT_OLLAMA_MODEL="qwen2.5-coder:7b"
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
- Password: Stored in `~/Claude-Ollama/config/settings.conf`
- Keep config files secure (chmod 600)

### Best Practices
1. Use local Ollama models for sensitive code
2. Use Claude Code for non-sensitive tasks
3. Review generated code before execution
4. Keep logs for audit trail
5. Never commit credentials to version control

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
- qwen2.5-coder:7b
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

### Model Selection Guide

| Task Type | Recommended Model | Reason |
|-----------|------------------|---------|
| Complex architecture | Claude Opus 4.5 | Best reasoning |
| Code review | Claude Sonnet 4.5 | Balanced |
| Quick questions | Claude Haiku 4.5 | Fastest |
| Coding tasks | Qwen 2.5 Coder | Optimized for code |
| General offline | Llama 3.1 | Good all-around |
| Resource constrained | Phi 3.5 or Gemma | Lightweight |

### Optimization Tips

1. **Start with planning** (Claude Opus)
2. **Implement locally** (Qwen Coder)
3. **Review with Claude** (Sonnet)
4. **Document with Claude** (Sonnet)
5. **Test locally** (native tools)

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

**Version**: 1.0.0  
**Date**: February 2026  
**Status**: Production Ready
