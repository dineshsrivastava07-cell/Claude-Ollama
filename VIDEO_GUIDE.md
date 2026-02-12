# Installation Video Script / Step-by-Step Guide
## Claude Code + Ollama Automation for Mac Mini

---

## 📹 VIDEO GUIDE SCRIPT

### Opening (0:00 - 0:30)

**[Screen: Mac Mini Desktop]**

"Welcome! In this video, I'll show you how to set up a complete AI automation system on your Mac Mini that combines Claude Code Pro subscription with Ollama local models. This gives you the best of both worlds - powerful cloud AI and fast local models."

"By the end of this setup, you'll have a simple command-line interface where you can switch between different AI models, automate code reviews, generate documentation, and much more."

---

### Prerequisites Check (0:30 - 1:00)

**[Screen: Terminal]**

"Before we begin, make sure you have:"

```bash
# Check Ollama is installed
ollama list

# Should show:
# qwen2.5-coder:7b
# llama3.1:8b
# phi3.5
# gemma2:2b
# mistral:7b
```

"Also ensure you have an active Claude Pro subscription. We'll authenticate during setup."

---

### Step 1: Download Files (1:00 - 2:00)

**[Screen: Browser, then Finder]**

"First, download all the automation files. You should have these 9 files:"

```
✓ deploy-claude-ollama.sh
✓ setup-claude-ollama-automation.sh
✓ advanced-automation.sh
✓ mcp-integration.sh
✓ system-monitor.sh
✓ project-templates.sh
✓ README.md
✓ QUICKSTART.md
✓ DEPLOYMENT_CHECKLIST.md
```

"Place all these files in a folder called 'claude-ollama-deploy' in your home directory."

**[Show dragging files to folder]**

---

### Step 2: Open Terminal (2:00 - 2:30)

**[Screen: Spotlight search → Terminal]**

"Open Terminal - you can use Spotlight (Cmd + Space) and type 'Terminal'."

"Navigate to our deployment folder:"

```bash
cd ~/claude-ollama-deploy
ls -la
```

**[Show: Files listed]**

"Great! All our files are here."

---

### Step 3: Run Master Deployment (2:30 - 5:00)

**[Screen: Terminal]**

"Now let's run the master deployment script:"

```bash
chmod +x deploy-claude-ollama.sh
./deploy-claude-ollama.sh
```

**[Show: Script running with colored output]**

"The script will:"
- Check your system (macOS version)
- Install Homebrew if needed
- Install Node.js if needed
- Setup Claude Code CLI
- Configure Ollama integration
- Create automation framework
- Setup MCP servers
- Configure shell aliases

**[Show: Progress bars and success messages]**

"This takes about 5-10 minutes. The script will ask for confirmation before installing anything."

**[Show: Confirmation prompt]**

"Type 'y' and press Enter to continue."

**[Show: Installation progress]**

"The script is now installing all components..."

**[Show: Success message]**

"Perfect! Installation complete."

---

### Step 4: Authenticate Claude Code (5:00 - 6:00)

**[Screen: Terminal]**

"Next, we need to authenticate Claude Code with your Pro account:"

```bash
claude auth login
```

**[Show: Browser opening]**

"Your browser will open. Log in with your Claude Pro credentials."

**[Show: Authentication success page]**

"Once you see 'Authentication successful', return to Terminal."

**[Show: Terminal confirmation]**

"Great! Claude Code is now authenticated."

---

### Step 5: Reload Shell (6:00 - 6:30)

**[Screen: Terminal]**

"Now reload your shell configuration to activate all the new commands:"

```bash
source ~/.zshrc
```

**[Show: No errors]**

"No errors means we're good to go!"

---

### Step 6: Verify Installation (6:30 - 7:30)

**[Screen: Terminal]**

"Let's verify everything is working:"

```bash
co-status
```

**[Show: Status output with:]**
- Claude Code version
- Ollama version
- List of available models

"Perfect! Both Claude Code and Ollama are ready."

"Let's check our available commands:"

```bash
co-help
```

**[Show: Help output with all commands]**

"Excellent! All our shortcuts are set up."

---

### Step 7: First Launch (7:30 - 9:00)

**[Screen: Terminal]**

"Now for the moment of truth - let's launch the automation system:"

```bash
co
```

**[Show: Main menu with colorful ASCII art banner]**

"Beautiful! Here's our main interface. Let's go through the options:"

```
1. Start Claude Code (Pro Subscription)
2. Start Ollama Chat
3. Switch Model
4. Run Automated Task
5. System Information
6. Configuration
7. View Logs
8. Terminal Access
9. Help & Documentation
0. Exit
```

"Let's try option 1 - Starting Claude Code."

**[Show: Selecting 1]**

**[Show: Model selection menu]**

"You can choose which Claude model to use. Let's try Sonnet 4.5 (option 2)."

**[Show: Claude Code starting]**

**[Type a question]**

"Let me ask: 'What are the key features of Python 3.12?'"

**[Show: Claude responding]**

"Perfect! Claude Code is working beautifully."

**[Show: Exiting with Ctrl+C]**

---

### Step 8: Try Ollama (9:00 - 10:00)

**[Screen: Main menu again]**

"Let's also test a local Ollama model. Select option 2."

**[Show: Ollama model list]**

"These are all your local models. Let's try Qwen 2.5 Coder - it's excellent for programming tasks."

**[Show: Selecting qwen]**

**[Show: Qwen starting]**

**[Type a question]**

"Let me ask: 'Write a function to calculate factorial in Python'"

**[Show: Qwen responding with code]**

"Excellent! Local model working great, and it's fast!"

---

### Step 9: Quick Command Shortcuts (10:00 - 11:00)

**[Screen: Terminal at main prompt]**

"You don't always need the menu. Try these quick shortcuts:"

```bash
# Quick access to Claude models
cc-opus          # Most capable
cc-sonnet        # Balanced
cc-haiku         # Fastest

# Quick access to Ollama models
ol-qwen          # Best for coding
ol-llama         # General purpose
ol-phi           # Efficient
```

**[Demo: Running cc-sonnet]**

"See? Direct access to Claude Sonnet!"

**[Exit]**

**[Demo: Running ol-qwen]**

"And direct access to local Qwen model!"

---

### Step 10: Automation Features (11:00 - 12:30)

**[Screen: Terminal]**

"Now let's try the automation features. Let's create a sample Python file:"

```bash
cat > test.py << 'EOF'
def add(a,b):
    return a+b

def multiply(x,y):
    return x*y

print(add(2,3))
EOF
```

"Now let's run an automated code review:"

```bash
code-review test.py
```

**[Show: Analysis running]**

**[Show: Detailed review output]**

"Look at that! Comprehensive code review with specific suggestions."

---

### Step 11: Desktop Shortcut (12:30 - 13:00)

**[Screen: Desktop]**

"Notice the Claude-Ollama.command file on your desktop?"

**[Double-click it]**

"This launches the system directly from your desktop - very convenient!"

---

### Step 12: System Monitor (13:00 - 14:00)

**[Screen: Terminal]**

"There's also a system monitor for tracking usage:"

```bash
~/Claude-Ollama/scripts/system-monitor.sh
```

**[Show: System monitor interface with]**
- Real-time stats
- Model usage
- Session logs
- Resource monitoring

"This helps you track which models you're using most and system performance."

---

### Step 13: Project Templates (14:00 - 15:00)

**[Screen: Terminal]**

"Want to start a new project? Use the template generator:"

```bash
~/Claude-Ollama/scripts/project-templates.sh
```

**[Show: Template menu]**

"Choose Python, Node.js, Web App, or API - it sets up everything for you!"

**[Demo: Creating a Python project]**

**[Show: Generated project structure]**

"Complete project structure with tests, configs, everything!"

---

### Closing (15:00 - 16:00)

**[Screen: Terminal with main menu]**

"That's it! You now have a complete AI automation system combining:"

✓ Claude Code (Pro subscription)
  - Opus, Sonnet, Haiku models
  - Cloud-powered intelligence
  
✓ Ollama (Local models)
  - Qwen, Llama, Phi, Gemma, Mistral
  - Fast, private, offline-capable

✓ Automation Tools
  - Code review
  - Documentation generation
  - Refactoring
  - Project templates

✓ Easy Access
  - Simple commands (co, cc-*, ol-*)
  - Desktop shortcut
  - Full system integration

"Key commands to remember:"

```bash
co              # Main menu
co-help         # Show help
co-status       # System status

cc-sonnet       # Claude Sonnet
ol-qwen         # Qwen Coder

code-review     # Review code
gen-docs        # Generate docs
```

"Check out the README and QUICKSTART files for more details:"

```bash
open ~/Claude-Ollama/README.md
open ~/Claude-Ollama/QUICKSTART.md
```

"Happy coding with your new AI automation system!"

**[Show: Main menu one more time]**

---

## 📋 TROUBLESHOOTING GUIDE

### Issue: "claude: command not found"

```bash
# Re-authenticate
claude auth login

# Or reinstall
npm install -g @anthropic-ai/claude-code
```

### Issue: "ollama: command not found"

```bash
# Check if Ollama is running
pgrep ollama

# Start Ollama
ollama serve
```

### Issue: Commands (co, cc-*, ol-*) not found

```bash
# Reload shell
source ~/.zshrc

# Or restart Terminal
```

### Issue: Permission denied

```bash
# Fix permissions
chmod +x ~/Claude-Ollama/scripts/*.sh
```

### Issue: Model not found in Ollama

```bash
# List models
ollama list

# Pull missing model
ollama pull qwen2.5-coder:7b
```

---

## 🎯 POST-INSTALLATION CHECKLIST

After completing the video guide:

- [ ] All commands work (co, cc-*, ol-*)
- [ ] Can launch Claude Code
- [ ] Can launch Ollama models
- [ ] Desktop shortcut works
- [ ] Automation commands work (code-review, gen-docs)
- [ ] Documentation accessible
- [ ] No error messages

---

## 📞 SUPPORT RESOURCES

**Documentation:**
- ~/Claude-Ollama/README.md - Main documentation
- ~/Claude-Ollama/QUICKSTART.md - Quick reference
- ~/Claude-Ollama/mcp-servers/README.md - MCP servers

**Commands:**
```bash
co-help         # Quick help
co-status       # System status
co-models       # List models
```

**Logs:**
```bash
# View logs
ls -lh ~/Claude-Ollama/logs/

# Follow live
tail -f ~/Claude-Ollama/logs/automation.log
```

---

## 🚀 NEXT STEPS

1. Explore different models - try them all!
2. Test automation features
3. Create a project with templates
4. Configure MCP servers (optional)
5. Customize settings to your preference

---

**Total Video Length: ~16 minutes**

**Difficulty: Beginner-Friendly**

**Result: Complete AI automation system ready to use!**
