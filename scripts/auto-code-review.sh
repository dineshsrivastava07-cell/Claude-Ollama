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
