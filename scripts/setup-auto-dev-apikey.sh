#!/bin/bash
# ============================================================================
# Auto-Dev setup script (API key)
# ============================================================================
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/miles990/claude-software-skills/main/scripts/setup-auto-dev-apikey.sh | bash
# ============================================================================

set -e

echo "🤖 Auto-Dev setup script (API key)"
echo "===================================="
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
# Auto-Dev Workflow (API key)
# Uses official claude-code-action

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
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            You are a professional software development assistant.
            Complete the task described in the issue or comment.
            For development tasks, open a PR when done.
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
# Done
# ============================================================================
echo ""
echo "============================================"
echo -e "${GREEN}🎉 Auto-Dev setup complete!${NC}"
echo "============================================"
echo ""
echo "Next steps:"
echo ""
echo -e "  ${YELLOW}1. Get an API key:${NC}"
echo "     https://console.anthropic.com/settings/keys"
echo ""
echo -e "  ${YELLOW}2. Set GitHub Secret:${NC}"
echo "     Repository Settings → Secrets → Actions"
echo -e "     Add ${BLUE}ANTHROPIC_API_KEY${NC}"
echo ""
echo -e "  ${YELLOW}3. Commit changes:${NC}"
echo "     git add .github/"
echo "     git commit -m 'feat: Add Auto-Dev workflow'"
echo "     git push"
echo ""
echo -e "  ${YELLOW}4. How to use:${NC}"
echo "     - Open an issue → add the 'auto-dev' label"
echo "     - Or comment @claude [instruction] on an issue or PR"
echo ""
