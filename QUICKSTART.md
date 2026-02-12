# Claude Code + Ollama Automation - Quick Start Guide

## 🚀 Installation (5 Minutes)

### Step 1: Download and Transfer Files to Mac Mini

Transfer these files to your Mac Mini (`dsr-ai-lab`):

```bash
# On your Mac Mini, create directory
mkdir -p ~/setup-files
cd ~/setup-files

# Transfer files (use one of these methods):
# Via USB drive, AirDrop, or scp from another Mac
```

### Step 2: Run Setup Script

```bash
cd ~/setup-files
chmod +x setup-claude-ollama-automation.sh
./setup-claude-ollama-automation.sh
```

The script will:
- ✅ Install dependencies (Homebrew, Node.js)
- ✅ Setup Claude Code CLI
- ✅ Verify Ollama installation
- ✅ Create automation framework
- ✅ Configure shell aliases

### Step 3: Authenticate Claude Code

```bash
claude auth login
```

Follow the prompts to log in with your Claude Pro account.

### Step 4: Reload Shell

```bash
source ~/.zshrc
```

## 🎯 You're Ready!

Launch the automation:
```bash
co
```

---

## 📚 Quick Reference

### Main Commands

| Command | Description |
|---------|-------------|
| `co` | Launch main menu |
| `cc` | Switch to Claude Code |
| `ol` | Switch to Ollama |
| `co-help` | Show help |
| `co-status` | System status |

### Claude Models

| Command | Model |
|---------|-------|
| `cc-opus` | Claude Opus 4.5 (most capable) |
| `cc-sonnet` | Claude Sonnet 4.5 (balanced) |
| `cc-haiku` | Claude Haiku 4.5 (fastest) |

### Ollama Models

| Command | Model |
|---------|-------|
| `ol-qwen` | Qwen 2.5 Coder 7B (best for coding) |
| `ol-llama` | Llama 3.1 8B |
| `ol-phi` | Phi 3.5 |
| `ol-gemma` | Gemma 2B |
| `ol-mistral` | Mistral 7B |

### Automation Tasks

| Command | Description |
|---------|-------------|
| `code-review <path>` | Automated code review |
| `gen-docs <path>` | Generate documentation |
| `refactor <file>` | Refactor code |

---

## 💡 Usage Examples

### Example 1: Quick Code Review
```bash
# Review a Python file
code-review ~/projects/my-app/main.py

# Review entire project
code-review ~/projects/my-app
```

### Example 2: Generate Documentation
```bash
# Generate docs for a project
gen-docs ~/projects/my-app ~/projects/my-app/docs
```

### Example 3: Switch Between Models
```bash
# Start with Claude Sonnet
cc-sonnet

# (After finishing, switch to local Qwen for coding)
ol-qwen
```

### Example 4: Interactive Session
```bash
# Launch main menu
co

# Select option 1 (Claude Code)
# Choose model
# Start chatting!
```

---

## 🔧 Configuration

### Model Preferences

Edit: `~/Claude-Ollama/config/models.conf`

```bash
# Set your default Claude model
DEFAULT_CLAUDE_MODEL="claude-sonnet-4-5-20250929"

# Set your default Ollama model
DEFAULT_OLLAMA_MODEL="qwen2.5-coder:7b"
```

### System Settings

Edit: `~/Claude-Ollama/config/settings.conf`

```bash
# Workspace directory
WORKSPACE_DIR="/Users/dsr-ai-lab/Claude-Ollama/workspace"

# Enable verbose logging
VERBOSE_LOGGING=true

# Auto-update
AUTO_UPDATE=true
```

---

## 🎨 Workflow Examples

### Workflow 1: Full Development Cycle

1. **Plan** (Claude Opus for complex reasoning)
   ```bash
   cc-opus
   # "Help me design the architecture for a web scraper"
   ```

2. **Code** (Qwen Coder for implementation)
   ```bash
   ol-qwen
   # "Implement the web scraper based on the architecture"
   ```

3. **Review** (Claude Sonnet for code review)
   ```bash
   code-review ~/projects/scraper
   ```

4. **Document** (Claude Sonnet for documentation)
   ```bash
   gen-docs ~/projects/scraper
   ```

### Workflow 2: Quick Bug Fix

1. **Analyze** (Claude Sonnet)
   ```bash
   cc-sonnet
   # Paste error message and code
   ```

2. **Implement Fix** (Qwen locally)
   ```bash
   ol-qwen
   # Apply the suggested fix
   ```

3. **Test** (Local environment)
   ```bash
   # Run tests
   pytest
   ```

### Workflow 3: Learning & Exploration

1. **Learn Concept** (Claude Opus)
   ```bash
   cc-opus
   # "Explain how async/await works in Python"
   ```

2. **Practice** (Qwen locally)
   ```bash
   ol-qwen
   # "Generate practice exercises for async/await"
   ```

3. **Review** (Claude Sonnet)
   ```bash
   cc-sonnet
   # "Review my implementation"
   ```

---

## 🛠️ Advanced Features

### Custom Automation Scripts

Create your own automation in: `~/Claude-Ollama/scripts/`

Example:
```bash
#!/bin/bash
# ~/Claude-Ollama/scripts/my-automation.sh

# Your custom automation
echo "Running custom task..."
claude --model claude-sonnet-4-5-20250929 << EOF
Your custom prompt here
EOF
```

### MCP Server Integration

See: `~/Claude-Ollama/mcp-servers/README.md`

Enable MCP servers for:
- Filesystem access
- Git operations
- GitHub integration
- Database queries
- Web search

### Terminal Access

Full system access:
```bash
# From main menu, select option 8
# Or directly:
/bin/zsh
```

---

## 📊 Monitoring & Logs

### View Logs
```bash
# Recent logs
tail -f ~/Claude-Ollama/logs/automation.log

# All logs
ls -lh ~/Claude-Ollama/logs/

# Specific session
cat ~/Claude-Ollama/logs/claude-code-20260211-143022.log
```

### System Status
```bash
co-status
```

Output:
```
Claude Code Status:
claude version 1.0.0

Ollama Status:
NAME                    ID              SIZE      MODIFIED
qwen2.5-coder:7b       abc123...       4.7 GB    2 days ago
llama3.1:8b            def456...       4.7 GB    3 days ago
...
```

---

## 🔐 Security Notes

### Credentials Storage
- System credentials stored in: `~/Claude-Ollama/config/settings.conf`
- Keep this file secure (chmod 600)
- Never commit to version control

### Best Practices
1. Use local Ollama models for sensitive code
2. Claude Code for non-sensitive tasks
3. Review generated code before execution
4. Keep logs for audit trail

---

## 🚨 Troubleshooting

### Issue: Claude Code not authenticated
```bash
claude auth login
```

### Issue: Ollama model not found
```bash
# List available models
ollama list

# Pull missing model
ollama pull qwen2.5-coder:7b
```

### Issue: Command not found
```bash
# Reload shell config
source ~/.zshrc

# Or restart terminal
```

### Issue: Permission denied
```bash
# Fix permissions
chmod +x ~/Claude-Ollama/scripts/*.sh
```

### Get Help
```bash
co-help
```

---

## 🎓 Learning Resources

### Best Practices
1. **Model Selection**:
   - Opus: Complex reasoning, architecture design
   - Sonnet: Balanced tasks, code review, docs
   - Haiku: Quick tasks, simple queries
   - Qwen: Coding, refactoring (local)
   - Llama: General tasks (local)

2. **Prompting Tips**:
   - Be specific and detailed
   - Provide context
   - Use examples
   - Iterate and refine

3. **Workflow Optimization**:
   - Start with Claude for planning
   - Use local models for implementation
   - Return to Claude for review

### Documentation
- Main: `~/Claude-Ollama/README.md`
- MCP: `~/Claude-Ollama/mcp-servers/README.md`
- This guide: `~/Claude-Ollama/QUICKSTART.md`

---

## 📞 Support

### Self-Help
1. Run `co-help`
2. Check logs: `~/Claude-Ollama/logs/`
3. Review documentation
4. Test with `co-status`

### Community Resources
- Claude Documentation: https://docs.anthropic.com
- Ollama Documentation: https://ollama.ai/docs

---

## 🎯 Next Steps

1. ✅ Complete installation
2. ✅ Try all main commands
3. ✅ Run a code review
4. ✅ Generate documentation
5. ✅ Explore different models
6. ✅ Create custom automation
7. ✅ Setup MCP servers

---

## 📝 Version Information

- **Version**: 1.0.0
- **Last Updated**: February 2026
- **Mac Mini**: dsr-ai-lab
- **User**: Dinesh Srivastava

---

## 🎉 You're All Set!

Start building with the power of Claude Code + Ollama:

```bash
co
```

Happy coding! 🚀
