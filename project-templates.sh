#!/bin/bash

###############################################################################
# Project Template & Scaffolding Tool
# Quick project setup with Claude Code + Ollama integration
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$(dirname "$SCRIPT_DIR")/templates"
WORKSPACE_DIR="$(dirname "$SCRIPT_DIR")/workspace"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

mkdir -p "$TEMPLATES_DIR"

# Template definitions
create_python_project() {
    local project_name="$1"
    local project_dir="${WORKSPACE_DIR}/${project_name}"
    
    echo -e "${BLUE}Creating Python project: ${project_name}${NC}"
    
    mkdir -p "$project_dir"
    cd "$project_dir"
    
    # Project structure
    mkdir -p {src,tests,docs}
    
    # README
    cat > README.md << EOF
# ${project_name}

## Overview
${project_name} - A Python project created with Claude Code + Ollama automation

## Installation

\`\`\`bash
pip install -r requirements.txt
\`\`\`

## Usage

\`\`\`python
from src.main import main

main()
\`\`\`

## Development

\`\`\`bash
# Run tests
pytest

# Run with coverage
pytest --cov

# Lint
flake8 src/
\`\`\`

## License
MIT
EOF

    # requirements.txt
    cat > requirements.txt << EOF
# Core dependencies
requests>=2.31.0
python-dotenv>=1.0.0

# Development dependencies
pytest>=7.4.0
pytest-cov>=4.1.0
black>=23.0.0
flake8>=6.0.0
mypy>=1.5.0
EOF

    # pyproject.toml
    cat > pyproject.toml << EOF
[build-system]
requires = ["setuptools>=61.0", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "${project_name}"
version = "0.1.0"
description = "A Python project"
readme = "README.md"
requires-python = ">=3.8"
dependencies = [
    "requests>=2.31.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "pytest-cov>=4.1.0",
    "black>=23.0.0",
    "flake8>=6.0.0",
]

[tool.black]
line-length = 88
target-version = ['py38']

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
EOF

    # .gitignore
    cat > .gitignore << EOF
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
build/
dist/
*.egg-info/

# Testing
.pytest_cache/
.coverage
htmlcov/

# IDE
.vscode/
.idea/
*.swp
*.swo

# Environment
.env
.env.local
EOF

    # Main source file
    cat > src/main.py << EOF
"""Main module for ${project_name}."""

def main():
    """Main entry point."""
    print("Hello from ${project_name}!")

if __name__ == "__main__":
    main()
EOF

    # Test file
    cat > tests/test_main.py << EOF
"""Tests for main module."""
import pytest
from src.main import main

def test_main():
    """Test main function."""
    # Your tests here
    pass
EOF

    # Setup script
    cat > setup.sh << 'EOF'
#!/bin/bash
# Setup script

# Create virtual environment
python3 -m venv venv

# Activate
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Install dev dependencies
pip install -e ".[dev]"

echo "Setup complete! Activate with: source venv/bin/activate"
EOF
    chmod +x setup.sh
    
    echo -e "${GREEN}✓ Python project created${NC}"
    echo -e "${BLUE}Location: ${project_dir}${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  cd ${project_dir}"
    echo "  ./setup.sh"
}

create_nodejs_project() {
    local project_name="$1"
    local project_dir="${WORKSPACE_DIR}/${project_name}"
    
    echo -e "${BLUE}Creating Node.js project: ${project_name}${NC}"
    
    mkdir -p "$project_dir"
    cd "$project_dir"
    
    # Project structure
    mkdir -p {src,tests,docs}
    
    # package.json
    cat > package.json << EOF
{
  "name": "${project_name}",
  "version": "1.0.0",
  "description": "A Node.js project created with Claude Code + Ollama",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "lint": "eslint src/",
    "format": "prettier --write 'src/**/*.js'"
  },
  "keywords": [],
  "author": "",
  "license": "MIT",
  "dependencies": {
    "express": "^4.18.2",
    "dotenv": "^16.3.1"
  },
  "devDependencies": {
    "jest": "^29.7.0",
    "nodemon": "^3.0.1",
    "eslint": "^8.52.0",
    "prettier": "^3.0.3"
  }
}
EOF

    # README
    cat > README.md << EOF
# ${project_name}

## Overview
${project_name} - A Node.js project created with Claude Code + Ollama automation

## Installation

\`\`\`bash
npm install
\`\`\`

## Usage

\`\`\`bash
npm start
\`\`\`

## Development

\`\`\`bash
# Development with auto-reload
npm run dev

# Run tests
npm test

# Run with coverage
npm run test:coverage

# Lint
npm run lint
\`\`\`

## License
MIT
EOF

    # .gitignore
    cat > .gitignore << EOF
# Node
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Environment
.env
.env.local

# IDE
.vscode/
.idea/

# Testing
coverage/
.nyc_output/

# Build
dist/
build/
EOF

    # Main source
    cat > src/index.js << EOF
/**
 * Main entry point for ${project_name}
 */

require('dotenv').config();

function main() {
    console.log('Hello from ${project_name}!');
}

if (require.main === module) {
    main();
}

module.exports = { main };
EOF

    # Test file
    cat > tests/index.test.js << EOF
/**
 * Tests for main module
 */

const { main } = require('../src/index');

describe('Main', () => {
    test('should run without errors', () => {
        expect(() => main()).not.toThrow();
    });
});
EOF

    # ESLint config
    cat > .eslintrc.js << EOF
module.exports = {
    env: {
        node: true,
        es2021: true,
        jest: true
    },
    extends: 'eslint:recommended',
    parserOptions: {
        ecmaVersion: 'latest'
    },
    rules: {
        'indent': ['error', 4],
        'quotes': ['error', 'single'],
        'semi': ['error', 'always']
    }
};
EOF

    # Prettier config
    cat > .prettierrc << EOF
{
    "semi": true,
    "trailingComma": "es5",
    "singleQuote": true,
    "printWidth": 80,
    "tabWidth": 4
}
EOF

    # Jest config
    cat > jest.config.js << EOF
module.exports = {
    testEnvironment: 'node',
    coverageDirectory: 'coverage',
    collectCoverageFrom: [
        'src/**/*.js',
        '!src/**/*.test.js'
    ]
};
EOF

    echo -e "${GREEN}✓ Node.js project created${NC}"
    echo -e "${BLUE}Location: ${project_dir}${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  cd ${project_dir}"
    echo "  npm install"
}

create_web_app() {
    local project_name="$1"
    local project_dir="${WORKSPACE_DIR}/${project_name}"
    
    echo -e "${BLUE}Creating Web App project: ${project_name}${NC}"
    
    mkdir -p "$project_dir"
    cd "$project_dir"
    
    # Project structure
    mkdir -p {public,src/{components,styles,utils},tests}
    
    # index.html
    cat > public/index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${project_name}</title>
    <link rel="stylesheet" href="../src/styles/main.css">
</head>
<body>
    <div id="app">
        <header>
            <h1>${project_name}</h1>
        </header>
        <main id="content">
            <p>Welcome to your new web app!</p>
        </main>
    </div>
    <script type="module" src="../src/main.js"></script>
</body>
</html>
EOF

    # CSS
    cat > src/styles/main.css << EOF
:root {
    --primary-color: #007bff;
    --secondary-color: #6c757d;
    --background-color: #f8f9fa;
    --text-color: #212529;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
    line-height: 1.6;
    color: var(--text-color);
    background-color: var(--background-color);
}

#app {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}

header {
    text-align: center;
    padding: 40px 0;
}

h1 {
    color: var(--primary-color);
    font-size: 2.5rem;
}

main {
    padding: 20px;
    background: white;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}
EOF

    # JavaScript
    cat > src/main.js << EOF
/**
 * Main application entry point
 */

import { initApp } from './utils/app.js';

document.addEventListener('DOMContentLoaded', () => {
    initApp();
});
EOF

    cat > src/utils/app.js << EOF
/**
 * Application initialization
 */

export function initApp() {
    console.log('App initialized!');
    
    // Your app logic here
    const content = document.getElementById('content');
    if (content) {
        content.innerHTML += '<p>App is running!</p>';
    }
}
EOF

    # README
    cat > README.md << EOF
# ${project_name}

A modern web application created with Claude Code + Ollama automation

## Development

\`\`\`bash
# Simple HTTP server
python3 -m http.server 8000

# Or with Node.js
npx serve public
\`\`\`

Then open: http://localhost:8000

## Project Structure

\`\`\`
${project_name}/
├── public/
│   └── index.html
├── src/
│   ├── components/
│   ├── styles/
│   │   └── main.css
│   ├── utils/
│   │   └── app.js
│   └── main.js
└── tests/
\`\`\`

## License
MIT
EOF

    echo -e "${GREEN}✓ Web App project created${NC}"
    echo -e "${BLUE}Location: ${project_dir}${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  cd ${project_dir}"
    echo "  python3 -m http.server 8000"
}

create_api_project() {
    local project_name="$1"
    local project_dir="${WORKSPACE_DIR}/${project_name}"
    
    echo -e "${BLUE}Creating API project: ${project_name}${NC}"
    
    mkdir -p "$project_dir"
    cd "$project_dir"
    
    # Project structure
    mkdir -p {src/{routes,models,middleware,utils},tests}
    
    # Main server file
    cat > src/server.js << EOF
/**
 * Main API server
 */

const express = require('express');
const dotenv = require('dotenv');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.get('/', (req, res) => {
    res.json({ message: 'Welcome to ${project_name} API' });
});

app.get('/health', (req, res) => {
    res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

// Start server
app.listen(PORT, () => {
    console.log(\`Server running on port \${PORT}\`);
});

module.exports = app;
EOF

    # Package.json
    cat > package.json << EOF
{
  "name": "${project_name}",
  "version": "1.0.0",
  "description": "RESTful API with Express",
  "main": "src/server.js",
  "scripts": {
    "start": "node src/server.js",
    "dev": "nodemon src/server.js",
    "test": "jest --watchAll=false"
  },
  "dependencies": {
    "express": "^4.18.2",
    "dotenv": "^16.3.1",
    "cors": "^2.8.5"
  },
  "devDependencies": {
    "nodemon": "^3.0.1",
    "jest": "^29.7.0",
    "supertest": "^6.3.3"
  }
}
EOF

    # .env
    cat > .env << EOF
PORT=3000
NODE_ENV=development
EOF

    # README
    cat > README.md << EOF
# ${project_name} API

RESTful API created with Claude Code + Ollama automation

## Installation

\`\`\`bash
npm install
\`\`\`

## Usage

\`\`\`bash
# Development
npm run dev

# Production
npm start
\`\`\`

## API Endpoints

### Health Check
\`\`\`
GET /health
\`\`\`

### Root
\`\`\`
GET /
\`\`\`

## Testing

\`\`\`bash
npm test
\`\`\`

## License
MIT
EOF

    echo -e "${GREEN}✓ API project created${NC}"
    echo -e "${BLUE}Location: ${project_dir}${NC}"
}

# Main menu
show_template_menu() {
    clear
    echo -e "${CYAN}"
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║              Project Template Generator                       ║
╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo -e "${BLUE}Available Templates:${NC}"
    echo ""
    echo "  1. Python Project (with pytest, black, flake8)"
    echo "  2. Node.js Project (with Express, Jest)"
    echo "  3. Web Application (HTML, CSS, JS)"
    echo "  4. REST API (Express.js)"
    echo "  5. Custom Project (guided setup)"
    echo "  6. Exit"
    echo ""
    read -p "Select template: " choice
    
    case $choice in
        1)
            read -p "Project name: " name
            create_python_project "$name"
            ;;
        2)
            read -p "Project name: " name
            create_nodejs_project "$name"
            ;;
        3)
            read -p "Project name: " name
            create_web_app "$name"
            ;;
        4)
            read -p "Project name: " name
            create_api_project "$name"
            ;;
        5)
            echo "Custom project creation - use Claude Code to guide!"
            ;;
        6)
            exit 0
            ;;
    esac
    
    echo ""
    read -p "Create another project? (y/N): " again
    if [[ $again =~ ^[Yy]$ ]]; then
        show_template_menu
    fi
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    show_template_menu
fi
