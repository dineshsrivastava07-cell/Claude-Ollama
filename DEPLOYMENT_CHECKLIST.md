# Deployment Checklist for Claude Code + Ollama Automation

## 📋 Pre-Deployment

- [ ] Mac Mini (dsr-ai-lab) is accessible
- [ ] User account: dsr-ai-lab (password: Srbh#0007)
- [ ] Ollama is installed with models:
  - [ ] qwen2.5-coder:7b
  - [ ] llama3.1:8b
  - [ ] phi3.5
  - [ ] gemma2:2b
  - [ ] mistral:7b
- [ ] Claude Pro subscription is active
- [ ] Internet connection available

## 📦 File Transfer

- [ ] Download/extract claude-ollama-automation.tar.gz
- [ ] Transfer files to Mac Mini via:
  - [ ] AirDrop, or
  - [ ] USB drive, or
  - [ ] Network transfer (scp/rsync)
- [ ] Files in: ~/claude-ollama-deploy/

## 🚀 Deployment Steps

### Step 1: Verify Files
```bash
cd ~/claude-ollama-deploy
ls -lh
```

Expected files:
- [ ] deploy-claude-ollama.sh
- [ ] setup-claude-ollama-automation.sh
- [ ] advanced-automation.sh
- [ ] mcp-integration.sh
- [ ] QUICKSTART.md
- [ ] README.md

### Step 2: Run Master Deployment
```bash
chmod +x deploy-claude-ollama.sh
./deploy-claude-ollama.sh
```

- [ ] Script starts successfully
- [ ] All checks pass
- [ ] Confirm installation (press Y)
- [ ] Wait for completion (~5-10 minutes)

### Step 3: Authenticate Claude Code
```bash
claude auth login
```

- [ ] Browser opens
- [ ] Login with Claude Pro account
- [ ] Authentication successful

### Step 4: Reload Shell
```bash
source ~/.zshrc
```

- [ ] No errors displayed
- [ ] Shell reloaded successfully

### Step 5: Verify Installation
```bash
co-status
```

Check output:
- [ ] Claude Code version displayed
- [ ] Ollama models listed
- [ ] All expected models present

### Step 6: Test Basic Functionality
```bash
co
```

- [ ] Main menu displays
- [ ] Can navigate menu
- [ ] Exit works (option 0)

### Step 7: Test Claude Code
```bash
cc-sonnet
```

- [ ] Claude Code launches
- [ ] Can interact with Claude
- [ ] Exit with Ctrl+C or /exit

### Step 8: Test Ollama
```bash
ol-qwen
```

- [ ] Ollama launches
- [ ] Can interact with model
- [ ] Exit with /bye

### Step 9: Test Automation
```bash
co-help
```

- [ ] Help displays correctly
- [ ] All commands listed

### Step 10: Final Verification
```bash
# List all available commands
alias | grep -E '(co|cc|ol)'
```

- [ ] All aliases present
- [ ] No errors

## ✅ Post-Deployment

- [ ] Desktop shortcut created (Claude-Ollama.command)
- [ ] Documentation accessible:
  - [ ] ~/Claude-Ollama/README.md
  - [ ] ~/Claude-Ollama/QUICKSTART.md
  - [ ] ~/Claude-Ollama/mcp-servers/README.md
- [ ] Configuration files created:
  - [ ] ~/Claude-Ollama/config/models.conf
  - [ ] ~/Claude-Ollama/config/settings.conf
  - [ ] ~/Claude-Ollama/config/mcp-servers.json

## 🎯 Quick Test Suite

Run these commands to verify everything works:

```bash
# 1. Status check
co-status

# 2. List models
co-models

# 3. Help
co-help

# 4. Quick Claude test
echo "What is 2+2?" | cc-sonnet

# 5. Quick Ollama test
echo "Hello" | ol-qwen

# 6. Main interface
co
# Navigate menu and exit
```

All tests passing: [ ]

## 🔧 Troubleshooting

### If Claude Code authentication fails:
```bash
claude auth logout
claude auth login
```

### If commands not found:
```bash
source ~/.zshrc
# Or restart terminal
```

### If Ollama model missing:
```bash
ollama pull <model-name>
```

### If permission errors:
```bash
chmod +x ~/Claude-Ollama/scripts/*.sh
```

## 📊 Success Criteria

Deployment is successful when:
- [x] All commands work (`co`, `cc-*`, `ol-*`)
- [x] Can interact with Claude Code
- [x] Can interact with Ollama models
- [x] Main menu functions properly
- [x] Desktop shortcut works
- [x] Documentation accessible
- [x] No error messages

## 🎉 Completion

Date: _______________
Time: _______________
Deployed by: _______________

Notes:
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________

Deployment Status: [ ] SUCCESS  [ ] ISSUES (see notes)

## 📞 Support

If issues occur:
1. Check logs: ~/Claude-Ollama/logs/
2. Run: co-status
3. Review: ~/Claude-Ollama/QUICKSTART.md
4. Check troubleshooting section in README.md

## 🔄 Next Steps

After successful deployment:
1. [ ] Review QUICKSTART.md
2. [ ] Configure MCP servers (optional)
3. [ ] Customize models.conf (optional)
4. [ ] Test automation features
5. [ ] Create first project
6. [ ] Explore different models

---

**System**: Mac Mini (dsr-ai-lab)
**User**: Dinesh Srivastava
**Version**: 1.0.0
