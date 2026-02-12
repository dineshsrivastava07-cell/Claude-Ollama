#!/bin/bash

###############################################################################
# Advanced Task Automation for Claude Code + Ollama
# Provides intelligent task routing and execution
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")/config"
WORKSPACE_DIR="$(dirname "$SCRIPT_DIR")/workspace"
LOGS_DIR="$(dirname "$SCRIPT_DIR")/logs"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Load configurations
source "${CONFIG_DIR}/models.conf" 2>/dev/null || true
source "${CONFIG_DIR}/settings.conf" 2>/dev/null || true

log_message() {
    local level="$1"
    shift
    local message="$@"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[${timestamp}] [${level}] ${message}" | tee -a "${LOGS_DIR}/automation.log"
}

# Intelligent task router - decides which model to use
route_task() {
    local task_type="$1"
    local task_description="$2"
    
    case "$task_type" in
        "code_generation")
            # Use Qwen Coder for code generation (fast and local)
            echo "qwen2.5-coder:7b"
            ;;
        "code_review")
            # Use Claude Sonnet for code review (better reasoning)
            echo "claude-sonnet-4-5-20250929"
            ;;
        "complex_reasoning")
            # Use Claude Opus for complex tasks
            echo "claude-opus-4-5-20251101"
            ;;
        "documentation")
            # Use Claude Sonnet for documentation
            echo "claude-sonnet-4-5-20250929"
            ;;
        "quick_task")
            # Use local model for quick tasks
            echo "phi3.5"
            ;;
        "refactoring")
            # Use Qwen Coder for refactoring
            echo "qwen2.5-coder:7b"
            ;;
        *)
            # Default to Claude Sonnet
            echo "claude-sonnet-4-5-20250929"
            ;;
    esac
}

# Execute task with appropriate model
execute_task() {
    local task_type="$1"
    local prompt_file="$2"
    local output_file="$3"
    
    local model=$(route_task "$task_type")
    
    log_message "INFO" "Routing task '$task_type' to model: $model"
    
    # Check if it's a Claude or Ollama model
    if [[ "$model" == claude-* ]]; then
        # Claude Code execution
        log_message "INFO" "Using Claude Code API"
        claude --model "$model" < "$prompt_file" > "$output_file" 2>&1
    else
        # Ollama execution
        log_message "INFO" "Using Ollama local model"
        ollama run "$model" < "$prompt_file" > "$output_file" 2>&1
    fi
    
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        log_message "SUCCESS" "Task completed successfully"
        return 0
    else
        log_message "ERROR" "Task failed with exit code: $exit_code"
        return 1
    fi
}

# Automated code review with detailed analysis
run_code_review() {
    local target_path="$1"
    
    if [ -z "$target_path" ]; then
        echo -e "${RED}Error: Please provide a path to review${NC}"
        return 1
    fi
    
    echo -e "${CYAN}=== Automated Code Review ===${NC}"
    echo -e "${BLUE}Target: ${target_path}${NC}"
    echo ""
    
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local prompt_file="${WORKSPACE_DIR}/review_prompt_${timestamp}.txt"
    local output_file="${WORKSPACE_DIR}/review_output_${timestamp}.md"
    
    # Create review prompt
    cat > "$prompt_file" << EOF
You are an expert code reviewer. Please perform a comprehensive code review of the following code/project:

Path: ${target_path}

Please analyze:
1. Code Quality & Structure
   - Naming conventions
   - Code organization
   - Design patterns usage
   - SOLID principles adherence

2. Security
   - Potential vulnerabilities
   - Input validation
   - Authentication/authorization
   - Data protection

3. Performance
   - Time complexity
   - Memory usage
   - Database queries
   - Caching opportunities

4. Best Practices
   - Language-specific idioms
   - Error handling
   - Logging
   - Testing coverage

5. Maintainability
   - Documentation
   - Code comments
   - Complexity
   - Dependencies

Please provide:
- Overall assessment (score 1-10)
- Critical issues (must fix)
- Important issues (should fix)
- Suggestions (nice to have)
- Positive aspects

Format the output as a detailed markdown report.

Project/Code to review:
$(cat "$target_path" 2>/dev/null || echo "Directory: $target_path")
EOF
    
    echo -e "${YELLOW}Running code review...${NC}"
    execute_task "code_review" "$prompt_file" "$output_file"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}Code review complete!${NC}"
        echo -e "${BLUE}Report saved to: ${output_file}${NC}"
        echo ""
        echo -e "${CYAN}=== Review Summary ===${NC}"
        cat "$output_file"
    fi
}

# Generate comprehensive documentation
generate_documentation() {
    local project_path="$1"
    local output_dir="$2"
    
    if [ -z "$project_path" ]; then
        echo -e "${RED}Error: Please provide a project path${NC}"
        return 1
    fi
    
    output_dir="${output_dir:-${project_path}/docs}"
    mkdir -p "$output_dir"
    
    echo -e "${CYAN}=== Documentation Generator ===${NC}"
    echo -e "${BLUE}Project: ${project_path}${NC}"
    echo -e "${BLUE}Output: ${output_dir}${NC}"
    echo ""
    
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local prompt_file="${WORKSPACE_DIR}/docs_prompt_${timestamp}.txt"
    
    # Create documentation prompt
    cat > "$prompt_file" << EOF
You are a technical documentation expert. Please generate comprehensive documentation for this project:

Project Path: ${project_path}

Please create the following documentation:

1. README.md
   - Project overview
   - Features
   - Installation instructions
   - Quick start guide
   - Usage examples
   - Configuration
   - Contributing guidelines
   - License information

2. ARCHITECTURE.md
   - System architecture
   - Component diagram
   - Data flow
   - Technology stack
   - Design decisions

3. API.md (if applicable)
   - API endpoints
   - Request/response formats
   - Authentication
   - Error codes
   - Examples

4. DEVELOPMENT.md
   - Development setup
   - Build process
   - Testing
   - Debugging
   - Coding standards

5. DEPLOYMENT.md
   - Deployment process
   - Environment setup
   - Configuration management
   - Monitoring
   - Troubleshooting

Please analyze the project and generate appropriate documentation.

Project structure and code:
$(find "$project_path" -type f -name "*.py" -o -name "*.js" -o -name "*.go" -o -name "*.java" 2>/dev/null | head -20)
EOF
    
    echo -e "${YELLOW}Generating documentation...${NC}"
    
    # Generate each documentation file
    local docs=("README.md" "ARCHITECTURE.md" "API.md" "DEVELOPMENT.md" "DEPLOYMENT.md")
    
    for doc in "${docs[@]}"; do
        echo -e "${BLUE}Generating ${doc}...${NC}"
        execute_task "documentation" "$prompt_file" "${output_dir}/${doc}"
    done
    
    echo ""
    echo -e "${GREEN}Documentation generated!${NC}"
    echo -e "${BLUE}Output directory: ${output_dir}${NC}"
}

# Intelligent code refactoring
refactor_code() {
    local file_path="$1"
    local refactor_type="$2"
    
    if [ -z "$file_path" ]; then
        echo -e "${RED}Error: Please provide a file path${NC}"
        return 1
    fi
    
    refactor_type="${refactor_type:-general}"
    
    echo -e "${CYAN}=== Code Refactoring ===${NC}"
    echo -e "${BLUE}File: ${file_path}${NC}"
    echo -e "${BLUE}Type: ${refactor_type}${NC}"
    echo ""
    
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local prompt_file="${WORKSPACE_DIR}/refactor_prompt_${timestamp}.txt"
    local output_file="${WORKSPACE_DIR}/refactor_output_${timestamp}.txt"
    local backup_file="${file_path}.backup.${timestamp}"
    
    # Backup original file
    cp "$file_path" "$backup_file"
    echo -e "${GREEN}Backup created: ${backup_file}${NC}"
    
    # Create refactoring prompt
    cat > "$prompt_file" << EOF
You are an expert code refactoring specialist. Please refactor the following code:

File: ${file_path}
Refactoring Type: ${refactor_type}

Focus areas:
1. Code readability and clarity
2. Performance optimization
3. Best practices and idioms
4. Error handling
5. Code organization
6. Remove duplication
7. Improve naming
8. Add comments where helpful

Please provide:
1. The refactored code
2. Explanation of changes
3. Performance implications
4. Any breaking changes

Original code:
$(cat "$file_path")
EOF
    
    echo -e "${YELLOW}Refactoring code...${NC}"
    execute_task "refactoring" "$prompt_file" "$output_file"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}Refactoring complete!${NC}"
        echo -e "${BLUE}Results saved to: ${output_file}${NC}"
        echo -e "${BLUE}Original backed up to: ${backup_file}${NC}"
        echo ""
        echo -e "${CYAN}=== Refactoring Summary ===${NC}"
        cat "$output_file"
    fi
}

# Run comprehensive test suite
run_test_suite() {
    local project_path="$1"
    
    echo -e "${CYAN}=== Test Suite Runner ===${NC}"
    echo -e "${BLUE}Project: ${project_path}${NC}"
    echo ""
    
    # Detect test framework
    if [ -f "${project_path}/pytest.ini" ] || [ -f "${project_path}/setup.py" ]; then
        echo -e "${GREEN}Detected Python project with pytest${NC}"
        cd "$project_path"
        pytest -v --cov --cov-report=html
    elif [ -f "${project_path}/package.json" ]; then
        echo -e "${GREEN}Detected Node.js project${NC}"
        cd "$project_path"
        npm test
    elif [ -f "${project_path}/go.mod" ]; then
        echo -e "${GREEN}Detected Go project${NC}"
        cd "$project_path"
        go test -v ./...
    else
        echo -e "${YELLOW}Test framework not detected. Please specify manually.${NC}"
    fi
}

# Deploy application
deploy_application() {
    local project_path="$1"
    local environment="$2"
    
    environment="${environment:-staging}"
    
    echo -e "${CYAN}=== Application Deployment ===${NC}"
    echo -e "${BLUE}Project: ${project_path}${NC}"
    echo -e "${BLUE}Environment: ${environment}${NC}"
    echo ""
    
    echo -e "${YELLOW}This is a placeholder for deployment automation${NC}"
    echo -e "${YELLOW}Customize this function based on your deployment process${NC}"
    
    # Example deployment steps
    echo "1. Running tests..."
    echo "2. Building application..."
    echo "3. Deploying to ${environment}..."
    echo "4. Running health checks..."
    echo "5. Deployment complete!"
}

# Interactive prompt builder
build_custom_prompt() {
    echo -e "${CYAN}=== Custom Prompt Builder ===${NC}"
    echo ""
    
    echo -e "${BLUE}Select task type:${NC}"
    echo "1. Code generation"
    echo "2. Code review"
    echo "3. Documentation"
    echo "4. Refactoring"
    echo "5. Debugging"
    echo "6. Custom"
    echo ""
    read -p "Choice: " task_choice
    
    echo ""
    echo -e "${BLUE}Enter your prompt (end with Ctrl+D):${NC}"
    local prompt=$(cat)
    
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local prompt_file="${WORKSPACE_DIR}/custom_prompt_${timestamp}.txt"
    local output_file="${WORKSPACE_DIR}/custom_output_${timestamp}.txt"
    
    echo "$prompt" > "$prompt_file"
    
    case $task_choice in
        1) execute_task "code_generation" "$prompt_file" "$output_file" ;;
        2) execute_task "code_review" "$prompt_file" "$output_file" ;;
        3) execute_task "documentation" "$prompt_file" "$output_file" ;;
        4) execute_task "refactoring" "$prompt_file" "$output_file" ;;
        5) execute_task "quick_task" "$prompt_file" "$output_file" ;;
        6) execute_task "complex_reasoning" "$prompt_file" "$output_file" ;;
    esac
    
    echo ""
    echo -e "${GREEN}Task complete!${NC}"
    echo -e "${BLUE}Output saved to: ${output_file}${NC}"
    cat "$output_file"
}

# Main menu for advanced automation
show_automation_menu() {
    clear
    echo -e "${CYAN}"
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════╗
║        Advanced Task Automation                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo -e "${BLUE}Available Tasks:${NC}"
    echo ""
    echo "  1. Code Review"
    echo "  2. Generate Documentation"
    echo "  3. Refactor Code"
    echo "  4. Run Test Suite"
    echo "  5. Deploy Application"
    echo "  6. Custom Prompt"
    echo "  7. Back to Main Menu"
    echo ""
    read -p "Select task: " choice
    
    case $choice in
        1)
            read -p "Enter path to review: " path
            run_code_review "$path"
            ;;
        2)
            read -p "Enter project path: " path
            read -p "Enter output directory (optional): " output
            generate_documentation "$path" "$output"
            ;;
        3)
            read -p "Enter file path: " path
            read -p "Refactoring type (or Enter for general): " type
            refactor_code "$path" "$type"
            ;;
        4)
            read -p "Enter project path: " path
            run_test_suite "$path"
            ;;
        5)
            read -p "Enter project path: " path
            read -p "Environment (staging/production): " env
            deploy_application "$path" "$env"
            ;;
        6)
            build_custom_prompt
            ;;
        7)
            return
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    show_automation_menu
}

# If script is run directly, show menu
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    show_automation_menu
fi
