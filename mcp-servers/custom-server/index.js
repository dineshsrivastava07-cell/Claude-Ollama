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
