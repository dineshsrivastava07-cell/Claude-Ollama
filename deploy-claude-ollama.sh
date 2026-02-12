#!/bin/bash

###############################################################################
# Master Deployment Script for Claude Code + Ollama Automation
# This script orchestrates the complete deployment on Mac Mini
###############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

clear

echo -e "${CYAN}"
cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║   ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗              ║
║  ██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝              ║
║  ██║     ██║     ███████║██║   ██║██║  ██║█████╗                ║
║  ██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝                ║
║  ╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗              ║
║   ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝              ║
║                                                                   ║
║              + Ollama Automation Deployment                      ║
║                                                                   ║
║              Mac Mini: dsr-ai-lab                                ║
║              User: Dinesh Srivastava                             ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Master Deployment Script${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# Get current directory
DEPLOY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${YELLOW}Deployment directory: ${DEPLOY_DIR}${NC}"
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}Error: This script must be run on macOS${NC}"
    echo -e "${YELLOW}Current OS: ${OSTYPE}${NC}"
    echo ""
    echo -e "${BLUE}To deploy on Mac Mini:${NC}"
    echo "  1. Transfer these files to your Mac Mini"
    echo "  2. Run this script on the Mac Mini"
    exit 1
fi

echo -e "${GREEN}✓ Running on macOS${NC}"
echo ""

# Verify required files
echo -e "${BLUE}Verifying deployment files...${NC}"
REQUIRED_FILES=(
    "setup-claude-ollama-automation.sh"
    "advanced-automation.sh"
    "mcp-integration.sh"
    "QUICKSTART.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "${DEPLOY_DIR}/${file}" ]; then
        echo -e "${GREEN}✓ ${file}${NC}"
    else
        echo -e "${RED}✗ ${file} not found${NC}"
        exit 1
    fi
done

echo ""

# Ask for confirmation
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}This will install and configure:${NC}"
echo ""
echo "  • Claude Code CLI (with Pro subscription)"
echo "  • Ollama integration"
echo "  • Automated development environment"
echo "  • MCP server support"
echo "  • Shell aliases and shortcuts"
echo "  • Full system access automation"
echo ""
echo -e "${YELLOW}Installation location: /Users/dsr-ai-lab/Claude-Ollama${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""

read -p "Do you want to proceed? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Deployment cancelled${NC}"
    exit 0
fi

echo ""
echo -e "${CYAN}Starting deployment...${NC}"
echo ""

# Step 1: Run main setup
echo -e "${MAGENTA}[1/4] Running main setup...${NC}"
chmod +x "${DEPLOY_DIR}/setup-claude-ollama-automation.sh"
bash "${DEPLOY_DIR}/setup-claude-ollama-automation.sh"

echo ""

# Step 2: Setup advanced automation
echo -e "${MAGENTA}[2/4] Setting up advanced automation...${NC}"
TARGET_DIR="/Users/dsr-ai-lab/Claude-Ollama"
mkdir -p "${TARGET_DIR}/scripts"
cp "${DEPLOY_DIR}/advanced-automation.sh" "${TARGET_DIR}/scripts/"
chmod +x "${TARGET_DIR}/scripts/advanced-automation.sh"
echo -e "${GREEN}✓ Advanced automation installed${NC}"

echo ""

# Step 3: Setup MCP integration
echo -e "${MAGENTA}[3/4] Setting up MCP server integration...${NC}"
cp "${DEPLOY_DIR}/mcp-integration.sh" "${TARGET_DIR}/scripts/"
chmod +x "${TARGET_DIR}/scripts/mcp-integration.sh"
bash "${TARGET_DIR}/scripts/mcp-integration.sh"
echo -e "${GREEN}✓ MCP integration complete${NC}"

echo ""

# Step 4: Copy documentation
echo -e "${MAGENTA}[4/4] Installing documentation...${NC}"
cp "${DEPLOY_DIR}/QUICKSTART.md" "${TARGET_DIR}/"
echo -e "${GREEN}✓ Documentation installed${NC}"

echo ""

# Create desktop shortcut
echo -e "${BLUE}Creating desktop shortcut...${NC}"
DESKTOP_DIR="/Users/dsr-ai-lab/Desktop"
if [ -d "$DESKTOP_DIR" ]; then
    cat > "${DESKTOP_DIR}/Claude-Ollama.command" << 'EOFSHORTCUT'
#!/bin/bash
cd /Users/dsr-ai-lab/Claude-Ollama/scripts
./claude-ollama.sh
EOFSHORTCUT
    chmod +x "${DESKTOP_DIR}/Claude-Ollama.command"
    echo -e "${GREEN}✓ Desktop shortcut created${NC}"
fi

echo ""

# Summary
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                               ║${NC}"
echo -e "${GREEN}║  Deployment Complete! 🎉                                      ║${NC}"
echo -e "${GREEN}║                                                               ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${CYAN}Installation Summary:${NC}"
echo ""
echo -e "${BLUE}Installed Components:${NC}"
echo "  ✓ Claude Code CLI"
echo "  ✓ Ollama integration"
echo "  ✓ Automation framework"
echo "  ✓ MCP servers"
echo "  ✓ Shell configuration"
echo "  ✓ Documentation"
echo ""

echo -e "${BLUE}Installation Directory:${NC}"
echo "  ${TARGET_DIR}"
echo ""

echo -e "${BLUE}Available Commands:${NC}"
echo "  co              - Launch main menu"
echo "  cc              - Switch to Claude Code"
echo "  ol              - Switch to Ollama"
echo "  cc-opus         - Claude Opus 4.5"
echo "  cc-sonnet       - Claude Sonnet 4.5"
echo "  cc-haiku        - Claude Haiku 4.5"
echo "  ol-qwen         - Qwen 2.5 Coder"
echo "  ol-llama        - Llama 3.1"
echo "  code-review     - Automated code review"
echo "  gen-docs        - Generate documentation"
echo "  co-help         - Show help"
echo ""

echo -e "${YELLOW}⚠️  Important Next Steps:${NC}"
echo ""
echo "  1. Authenticate Claude Code:"
echo "     ${CYAN}claude auth login${NC}"
echo ""
echo "  2. Reload your shell:"
echo "     ${CYAN}source ~/.zshrc${NC}"
echo ""
echo "  3. Launch the automation:"
echo "     ${CYAN}co${NC}"
echo ""

echo -e "${BLUE}Quick Start Guide:${NC}"
echo "  Read: ${TARGET_DIR}/QUICKSTART.md"
echo "  Or:   open ${TARGET_DIR}/QUICKSTART.md"
echo ""

echo -e "${BLUE}Desktop Shortcut:${NC}"
echo "  Double-click: Claude-Ollama.command on your Desktop"
echo ""

echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${CYAN}System is ready! Start with:${NC} ${YELLOW}co${NC}"
echo ""

# Open quick start guide
read -p "Open Quick Start Guide now? (Y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    open "${TARGET_DIR}/QUICKSTART.md" 2>/dev/null || cat "${TARGET_DIR}/QUICKSTART.md"
fi
