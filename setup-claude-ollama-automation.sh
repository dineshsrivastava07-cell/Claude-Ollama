#!/bin/bash

###############################################################################
# Claude Code + Ollama Automation Setup for Mac Mini (dsr-ai-lab)
# User: Dinesh Srivastava
# Purpose: Automated CLI development environment with model switching
###############################################################################

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
USER_HOME="/Users/dsr-ai-lab"
CLAUDE_OLLAMA_DIR="${USER_HOME}/Claude-Ollama"
OLLAMA_MODELS_PATH="${USER_HOME}/.ollama/models"
CONFIG_DIR="${CLAUDE_OLLAMA_DIR}/config"
SCRIPTS_DIR="${CLAUDE_OLLAMA_DIR}/scripts"
LOGS_DIR="${CLAUDE_OLLAMA_DIR}/logs"
WORKSPACE_DIR="${CLAUDE_OLLAMA_DIR}/workspace"

# System credentials (for automation)
MAC_USER="dsr-ai-lab"
MAC_PASSWORD="Srbh#0007"

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Claude Code + Ollama Automation Setup                  ║${NC}"
echo -e "${BLUE}║   Mac Mini: dsr-ai-lab                                    ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Function to print status messages
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Create directory structure
create_directories() {
    print_info "Creating directory structure..."
    
    mkdir -p "${CLAUDE_OLLAMA_DIR}"
    mkdir -p "${CONFIG_DIR}"
    mkdir -p "${SCRIPTS_DIR}"
    mkdir -p "${LOGS_DIR}"
    mkdir -p "${WORKSPACE_DIR}"
    mkdir -p "${CLAUDE_OLLAMA_DIR}/templates"
    mkdir -p "${CLAUDE_OLLAMA_DIR}/tools"
    mkdir -p "${CLAUDE_OLLAMA_DIR}/mcp-servers"
    
    print_status "Directory structure created"
}

# Check and install Homebrew
check_homebrew() {
    print_info "Checking Homebrew installation..."
    
    if ! command -v brew &> /dev/null; then
        print_warning "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "${USER_HOME}/.zprofile"
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "${USER_HOME}/.zprofile"
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        
        print_status "Homebrew installed"
    else
        print_status "Homebrew already installed"
    fi
}

# Check and install Node.js (required for Claude Code)
check_nodejs() {
    print_info "Checking Node.js installation..."
    
    if ! command -v node &> /dev/null; then
        print_warning "Node.js not found. Installing via Homebrew..."
        brew install node
        print_status "Node.js installed"
    else
        NODE_VERSION=$(node --version)
        print_status "Node.js already installed: ${NODE_VERSION}"
    fi
}

# Check and setup Claude Code CLI
setup_claude_code() {
    print_info "Setting up Claude Code CLI..."
    
    if ! command -v claude &> /dev/null; then
        print_warning "Claude Code CLI not found. Installing..."
        npm install -g @anthropic-ai/claude-code
        print_status "Claude Code CLI installed"
    else
        CLAUDE_VERSION=$(claude --version 2>/dev/null || echo "unknown")
        print_status "Claude Code CLI already installed: ${CLAUDE_VERSION}"
    fi
    
    # Verify authentication
    print_info "Verifying Claude Code authentication..."
    print_warning "Please ensure you're logged in with: claude auth login"
}

# Verify Ollama installation and models
verify_ollama() {
    print_info "Verifying Ollama installation..."
    
    if ! command -v ollama &> /dev/null; then
        print_error "Ollama not found. Please install from: https://ollama.ai"
        exit 1
    fi
    
    print_status "Ollama found"
    
    # Check Ollama models
    print_info "Checking available Ollama models..."
    ollama list
    
    # Verify expected models
    EXPECTED_MODELS=("qwen2.5-coder:7b" "llama3.1:8b" "phi3.5" "gemma2:2b" "mistral:7b")
    
    for model in "${EXPECTED_MODELS[@]}"; do
        if ollama list | grep -q "${model}"; then
            print_status "Model available: ${model}"
        else
            print_warning "Model not found: ${model}"
        fi
    done
}

# Install additional tools
install_tools() {
    print_info "Installing additional development tools..."
    
    # Install common tools
    brew install jq yq curl wget git gh ripgrep fd fzf bat
    
    print_status "Additional tools installed"
}

# Create main automation script
create_main_script() {
    print_info "Creating main automation script..."
    
    cat > "${SCRIPTS_DIR}/claude-ollama.sh" << 'EOFMAIN'
#!/bin/bash

###############################################################################
# Claude Code + Ollama CLI Automation Tool
# Main entry point for automated development environment
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")/config"
LOGS_DIR="$(dirname "$SCRIPT_DIR")/logs"

# Load configuration
source "${CONFIG_DIR}/models.conf"
source "${CONFIG_DIR}/settings.conf"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

show_banner() {
    clear
    echo -e "${CYAN}"
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║    ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗         ║
║   ██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝         ║
║   ██║     ██║     ███████║██║   ██║██║  ██║█████╗           ║
║   ██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝           ║
║   ╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗         ║
║    ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝         ║
║                                                               ║
║              +  Ollama Automation CLI                        ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

show_menu() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Main Menu${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "  ${YELLOW}1.${NC} Start Claude Code (Pro Subscription)"
    echo -e "  ${YELLOW}2.${NC} Start Ollama Chat"
    echo -e "  ${YELLOW}3.${NC} Switch Model"
    echo -e "  ${YELLOW}4.${NC} Run Automated Task"
    echo -e "  ${YELLOW}5.${NC} System Information"
    echo -e "  ${YELLOW}6.${NC} Configuration"
    echo -e "  ${YELLOW}7.${NC} View Logs"
    echo -e "  ${YELLOW}8.${NC} Terminal Access"
    echo -e "  ${YELLOW}9.${NC} Help & Documentation"
    echo -e "  ${YELLOW}0.${NC} Exit"
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -n "Select option: "
}

start_claude_code() {
    show_banner
    echo -e "${GREEN}Starting Claude Code CLI (Pro Subscription)${NC}"
    echo ""
    echo -e "${CYAN}Available Claude Models:${NC}"
    echo "  1. Claude Opus 4.5"
    echo "  2. Claude Sonnet 4.5 (Default)"
    echo "  3. Claude Haiku 4.5"
    echo "  4. Claude Opus 3"
    echo "  5. Claude Sonnet 3.5"
    echo ""
    read -p "Select model (or press Enter for default): " model_choice
    
    case $model_choice in
        1) MODEL="claude-opus-4-5-20251101" ;;
        2) MODEL="claude-sonnet-4-5-20250929" ;;
        3) MODEL="claude-haiku-4-5-20251001" ;;
        4) MODEL="claude-opus-3-5-20240229" ;;
        5) MODEL="claude-sonnet-3-5-20240620" ;;
        *) MODEL="claude-sonnet-4-5-20250929" ;;
    esac
    
    echo ""
    echo -e "${GREEN}Starting Claude Code with model: ${MODEL}${NC}"
    echo ""
    
    # Log the session
    LOG_FILE="${LOGS_DIR}/claude-code-$(date +%Y%m%d-%H%M%S).log"
    
    # Start Claude Code
    claude --model "${MODEL}" 2>&1 | tee "${LOG_FILE}"
}

start_ollama_chat() {
    show_banner
    echo -e "${GREEN}Starting Ollama Chat${NC}"
    echo ""
    echo -e "${CYAN}Available Ollama Models:${NC}"
    
    # List available models
    MODELS=($(ollama list | tail -n +2 | awk '{print $1}'))
    
    for i in "${!MODELS[@]}"; do
        echo "  $((i+1)). ${MODELS[$i]}"
    done
    
    echo ""
    read -p "Select model: " model_choice
    
    if [ "$model_choice" -ge 1 ] && [ "$model_choice" -le "${#MODELS[@]}" ]; then
        SELECTED_MODEL="${MODELS[$((model_choice-1))]}"
        echo ""
        echo -e "${GREEN}Starting Ollama with model: ${SELECTED_MODEL}${NC}"
        echo ""
        
        # Log the session
        LOG_FILE="${LOGS_DIR}/ollama-${SELECTED_MODEL}-$(date +%Y%m%d-%H%M%S).log"
        
        # Start Ollama
        ollama run "${SELECTED_MODEL}" 2>&1 | tee "${LOG_FILE}"
    else
        echo -e "${RED}Invalid selection${NC}"
        sleep 2
    fi
}

switch_model() {
    show_banner
    echo -e "${GREEN}Model Switching${NC}"
    echo ""
    echo -e "${CYAN}1.${NC} Switch to Claude Code Model"
    echo -e "${CYAN}2.${NC} Switch to Ollama Model"
    echo -e "${CYAN}3.${NC} Back to Main Menu"
    echo ""
    read -p "Select option: " switch_choice
    
    case $switch_choice in
        1) start_claude_code ;;
        2) start_ollama_chat ;;
        3) return ;;
        *) echo -e "${RED}Invalid option${NC}"; sleep 2 ;;
    esac
}

run_automated_task() {
    show_banner
    echo -e "${GREEN}Automated Task Runner${NC}"
    echo ""
    echo -e "${CYAN}Available Tasks:${NC}"
    echo "  1. Code Review"
    echo "  2. Generate Documentation"
    echo "  3. Refactor Code"
    echo "  4. Run Tests"
    echo "  5. Deploy Application"
    echo "  6. Custom Script"
    echo ""
    read -p "Select task: " task_choice
    
    case $task_choice in
        1) run_code_review ;;
        2) generate_documentation ;;
        3) refactor_code ;;
        4) run_tests ;;
        5) deploy_application ;;
        6) run_custom_script ;;
        *) echo -e "${RED}Invalid option${NC}"; sleep 2 ;;
    esac
}

system_info() {
    show_banner
    echo -e "${GREEN}System Information${NC}"
    echo ""
    echo -e "${CYAN}macOS Version:${NC}"
    sw_vers
    echo ""
    echo -e "${CYAN}Hardware:${NC}"
    system_profiler SPHardwareDataType | grep -E "Model|Processor|Memory|Serial"
    echo ""
    echo -e "${CYAN}Claude Code Version:${NC}"
    claude --version 2>/dev/null || echo "Not installed"
    echo ""
    echo -e "${CYAN}Ollama Version:${NC}"
    ollama --version 2>/dev/null || echo "Not installed"
    echo ""
    echo -e "${CYAN}Ollama Models:${NC}"
    ollama list
    echo ""
    read -p "Press Enter to continue..."
}

terminal_access() {
    show_banner
    echo -e "${GREEN}Opening Terminal with Full Access${NC}"
    echo ""
    echo -e "${YELLOW}Starting interactive shell...${NC}"
    echo ""
    
    # Start a new shell with full access
    /bin/zsh
}

main() {
    while true; do
        show_banner
        show_menu
        read -r choice
        
        case $choice in
            1) start_claude_code ;;
            2) start_ollama_chat ;;
            3) switch_model ;;
            4) run_automated_task ;;
            5) system_info ;;
            6) configure_system ;;
            7) view_logs ;;
            8) terminal_access ;;
            9) show_help ;;
            0) echo -e "${GREEN}Goodbye!${NC}"; exit 0 ;;
            *) echo -e "${RED}Invalid option${NC}"; sleep 2 ;;
        esac
    done
}

# Run main menu
main
EOFMAIN

    chmod +x "${SCRIPTS_DIR}/claude-ollama.sh"
    print_status "Main script created"
}

# Create configuration files
create_config_files() {
    print_info "Creating configuration files..."
    
    # Models configuration
    cat > "${CONFIG_DIR}/models.conf" << 'EOFMODELS'
# Claude Code Models (Pro Subscription)
CLAUDE_OPUS_45="claude-opus-4-5-20251101"
CLAUDE_SONNET_45="claude-sonnet-4-5-20250929"
CLAUDE_HAIKU_45="claude-haiku-4-5-20251001"
CLAUDE_OPUS_35="claude-opus-3-5-20240229"
CLAUDE_SONNET_35="claude-sonnet-3-5-20240620"
CLAUDE_HAIKU_35="claude-haiku-3-5-20241022"

# Default Claude model
DEFAULT_CLAUDE_MODEL="${CLAUDE_SONNET_45}"

# Ollama Models
OLLAMA_QWEN_CODER="qwen2.5-coder:7b"
OLLAMA_LLAMA="llama3.1:8b"
OLLAMA_PHI="phi3.5"
OLLAMA_GEMMA="gemma2:2b"
OLLAMA_MISTRAL="mistral:7b"

# Default Ollama model
DEFAULT_OLLAMA_MODEL="${OLLAMA_QWEN_CODER}"
EOFMODELS

    # Settings configuration
    cat > "${CONFIG_DIR}/settings.conf" << 'EOFSETTINGS'
# General Settings
LOG_RETENTION_DAYS=30
AUTO_UPDATE=true
VERBOSE_LOGGING=false

# System Credentials (for automation)
MAC_USER="dsr-ai-lab"
MAC_PASSWORD="Srbh#0007"

# Paths
WORKSPACE_DIR="/Users/dsr-ai-lab/Claude-Ollama/workspace"
OLLAMA_MODELS_PATH="/Users/dsr-ai-lab/.ollama/models"

# Terminal Settings
SHELL="/bin/zsh"
EDITOR="vim"
EOFSETTINGS

    print_status "Configuration files created"
}

# Create model switching utilities
create_model_switcher() {
    print_info "Creating model switching utilities..."
    
    cat > "${SCRIPTS_DIR}/switch-to-claude.sh" << 'EOFCLAUDE'
#!/bin/bash

# Quick switch to Claude Code
source "$(dirname "$0")/../config/models.conf"

MODEL="${1:-$DEFAULT_CLAUDE_MODEL}"

echo "Switching to Claude Code: ${MODEL}"
claude --model "${MODEL}"
EOFCLAUDE

    cat > "${SCRIPTS_DIR}/switch-to-ollama.sh" << 'EOFOLLAMA'
#!/bin/bash

# Quick switch to Ollama
source "$(dirname "$0")/../config/models.conf"

MODEL="${1:-$DEFAULT_OLLAMA_MODEL}"

echo "Switching to Ollama: ${MODEL}"
ollama run "${MODEL}"
EOFOLLAMA

    chmod +x "${SCRIPTS_DIR}/switch-to-claude.sh"
    chmod +x "${SCRIPTS_DIR}/switch-to-ollama.sh"
    
    print_status "Model switching utilities created"
}

# Create automated task scripts
create_automation_scripts() {
    print_info "Creating automation scripts..."
    
    # Code review automation
    cat > "${SCRIPTS_DIR}/auto-code-review.sh" << 'EOFREVIEW'
#!/bin/bash

# Automated code review using Claude Code
PROJECT_DIR="${1:-.}"

echo "Running automated code review on: ${PROJECT_DIR}"

claude --model claude-sonnet-4-5-20250929 << EOF
Please perform a comprehensive code review of the project in ${PROJECT_DIR}.

Include:
1. Code quality assessment
2. Security vulnerabilities
3. Performance optimization suggestions
4. Best practices recommendations
5. Documentation improvements

Provide a detailed report with specific line-by-line feedback where applicable.
EOF
EOFREVIEW

    # Documentation generator
    cat > "${SCRIPTS_DIR}/auto-generate-docs.sh" << 'EOFDOCS'
#!/bin/bash

# Automated documentation generation
PROJECT_DIR="${1:-.}"
OUTPUT_DIR="${2:-./docs}"

echo "Generating documentation for: ${PROJECT_DIR}"
echo "Output directory: ${OUTPUT_DIR}"

mkdir -p "${OUTPUT_DIR}"

claude --model claude-sonnet-4-5-20250929 << EOF
Please generate comprehensive documentation for the project in ${PROJECT_DIR}.

Include:
1. README.md with project overview
2. API documentation
3. Architecture documentation
4. Setup and installation guide
5. Usage examples
6. Contributing guidelines

Save all documentation to ${OUTPUT_DIR}
EOF
EOFDOCS

    # Refactoring automation
    cat > "${SCRIPTS_DIR}/auto-refactor.sh" << 'EOFREFACTOR'
#!/bin/bash

# Automated code refactoring
FILE_PATH="$1"

if [ -z "$FILE_PATH" ]; then
    echo "Usage: $0 <file_path>"
    exit 1
fi

echo "Refactoring: ${FILE_PATH}"

claude --model claude-sonnet-4-5-20250929 << EOF
Please refactor the code in ${FILE_PATH}.

Focus on:
1. Code readability and maintainability
2. Performance optimization
3. Following language-specific best practices
4. Removing code duplication
5. Improving error handling

Provide the refactored code and explain the changes made.
EOF
EOFREFACTOR

    chmod +x "${SCRIPTS_DIR}"/*.sh
    
    print_status "Automation scripts created"
}

# Create shell aliases and functions
create_shell_config() {
    print_info "Creating shell configuration..."
    
    SHELL_CONFIG="${USER_HOME}/.zshrc"
    
    # Backup existing config
    if [ -f "${SHELL_CONFIG}" ]; then
        cp "${SHELL_CONFIG}" "${SHELL_CONFIG}.backup.$(date +%Y%m%d)"
    fi
    
    # Add Claude-Ollama aliases
    cat >> "${SHELL_CONFIG}" << 'EOFSHELL'

# ======================================================================
# Claude Code + Ollama Automation
# ======================================================================

# Main CLI
alias co='~/Claude-Ollama/scripts/claude-ollama.sh'
alias claude-ollama='~/Claude-Ollama/scripts/claude-ollama.sh'

# Quick switches
alias cc='~/Claude-Ollama/scripts/switch-to-claude.sh'
alias ol='~/Claude-Ollama/scripts/switch-to-ollama.sh'

# Model specific shortcuts
alias cc-opus='claude --model claude-opus-4-5-20251101'
alias cc-sonnet='claude --model claude-sonnet-4-5-20250929'
alias cc-haiku='claude --model claude-haiku-4-5-20251001'

alias ol-qwen='ollama run qwen2.5-coder:7b'
alias ol-llama='ollama run llama3.1:8b'
alias ol-phi='ollama run phi3.5'
alias ol-gemma='ollama run gemma2:2b'
alias ol-mistral='ollama run mistral:7b'

# Automation shortcuts
alias code-review='~/Claude-Ollama/scripts/auto-code-review.sh'
alias gen-docs='~/Claude-Ollama/scripts/auto-generate-docs.sh'
alias refactor='~/Claude-Ollama/scripts/auto-refactor.sh'

# Quick info
alias co-models='ollama list && echo "" && claude --help | grep -A 20 "Available models"'
alias co-status='echo "Claude Code Status:" && claude --version; echo "" && echo "Ollama Status:" && ollama list'

# Workspace
export CLAUDE_OLLAMA_HOME="${HOME}/Claude-Ollama"
export CLAUDE_WORKSPACE="${CLAUDE_OLLAMA_HOME}/workspace"

# Functions
co-help() {
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════╗
║  Claude Code + Ollama CLI - Quick Reference               ║
╚═══════════════════════════════════════════════════════════╝

Main Commands:
  co              - Launch main menu
  cc              - Switch to Claude Code
  ol              - Switch to Ollama

Claude Models:
  cc-opus         - Claude Opus 4.5
  cc-sonnet       - Claude Sonnet 4.5
  cc-haiku        - Claude Haiku 4.5

Ollama Models:
  ol-qwen         - Qwen 2.5 Coder 7B
  ol-llama        - Llama 3.1 8B
  ol-phi          - Phi 3.5
  ol-gemma        - Gemma 2B
  ol-mistral      - Mistral 7B

Automation:
  code-review     - Run automated code review
  gen-docs        - Generate documentation
  refactor        - Refactor code

Info:
  co-models       - List all available models
  co-status       - Show system status
  co-help         - Show this help

For more information, visit:
  ${CLAUDE_OLLAMA_HOME}/README.md
EOF
}

EOFSHELL
    
    print_status "Shell configuration created"
}

# Create README documentation
create_documentation() {
    print_info "Creating documentation..."
    
    cat > "${CLAUDE_OLLAMA_DIR}/README.md" << 'EOFREADME'
# Claude Code + Ollama Automation CLI

## Overview

This automation framework integrates Claude Code (Pro subscription) with Ollama local models, providing a powerful hybrid AI development environment on your Mac Mini.

## Features

- **Dual Model Support**: Seamlessly switch between Claude Code Pro subscription models and local Ollama models
- **Automated Workflows**: Pre-built automation scripts for common development tasks
- **Full System Access**: Terminal integration with complete Mac Mini access
- **Model Flexibility**: Easy switching between multiple Claude and Ollama models
- **Logging**: Comprehensive session logging for all interactions
- **CLI Interface**: User-friendly command-line interface

## Installation

Run the setup script:
```bash
./setup-claude-ollama-automation.sh
```

## Quick Start

### Launch Main Interface
```bash
co
# or
claude-ollama
```

### Quick Model Switching

#### Claude Code Models
```bash
cc-opus          # Claude Opus 4.5
cc-sonnet        # Claude Sonnet 4.5
cc-haiku         # Claude Haiku 4.5
```

#### Ollama Models
```bash
ol-qwen          # Qwen 2.5 Coder 7B (best for coding)
ol-llama         # Llama 3.1 8B
ol-phi           # Phi 3.5
ol-gemma         # Gemma 2B
ol-mistral       # Mistral 7B
```

## Available Models

### Claude Code (Pro Subscription)
- **Claude Opus 4.5** (`claude-opus-4-5-20251101`) - Most capable
- **Claude Sonnet 4.5** (`claude-sonnet-4-5-20250929`) - Balanced (default)
- **Claude Haiku 4.5** (`claude-haiku-4-5-20251001`) - Fastest
- **Claude Opus 3.5** - Previous generation
- **Claude Sonnet 3.5** - Previous generation

### Ollama (Local)
- **Qwen 2.5 Coder 7B** - Optimized for coding tasks
- **Llama 3.1 8B** - General purpose, good reasoning
- **Phi 3.5** - Microsoft's efficient model
- **Gemma 2B** - Google's lightweight model
- **Mistral 7B** - Strong general capabilities

## Automation Scripts

### Code Review
```bash
code-review /path/to/project
```

### Generate Documentation
```bash
gen-docs /path/to/project /output/dir
```

### Refactor Code
```bash
refactor /path/to/file.py
```

## Configuration

Configuration files are located in `~/Claude-Ollama/config/`:
- `models.conf` - Model definitions and defaults
- `settings.conf` - System settings and credentials

## System Access

The automation has full access to your Mac Mini with the following credentials:
- **User**: dsr-ai-lab
- **Password**: Srbh#0007

This enables automated task execution, file management, and system operations.

## Logs

All sessions are logged to `~/Claude-Ollama/logs/` with timestamps.

## Directory Structure

```
~/Claude-Ollama/
├── config/           # Configuration files
├── scripts/          # Automation scripts
├── logs/             # Session logs
├── workspace/        # Working directory
├── templates/        # Project templates
├── tools/            # Additional tools
└── mcp-servers/      # MCP server integrations
```

## Tips & Best Practices

1. **Model Selection**:
   - Use Claude Sonnet 4.5 for most tasks (good balance)
   - Use Claude Opus 4.5 for complex reasoning
   - Use Qwen 2.5 Coder for coding tasks offline
   - Use Llama 3.1 for general offline tasks

2. **Performance**:
   - Local Ollama models run entirely on your Mac Mini
   - Claude Code requires internet connection
   - Use local models for privacy-sensitive tasks

3. **Switching**:
   - You can switch models anytime during a session
   - Each model has different strengths - experiment!

## Troubleshooting

### Claude Code not authenticated
```bash
claude auth login
```

### Ollama model not found
```bash
ollama pull <model-name>
```

### Check system status
```bash
co-status
```

## Support

For issues or questions:
1. Check the logs in `~/Claude-Ollama/logs/`
2. Run `co-help` for quick reference
3. Review this README

## Updates

To update the system:
```bash
cd ~/Claude-Ollama
git pull
./setup-claude-ollama-automation.sh
```

---

**Version**: 1.0.0  
**User**: Dinesh Srivastava  
**System**: Mac Mini (dsr-ai-lab)  
**Date**: February 2026
EOFREADME
    
    print_status "Documentation created"
}

# Create launcher script
create_launcher() {
    print_info "Creating launcher script..."
    
    cat > "${USER_HOME}/launch-claude-ollama.sh" << 'EOFLAUNCHER'
#!/bin/bash

# Quick launcher for Claude-Ollama automation
cd ~/Claude-Ollama/scripts
./claude-ollama.sh
EOFLAUNCHER

    chmod +x "${USER_HOME}/launch-claude-ollama.sh"
    
    print_status "Launcher created"
}

# Main setup execution
main() {
    echo ""
    print_info "Starting setup process..."
    echo ""
    
    create_directories
    check_homebrew
    check_nodejs
    setup_claude_code
    verify_ollama
    install_tools
    create_config_files
    create_main_script
    create_model_switcher
    create_automation_scripts
    create_shell_config
    create_documentation
    create_launcher
    
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  Setup Complete!                                          ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    print_status "Claude Code + Ollama automation is ready!"
    echo ""
    print_info "Next steps:"
    echo "  1. Ensure Claude Code is authenticated: claude auth login"
    echo "  2. Reload your shell: source ~/.zshrc"
    echo "  3. Launch the automation: co"
    echo ""
    print_info "Quick commands:"
    echo "  co         - Launch main menu"
    echo "  cc         - Switch to Claude Code"
    echo "  ol         - Switch to Ollama"
    echo "  co-help    - Show help"
    echo ""
    print_warning "Important: Keep your credentials secure!"
    echo ""
}

# Run main setup
main
