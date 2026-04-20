# Claude Software Skills usage guide

> How to install and use claude-software-skills in your project

## Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Examples](#examples)
- [Full install walkthrough](#full-install-walkthrough)
- [FAQ](#faq)

---

## Prerequisites

### 1. Install skillpkg MCP server

claude-software-skills uses [skillpkg](https://github.com/anthropics/skillpkg) for packaging.

```bash
# Install skillpkg MCP via Claude Code
claude mcp add skillpkg
```

Or add to `~/.claude/mcp.json` manually:

```json
{
  "mcpServers": {
    "skillpkg": {
      "command": "npx",
      "args": ["-y", "@anthropic/skillpkg-mcp"]
    }
  }
}
```

### 2. Initialize the project

From your project root:

```bash
# Claude Code can create skillpkg.json
# Or create manually:
echo '{
  "$schema": "https://skillpkg.dev/schemas/skillpkg.json",
  "name": "your-project",
  "skills": {},
  "sync_targets": {
    "claude-code": true
  }
}' > skillpkg.json
```

---

## Installation

### Option A: Install a single skill

```
github:leoarruda/claude-software-skills#{skill-path}
```

**Examples:**

```python
# Install frontend skill
mcp__skillpkg__install_skill(
    source="github:leoarruda/claude-software-skills#development-stacks/frontend",
    scope="local"  # or "global"
)

# Install python skill
mcp__skillpkg__install_skill(
    source="github:leoarruda/claude-software-skills#programming-languages/python",
    scope="local"
)
```

### Option B: Install several skills in batch

```python
# Parallel-friendly batch install
skills_to_install = [
    "development-stacks/frontend",
    "development-stacks/backend",
    "programming-languages/javascript-typescript",
    "programming-languages/python",
    "software-engineering/code-quality",
    "software-design/api-design",
]

for skill_path in skills_to_install:
    mcp__skillpkg__install_skill(
        source=f"github:leoarruda/claude-software-skills#{skill_path}",
        scope="local"
    )
```

### Option C: Local path (development)

If you cloned the repo:

```bash
git clone https://github.com/leoarruda/claude-software-skills.git
```

Install from disk:

```python
mcp__skillpkg__install_skill(
    source="/path/to/claude-software-skills/development-stacks/frontend",
    scope="local"
)
```

---

## Examples

### Example 1: Full-stack web (React + FastAPI)

```python
# Frontend
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#development-stacks/frontend")
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#programming-languages/javascript-typescript")

# Backend
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#development-stacks/backend")
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#programming-languages/python")

# API design
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#software-design/api-design")

# Quality and testing
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#software-engineering/code-quality")
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#software-engineering/testing-strategies")
```

### Example 2: AI application

```python
# AI/ML integration
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#development-stacks/ai-ml-integration")

# Backend
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#development-stacks/backend")
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#programming-languages/python")

# API design (for AI endpoints)
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#software-design/api-design")
```

### Example 3: Real-time app

```python
# Real-time systems
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#development-stacks/realtime-systems")

# Frontend and backend
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#development-stacks/frontend")
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#development-stacks/backend")
```

### Example 4: Backend API only

```python
# Backend
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#development-stacks/backend")
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#programming-languages/python")
# Or Go
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#programming-languages/go")

# API design
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#software-design/api-design")

# Database
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#development-stacks/database")

# Reliability
mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#software-engineering/reliability-engineering")
```

---

## Full install walkthrough

Recorded steps for installing claude-software-skills on the omniflow-studio project.

### Step 1: Confirm skillpkg MCP works

```python
mcp__skillpkg__skill_status()
```

### Step 2: Install stack skills

```python
# Frontend (React)
mcp__skillpkg__install_skill(
    source="github:leoarruda/claude-software-skills#development-stacks/frontend",
    scope="local"
)
# Output: ✅ Installed 1 skill(s): frontend v1.0.0

# Backend (FastAPI)
mcp__skillpkg__install_skill(
    source="github:leoarruda/claude-software-skills#development-stacks/backend",
    scope="local"
)
# Output: ✅ Installed 1 skill(s): backend v1.0.0

# Real-time (SSE/WebSocket)
mcp__skillpkg__install_skill(
    source="github:leoarruda/claude-software-skills#development-stacks/realtime-systems",
    scope="local"
)
# Output: ✅ Installed 1 skill(s): realtime-systems v1.0.0

# AI integration
mcp__skillpkg__install_skill(
    source="github:leoarruda/claude-software-skills#development-stacks/ai-ml-integration",
    scope="local"
)
# Output: ✅ Installed 1 skill(s): ai-ml-integration v1.0.0
```

### Step 3: Install language skills

```python
# JavaScript/TypeScript
mcp__skillpkg__install_skill(
    source="github:leoarruda/claude-software-skills#programming-languages/javascript-typescript",
    scope="local"
)

# Python
mcp__skillpkg__install_skill(
    source="github:leoarruda/claude-software-skills#programming-languages/python",
    scope="local"
)
```

### Step 4: Install software engineering skills

```python
# Code quality
mcp__skillpkg__install_skill(
    source="github:leoarruda/claude-software-skills#software-engineering/code-quality",
    scope="local"
)

# Testing strategies
mcp__skillpkg__install_skill(
    source="github:leoarruda/claude-software-skills#software-engineering/testing-strategies",
    scope="local"
)
```

### Step 5: Install software design skills

```python
# API design
mcp__skillpkg__install_skill(
    source="github:leoarruda/claude-software-skills#software-design/api-design",
    scope="local"
)

# UX principles
mcp__skillpkg__install_skill(
    source="github:leoarruda/claude-software-skills#software-design/ux-principles",
    scope="local"
)
```

### Step 6: Verify installation

```python
mcp__skillpkg__list_skills(scope="local")

# Output:
# Found 16 installed skill(s):
# • ai-ml-integration v1.0.0 [local]
# • api-design v1.0.0 [local]
# • backend v1.0.0 [local]
# • code-quality v1.0.0 [local]
# • frontend v1.0.0 [local]
# • javascript-typescript v1.0.0 [local]
# • python v1.0.0 [local]
# • realtime-systems v1.0.0 [local]
# • testing-strategies v1.0.0 [local]
# • ux-principles v1.0.0 [local]
# ...
```

### Step 7: Project status

```python
mcp__skillpkg__skill_status()

# Output:
# 📦 Project
#    Name: omniflow-studio
#    Config: skillpkg.json ✓
#
# 🔧 Skills
#    Total: 16 (16 direct, 0 transitive)
#
# 🔄 Sync Targets
#    • claude-code: ✓ synced
```

### Resulting skillpkg.json

```json
{
  "$schema": "https://skillpkg.dev/schemas/skillpkg.json",
  "name": "omniflow-studio",
  "skills": {
    "frontend": "github:leoarruda/claude-software-skills#development-stacks/frontend",
    "backend": "github:leoarruda/claude-software-skills#development-stacks/backend",
    "realtime-systems": "github:leoarruda/claude-software-skills#development-stacks/realtime-systems",
    "ai-ml-integration": "github:leoarruda/claude-software-skills#development-stacks/ai-ml-integration",
    "javascript-typescript": "github:leoarruda/claude-software-skills#programming-languages/javascript-typescript",
    "python": "github:leoarruda/claude-software-skills#programming-languages/python",
    "code-quality": "github:leoarruda/claude-software-skills#software-engineering/code-quality",
    "testing-strategies": "github:leoarruda/claude-software-skills#software-engineering/testing-strategies",
    "api-design": "github:leoarruda/claude-software-skills#software-design/api-design",
    "ux-principles": "github:leoarruda/claude-software-skills#software-design/ux-principles"
  },
  "sync_targets": {
    "claude-code": true
  }
}
```

---

## Available skills overview

### Development stacks

| Skill | Path | Description |
|-------|------|-------------|
| frontend | `development-stacks/frontend` | React, Vue, web stack |
| backend | `development-stacks/backend` | Node.js, Express, NestJS |
| database | `development-stacks/database` | SQL, NoSQL, ORMs |
| cloud-platforms | `development-stacks/cloud-platforms` | AWS, GCP, Azure |
| mobile | `development-stacks/mobile` | React Native, Flutter |
| realtime-systems | `development-stacks/realtime-systems` | WebSocket, SSE |
| ai-ml-integration | `development-stacks/ai-ml-integration` | LLMs, AI APIs |
| edge-iot | `development-stacks/edge-iot` | IoT, edge |

### Programming languages

| Skill | Path | Description |
|-------|------|-------------|
| javascript-typescript | `programming-languages/javascript-typescript` | JS/TS |
| python | `programming-languages/python` | Python |
| go | `programming-languages/go` | Go |
| rust | `programming-languages/rust` | Rust |
| java-kotlin | `programming-languages/java-kotlin` | Java/Kotlin |
| csharp-dotnet | `programming-languages/csharp-dotnet` | C#/.NET |
| ruby | `programming-languages/ruby` | Ruby |
| php | `programming-languages/php` | PHP |
| swift | `programming-languages/swift` | Swift |
| shell-bash | `programming-languages/shell-bash` | Shell |
| sql | `programming-languages/sql` | SQL |
| cpp | `programming-languages/cpp` | C++ |

### Software engineering

| Skill | Path | Description |
|-------|------|-------------|
| code-quality | `software-engineering/code-quality` | Clean code, SOLID |
| testing-strategies | `software-engineering/testing-strategies` | TDD, testing |
| devops-cicd | `software-engineering/devops-cicd` | CI/CD, Docker |
| security-practices | `software-engineering/security-practices` | Security |
| performance-optimization | `software-engineering/performance-optimization` | Performance |
| reliability-engineering | `software-engineering/reliability-engineering` | Reliability |
| documentation | `software-engineering/documentation` | Documentation |

### Software design

| Skill | Path | Description |
|-------|------|-------------|
| api-design | `software-design/api-design` | REST, GraphQL |
| architecture-patterns | `software-design/architecture-patterns` | Architecture |
| design-patterns | `software-design/design-patterns` | GoF patterns |
| system-design | `software-design/system-design` | System design |
| data-design | `software-design/data-design` | Data modeling |
| ux-principles | `software-design/ux-principles` | UX/accessibility |

### Domain applications

| Skill | Path | Description |
|-------|------|-------------|
| e-commerce | `domain-applications/e-commerce` | E-commerce |
| saas-platforms | `domain-applications/saas-platforms` | SaaS |
| content-platforms | `domain-applications/content-platforms` | CMS |
| communication-systems | `domain-applications/communication-systems` | Messaging |
| developer-tools | `domain-applications/developer-tools` | Dev tools |
| desktop-apps | `domain-applications/desktop-apps` | Desktop |
| game-development | `domain-applications/game-development` | Games |

### Tools & integrations

| Skill | Path | Description |
|-------|------|-------------|
| git-workflows | `tools-integrations/git-workflows` | Git workflows |
| development-environment | `tools-integrations/development-environment` | Dev environment |
| monitoring-logging | `tools-integrations/monitoring-logging` | Monitoring |
| api-tools | `tools-integrations/api-tools` | API tooling |
| automation-scripts | `tools-integrations/automation-scripts` | Automation |
| project-management | `tools-integrations/project-management` | Project management |

---

## FAQ

### Q: Install failed?

```python
# Check network
# Verify the GitHub path

# Try a local path
mcp__skillpkg__install_skill(
    source="/local/path/to/claude-software-skills#development-stacks/frontend"
)
```

### Q: How do I update an installed skill?

```python
# Reinstall overwrites the previous version
mcp__skillpkg__install_skill(
    source="github:leoarruda/claude-software-skills#development-stacks/frontend",
    scope="local"
)
```

### Q: How do I remove a skill?

```python
mcp__skillpkg__uninstall_skill(
    id="frontend",
    scope="local"
)
```

### Q: local vs global?

| Scope | Location | Use |
|-------|----------|-----|
| `local` | `.skillpkg/` in the project | Per-repo, versioned with Git |
| `global` | `~/.skillpkg/` | Shared across projects |

### Q: How do I load a skill to inspect it?

```python
result = mcp__skillpkg__load_skill(id="frontend")
print(result)  # SKILL.md contents
```

### Q: How do I search skills?

```python
# Installed skills
mcp__skillpkg__search_skills(query="react", source="local")

# GitHub index
mcp__skillpkg__search_skills(query="react", source="github")
```

---

## Related resources

- [skillpkg docs](https://github.com/anthropics/skillpkg)
- [Claude Code Skills](https://docs.anthropic.com/en/docs/claude-code/skills)
- [SKILL.md format](./SKILL-TEMPLATE.md)
- [Contributing](../CONTRIBUTING.md)
