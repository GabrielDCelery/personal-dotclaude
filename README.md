# personal-dotclaude

Shared Claude Code configuration for personal repositories. Provides default project context, custom agents, and standardized rules for common tasks like README generation.

> [!NOTE]
> Intentionally separated from [dotfiles](https://github.com/GabrielDCelery/personal-dotfiles) and [dev environment setup](https://github.com/GabrielDCelery/personal-dev-environment-quickstart)

![Personal Dotclaude Screenshot](./assets/screenshot-dotclaude-002.jpg)

## Quick Start

```sh
git clone git@github.com:GabrielDCelery/personal-dotclaude.git
cd personal-dotclaude
mise run symlink-dotclaude-to-user
mise run add-mcp-servers-to-user
```

## Architecture

- **Type**: Configuration repository
- **Task Runner**: mise
- **MCP Servers**: Context7 (documentation lookup)
- **Custom Agents**: DocsExplorer, Context7DocsExplorer
- **Custom Rules**: README generation guidelines

## What's Included

```
.dotclaude/
├── CLAUDE.md                        # Default project context
├── settings.json                    # Claude Code settings
├── agents/
│   ├── DocsExplorer.md             # Documentation lookup (Context7 + web)
│   └── Context7DocsExplorer.md     # Documentation lookup (Context7 only)
└── rules/
    └── readme-styles.md            # README generation guidelines
```

## Configuration

| Variable | Description | Required | Default |
| -------- | ----------- | -------- | ------- |
| CONTEXT7_API_KEY | API key for Context7 MCP server | Yes | None |

Secrets are stored in `.env` locally.

## Setup

Prerequisites: [Claude Code](https://code.claude.com/docs/en/setup) installed with `~/.claude` directory initialized.

### Option A: User-wide setup (recommended)

Symlinks configuration to `~/.claude` for all projects:

```sh
mise run symlink-dotclaude-to-user
mise run add-mcp-servers-to-user
```

> [!WARNING]
> Don't symlink the entire `.dotclaude` directory to `~/.claude` - the home directory contains Claude Code's data files.

### Option B: Per-project setup

Symlinks configuration to a specific project:

```sh
ln -s /path/to/personal-dotclaude/.dotclaude /path/to/your-project/.claude
echo '.claude' >> /path/to/your-project/.gitignore
```

## Usage

Start Claude Code and reference the custom rules:

```sh
claude
```

Example prompts:

```
Can you help me with the README according to our standards?
Get docs for React and TypeScript
```

## Adding Project-Specific Context

Create a `CLAUDE.md` at the project root for additional context:

```
your-project/
├── CLAUDE.md          # Project-specific context
├── .claude -> ...     # Symlinked from personal-dotclaude
└── src/
```

Claude Code merges both the global and project-specific context.

## Updates

```sh
cd personal-dotclaude
git pull
```

Symlinks pick up changes automatically.

---

> [!NOTE]
> Why `.dotclaude` instead of `.claude`? To avoid naming conflicts with Claude Code's default directory.
