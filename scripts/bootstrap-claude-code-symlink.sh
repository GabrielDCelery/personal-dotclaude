#!/usr/bin/env bash
set -e

[ -L ~/.claude/settings.json ] || ln -s "$(pwd)/.dotclaude/settings.json" ~/.claude/settings.json
[ -L ~/.claude/CLAUDE.md ] || ln -s "$(pwd)/.dotclaude/CLAUDE.md" ~/.claude/CLAUDE.md
[ -L ~/.claude/rules ] || ln -s "$(pwd)/.dotclaude/rules" ~/.claude/rules
[ -L ~/.claude/agents ] || ln -s "$(pwd)/.dotclaude/agents" ~/.claude/agents
[ -L ~/.claude/commands ] || ln -s "$(pwd)/.dotclaude/commands" ~/.claude/commands
[ -L ~/.claude/skills ] || ln -s "$(pwd)/.dotclaude/skills" ~/.claude/skills
