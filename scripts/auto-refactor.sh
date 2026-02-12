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
