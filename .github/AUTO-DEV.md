# 🤖 Auto-Dev System

> Human-in-the-loop automated development
>
> Uses the official [claude-code-action](https://github.com/anthropics/claude-code-action) GitHub Action

## Quick install

### Option 1: API key

```bash
curl -fsSL https://raw.githubusercontent.com/miles990/claude-software-skills/main/scripts/setup-auto-dev-apikey.sh | bash
```

After install:
1. Get an API key at https://console.anthropic.com/settings/keys
2. Add GitHub Secret: `ANTHROPIC_API_KEY`

### Option 2: Claude Max (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/miles990/claude-software-skills/main/scripts/setup-auto-dev-max.sh | bash
```

After install:
```bash
claude /install-github-app
```
This configures `CLAUDE_CODE_OAUTH_TOKEN` (usage included in the Max subscription).

---

## Comparison

| Option | Cost | Setup | Best for |
|--------|------|--------|----------|
| API key | Pay per use | Simple | Most developers |
| Claude Max | Included in subscription | Requires app install | Max subscribers |

---

## Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        Auto-Dev architecture                     │
│                                                                 │
│  ┌─────────────┐     ┌─────────────┐     ┌─────────────┐       │
│  │   Issue     │     │   GitHub    │     │   Claude    │       │
│  │  + Label    │────→│   Actions   │────→│    Code     │       │
│  │  auto-dev   │     │             │     │  + Evolve   │       │
│  └─────────────┘     └──────┬──────┘     └──────┬──────┘       │
│                             │                    │              │
│                             ↓                    ↓              │
│                      ┌─────────────┐     ┌─────────────┐       │
│                      │     PR      │←────│   Code      │       │
│                      │   Review    │     │   changes   │       │
│                      └──────┬──────┘     └─────────────┘       │
│                             │                                   │
│               ┌─────────────┼─────────────┐                    │
│               ↓             ↓             ↓                    │
│         ┌─────────┐   ┌─────────┐   ┌─────────┐               │
│         │  Merge  │   │ /evolve │   │  Close  │               │
│         │   ✅    │   │   ✏️    │   │   ❌    │               │
│         └────┬────┘   └────┬────┘   └────┬────┘               │
│              │             │             │                     │
│              ↓             ↓             ↓                     │
│         ┌─────────┐   ┌─────────┐   ┌─────────┐               │
│         │ Record  │   │ Continue│   │ Record  │               │
│         │ success │   │ iterate │   │ failure │               │
│         └─────────┘   └─────────┘   └─────────┘               │
│                             │                                   │
│              .claude/memory/ ← cumulative experience           │
└─────────────────────────────────────────────────────────────────┘
```

## Quick start

### 1. Configure secrets

In Repository Settings → Secrets and variables → Actions add:

```
ANTHROPIC_API_KEY=sk-ant-...
```

### 2. Open an issue to trigger auto-dev

```markdown
Title: Implement user login

Body:
Requirements:
- Email + password login
- JWT validation
- Remember me

Acceptance:
- Successful login returns token
- Errors show clear messages
- Unit tests included
```

Then add the `auto-dev` label.

### 3. Wait for the PR

The bot will:
1. Create a branch
2. Run Claude Code + Evolve
3. Commit changes
4. Open a PR

### 4. Review and interact

#### ✅ Happy path → merge
Success is recorded in memory automatically.

#### ✏️ Needs changes → comment
```
/evolve Do not use sessions; use JWT and add a refresh token
```
The bot keeps iterating on the same PR.

#### ➕ New scope → new issue
Add the `auto-dev` label; it joins the queue.

#### ❌ Reject → close PR
Failure is recorded so similar mistakes are avoided later.

---

## Triggers

### 1. Issue label (recommended)

1. Open an issue describing the goal
2. Add the `auto-dev` label
3. Optional: `priority:high` / `priority:low`

### 2. Comment command

On any issue or PR:
```
/evolve Implement feature X

Optional flags:
--priority=high
--max-iterations=15
```

### 3. Manual run

Actions → Auto Development → Run workflow

---

## Labels

| Label | Meaning |
|-------|---------|
| `auto-dev` | Triggers auto-dev |
| `🤖 auto-dev` | PR created by the bot |
| `priority:high` | Higher priority in queue |
| `priority:low` | Lower priority |
| `⏳ processing` | In progress |
| `needs-review` | Waiting for human review |

---

## Memory system

Experience is stored under `.claude/memory/`:

```
.claude/memory/
├── index.md              # Quick index
├── learnings/            # Success patterns
│   └── 2025-01-05-user-login.md
├── failures/             # Failure lessons
│   └── 2025-01-04-oauth-attempt.md
├── decisions/            # Technical decisions
├── patterns/             # Recurring patterns
└── strategies/           # Strategy notes
```

### Learning from experience

```markdown
# Example: learnings/2025-01-05-jwt-preference.md

## Context
Building authentication

## Human feedback
“Do not use sessions; this project standardizes on JWT.”

## Preference learned
- Auth strategy for this project: JWT only

## Impact
Future auth-related tasks should prefer JWT
```

---

## Workflow files

| File | Role |
|------|------|
| `auto-dev.yml` | Main execution flow |
| `auto-dev-feedback.yml` | Review feedback handling |
| `auto-dev-queue.yml` | Queue management (hourly) |

---

## Configuration

### Max runtime

```yaml
# auto-dev.yml
timeout-minutes: 60  # Default 1 hour
```

### Max iterations

```yaml
# Via label or command
/evolve --max-iterations=20 Implement X
```

### Queue frequency

```yaml
# auto-dev-queue.yml
schedule:
  - cron: '0 */2 * * *'  # Every 2 hours
```

---

## Security notes

1. **API keys**
   - Use GitHub Secrets
   - Never hard-code keys in the repo

2. **Execution limits**
   - Set reasonable timeouts
   - Cap max iterations
   - Monitor API usage

3. **Review gate**
   - All changes go through PRs
   - Enable branch protection where appropriate
   - Require approval on important branches

4. **Cost control**
   - Monitor Anthropic API spend
   - Set budget alerts
   - Consider cheaper models for exploratory steps

---

## FAQ

### Q: The run failed—what now?
A: Check Actions logs. Common causes:
- Invalid API key
- Vague goal description
- Hit iteration limit

### Q: How do I stop a running job?
A: Cancel the workflow run on the Actions tab.

### Q: The PR is too large?
A: Split the work into smaller issues.

### Q: How does the bot remember preferences?
A: Explain clearly in PR review; entries go into memory.

---

## GitHub Copilot integration

Because memory lives under `.claude/memory/`, Copilot can read it too:

```
.github/
├── copilot/              # Copilot config
│   └── instructions.md   # Can reference memory
└── memory/               # Shared memory
    └── ...
```

In `instructions.md`:
```markdown
See `.claude/memory/` for project preferences and past experience.
```
