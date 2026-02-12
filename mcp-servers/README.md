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
