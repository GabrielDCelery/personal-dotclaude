#!/usr/bin/env bash
set -e

mkdir -p ~/.copilot
[ -L ~/.copilot/skills ] || ln -s "$(pwd)/.dotclaude/skills" ~/.copilot/skills
[ -L ~/.copilot/mcp-config.json ] || ln -s "$(pwd)/.dotclaude/mcp.json" ~/.copilot/mcp-config.json

YELLOW='\033[0;33m'
NC='\033[0m'

if [ -z "${WORK_CONFLUENCE_AUTH_HEADER}" ] || [ -z "${WORK_JIRA_AUTH_HEADER}" ]; then
    printf "${YELLOW}warning: WORK_CONFLUENCE_AUTH_HEADER / WORK_JIRA_AUTH_HEADER are not set in this shell — Copilot resolves these at its own startup, so set them before launching Copilot for Atlassian MCP auth to work${NC}\n"
fi
