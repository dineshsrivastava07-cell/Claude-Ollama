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

    LOG_FILE="${LOGS_DIR}/claude-code-$(date +%Y%m%d-%H%M%S).log"
    claude --model "${MODEL}" 2>&1 | tee "${LOG_FILE}"
}

start_ollama_chat() {
    show_banner
    echo -e "${GREEN}Starting Ollama Chat${NC}"
    echo ""
    echo -e "${CYAN}Available Ollama Models:${NC}"

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

        LOG_FILE="${LOGS_DIR}/ollama-${SELECTED_MODEL}-$(date +%Y%m%d-%H%M%S).log"
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

main
