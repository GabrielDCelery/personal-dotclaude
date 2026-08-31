#!/usr/bin/env bash
set -e

YELLOW='\033[0;33m'
NC='\033[0m'

if claude mcp get context7 >/dev/null 2>&1; then
    printf "${YELLOW}skip: Context7 MCP server is already registered${NC}\n"
elif [ -z "${CONTEXT7_API_KEY}" ]; then
    printf "${YELLOW}skip: CONTEXT7_API_KEY is not set, not registering Context7 MCP server${NC}\n"
else
    claude mcp add --header "CONTEXT7_API_KEY: ${CONTEXT7_API_KEY}" -s user --transport http context7 https://mcp.context7.com/mcp
fi
