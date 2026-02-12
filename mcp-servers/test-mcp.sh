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
