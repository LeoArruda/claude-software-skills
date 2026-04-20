---
name: auto-dev-setup
description: Configure Auto-Dev workflows for Human-in-the-Loop automated development
domain: tools-integrations
version: 1.0.0
tags: [github-actions, automation, workflow, ci-cd, human-in-the-loop]
triggers:
  keywords:
    primary: [auto-dev, automated development, human-in-the-loop, github actions workflow]
    secondary: [setup workflow, workflow automation, claude automation, agent workflow]
  context_boost: [github, ci, automation, workflow]
  context_penalty: [frontend, ui, design]
  priority: medium
---

# Auto-Dev Setup Skill

Configure Human-in-the-Loop automated development for any repository.

## When to use

Users ask for things like:
- “Set up auto-dev for this project”
- “I want automated development on this repo”
- “Configure GitHub Actions for auto-dev”

## Setup flow

### Step 1: Confirm requirements

Use AskUserQuestion to confirm:

```
1. Workflow source
   □ Reusable workflow (recommended; upstream updates)
   □ Copy full workflows (fully customizable)

2. Skills source
   □ Use claude-software-skills
   □ Use a custom skills repo
   □ No extra skills

3. Optional features
   □ Task queue (scheduled processing)
   □ Feedback handler (iterate on PRs)
```

### Step 2: Create directories

```bash
mkdir -p .github/workflows
mkdir -p .claude/memory/{learnings,failures,decisions,patterns,strategies}
mkdir -p .github/ISSUE_TEMPLATE
```

### Step 3: Add workflows (pick one)

#### Option A: Reusable workflow (recommended)

```yaml
# .github/workflows/auto-dev.yml
name: 🤖 Auto-Dev

on:
  issues:
    types: [labeled]
  issue_comment:
    types: [created]
  workflow_dispatch:
    inputs:
      goal:
        description: 'Development goal'
        required: true

jobs:
  auto-dev:
    uses: {SKILLS_REPO}/.github/workflows/auto-dev-reusable.yml@main
    with:
      goal: ${{ github.event.inputs.goal || '' }}
    secrets:
      ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
```

Replace `{SKILLS_REPO}` with the real path.

#### Option B: Copy full workflows

From claude-software-skills copy:
- `.github/workflows/auto-dev.yml`
- `.github/workflows/auto-dev-feedback.yml`
- `.github/workflows/auto-dev-queue.yml`

### Step 4: Issue template

```yaml
# .github/ISSUE_TEMPLATE/auto-dev.yml
name: 🤖 Auto-Dev Task
description: Create an automated development task
labels: ["auto-dev"]
body:
  - type: textarea
    id: goal
    attributes:
      label: Goal
      description: Describe the development goal
    validations:
      required: true
```

### Step 5: Seed memory

```markdown
# .claude/memory/index.md
# Project memory index

## Recent learnings
<!-- LEARNINGS_START -->
<!-- LEARNINGS_END -->

## Failures
<!-- FAILURES_START -->
<!-- FAILURES_END -->
```

### Step 6: Secrets reminder

Tell the user:

```
Repository Settings → Secrets → Actions
Add ANTHROPIC_API_KEY
```

## Quick reference

| Action | How |
|--------|-----|
| Start auto-dev | Issue + `auto-dev` label |
| Command | Comment `/evolve [goal]` |
| Iterate | Comment `/evolve [changes]` on the PR |
| Manual | Actions → Run workflow |

## Verify

After setup:

1. Open a test issue
2. Add the `auto-dev` label
3. Confirm the workflow runs
4. Confirm a PR is created

## Related docs

- [AUTO-DEV.md](https://github.com/leoarruda/claude-software-skills/blob/main/.github/AUTO-DEV.md)
- [Evolve Skill](../../skills/evolve/SKILL.md)
