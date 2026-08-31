#!/usr/bin/env bash
set -e

YELLOW='\033[0;33m'
NC='\033[0m'

if claude mcp get work-atlassian-confluence >/dev/null 2>&1; then
    printf "${YELLOW}skip: Atlassian Confluence MCP server is already registered${NC}\n"
elif [ -z "${WORK_CONFLUENCE_AUTH_HEADER}" ]; then
    printf "${YELLOW}skip: WORK_CONFLUENCE_AUTH_HEADER is not set, not registering Atlassian Confluence MCP server${NC}\n"
else
    claude mcp add-json work-atlassian-confluence "{\"type\":\"http\",\"url\":\"https://mcp.atlassian.com/v1/mcp\",\"headers\":{\"Authorization\":\"${WORK_CONFLUENCE_AUTH_HEADER}\"}}" --scope user
fi
