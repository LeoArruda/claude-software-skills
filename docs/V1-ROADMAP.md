# V1 Roadmap: Skills Enhancement Plan

> Plan to evolve from MVP to V1

## Goals

Upgrade 48 skills from “knowledge-only” to “hybrid” by adding practical `templates/`, `scripts/`, and `reference.md`.

## Current state

### Stats

| Metric | Count |
|--------|-------|
| Total skills | 48 |
| Over 500 lines (recommended cap) | 27 |
| Already had `templates/` (MVP) | 4 |
| Needed extra assets | ~35 |
| Knowledge-only (no extras) | ~8 |

### MVP already done

- ✅ `software-engineering/devops-cicd/templates/`
- ✅ `tools-integrations/git-workflows/scripts/` + `templates/`
- ✅ `development-stacks/frontend/templates/`
- ✅ `development-stacks/backend/templates/`

---

## Recommended layout (official)

Per [Claude Code Skills docs](https://docs.anthropic.com/en/docs/claude-code/skills):

```
my-skill/
├── SKILL.md              # Required, under 500 lines
├── reference.md          # Optional deep API/parameter notes
├── examples.md           # Optional examples
├── scripts/              # Optional tooling
│   └── helper.py
└── templates/            # Optional copy-paste configs
    └── config.example
```

**Principles:**
- Keep SKILL.md under 500 lines
- Move long content to reference.md
- Put runnable examples in scripts/
- Put copy-paste configs in templates/

---

## V1 plan detail

### P0: MVP complete ✅

| Skill | New assets | Status |
|-------|------------|--------|
| devops-cicd | templates/github-actions/, templates/docker/ | ✅ |
| git-workflows | scripts/pre-commit, commit-msg + templates/gitignore-* | ✅ |
| frontend | templates/react/, templates/vite/ | ✅ |
| backend | templates/express/, templates/fastapi/ | ✅ |

---

### P1: High value (12 skills) ✅

**Status: done** (45 files, 4169 lines)

#### software-engineering/

| Skill | Lines | Added | Contents | Status |
|-------|-------|-------|----------|--------|
| testing-strategies | 532 | `templates/` | jest.config.ts, vitest.config.ts, pytest.ini | ✅ |
| code-quality | 501 | `templates/` | eslint.config.js, .prettierrc, .editorconfig | ✅ |
| security-practices | 486 | `templates/` | helmet-config.js, csp-policy.json, .env.example | ✅ |

#### development-stacks/

| Skill | Lines | Added | Contents | Status |
|-------|-------|-------|----------|--------|
| database | 644 | `templates/` | schema.prisma, migration.sql, docker-compose.db.yml | ✅ |
| cloud-platforms | 540 | `templates/` | main.tf, cdk-stack.ts, serverless.yml | ✅ |

#### tools-integrations/

| Skill | Lines | Added | Contents | Status |
|-------|-------|-------|----------|--------|
| automation-scripts | 570 | `templates/` | Makefile.example, turbo.json | ✅ |
| development-environment | 610 | `templates/` | .vscode/settings.json, extensions.json, devcontainer.json | ✅ |
| monitoring-logging | 500 | `templates/` | prometheus.yml, grafana-dashboard.json, docker-compose.monitoring.yml | ✅ |
| project-management | 438 | `templates/` | ISSUE_TEMPLATE/, PULL_REQUEST_TEMPLATE.md | ✅ |

#### software-design/

| Skill | Lines | Added | Contents | Status |
|-------|-------|-------|----------|--------|
| api-design | 463 | `templates/` | openapi.yaml, schema.graphql | ✅ |

#### programming-languages/

| Skill | Lines | Added | Contents | Status |
|-------|-------|-------|----------|--------|
| javascript-typescript | 536 | `templates/` | tsconfig.json, tsconfig.react.json, package.json | ✅ |
| python | 467 | `templates/` | pyproject.toml, requirements.txt, requirements-dev.txt | ✅ |

---

### P2: Medium value (13 skills) ✅

**Status: done**

#### development-stacks/

| Skill | Lines | Added | Contents | Status |
|-------|-------|-------|----------|--------|
| mobile | 662 | `templates/` | react-native.config.js, pubspec.yaml | ✅ |
| realtime-systems | 689 | `templates/` | websocket-server.ts, sse-handler.ts | ✅ |
| ai-ml-integration | 564 | `templates/` | llm-config.ts, embedding-utils.py | ✅ |

#### tools-integrations/

| Skill | Lines | Added | Contents | Status |
|-------|-------|-------|----------|--------|
| api-tools | 590 | `scripts/` + `templates/` | curl-examples.sh, postman-collection.json | ✅ |

#### domain-applications/

| Skill | Lines | Added | Contents | Status |
|-------|-------|-------|----------|--------|
| e-commerce | 539 | `templates/` | cart-schema.ts, checkout-flow.ts | ✅ |
| saas-platforms | 464 | `templates/` | tenant-schema.prisma, billing-config.ts | ✅ |

#### programming-languages/

| Skill | Lines | Added | Contents | Status |
|-------|-------|-------|----------|--------|
| go | 623 | `templates/` | go.mod, Makefile | ✅ |
| rust | 540 | `templates/` | Cargo.toml | ✅ |
| shell-bash | 528 | `scripts/` | common-utils.sh | ✅ |
| sql | 578 | `templates/` | migration-template.sql | ✅ |

#### software-design/

| Skill | Lines | Added | Contents | Status |
|-------|-------|-------|----------|--------|
| data-design | 464 | `templates/` | schema-patterns.sql | ✅ |

#### software-engineering/

| Skill | Lines | Added | Contents | Status |
|-------|-------|-------|----------|--------|
| reliability-engineering | 470 | `templates/` | health-check.ts, circuit-breaker.ts | ✅ |
| documentation | 493 | `templates/` | README-template.md, CHANGELOG-template.md | ✅ |

---

### P3: Lower value (11 skills) ✅

**Status: done**

#### programming-languages/

| Skill | Lines | Added | Contents | Status |
|-------|-------|-------|----------|--------|
| java-kotlin | 499 | `templates/` | build.gradle.kts, pom.xml | ✅ |
| csharp-dotnet | 588 | `templates/` | WebApi.csproj, appsettings.json | ✅ |
| cpp | 607 | `templates/` | CMakeLists.txt | ✅ |
| ruby | 604 | `templates/` | Gemfile, .rubocop.yml | ✅ |
| php | 682 | `templates/` | composer.json, phpunit.xml | ✅ |
| swift | 617 | `templates/` | Package.swift | ✅ |

#### domain-applications/

| Skill | Lines | Added | Contents | Status |
|-------|-------|-------|----------|--------|
| content-platforms | 502 | `templates/` | cms-schema.ts | ✅ |
| communication-systems | 530 | `templates/` | email-template.html, notification-types.ts | ✅ |
| developer-tools | 485 | `templates/` | cli-boilerplate.ts | ✅ |
| desktop-apps | 515 | `templates/` | electron-main.ts, tauri.conf.json | ✅ |

#### Split to reference.md

| Skill | Lines | Added | Status |
|-------|-------|-------|--------|
| edge-iot | 659 | `reference.md` | ✅ |
| ux-principles | 554 | `reference.md` | ✅ |
| performance-optimization | 515 | `reference.md` | ✅ |

---

### No extra assets needed (8 skills)

Knowledge-only; SKILL.md is enough:

| Skill | Lines | Reason |
|-------|-------|--------|
| architecture-patterns | 214 | Architecture concepts only |
| design-patterns | 490 | GoF patterns |
| system-design | 468 | Distributed systems concepts |
| application-patterns | 378 | MVC/CQRS concepts |
| game-development | 408 | Game dev concepts |
| auto-dev-setup | 151 | Already complete (standalone scripts/) |

---

## Implementation guide

### Example directory layout

```
my-skill/
├── SKILL.md                    # Main doc (under 500 lines)
├── reference.md                # Deep reference (optional)
├── templates/
│   ├── README.md               # How to use templates
│   ├── config-a.example        # Template A
│   └── config-b.example        # Template B
└── scripts/
    ├── setup.sh                # Setup script
    └── helper.py               # Helper script
```

### templates/README.md template

```markdown
# [Skill Name] Templates

Ready-to-use templates for [purpose].

## Files

| Template | Purpose |
|----------|---------|
| `file-a.example` | Description |
| `file-b.example` | Description |

## Usage

\`\`\`bash
cp templates/file-a.example ./file-a
\`\`\`
```

### Naming

| Type | Rule | Examples |
|------|------|----------|
| Config files | Original filename | `tsconfig.json`, `eslint.config.js` |
| Templates to customize | `.example` suffix | `config.example.yaml` |
| Scripts | Descriptive name | `setup-hooks.sh`, `validate.py` |

---

## Suggested timeline

| Phase | Scope | Estimate |
|-------|-------|----------|
| V1.0 | P1 (12 skills) | 3–4 hours |
| V1.1 | P2 (13 skills) | 3–4 hours |
| V1.2 | P3 (11 skills) | 2–3 hours |
| V1.3 | reference.md splits | 1–2 hours |

**Total: roughly 10–13 hours**

---

## Acceptance criteria

### Each templates/ must have

- [ ] README.md explaining usage
- [ ] At least 2–3 practical templates
- [ ] Templates copy-paste ready

### Each scripts/ must have

- [ ] Executable bit (`chmod +x`)
- [ ] Header comment describing purpose
- [ ] Runnable standalone

### CI checks

- [ ] All SKILL.md frontmatter valid
- [ ] No duplicate skill names
- [ ] README.md under each templates/

---

## Related docs

- [SKILL-TEMPLATE.md](./SKILL-TEMPLATE.md) — Skill authoring template
- [CONTRIBUTING.md](../CONTRIBUTING.md) — Contribution guide
- [Claude Code Skills (official)](https://docs.anthropic.com/en/docs/claude-code/skills)
