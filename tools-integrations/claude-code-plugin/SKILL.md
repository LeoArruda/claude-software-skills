---
schema: "1.0"
name: claude-code-plugin
version: "1.1.0"
description: Complete guide to developing, publishing, installing, updating, and managing Claude Code plugins and marketplaces
triggers:
  keywords:
    primary: [plugin, claude-code, claude code plugin, hooks, commands, marketplace]
    secondary: [mcp, skill, subagent, version control, version, publish, install, update, sync]
  context_boost: [claude, anthropic, cli, automation, workflow]
  context_penalty: [game, trading, design]
  priority: high
keywords: [claude-code, plugin, development, automation, marketplace]
dependencies:
  software-skills: [git-workflows, automation-scripts]
author: claude-software-skills
---

# Claude Code Plugin — Complete Guide

> Create, publish, install, update, and sync Claude Code plugins

## When to use this skill

- Building a new Claude Code plugin
- Publishing a plugin to a marketplace
- Installing and updating plugins
- Managing plugin versions
- Syncing to the latest release
- Creating a custom marketplace

---

## Part 1: Plugin structure

### Directory layout

```
my-plugin/
├── .claude-plugin/
│   ├── plugin.json          # Plugin manifest (required)
│   └── marketplace.json     # Marketplace index (optional)
├── commands/                # Slash commands (at repo root!)
│   └── my-command.md
├── skills/                  # Agent skills
│   └── my-skill/
│       └── SKILL.md
├── hooks/
│   └── hooks.json           # Hook configuration
├── agents/                  # Subagent definitions
├── .mcp.json               # MCP server configuration
├── CHANGELOG.md
└── README.md
```

**Important**: `commands/`, `skills/`, and `hooks/` must live at the plugin root, not inside `.claude-plugin/`.

### `plugin.json` basics

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "What the plugin does",
  "author": {
    "name": "Author name",
    "email": "email@example.com"
  },
  "license": "MIT",
  "keywords": ["keyword1", "keyword2"]
}
```

### Four main building blocks

| Component | Purpose | How it runs | Format |
|-----------|---------|-------------|--------|
| **Commands** | Slash commands users run | `/command` manually | Markdown |
| **Skills** | Teach Claude how to behave | Auto from context | SKILL.md |
| **Hooks** | Event-driven automation | System events | JSON + shell |
| **MCP** | External tools | Claude invokes | `.mcp.json` |

---

## Part 2: Publishing a plugin

### Option A: GitHub marketplace (recommended)

**Step 1: Create `marketplace.json`**

```json
{
  "$schema": "https://anthropic.com/claude-code/marketplace.schema.json",
  "name": "my-marketplace",
  "description": "My plugin collection",
  "owner": {
    "name": "username",
    "email": "email@example.com"
  },
  "plugins": [
    {
      "name": "my-plugin",
      "version": "1.0.0",
      "source": "./",
      "description": "Plugin description",
      "category": "development"
    }
  ]
}
```

**Step 2: Push to GitHub**

```bash
git add .
git commit -m "feat: add Plugin marketplace format"
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin main
git push origin v1.0.0
```

**Step 3: User installs**

```bash
# Add marketplace
/plugin marketplace add owner/repo

# Install plugin
/plugin install my-plugin@my-marketplace
```

### Option B: npm publish

```bash
# 1. Name in package.json (claude-plugin- prefix)
{
  "name": "claude-plugin-my-plugin",
  "version": "1.0.0"
}

# 2. Publish
npm publish

# 3. User installs
npm install -g claude-plugin-my-plugin
```

### Option C: Direct share

```bash
# User downloads and installs locally
/plugin install /path/to/my-plugin
```

---

## Part 3: Installing plugins

### From a marketplace

```bash
# 1. Add marketplace (once)
/plugin marketplace add owner/repo

# 2. List available plugins
/plugin marketplace list

# 3. Install plugin
/plugin install plugin-name@marketplace-name
```

### From GitHub directly

```bash
# Full path install
/plugin install github:owner/repo#path/to/plugin

# Example
/plugin install github:leoarruda/evolve-plugin
```

### Local install

```bash
# From a local directory
/plugin install /path/to/my-plugin
```

### List installed plugins

```bash
# All installed plugins
/plugin list

# Details
/plugin info plugin-name@marketplace
```

### Uninstall

```bash
# Uninstall a specific plugin
/plugin uninstall plugin-name@marketplace

# Example
/plugin uninstall evolve@evolve-plugin

# Force (ignore dependencies)
/plugin uninstall plugin-name@marketplace --force
```

**Uninstall notes**:
- Uninstalling does not remove the marketplace entry; only the installed plugin
- If other plugins depend on this one, you will see a warning
- You can reinstall anytime

---

## Part 4: Updating plugins

### Check for updates

```bash
# Check all plugins
/plugin update --check

# Check one plugin
/plugin update --check plugin-name@marketplace
```

### Apply updates

```bash
# Update one plugin
/plugin update plugin-name@marketplace

# Update all plugins
/plugin update --all
```

### Automatic version check flow

```
Local version -> Remote version -> Compare
    |                |
plugin.json    GitHub API / marketplace.json
    |
If remote is newer -> prompt user to update
```

### Manual version check

```bash
# Local version
cat ~/.claude/plugins/installed_plugins.json | jq '.plugins["plugin@marketplace"][0].version'

# Remote version
curl -s https://raw.githubusercontent.com/owner/repo/main/.claude-plugin/plugin.json | jq -r '.version'
```

---

## Part 5: Version management

### Places versions must stay in sync

| Location | Role |
|----------|------|
| `.claude-plugin/plugin.json` | Plugin manifest |
| `.claude-plugin/marketplace.json` | Marketplace index |
| `skills/*/SKILL.md` | Skill version (if used) |
| `CHANGELOG.md` | Change log |
| Git tag | Release marker |

### Semantic versioning

```
MAJOR.MINOR.PATCH
  |     |     └── Bug fixes
  |     └── New features (backward compatible)
  └── Breaking changes
```

### Release checklist

```bash
# Update every version location
- [ ] plugin.json -> version
- [ ] marketplace.json -> plugins[].version
- [ ] SKILL.md -> version: (if applicable)
- [ ] CHANGELOG.md -> new entry
- [ ] README.md -> version badge

# Git
git add .
git commit -m "chore: bump version to vX.Y.Z"
git tag -a vX.Y.Z -m "Release vX.Y.Z: description"
git push origin main
git push origin vX.Y.Z
```

### CHANGELOG format

```markdown
## [1.1.0] - 2026-01-16

### Added
- New feature description

### Changed
- Change description

### Fixed
- Fix description

### Security
- Security fix
```

---

## Part 6: Syncing the latest version

### Sync from main repo to a standalone plugin repo

When the plugin was split from a monorepo:

```bash
# 1. Copy skills directory
cp -r /path/to/main-project/skills /path/to/plugin-repo/

# 2. Bump versions
# Edit plugin.json, marketplace.json

# 3. Commit and push
cd /path/to/plugin-repo
git add -A
git commit -m "chore: sync with main-project vX.Y.Z"
git push origin main
```

### Example sync script

```bash
#!/bin/bash
# sync-plugin.sh - sync plugin to standalone repo

MAIN_REPO="$1"
PLUGIN_REPO="$2"
VERSION="$3"

# Copy skills
rm -rf "$PLUGIN_REPO/skills"
cp -r "$MAIN_REPO/skills" "$PLUGIN_REPO/"

# Update version
sed -i '' "s/\"version\": \".*\"/\"version\": \"$VERSION\"/" \
    "$PLUGIN_REPO/.claude-plugin/plugin.json"

# Commit
cd "$PLUGIN_REPO"
git add -A
git commit -m "chore: sync with main-project v$VERSION"
git push origin main
```

### Automated sync (GitHub Actions)

```yaml
# .github/workflows/sync-plugin.yml
name: Sync Plugin

on:
  push:
    branches: [main]
    paths:
      - 'skills/**'
      - 'evolve-plugin/**'

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Sync to plugin repo
        run: |
          # Clone plugin repo
          git clone https://github.com/owner/plugin-repo.git

          # Copy files
          cp -r skills/ plugin-repo/
          cp evolve-plugin/.claude-plugin/* plugin-repo/.claude-plugin/

          # Push
          cd plugin-repo
          git add -A
          git commit -m "chore: auto-sync from main repo"
          git push
```

---

## Part 7: Marketplace management

### Create your own marketplace

**Step 1: Create `marketplace.json`**

```json
{
  "$schema": "https://anthropic.com/claude-code/marketplace.schema.json",
  "name": "my-marketplace",
  "description": "My plugin collection",
  "owner": {
    "name": "username"
  },
  "plugins": [
    {
      "name": "plugin-a",
      "version": "1.0.0",
      "source": "./plugin-a",
      "description": "Plugin A description",
      "category": "development"
    },
    {
      "name": "plugin-b",
      "version": "2.0.0",
      "source": "./plugin-b",
      "description": "Plugin B description",
      "category": "productivity"
    }
  ]
}
```

**Step 2: Organize directories**

```
my-marketplace/
├── .claude-plugin/
│   └── marketplace.json
├── plugin-a/
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── commands/
│   └── skills/
├── plugin-b/
│   ├── .claude-plugin/
│   │   └── plugin.json
│   └── commands/
└── README.md
```

### Manage added marketplaces

```bash
# List marketplaces
/plugin marketplace list

# Add marketplace
/plugin marketplace add owner/repo

# Remove marketplace
/plugin marketplace remove marketplace-name

# Refresh marketplace index
/plugin marketplace refresh
```

### Where known marketplaces are stored

```
~/.claude/plugins/known_marketplaces.json
```

---

## Part 8: Hook development

### Hook event types

| Event | When | Use |
|-------|------|-----|
| **PreToolUse** | Before a tool runs | Block or modify tool calls |
| **PostToolUse** | After a tool runs | Post-processing, notifications |
| **UserPromptSubmit** | User submits input | Input validation |
| **SessionStart** | Session starts | Initialization |
| **SessionEnd** | Session ends | Cleanup |
| **Stop** | AI finishes response | Post-processing |
| **SubagentStop** | Subagent finishes | Subtask handling |

### `hooks.json` example

```json
{
  "hooks": [
    {
      "type": "command",
      "event": "PreToolUse",
      "command": "./hooks/protect-env.sh"
    },
    {
      "type": "command",
      "event": "PostToolUse",
      "command": "./hooks/format-code.sh"
    },
    {
      "type": "command",
      "event": "SessionStart",
      "command": "./hooks/init.sh"
    }
  ]
}
```

### Example hook: protect sensitive files

```bash
#!/bin/bash
# hooks/protect-env.sh

FILE_PATH=$(echo "$1" | jq -r '.tool.input.path // .tool.input.file_path // empty')

if [[ "$FILE_PATH" =~ \.(env|key|secret|credentials)$ ]]; then
    echo '{"decision": "block", "reason": "Protected file type"}' >&2
    exit 1
fi

exit 0
```

### Example hook: auto-format

```bash
#!/bin/bash
# hooks/format-code.sh

FILE_PATH=$(echo "$1" | jq -r '.tool.input.path // empty')

if [[ "$FILE_PATH" =~ \.(ts|tsx|js|jsx)$ ]]; then
    prettier --write "$FILE_PATH" 2>/dev/null
fi

exit 0
```

---

## Part 9: Common issues and fixes

### Sharp edges

#### SE-1: Wrong directory layout
- **Severity**: critical
- **Symptom**: `/plugin list` shows the plugin but commands are missing
- **Cause**: `commands/` or `skills/` were placed under `.claude-plugin/`
- **Fix**: Move component folders to the plugin root

#### SE-2: Version drift
- **Severity**: high
- **Symptom**: `/plugin list` version does not match CHANGELOG
- **Cause**: `plugin.json` and `marketplace.json` versions differ
- **Fix**: Use a release checklist and verify every location

#### SE-3: Hooks with too much power
- **Severity**: high
- **Symptom**: Unexpected file changes or data loss
- **Cause**: Hooks run as the user with a broad scope
- **Fix**: Narrow hook targets and add safety checks

#### SE-4: MCP prompt injection
- **Severity**: critical
- **Symptom**: Claude performs unintended actions
- **Cause**: MCP content from untrusted sources
- **Fix**: Only use MCP from trusted sources

### Quick reference

| Mistake | Correct approach |
|---------|------------------|
| Putting `commands/` under `.claude-plugin/` | Put it at the plugin root |
| Mismatched version numbers | Update all locations together |
| Hooks too broad | Target specific tools |
| Forgetting git tags | Tag every release |
| Shipping untested code | Test with `--plugin-dir` first |

---

## Part 10: Local testing

```bash
# Test plugin without installing
claude-code --plugin-dir /path/to/my-plugin

# Verify structure
tree /path/to/my-plugin

# Validate plugin.json
cat /path/to/my-plugin/.claude-plugin/plugin.json | jq .

# Validate hooks
cat /path/to/my-plugin/hooks/hooks.json | jq .
```

---

## Official documentation

- [Plugins](https://code.claude.com/docs/en/plugins)
- [Plugins Reference](https://code.claude.com/docs/en/plugins-reference)
- [Plugin Marketplaces](https://code.claude.com/docs/en/plugin-marketplaces)
- [Hooks Guide](https://code.claude.com/docs/en/hooks-guide)
- [Hooks Reference](https://code.claude.com/docs/en/hooks)
- [Skills](https://code.claude.com/docs/en/skills)
- [MCP](https://code.claude.com/docs/en/mcp)
- [Subagents](https://code.claude.com/docs/en/sub-agents)
- [Slash Commands](https://code.claude.com/docs/en/slash-commands)

## Additional resources

- [Claude Code GitHub](https://github.com/anthropics/claude-code)
- [Official Plugins](https://github.com/anthropics/claude-plugins-official)
- evolve-plugin example: see `evolve-plugin/.claude-plugin/` layout
