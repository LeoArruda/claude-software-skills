# Claude Software Skills Quick Start

> Get started with 50+ software development skills in about three minutes

## What is Claude Software Skills?

A software development skill library for Claude Code, covering:

| Category | Skill count | Examples |
|----------|-------------|----------|
| Programming Languages | 12 | python, typescript, rust, go |
| Software Engineering | 8 | backend, frontend, database, api-design |
| Software Design | 6 | architecture-patterns, design-patterns |
| Tools & Integrations | 8 | git-workflows, devops-ci-cd |
| Development Stacks | 8 | react-ecosystem, node-backend |
| Domain Applications | 8 | ai-ml-integration, data-analysis |

---

## Step 1: Install the full library (~1 minute)

### Option A: In Claude Code

```
Install the claude-software-skills library
```

### Option B: Using the CLI

```bash
npx skillpkg-cli install LeoArruda/claude-software-skills
```

---

## Step 2: Install a single skill (~30 seconds)

Only need specific skills?

```bash
# Install backend skill
npx skillpkg-cli install github:LeoArruda/claude-software-skills#skills/backend

# Install python skill
npx skillpkg-cli install github:LeoArruda/claude-software-skills#skills/python

# Install testing-strategies skill
npx skillpkg-cli install github:LeoArruda/claude-software-skills#skills/testing-strategies
```

---

## Step 3: Use skills (~1 minute)

After installation, Claude applies relevant knowledge automatically.

### Example prompts

```
# Using backend skill
/evolve Build a RESTful API with Express + TypeScript

# Using testing-strategies skill
Write unit tests for this module with 80% coverage

# Using python skill
Write a Python scraper that fetches a site and stores data in SQLite
```

---

## Skill catalog

### Programming languages
`python` `typescript` `javascript` `rust` `go` `java` `csharp` `cpp` `ruby` `php` `swift` `kotlin`

### Software engineering
`backend` `frontend` `database` `api-design` `testing-strategies` `security` `performance-optimization` `documentation`

### Software design
`architecture-patterns` `design-patterns` `clean-code` `refactoring` `system-design` `ddd`

### Tools & integrations
`git-workflows` `devops-ci-cd` `docker-containers` `aws-cloud` `monitoring-observability` `debugging-profiling` `ide-productivity` `cli-tools`

### Frameworks & stacks
`react-ecosystem` `vue-ecosystem` `node-backend` `python-web` `mobile-development` `serverless` `microservices` `monorepo`

### Domain applications
`ai-ml-integration` `data-analysis` `blockchain-web3` `game-development` `iot-embedded` `real-time-systems` `fintech` `healthcare-systems`

---

## FAQ

### Q: Is installing everything slow?

Skills are Markdown; nothing to compile. A full install is roughly 30 seconds.

### Q: Do skills conflict?

No. They are designed to stack.

### Q: How do I see what is loaded?

```bash
npx skillpkg-cli list
```

Or in Claude Code:
```
List loaded skills
```

---

## Next steps

| Goal | Link |
|------|------|
| Full skill list | [README.md](../README.md) |
| Usage details | [USAGE-GUIDE.md](USAGE-GUIDE.md) |
| Skill template | [SKILL-TEMPLATE.md](SKILL-TEMPLATE.md) |
| Contributing | [CONTRIBUTING.md](../CONTRIBUTING.md) |

---

## Success

```
✅ Skill library installed
✅ Claude can use software development guidance
✅ Start your project!

/evolve [your goal]
```
