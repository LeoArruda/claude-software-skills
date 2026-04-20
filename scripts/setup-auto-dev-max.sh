#!/bin/bash
# ============================================================================
# Auto-Dev setup script (Claude Max)
# ============================================================================
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/leoarruda/claude-software-skills/main/scripts/setup-auto-dev-max.sh | bash
# ============================================================================

set -e

echo "🤖 Auto-Dev setup script (Claude Max)"
echo "======================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Ensure we are in a git repo
if [ ! -d .git ]; then
    echo -e "${RED}Error: run this script from the root of a Git repository${NC}"
    exit 1
fi

echo -e "${BLUE}📁 Creating directory layout...${NC}"
mkdir -p .github/workflows
mkdir -p .claude/memory/{learnings,failures,decisions,patterns,strategies}
mkdir -p .github/ISSUE_TEMPLATE
touch .claude/memory/{learnings,failures,decisions,patterns,strategies}/.gitkeep

echo -e "${GREEN}✓ Directories created${NC}"

# ============================================================================
# Create workflow
# ============================================================================
echo -e "${BLUE}📝 Creating workflow...${NC}"

cat > .github/workflows/auto-dev.yml << 'EOF'
# Auto-Dev Workflow (Claude Max)
# Uses official claude-code-action + OAuth token

name: 🤖 Auto-Dev

on:
  issues:
    types: [labeled, opened]
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]

permissions:
  contents: write
  pull-requests: write
  issues: write
  id-token: write

jobs:
  auto-dev:
    if: |
      (github.event_name == 'issues' && contains(github.event.issue.labels.*.name, 'auto-dev')) ||
      (github.event_name == 'issue_comment' && contains(github.event.comment.body, '@claude')) ||
      (github.event_name == 'pull_request_review_comment')

    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - uses: anthropics/claude-code-action@v1
        with:
          claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
          # Use custom_instructions instead of prompt to keep default behavior
          custom_instructions: |
            Reply in English unless the user or issue explicitly asks for another language.
            Keep technical terms (e.g. HTML, JavaScript, CSS) as usual.

            When the task is done, include in your reply:

            ### 🛠️ Tools and skills used
            - Languages/frameworks used
            - Techniques or approaches

            ### 📝 Task summary
            - What was completed
            - Files created or changed

            ### 📚 Memory updates
            - If you learned something or hit issues, update the relevant files under .claude/memory/
EOF

echo -e "${GREEN}✓ Workflow created${NC}"

# ============================================================================
# Create issue template
# ============================================================================
echo -e "${BLUE}📝 Creating issue template...${NC}"

cat > .github/ISSUE_TEMPLATE/auto-dev.yml << 'EOF'
name: 🤖 Auto-Dev Task
description: Create an automated development task
title: "[Auto-Dev] "
labels: ["auto-dev"]
body:
  - type: textarea
    id: goal
    attributes:
      label: Goal
      description: Describe the development goal you want to achieve
      placeholder: "e.g. Build a Hello World program"
    validations:
      required: true

  - type: textarea
    id: acceptance
    attributes:
      label: Acceptance criteria
      description: How do we know the task is done?
    validations:
      required: false
EOF

echo -e "${GREEN}✓ Issue template created${NC}"

# ============================================================================
# Initialize memory
# ============================================================================
echo -e "${BLUE}📝 Initializing memory system...${NC}"

cat > .claude/memory/index.md << 'EOF'
# Project memory index

## Recent learnings
<!-- LEARNINGS_START -->
<!-- LEARNINGS_END -->

## Failures
<!-- FAILURES_START -->
<!-- FAILURES_END -->
EOF

echo -e "${GREEN}✓ Memory system initialized${NC}"

# ============================================================================
# Create CLAUDE.md
# ============================================================================
echo -e "${BLUE}📝 Creating CLAUDE.md...${NC}"

cat > CLAUDE.md << 'EOF'
# Claude Code project settings

## Language
Reply in English unless the user or issue explicitly asks for another language.
Keep technical terms (e.g. HTML, JavaScript, CSS) as usual.

## Memory system

After completing work, update the relevant files under `.claude/memory/`:

### Learnings (`learnings/`)
Record technical knowledge or best practices learned on this project.

### Failures (`failures/`)
Record problems encountered and how they were resolved.

### Decisions (`decisions/`)
Record important technical decisions.

### Patterns (`patterns/`)
Record code patterns you noticed.

### Update index.md
After adding entries, update the index in `.claude/memory/index.md`.

## Task completion report format

### 🛠️ Tools and skills used
- Languages/frameworks used
- Techniques or approaches

### 📝 Task summary
- What was completed
- Files created or changed

### 📚 Memory updates
- List memory files you updated
EOF

echo -e "${GREEN}✓ CLAUDE.md created${NC}"

# ============================================================================
# Done
# ============================================================================
echo ""
echo "============================================"
echo -e "${GREEN}🎉 Auto-Dev setup complete!${NC}"
echo "============================================"
echo ""
echo "Next steps:"
echo ""
echo -e "  ${YELLOW}1. Install the GitHub App (OAuth token):${NC}"
echo ""
echo "     Run in this directory:"
echo -e "     ${BLUE}claude /install-github-app${NC}"
echo ""
echo "     This will:"
echo "     - Install the Claude Code GitHub App"
echo "     - Set CLAUDE_CODE_OAUTH_TOKEN in repo secrets"
echo ""
echo -e "  ${YELLOW}2. Commit changes:${NC}"
echo "     git add .github/"
echo "     git commit -m 'feat: Add Auto-Dev workflow'"
echo "     git push"
echo ""
echo -e "  ${YELLOW}3. How to use:${NC}"
echo "     - Open an issue → add the 'auto-dev' label"
echo "     - Or comment @claude [instruction] on an issue or PR"
echo ""
echo -e "${BLUE}💡 Tip: Claude Max subscription usage is included in your plan${NC}"
echo ""
