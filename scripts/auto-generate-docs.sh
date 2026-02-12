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
