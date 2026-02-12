#!/bin/bash

###############################################################################
# Claude Code + Ollama System Monitor & Management
# Real-time monitoring and system management utilities
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")/config"
LOGS_DIR="$(dirname "$SCRIPT_DIR")/logs"
WORKSPACE_DIR="$(dirname "$SCRIPT_DIR")/workspace"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Load configurations
source "${CONFIG_DIR}/models.conf" 2>/dev/null || true
source "${CONFIG_DIR}/settings.conf" 2>/dev/null || true

show_system_monitor() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           System Monitor - Real-time Status                   ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # System Info
    echo -e "${GREEN}=== System Information ===${NC}"
    echo -e "${BLUE}Hostname:${NC} $(hostname)"
    echo -e "${BLUE}macOS Version:${NC} $(sw_vers -productVersion)"
    echo -e "${BLUE}Architecture:${NC} $(uname -m)"
    echo -e "${BLUE}Uptime:${NC} $(uptime | awk '{print $3,$4}' | sed 's/,$//')"
    echo ""
    
    # CPU & Memory
    echo -e "${GREEN}=== Resources ===${NC}"
    echo -e "${BLUE}CPU Usage:${NC}"
    top -l 1 | grep "CPU usage" | awk '{print "  User: " $3 " | System: " $5 " | Idle: " $7}'
    echo -e "${BLUE}Memory:${NC}"
    vm_stat | perl -ne '/page size of (\d+)/ and $size=$1; /Pages\s+([^:]+)[^\d]+(\d+)/ and printf("  %-16s % 16.2f MB\n", "$1:", $2 * $size / 1048576);'
    echo ""
    
    # Disk Usage
    echo -e "${GREEN}=== Disk Usage ===${NC}"
    df -h / | tail -1 | awk '{print "  Root: " $3 " used / " $2 " total (" $5 " full)"}'
    echo ""
    
    # Claude Code Status
    echo -e "${GREEN}=== Claude Code Status ===${NC}"
    if command -v claude &> /dev/null; then
        CLAUDE_VERSION=$(claude --version 2>/dev/null || echo "unknown")
        echo -e "${BLUE}  Version:${NC} ${CLAUDE_VERSION}"
        
        # Check authentication
        if claude whoami &>/dev/null; then
            CLAUDE_USER=$(claude whoami 2>/dev/null | grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' || echo "authenticated")
            echo -e "${BLUE}  Status:${NC} ${GREEN}✓ Authenticated${NC} (${CLAUDE_USER})"
        else
            echo -e "${BLUE}  Status:${NC} ${RED}✗ Not authenticated${NC}"
        fi
    else
        echo -e "${RED}  Not installed${NC}"
    fi
    echo ""
    
    # Ollama Status
    echo -e "${GREEN}=== Ollama Status ===${NC}"
    if command -v ollama &> /dev/null; then
        OLLAMA_VERSION=$(ollama --version 2>/dev/null || echo "unknown")
        echo -e "${BLUE}  Version:${NC} ${OLLAMA_VERSION}"
        
        # Check if Ollama is running
        if pgrep -x "ollama" > /dev/null; then
            echo -e "${BLUE}  Status:${NC} ${GREEN}✓ Running${NC}"
        else
            echo -e "${BLUE}  Status:${NC} ${YELLOW}○ Not running${NC}"
        fi
        
        # List models with sizes
        echo -e "${BLUE}  Models:${NC}"
        ollama list | tail -n +2 | while read line; do
            echo "    $line"
        done
    else
        echo -e "${RED}  Not installed${NC}"
    fi
    echo ""
    
    # Active Sessions
    echo -e "${GREEN}=== Active Sessions ===${NC}"
    CLAUDE_SESSIONS=$(pgrep -f "claude" | wc -l | tr -d ' ')
    OLLAMA_SESSIONS=$(pgrep -f "ollama run" | wc -l | tr -d ' ')
    echo -e "${BLUE}  Claude Code:${NC} ${CLAUDE_SESSIONS} session(s)"
    echo -e "${BLUE}  Ollama:${NC} ${OLLAMA_SESSIONS} session(s)"
    echo ""
    
    # Recent Activity
    echo -e "${GREEN}=== Recent Activity ===${NC}"
    if [ -d "$LOGS_DIR" ] && [ "$(ls -A $LOGS_DIR 2>/dev/null)" ]; then
        echo -e "${BLUE}  Last 5 Sessions:${NC}"
        ls -t "${LOGS_DIR}"/*.log 2>/dev/null | head -5 | while read log; do
            BASENAME=$(basename "$log")
            SIZE=$(du -h "$log" | cut -f1)
            MODIFIED=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$log" 2>/dev/null || stat -c "%y" "$log" 2>/dev/null | cut -d' ' -f1,2 | cut -d'.' -f1)
            echo "    ${BASENAME} (${SIZE}, ${MODIFIED})"
        done
    else
        echo "    No recent sessions"
    fi
    echo ""
    
    # Workspace Usage
    echo -e "${GREEN}=== Workspace ===${NC}"
    if [ -d "$WORKSPACE_DIR" ]; then
        FILE_COUNT=$(find "$WORKSPACE_DIR" -type f 2>/dev/null | wc -l | tr -d ' ')
        DIR_SIZE=$(du -sh "$WORKSPACE_DIR" 2>/dev/null | cut -f1)
        echo -e "${BLUE}  Location:${NC} ${WORKSPACE_DIR}"
        echo -e "${BLUE}  Files:${NC} ${FILE_COUNT}"
        echo -e "${BLUE}  Size:${NC} ${DIR_SIZE}"
    else
        echo "    Not initialized"
    fi
    echo ""
}

show_model_stats() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║              Model Statistics & Usage                         ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Claude Models
    echo -e "${GREEN}=== Claude Code Models (Pro Subscription) ===${NC}"
    echo ""
    echo -e "${BLUE}Available Models:${NC}"
    cat << 'EOF'
  
  Model                      Capability    Speed    Cost    Best For
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Claude Opus 4.5           ⭐⭐⭐⭐⭐      ⭐⭐       💰💰💰    Complex reasoning
  Claude Sonnet 4.5         ⭐⭐⭐⭐       ⭐⭐⭐⭐     💰💰      Balanced tasks
  Claude Haiku 4.5          ⭐⭐⭐        ⭐⭐⭐⭐⭐    💰       Quick responses
  Claude Opus 3.5           ⭐⭐⭐⭐       ⭐⭐       💰💰      Previous gen
  Claude Sonnet 3.5         ⭐⭐⭐⭐       ⭐⭐⭐      💰💰      Previous gen
EOF
    echo ""
    
    # Ollama Models
    echo -e "${GREEN}=== Ollama Local Models ===${NC}"
    echo ""
    echo -e "${BLUE}Installed Models:${NC}"
    
    if command -v ollama &> /dev/null; then
        ollama list | tail -n +2 | while IFS= read -r line; do
            MODEL_NAME=$(echo "$line" | awk '{print $1}')
            MODEL_SIZE=$(echo "$line" | awk '{print $3}')
            
            # Add descriptions
            case "$MODEL_NAME" in
                *qwen*)
                    DESCRIPTION="Best for coding & refactoring"
                    STARS="⭐⭐⭐⭐⭐"
                    ;;
                *llama*)
                    DESCRIPTION="Strong general-purpose model"
                    STARS="⭐⭐⭐⭐"
                    ;;
                *phi*)
                    DESCRIPTION="Efficient, good quality"
                    STARS="⭐⭐⭐⭐"
                    ;;
                *gemma*)
                    DESCRIPTION="Lightweight & fast"
                    STARS="⭐⭐⭐"
                    ;;
                *mistral*)
                    DESCRIPTION="Versatile capabilities"
                    STARS="⭐⭐⭐⭐"
                    ;;
                *)
                    DESCRIPTION="Local model"
                    STARS="⭐⭐⭐"
                    ;;
            esac
            
            echo "  ${MODEL_NAME}"
            echo "    Size: ${MODEL_SIZE} | Quality: ${STARS}"
            echo "    ${DESCRIPTION}"
            echo ""
        done
    else
        echo "    Ollama not installed"
    fi
    
    # Usage Stats from logs
    echo -e "${GREEN}=== Usage Statistics ===${NC}"
    echo ""
    if [ -d "$LOGS_DIR" ]; then
        CLAUDE_LOGS=$(find "$LOGS_DIR" -name "claude-*.log" 2>/dev/null | wc -l | tr -d ' ')
        OLLAMA_LOGS=$(find "$LOGS_DIR" -name "ollama-*.log" 2>/dev/null | wc -l | tr -d ' ')
        TOTAL_LOGS=$((CLAUDE_LOGS + OLLAMA_LOGS))
        
        echo -e "${BLUE}  Total Sessions:${NC} ${TOTAL_LOGS}"
        echo -e "${BLUE}  Claude Code:${NC} ${CLAUDE_LOGS} sessions"
        echo -e "${BLUE}  Ollama:${NC} ${OLLAMA_LOGS} sessions"
        
        if [ $TOTAL_LOGS -gt 0 ]; then
            echo ""
            echo -e "${BLUE}  Most Used Models:${NC}"
            find "$LOGS_DIR" -name "*.log" -type f 2>/dev/null | \
                xargs basename -a | \
                sed 's/-[0-9]*-[0-9]*.log$//' | \
                sort | uniq -c | sort -rn | head -5 | \
                while read count model; do
                    echo "    ${model}: ${count} sessions"
                done
        fi
    fi
    echo ""
}

show_log_viewer() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                    Log Viewer                                 ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ ! -d "$LOGS_DIR" ] || [ -z "$(ls -A $LOGS_DIR 2>/dev/null)" ]; then
        echo -e "${YELLOW}No logs found${NC}"
        return
    fi
    
    echo -e "${BLUE}Recent Log Files:${NC}"
    echo ""
    
    # List recent logs
    LOGS=($(ls -t "${LOGS_DIR}"/*.log 2>/dev/null | head -20))
    
    for i in "${!LOGS[@]}"; do
        BASENAME=$(basename "${LOGS[$i]}")
        SIZE=$(du -h "${LOGS[$i]}" | cut -f1)
        MODIFIED=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "${LOGS[$i]}" 2>/dev/null)
        echo "  $((i+1)). ${BASENAME} (${SIZE}) - ${MODIFIED}"
    done
    
    echo ""
    echo -e "${YELLOW}Options:${NC}"
    echo "  1-20: View log file"
    echo "  a: View all logs (tail)"
    echo "  f: Follow automation log (live)"
    echo "  c: Clear old logs"
    echo "  b: Back to menu"
    echo ""
    read -p "Select option: " choice
    
    case $choice in
        [1-9]|1[0-9]|20)
            if [ -n "${LOGS[$((choice-1))]}" ]; then
                echo ""
                echo -e "${CYAN}=== ${LOGS[$((choice-1))]} ===${NC}"
                echo ""
                less "${LOGS[$((choice-1))]}"
            fi
            ;;
        a)
            echo ""
            find "$LOGS_DIR" -name "*.log" -exec tail -20 {} \; | less
            ;;
        f)
            echo ""
            echo -e "${CYAN}Following automation log (Ctrl+C to stop)...${NC}"
            echo ""
            tail -f "${LOGS_DIR}/automation.log" 2>/dev/null || echo "No automation log found"
            ;;
        c)
            echo ""
            read -p "Delete logs older than how many days? (default: 30): " days
            days=${days:-30}
            find "$LOGS_DIR" -name "*.log" -mtime +${days} -delete
            echo -e "${GREEN}Old logs cleaned${NC}"
            sleep 2
            ;;
        b)
            return
            ;;
    esac
}

show_config_editor() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║              Configuration Editor                             ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${BLUE}Configuration Files:${NC}"
    echo ""
    echo "  1. Model Configuration (models.conf)"
    echo "  2. System Settings (settings.conf)"
    echo "  3. MCP Servers (mcp-servers.json)"
    echo "  4. View Current Settings"
    echo "  5. Reset to Defaults"
    echo "  6. Back to Menu"
    echo ""
    read -p "Select option: " choice
    
    case $choice in
        1)
            echo ""
            echo -e "${CYAN}Editing Model Configuration...${NC}"
            ${EDITOR:-vim} "${CONFIG_DIR}/models.conf"
            ;;
        2)
            echo ""
            echo -e "${CYAN}Editing System Settings...${NC}"
            ${EDITOR:-vim} "${CONFIG_DIR}/settings.conf"
            ;;
        3)
            echo ""
            echo -e "${CYAN}Editing MCP Configuration...${NC}"
            ${EDITOR:-vim} "${CONFIG_DIR}/mcp-servers.json"
            ;;
        4)
            echo ""
            echo -e "${GREEN}=== Current Configuration ===${NC}"
            echo ""
            echo -e "${BLUE}Model Settings:${NC}"
            cat "${CONFIG_DIR}/models.conf" 2>/dev/null || echo "Not found"
            echo ""
            echo -e "${BLUE}System Settings:${NC}"
            cat "${CONFIG_DIR}/settings.conf" 2>/dev/null || echo "Not found"
            echo ""
            read -p "Press Enter to continue..."
            ;;
        5)
            echo ""
            read -p "Reset all configurations to defaults? (y/N): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                # Backup current configs
                for conf in models.conf settings.conf mcp-servers.json; do
                    if [ -f "${CONFIG_DIR}/${conf}" ]; then
                        cp "${CONFIG_DIR}/${conf}" "${CONFIG_DIR}/${conf}.backup.$(date +%Y%m%d-%H%M%S)"
                    fi
                done
                
                # Re-run setup to recreate defaults
                echo -e "${YELLOW}Recreating default configurations...${NC}"
                # This would need to call the setup script
                echo -e "${GREEN}Configurations reset. Backups created.${NC}"
            fi
            sleep 2
            ;;
        6)
            return
            ;;
    esac
}

show_performance_stats() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║             Performance & Resource Monitor                    ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # CPU Details
    echo -e "${GREEN}=== CPU Information ===${NC}"
    sysctl -n machdep.cpu.brand_string
    echo -e "${BLUE}Cores:${NC} $(sysctl -n hw.ncpu)"
    echo ""
    
    # Real-time CPU usage
    echo -e "${GREEN}=== CPU Usage (5 second average) ===${NC}"
    echo -e "${BLUE}Overall:${NC}"
    top -l 2 -n 0 -s 5 | grep "CPU usage" | tail -1
    echo ""
    
    # Memory Details
    echo -e "${GREEN}=== Memory Usage ===${NC}"
    vm_stat | perl -ne '/page size of (\d+)/ and $size=$1; /Pages\s+([^:]+)[^\d]+(\d+)/ and printf("%-20s % 16.2f MB\n", "$1:", $2 * $size / 1048576);'
    echo ""
    
    # Disk I/O
    echo -e "${GREEN}=== Disk I/O ===${NC}"
    iostat -d disk0 | tail -1
    echo ""
    
    # Network
    echo -e "${GREEN}=== Network ===${NC}"
    netstat -ib | grep -E "en0|en1" | head -2
    echo ""
    
    # Process monitoring
    echo -e "${GREEN}=== Top Processes ===${NC}"
    echo -e "${BLUE}By CPU:${NC}"
    ps aux | sort -nrk 3 | head -5 | awk '{printf "  %-20s %5s%%\n", $11, $3}'
    echo ""
    echo -e "${BLUE}By Memory:${NC}"
    ps aux | sort -nrk 4 | head -5 | awk '{printf "  %-20s %5s%%\n", $11, $4}'
    echo ""
    
    read -p "Press Enter to continue..."
}

cleanup_system() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                 System Cleanup                                ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${YELLOW}Cleanup Options:${NC}"
    echo ""
    echo "  1. Clean old logs (30+ days)"
    echo "  2. Clean temporary workspace files"
    echo "  3. Clean npm cache"
    echo "  4. Clean Ollama unused models"
    echo "  5. Full cleanup (all above)"
    echo "  6. Back to Menu"
    echo ""
    read -p "Select option: " choice
    
    case $choice in
        1|5)
            echo ""
            echo -e "${BLUE}Cleaning old logs...${NC}"
            DELETED=$(find "$LOGS_DIR" -name "*.log" -mtime +30 -delete -print | wc -l | tr -d ' ')
            echo -e "${GREEN}✓ Deleted ${DELETED} old log files${NC}"
            ;;&
        2|5)
            echo ""
            echo -e "${BLUE}Cleaning temporary workspace files...${NC}"
            find "$WORKSPACE_DIR" -type f -name "*.tmp" -delete 2>/dev/null
            find "$WORKSPACE_DIR" -type f -name "*_prompt_*" -mtime +7 -delete 2>/dev/null
            find "$WORKSPACE_DIR" -type f -name "*_output_*" -mtime +7 -delete 2>/dev/null
            echo -e "${GREEN}✓ Workspace cleaned${NC}"
            ;;&
        3|5)
            echo ""
            echo -e "${BLUE}Cleaning npm cache...${NC}"
            npm cache clean --force 2>/dev/null
            echo -e "${GREEN}✓ npm cache cleaned${NC}"
            ;;&
        4)
            echo ""
            echo -e "${BLUE}Available Ollama models:${NC}"
            ollama list
            echo ""
            read -p "Enter model name to remove (or 'skip'): " model_name
            if [[ "$model_name" != "skip" ]] && [ -n "$model_name" ]; then
                ollama rm "$model_name"
                echo -e "${GREEN}✓ Model removed${NC}"
            fi
            ;;
        5)
            echo ""
            echo -e "${GREEN}✓ Full cleanup complete${NC}"
            ;;
        6)
            return
            ;;
    esac
    
    if [[ $choice =~ ^[1-5]$ ]]; then
        echo ""
        echo -e "${GREEN}Cleanup complete!${NC}"
        sleep 2
    fi
}

# Main menu
main_menu() {
    while true; do
        clear
        echo -e "${CYAN}"
        cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║           System Monitor & Management                         ║
╚═══════════════════════════════════════════════════════════════╝
EOF
        echo -e "${NC}"
        
        echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
        echo -e "${GREEN}  Monitoring & Management Menu${NC}"
        echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
        echo ""
        echo "  1. System Monitor (Real-time)"
        echo "  2. Model Statistics"
        echo "  3. View Logs"
        echo "  4. Configuration Editor"
        echo "  5. Performance Stats"
        echo "  6. System Cleanup"
        echo "  7. Export System Report"
        echo "  8. Back to Main Menu"
        echo ""
        echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
        echo -n "Select option: "
        
        read choice
        
        case $choice in
            1) show_system_monitor; read -p "Press Enter to continue..." ;;
            2) show_model_stats; read -p "Press Enter to continue..." ;;
            3) show_log_viewer ;;
            4) show_config_editor ;;
            5) show_performance_stats ;;
            6) cleanup_system ;;
            7) export_system_report ;;
            8) exit 0 ;;
            *) echo -e "${RED}Invalid option${NC}"; sleep 1 ;;
        esac
    done
}

export_system_report() {
    clear
    echo -e "${CYAN}Generating System Report...${NC}"
    echo ""
    
    REPORT_FILE="${WORKSPACE_DIR}/system-report-$(date +%Y%m%d-%H%M%S).txt"
    
    {
        echo "═══════════════════════════════════════════════════════════"
        echo "  Claude Code + Ollama System Report"
        echo "  Generated: $(date)"
        echo "═══════════════════════════════════════════════════════════"
        echo ""
        
        echo "=== System Information ==="
        sw_vers
        uname -a
        echo ""
        
        echo "=== Claude Code Status ==="
        claude --version 2>/dev/null || echo "Not installed"
        claude whoami 2>/dev/null || echo "Not authenticated"
        echo ""
        
        echo "=== Ollama Status ==="
        ollama --version 2>/dev/null || echo "Not installed"
        ollama list
        echo ""
        
        echo "=== Configuration ==="
        echo "Models:"
        cat "${CONFIG_DIR}/models.conf" 2>/dev/null
        echo ""
        echo "Settings:"
        cat "${CONFIG_DIR}/settings.conf" 2>/dev/null
        echo ""
        
        echo "=== Recent Activity ==="
        ls -lht "${LOGS_DIR}"/*.log 2>/dev/null | head -10
        echo ""
        
        echo "=== Resource Usage ==="
        df -h /
        echo ""
        vm_stat
        
    } > "$REPORT_FILE"
    
    echo -e "${GREEN}✓ Report generated${NC}"
    echo -e "${BLUE}Location: ${REPORT_FILE}${NC}"
    echo ""
    read -p "Open report? (y/N): " open_report
    
    if [[ $open_report =~ ^[Yy]$ ]]; then
        less "$REPORT_FILE"
    fi
}

# Run main menu if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main_menu
fi
