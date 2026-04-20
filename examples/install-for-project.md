# Example: Installing skills for a project

> Walkthrough: installing a full development skill set for omniflow-studio (React + FastAPI + AI)

## Project context

- **Frontend**: React + TypeScript
- **Backend**: FastAPI (Python)
- **Extras**: SSE real-time, AI API integration
- **Goal**: Install related skills to speed up development

## Installation steps

### 1. Confirm skillpkg is available

```
User: Check skillpkg status

Claude: [calls mcp__skillpkg__skill_status()]
Output:
📦 Project
   Name: omniflow-studio
   Config: skillpkg.json ✓
```

### 2. Install stack skills (4)

```
User: Install frontend, backend, realtime-systems, ai-ml-integration

Claude: [parallel install_skill calls]

mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#development-stacks/frontend")
→ ✅ Installed: frontend v1.0.0

mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#development-stacks/backend")
→ ✅ Installed: backend v1.0.0

mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#development-stacks/realtime-systems")
→ ✅ Installed: realtime-systems v1.0.0

mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#development-stacks/ai-ml-integration")
→ ✅ Installed: ai-ml-integration v1.0.0
```

### 3. Install language skills (2)

```
Claude: [parallel install_skill calls]

mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#programming-languages/javascript-typescript")
→ ✅ Installed: javascript-typescript v1.0.0

mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#programming-languages/python")
→ ✅ Installed: python v1.0.0
```

### 4. Install software engineering skills (2)

```
Claude: [parallel install_skill calls]

mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#software-engineering/code-quality")
→ ✅ Installed: code-quality v1.0.0

mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#software-engineering/testing-strategies")
→ ✅ Installed: testing-strategies v1.0.0
```

### 5. Install software design skills (2)

```
Claude: [parallel install_skill calls]

mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#software-design/api-design")
→ ✅ Installed: api-design v1.0.0

mcp__skillpkg__install_skill(source="github:leoarruda/claude-software-skills#software-design/ux-principles")
→ ✅ Installed: ux-principles v1.0.0
```

### 6. Verify installation

```
Claude: [calls mcp__skillpkg__list_skills(scope="local")]

Found 10 installed skill(s):
• ai-ml-integration v1.0.0 [local]
• api-design v1.0.0 [local]
• backend v1.0.0 [local]
• code-quality v1.0.0 [local]
• frontend v1.0.0 [local]
• javascript-typescript v1.0.0 [local]
• python v1.0.0 [local]
• realtime-systems v1.0.0 [local]
• testing-strategies v1.0.0 [local]
• ux-principles v1.0.0 [local]
```

## Resulting skillpkg.json

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

## What you get

After installation, Claude Code loads these skills automatically and can provide:

### Frontend skill
- React best practices (hooks, context, performance)
- State management (Zustand, Redux Toolkit)
- Testing (React Testing Library)

### Backend skill
- FastAPI routing patterns
- Dependency injection
- Error handling

### Realtime-systems skill
- SSE patterns
- WebSocket connection management
- Event-driven design

### AI-ML-integration skill
- LLM API integration
- Prompt engineering
- Streaming responses

## Copy-paste snippet

For a similar React + FastAPI + AI stack, you can use:

```python
# Run in Claude Code
skills = [
    "development-stacks/frontend",
    "development-stacks/backend",
    "development-stacks/realtime-systems",
    "development-stacks/ai-ml-integration",
    "programming-languages/javascript-typescript",
    "programming-languages/python",
    "software-engineering/code-quality",
    "software-engineering/testing-strategies",
    "software-design/api-design",
    "software-design/ux-principles",
]

for skill in skills:
    mcp__skillpkg__install_skill(
        source=f"github:leoarruda/claude-software-skills#{skill}",
        scope="local"
    )
```

## Related docs

- [Full usage guide](../docs/USAGE-GUIDE.md)
- [Skill catalog](../README.md#available-skills)
