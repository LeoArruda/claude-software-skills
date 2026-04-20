# Project Skills

This directory contains skills used for developing this project.

## Architecture

Skills are managed via **Git Submodules** for version tracking and easy updates:

```
claude-software-skills/
├── vendor/
│   └── self-evolving-agent/    ← Git Submodule
│       └── SKILL.md
├── .claude/skills/
│   ├── README.md               ← This file
│   └── evolve -> ../../vendor/self-evolving-agent  ← Symlink
```

## Installed Skills

### evolve (v3.3.0)

Self-Evolving Agent - Learns autonomously and iteratively improves until the goal is achieved.

**Source:** https://github.com/miles990/self-evolving-agent

**Usage:**
```
/evolve [goal description]
```

**Features:**
- Mandatory checkpoints (check Memory before tasks, compile/test after changes, confirm goals after milestones)
- Memory lifecycle management (keep what matters, remove noise)
- Git-based Memory (version-controlled, traceable, reversible)

## Managing Skills

### First-time clone

```bash
git clone --recursive https://github.com/miles990/claude-software-skills.git
```

Or if already cloned:
```bash
git submodule update --init --recursive
```

### Update to latest version

```bash
# Update all submodules
git submodule update --remote --merge

# Or update specific skill
cd vendor/self-evolving-agent
git pull origin main
cd ../..
git add vendor/self-evolving-agent
git commit -m "chore: update evolve skill to latest"
```

### Check current version

```bash
cd vendor/self-evolving-agent
git log -1 --format="%h %s"
```

## Adding New Skills

1. Add as submodule:
   ```bash
   git submodule add https://github.com/user/skill-repo.git vendor/skill-name
   ```

2. Create symlink:
   ```bash
   cd .claude/skills
   ln -s ../../vendor/skill-name skill-alias
   ```

3. Update this README
