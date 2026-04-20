#!/bin/bash
# ============================================================================
# Auto-Dev quick setup script
# ============================================================================
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/user/claude-software-skills/main/scripts/setup-auto-dev.sh | bash
#
# Or download and run:
#   chmod +x setup-auto-dev.sh
#   ./setup-auto-dev.sh
# ============================================================================

set -e

echo "🤖 Auto-Dev setup script"
echo "===================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Ensure we are in a git repo
if [ ! -d .git ]; then
    echo -e "${RED}Error: run this script from the root of a Git repository${NC}"
    exit 1
fi

# Get repo info
REPO_URL=$(git config --get remote.origin.url 2>/dev/null || echo "")
if [ -z "$REPO_URL" ]; then
    echo -e "${YELLOW}Warning: could not get remote URL${NC}"
fi

echo -e "${BLUE}📁 Creating directory layout...${NC}"

# Create directories
mkdir -p .github/workflows
mkdir -p .claude/memory/{learnings,failures,decisions,patterns,strategies}
mkdir -p .github/ISSUE_TEMPLATE

echo -e "${GREEN}✓ Directories created${NC}"

# ============================================================================
# Choose setup mode
# ============================================================================
echo ""
echo "Choose a setup mode:"
echo "  1) Reusable workflow (recommended; pulls updates automatically)"
echo "  2) Copy full workflows (standalone; fully customizable)"
echo ""
read -p "Choice [1/2]: " CHOICE

if [ "$CHOICE" = "1" ]; then
    # ========================================================================
    # Mode 1: Reusable workflow
    # ========================================================================
    echo -e "${BLUE}📝 Creating reusable workflow config...${NC}"

    cat > .github/workflows/auto-dev.yml << 'EOF'
# Auto-Dev Workflow
# Uses the reusable workflow from claude-software-skills

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
        type: string

concurrency:
  group: auto-dev-${{ github.event.issue.number || github.run_id }}
  cancel-in-progress: false

jobs:
  auto-dev:
    # TODO: replace with your skills repo
    uses: user/claude-software-skills/.github/workflows/auto-dev-reusable.yml@main
    with:
      goal: ${{ github.event.inputs.goal || '' }}
      # skills_repo: 'user/claude-software-skills'  # optional: load extra skills
      # custom_instructions: 'Use TypeScript; follow project style'  # optional
    secrets:
      ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
EOF

    echo -e "${YELLOW}⚠️  Edit .github/workflows/auto-dev.yml${NC}"
    echo -e "${YELLOW}   Replace 'user/claude-software-skills' with the correct repo path${NC}"

else
    # ========================================================================
    # Mode 2: Full copy
    # ========================================================================
    echo -e "${BLUE}📝 Downloading full workflows...${NC}"

    SKILLS_REPO="https://raw.githubusercontent.com/user/claude-software-skills/main"

    curl -fsSL "$SKILLS_REPO/.github/workflows/auto-dev.yml" -o .github/workflows/auto-dev.yml
    curl -fsSL "$SKILLS_REPO/.github/workflows/auto-dev-feedback.yml" -o .github/workflows/auto-dev-feedback.yml
    curl -fsSL "$SKILLS_REPO/.github/workflows/auto-dev-queue.yml" -o .github/workflows/auto-dev-queue.yml

    echo -e "${GREEN}✓ Workflow files downloaded${NC}"
fi

# ============================================================================
# Shared setup
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
      placeholder: "e.g. Implement user login with email and password"
    validations:
      required: true

  - type: textarea
    id: acceptance
    attributes:
      label: Acceptance criteria
      description: How do we know the task is done?
      placeholder: |
        - [ ] Feature works
        - [ ] Tests added
    validations:
      required: false

  - type: dropdown
    id: priority
    attributes:
      label: Priority
      options:
        - normal
        - high
        - low
EOF

echo -e "${GREEN}✓ Issue template created${NC}"

echo -e "${BLUE}📝 Initializing memory system...${NC}"

cat > .claude/memory/index.md << 'EOF'
# Project memory index

> Auto-maintained

## Recent learnings
<!-- LEARNINGS_START -->
<!-- LEARNINGS_END -->

## Failures
<!-- FAILURES_START -->
<!-- FAILURES_END -->

## Decisions
<!-- DECISIONS_START -->
<!-- DECISIONS_END -->
EOF

# Create .gitkeep
touch .claude/memory/{learnings,failures,decisions,patterns,strategies}/.gitkeep

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
echo "  1. Set GitHub Secret:"
echo "     Repository Settings → Secrets → Actions"
echo -e "     Add ${YELLOW}ANTHROPIC_API_KEY${NC}"
echo ""
echo "  2. Commit changes:"
echo "     git add .github/"
echo "     git commit -m 'feat: Add Auto-Dev workflow'"
echo "     git push"
echo ""
echo "  3. How to use:"
echo "     - Open an issue → add the 'auto-dev' label"
echo "     - Or comment on any issue: '/evolve [goal]'"
echo ""
echo "Docs: https://github.com/LeoArruda/claude-software-skills/blob/main/.github/AUTO-DEV.md"
echo ""
