#!/bin/bash

###############################################################################
# MCP Server Integration for Claude Code + Ollama
# Enables Model Context Protocol servers for extended functionality
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MCP_DIR="$(dirname "$SCRIPT_DIR")/mcp-servers"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")/config"
LOGS_DIR="$(dirname "$SCRIPT_DIR")/logs"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

mkdir -p "$MCP_DIR"

echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  MCP Server Integration Setup                             ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Create MCP server configuration
create_mcp_config() {
    local config_file="${CONFIG_DIR}/mcp-servers.json"
    
    echo -e "${BLUE}Creating MCP server configuration...${NC}"
    
    cat > "$config_file" << 'EOFMCP'
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/dsr-ai-lab/Claude-Ollama/workspace",
        "/Users/dsr-ai-lab/Documents",
        "/Users/dsr-ai-lab/Desktop"
      ],
      "description": "Access to Mac Mini filesystem"
    },
    "git": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-git"],
      "description": "Git repository operations"
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your-github-token-here"
      },
      "description": "GitHub API access"
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://localhost/mydb"
      },
      "description": "PostgreSQL database access"
    },
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "your-brave-api-key"
      },
      "description": "Web search via Brave"
    },
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-puppeteer"],
      "description": "Browser automation"
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "your-slack-token",
        "SLACK_TEAM_ID": "your-team-id"
      },
      "description": "Slack integration"
    },
    "sqlite": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sqlite"],
      "description": "SQLite database access"
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "description": "Persistent memory storage"
    }
  }
}
EOFMCP
    
    echo -e "${GREEN}✓ MCP configuration created${NC}"
    echo -e "${YELLOW}Note: Update API keys and tokens in: ${config_file}${NC}"
}

# Install common MCP servers
install_mcp_servers() {
    echo ""
    echo -e "${BLUE}Installing common MCP servers...${NC}"
    
    # Install via npx (they'll be cached)
    local servers=(
        "@modelcontextprotocol/server-filesystem"
        "@modelcontextprotocol/server-git"
        "@modelcontextprotocol/server-github"
        "@modelcontextprotocol/server-memory"
        "@modelcontextprotocol/server-sqlite"
    )
    
    for server in "${servers[@]}"; do
        echo -e "${YELLOW}Caching ${server}...${NC}"
        npx -y "$server" --version &>/dev/null || true
    done
    
    echo -e "${GREEN}✓ MCP servers installed${NC}"
}

# Create custom MCP server template
create_custom_server_template() {
    echo ""
    echo -e "${BLUE}Creating custom MCP server template...${NC}"
    
    mkdir -p "${MCP_DIR}/custom-server"
    
    cat > "${MCP_DIR}/custom-server/index.js" << 'EOFCUSTOM'
#!/usr/bin/env node

/**
 * Custom MCP Server for Claude Code
 * Extend this template to add your own tools and resources
 */

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  Tool,
} from "@modelcontextprotocol/sdk/types.js";

// Define your custom tools
const TOOLS = [
  {
    name: "custom_tool",
    description: "A custom tool for your specific use case",
    inputSchema: {
      type: "object",
      properties: {
        input: {
          type: "string",
          description: "Input for the custom tool",
        },
      },
      required: ["input"],
    },
  },
];

// Create server instance
const server = new Server(
  {
    name: "custom-mcp-server",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// List available tools
server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: TOOLS,
}));

// Handle tool calls
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  switch (name) {
    case "custom_tool": {
      const { input } = args;
      
      // Implement your custom logic here
      const result = `Processed: ${input}`;
      
      return {
        content: [
          {
            type: "text",
            text: result,
          },
        ],
      };
    }

    default:
      throw new Error(`Unknown tool: ${name}`);
  }
});

// Start server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("Custom MCP server running on stdio");
}

main().catch((error) => {
  console.error("Server error:", error);
  process.exit(1);
});
EOFCUSTOM

    cat > "${MCP_DIR}/custom-server/package.json" << 'EOFPKG'
{
  "name": "custom-mcp-server",
  "version": "1.0.0",
  "type": "module",
  "description": "Custom MCP server for Claude Code",
  "main": "index.js",
  "bin": {
    "custom-mcp-server": "./index.js"
  },
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "latest"
  }
}
EOFPKG

    chmod +x "${MCP_DIR}/custom-server/index.js"
    
    echo -e "${GREEN}✓ Custom server template created${NC}"
    echo -e "${BLUE}Location: ${MCP_DIR}/custom-server${NC}"
}

# Create Claude Code configuration with MCP
create_claude_config() {
    echo ""
    echo -e "${BLUE}Creating Claude Code configuration...${NC}"
    
    local claude_config_dir="${HOME}/.config/claude"
    mkdir -p "$claude_config_dir"
    
    # Copy MCP configuration to Claude config
    cp "${CONFIG_DIR}/mcp-servers.json" "${claude_config_dir}/mcp-servers.json"
    
    echo -e "${GREEN}✓ Claude Code configured with MCP servers${NC}"
    echo -e "${BLUE}Configuration: ${claude_config_dir}/mcp-servers.json${NC}"
}

# Create MCP testing script
create_mcp_tester() {
    echo ""
    echo -e "${BLUE}Creating MCP testing script...${NC}"
    
    cat > "${MCP_DIR}/test-mcp.sh" << 'EOFTEST'
#!/bin/bash

# Test MCP server connectivity

echo "Testing MCP Servers..."
echo ""

# Test filesystem server
echo "1. Testing filesystem server..."
echo '{"jsonrpc":"2.0","id":1,"method":"tools/list"}' | \
    npx -y @modelcontextprotocol/server-filesystem /tmp

echo ""
echo "2. Testing git server..."
echo '{"jsonrpc":"2.0","id":1,"method":"tools/list"}' | \
    npx -y @modelcontextprotocol/server-git

echo ""
echo "Testing complete!"
EOFTEST

    chmod +x "${MCP_DIR}/test-mcp.sh"
    
    echo -e "${GREEN}✓ MCP testing script created${NC}"
}

# Create documentation
create_mcp_docs() {
    echo ""
    echo -e "${BLUE}Creating MCP documentation...${NC}"
    
    cat > "${MCP_DIR}/README.md" << 'EOFDOCS'
# MCP Server Integration

## Overview

Model Context Protocol (MCP) servers extend Claude Code with additional capabilities including filesystem access, database connections, API integrations, and more.

## Available MCP Servers

### Built-in Servers

1. **Filesystem** - Access files and directories
   - Read/write files
   - List directories
   - Create/delete files

2. **Git** - Git repository operations
   - Clone repositories
   - Commit changes
   - View history

3. **GitHub** - GitHub API integration
   - Create issues
   - Manage PRs
   - Repository operations

4. **Database Servers**
   - PostgreSQL
   - SQLite
   - MySQL (via custom server)

5. **Web & Search**
   - Brave Search
   - Puppeteer (browser automation)

6. **Communication**
   - Slack integration
   - Email (via custom server)

7. **Memory** - Persistent storage for context

## Configuration

MCP servers are configured in: `~/Claude-Ollama/config/mcp-servers.json`

## Usage with Claude Code

Claude Code automatically discovers and loads MCP servers from the configuration file.

```bash
# Start Claude Code with MCP support
claude --model claude-sonnet-4-5-20250929

# In the chat, Claude can now use MCP tools:
# "List files in my workspace"
# "Create a new GitHub issue"
# "Search the web for information"
```

## Custom MCP Servers

Create custom servers in: `~/Claude-Ollama/mcp-servers/`

Template provided in: `~/Claude-Ollama/mcp-servers/custom-server/`

### Creating a Custom Server

1. Copy the template:
   ```bash
   cp -r ~/Claude-Ollama/mcp-servers/custom-server ~/Claude-Ollama/mcp-servers/my-server
   ```

2. Edit `index.js` to add your tools

3. Install dependencies:
   ```bash
   cd ~/Claude-Ollama/mcp-servers/my-server
   npm install
   ```

4. Add to configuration:
   ```json
   {
     "my-server": {
       "command": "node",
       "args": ["/Users/dsr-ai-lab/Claude-Ollama/mcp-servers/my-server/index.js"]
     }
   }
   ```

## Testing

Test MCP servers:
```bash
~/Claude-Ollama/mcp-servers/test-mcp.sh
```

## Security Notes

- MCP servers have direct access to system resources
- Always review server code before enabling
- Use environment variables for sensitive credentials
- Limit filesystem access to specific directories

## API Keys

Update these in `mcp-servers.json`:
- `GITHUB_PERSONAL_ACCESS_TOKEN` - GitHub API
- `BRAVE_API_KEY` - Brave Search
- `SLACK_BOT_TOKEN` - Slack integration
- Database connection strings

## Troubleshooting

### Server not loading
- Check Node.js is installed
- Verify server path in configuration
- Check logs: `~/Claude-Ollama/logs/`

### Permission errors
- Ensure execute permissions on server files
- Check filesystem access paths

### API authentication
- Verify API keys in configuration
- Check environment variables

## Resources

- [MCP Documentation](https://github.com/anthropics/anthropic-sdk-typescript/tree/main/packages/model-context-protocol)
- [Official MCP Servers](https://github.com/modelcontextprotocol/servers)
- [Creating MCP Servers](https://docs.anthropic.com/claude/docs/mcp)
EOFDOCS

    echo -e "${GREEN}✓ MCP documentation created${NC}"
}

# Main setup
main() {
    create_mcp_config
    install_mcp_servers
    create_custom_server_template
    create_claude_config
    create_mcp_tester
    create_mcp_docs
    
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  MCP Integration Complete!                                ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. Update API keys in: ${CONFIG_DIR}/mcp-servers.json"
    echo "  2. Test servers: ${MCP_DIR}/test-mcp.sh"
    echo "  3. Read docs: ${MCP_DIR}/README.md"
    echo "  4. Start Claude Code with MCP support"
    echo ""
}

main
