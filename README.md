# What is this repo for?

Shared Claude Code configuration for all company repositories. Provides default project context and rules for common tasks like README generation. Designed to be used by developers locally or agents running on remote machines.

[Personal Dotclaude Screenshot](./assets/screenshot-dotclaude-001.jpg)

## What is Included

```
.dotclaude/
└── rules/
    └── readme-styles.md    # README generation guidelines
```

## Setup

Make sure Claude Code has been installed on your machine [Claude Code Installation](https://code.claude.com/docs/en/setup) and that you have a `~/.claude` directory (Claude should autogenerate it after you log in)

Clone this repo:

```sh
git clone git@github.com:GabrielDCelery/personal-dotclaude.git
cd personal-dotclaude
```

Then choose one of the following options:

### Option A: Per-project setup

Symlink the `.dotclaude` directory into a specific project and add `.claude` to the project's gitignore.

```sh
ln -s /path/to/the/cloned/dotclaude/.dotclaude /path/to/your-project/.claude
echo '.claude' >> /path/to/your-project/.gitignore
```

### Option B: User-wide setup

Symlink the `CLAUDE.md` and `rules` into your existing `~/.claude` directory:

```sh
# The below is assuming you are in the dotclaude repo dir
ln -s $(pwd)/.dotclaude/settings.jsokk~/.claude/settings.json
ln -s $(pwd)/.dotclaude/CLAUDE.md ~/.claude/CLAUDE.md
ln -s $(pwd)/.dotclaude/rules ~/.claude/rules
```

> [!WARNING]
> Don't symlink the entire `.dotclaude` directory to home as `~/.claude` - the home directory contains Claude Code's data files (cache, history, settings, etc.).

## How to use it after setup

Just start claude code

```sh
claude
```

Then ask it to help you write the README

```claude
Hi can you help me with adding/updating the README according to our standards?
```

## Adding Project-Specific Context

If a project needs additional context, create a `CLAUDE.md` at the project root. Claude Code reads both files and combines them.

```
your-project/
├── CLAUDE.md          # Project-specific context
├── .claude -> ...     # Symlinked from .personal-claude
└── src/
```

> [!NOTE]
> Why `.dotclaude` and not `.claude`? Because the default dotfiles dir is .claude and wanted to make sure there are no accidental naming conflict shenanigans

> [!NOTE]
> To update, run `git pull` in this directory. Symlinks pick up changes automatically.
