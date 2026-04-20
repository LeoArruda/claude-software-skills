# analyze-repo Skill v2.0

> Enterprise-grade deep project analysis — full insight from code to business value

## Problems it solves

### Have you run into these situations?

| Role | Pain point |
|------|------------|
| **New engineer** | Taking over a project with no idea where to start; docs are outdated or missing |
| **Tech lead** | Need to assess technical debt and risk quickly but lack objective metrics |
| **Architect** | Want the full system picture but only have time to read tens of thousands of lines by hand |
| **Investor / PM** | Need to judge project value but the technical detail is overwhelming |
| **Interviewer** | Want to evaluate a candidate’s side project but time is limited |

### Limits of a manual approach

- **Slow**: A medium project can take days or weeks to analyze by hand
- **Subjective**: Different people use different criteria; results are hard to compare
- **Incomplete**: Easy to miss security, dependency health, and other important angles
- **No business lens**: Technical reports do not translate cleanly into business decisions

## Goals and value

### Core goal

**Produce a professional project analysis report in about 10 minutes**

The report helps:
- Engineers onboard quickly
- Leads make technical decisions
- Investors assess technical value
- Teams spot risks and improvement areas

### Value delivered

| Value | Description |
|------|-------------|
| **Time saved** | Compress days of manual review into about 10 minutes |
| **Objective view** | Eight-dimension metrics to reduce bias |
| **Broad coverage** | From code quality to market value in one pass |
| **Actionable guidance** | Not only issues but fixes and priorities |
| **Multi-audience** | Same report, different reading angles |

## Highlights

| Highlight | Description |
|-----------|-------------|
| **arc42 + C4** | Industry-standard architecture docs + four-layer visualization |
| **8-dimension quality** | Maintainability, testability, scalability, security, documentation, architecture, dependencies, DX |
| **Technical debt** | SQALE-style model + fix estimates + priority matrix |
| **Security** | OWASP Top 10 + dependency vulnerability scan + sensitive-data checks |
| **Market value** | TAM/SAM/SOM + trend alignment + SWOT + investment-style takeaways |
| **Multi-perspective** | Executive / Architect / Developer / Investor |

## Who is it for?

| Role | When to use | Suggested perspective |
|------|-------------|------------------------|
| **Executive** | Quick read on status, risk, and investment value | `--perspective=executive` |
| **Architect** | Deep dive on design, debt, and improvement roadmap | `--perspective=architect` |
| **Developer** | Onboarding, structure, and dev workflow | `--perspective=developer` |
| **Investor** | Due diligence, technical asset view, competitive landscape | `--perspective=investor` |

## Usage

```bash
# Analyze current directory
/analyze-repo .

# Analyze a GitHub project
/analyze-repo https://github.com/owner/repo

# Analyze a local path
/analyze-repo /path/to/project

# Perspective
/analyze-repo . --perspective=executive    # Executive summary
/analyze-repo . --perspective=architect    # Architecture deep dive
/analyze-repo . --perspective=developer    # Developer onboarding
/analyze-repo . --perspective=investor     # Due diligence style
/analyze-repo . --perspective=full         # Full report (default)
```

## Report structure

The full report has 11 major sections:

```
1. Executive Summary
   └── One-line positioning + health score + key findings + immediate actions

2. Project Overview
   └── Basics + tech stack + lifecycle stage

3. Architecture Analysis (C4 Model)
   ├── Level 1: System Context
   ├── Level 2: Container
   ├── Level 3: Component
   └── Level 4: Code (optional)

4. Quality Assessment (8 dimensions)
   ├── Maintainability / Testability / Scalability / Security
   └── Documentation / Architecture health / Dependency health / DX

5. Technical Debt Report
   └── SQALE-style categories + estimates + priority matrix

6. Dependency Analysis
   └── Dependency map + health check + cycles + license compliance

7. Security Assessment
   └── Vulnerability scan + OWASP Top 10 + sensitive data

8. Value & Competitive Analysis
   └── UVP + replaceability score + competitor matrix + adoption guidance

9. Market Future Value Analysis
   └── Trend alignment + TAM/SAM/SOM + SWOT + investment-style notes

10. Strategic Recommendations
    └── Priority matrix + timeline roadmap + detailed recommendations

11. Appendix
    └── Tree + key files + glossary + methodology
```

## Evaluation framework

### 8-dimension quality (1–100)

| Dimension | Weight | Question it answers | How it is assessed |
|-----------|--------|---------------------|--------------------|
| Maintainability | 15% | How easy is the code to change? | Complexity, naming, modularity, Maintainability Index |
| Testability | 12% | Is test coverage sufficient? | Coverage, test quality, mocks |
| Scalability | 12% | Can it handle 10× load? | Architecture flexibility, horizontal scale, patterns |
| Security | 15% | Are there security issues? | Dependency CVEs, sensitive data, OWASP |
| Documentation | 10% | Can a newcomer understand it? | README, API docs, comments |
| Architecture health | 15% | Is the design sound? | SOLID, separation of concerns, dependency direction |
| Dependency health | 11% | Are dependencies stable? | Count, versions, cycles |
| Developer experience | 10% | Is day-to-day dev smooth? | Onboarding, tooling, error messages |

### Technical debt categories (SQALE-style)

| Category | What to look for |
|----------|------------------|
| Reliability debt | Unhandled errors, null risks, resource leaks |
| Security debt | Known CVEs, hard-coded secrets, injection risk |
| Maintainability debt | Duplication, long functions, deep nesting |
| Performance debt | N+1 queries, missing cache, blocking I/O |
| Test debt | Low coverage, no integration tests, brittle tests |

### Recommendation priority framework

**Importance** (long-term impact on the project):

| Importance | Meaning |
|------------|---------|
| ⭐⭐⭐ Core / required | Skipping risks failure or severe exposure |
| ⭐⭐ Important / recommended | Clearly improves quality or reduces risk |
| ⭐ Optional / nice-to-have | Polish and ergonomics |

**Priority** (when to do it):

| Priority | Timeline |
|----------|----------|
| 🔴 Critical | Immediately (this week) |
| 🟠 High | Short term (1–3 months) |
| 🟡 Medium | Mid term (3–6 months) |
| 🟢 Low | Long term (6–12 months) |

## File layout

```
analyze-repo/
├── SKILL.md              # Core skill definition
├── README.md             # This file
└── extended/
    └── output-template.md  # Full output template
```

## v2.0 changelog

| Item | v1.0 | v2.0 |
|------|------|------|
| Architecture standard | Custom | arc42 + C4 Model |
| Quality dimensions | 5 | 8 |
| Technical debt | Simple list | SQALE-style quantification |
| Security | Basic checks | OWASP Top 10 |
| Market analysis | Competitor compare | TAM/SAM/SOM + SWOT |
| Recommendation system | Priority only | Importance + priority + roadmap |
| Output sections | 6 | 11 |

## Standards referenced

| Standard | Role |
|----------|------|
| [arc42](https://arc42.org/overview) | Architecture documentation |
| [C4 Model](https://c4model.com/) | Architecture visualization |
| [SQALE](https://www.sqale.org/) | Technical debt quantification |
| [OWASP Top 10](https://owasp.org/www-project-top-ten/) | Web application risks |

## Related skills

- [/evolve](../../.claude/skills/evolve/) — Autonomous multi-step goals
- [/commit](../../.claude/skills/commit/) — Commit workflow
- [/code-review](../../.claude/skills/code-review/) — Deep code review

## Installation

### Option 1: Claude Code Plugin Marketplace (recommended)

```bash
/install plugin:claude-software-skills
```

### Option 2: Manual install

```bash
cp -r tools-integrations/analyze-repo ~/.claude/skills/
```

## License

MIT License
