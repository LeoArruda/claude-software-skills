---
name: claude-code-sdk
description: Claude Code SDK integration for building AI-powered applications with OAuth and API Key authentication
domain: tools-integrations
subdomain: ai-agent-integration
version: 1.0.0
tags: [claude, anthropic, sdk, ai-agent, oauth, fastapi, streaming, sse]
triggers:
  keywords:
    primary: [claude-code-sdk, claude sdk, claude agent, anthropic sdk, claude integration]
    secondary: [ai agent, claude api, claude oauth, claude login, max plan]
  context_boost: [python, fastapi, backend, streaming, sse, authentication]
  context_penalty: [frontend only, browser direct]
  priority: high
---

# Claude Code SDK Integration

## Overview

The Claude Code SDK (`claude-code-sdk`) is Anthropic’s official Python package for integrating Claude AI Agent capabilities into applications. It supports OAuth (via `claude login`) and API Key authentication so developers can use Claude Max/Pro subscriptions or API billing. This SDK is central to AI-powered apps, especially for code generation, file operations, or multi-turn dialogue.

## Key Concepts

### Authentication

**Description**: The Claude Code SDK supports two authentication modes  
**Key Features**:
- **OAuth**: Credentials stored under `~/.claude/` after `claude login`
- **API Key**: Via the `ANTHROPIC_API_KEY` environment variable

**Use Cases**:
- OAuth: Personal development, users with Max/Pro subscriptions
- API Key: Production and metered services

### Core SDK API

**Description**: The `query()` function is the main asynchronous interface  
**Key Features**:
- Async iterator for messages
- Supports streaming and full responses
- Configurable tool permissions and execution limits

**Use Cases**: Code generation, file operations, research tasks, read-only analysis

### Tool types (ToolType)

**Description**: The SDK exposes several built-in tools  
**Key Features**:
- `READ`, `WRITE`, `EDIT` — file operations
- `BASH` — terminal commands
- `GLOB`, `GREP` — file search
- `WEB_FETCH` — web fetching

## Best Practices

1. **Dual authentication check**
   - Support both OAuth and API Key
   - Prefer OAuth when possible (uses Max/Pro quota)
   - Use API Key as fallback

```python
def check_auth_status() -> dict:
    status = {
        'api_key_set': bool(os.environ.get('ANTHROPIC_API_KEY')),
        'oauth_logged_in': False,
    }

    # Check OAuth login state
    claude_dir = os.path.expanduser('~/.claude')
    if os.path.exists(claude_dir):
        auth_files = ['credentials.json', 'settings.json', '.credentials.json']
        for auth_file in auth_files:
            if os.path.exists(os.path.join(claude_dir, auth_file)):
                status['oauth_logged_in'] = True
                break

    # Only one auth method is required
    status['auth_available'] = status['api_key_set'] or status['oauth_logged_in']
    return status
```

2. **Increase buffer size**
   - The default buffer is too small for large responses
   - Increase to ~50MB

```python
try:
    from claude_code_sdk._internal.transport import subprocess_cli
    subprocess_cli._MAX_BUFFER_SIZE = 50 * 1024 * 1024  # 50MB
except Exception as e:
    print(f"Failed to patch SDK buffer size: {e}")
```

3. **Use a singleton pattern**
   - Avoid repeated initialization
   - Share state and configuration

```python
_claude_service: Optional['ClaudeCodeService'] = None

def get_claude_code() -> 'ClaudeCodeService':
    global _claude_service
    if _claude_service is None:
        _claude_service = ClaudeCodeService()
    return _claude_service
```

4. **Preset configuration profiles**
   - Restrict tools by scenario
   - Reduce risk and improve safety

```python
@dataclass
class AgentConfig:
    allowed_tools: List[str]
    max_turns: int = 30
    cwd: Optional[str] = None

    @classmethod
    def coding(cls) -> 'AgentConfig':
        """Development mode: full permissions"""
        return cls(
            allowed_tools=['Read', 'Write', 'Edit', 'Bash', 'Glob', 'Grep'],
            max_turns=50
        )

    @classmethod
    def research(cls) -> 'AgentConfig':
        """Research mode: web access"""
        return cls(
            allowed_tools=['Read', 'Glob', 'Grep', 'WebFetch'],
            max_turns=20
        )

    @classmethod
    def readonly(cls) -> 'AgentConfig':
        """Read-only mode: safest"""
        return cls(
            allowed_tools=['Read', 'Glob', 'Grep'],
            max_turns=10
        )
```

## Common Pitfalls

### Pitfall 1: Calling the SDK directly from the frontend

- **Problem**: `claude-code-sdk` is a Python package and cannot run in the browser
- **Solution**: Expose a backend API
- **Example**:

```python
# Wrong: trying to use from the frontend
# JavaScript cannot use the Python SDK directly

# Right: expose a FastAPI backend
from fastapi import FastAPI
from claude_code_sdk import query

app = FastAPI()

@app.post("/api/generate")
async def generate(prompt: str):
    result = []
    async for msg in query(prompt=prompt):
        result.append(msg)
    return {"result": result}
```

### Pitfall 2: Forgetting async handling

- **Problem**: The SDK is async; omitting `await` causes errors
- **Solution**: Use `async`/`await` or `asyncio`

```python
# Wrong
def run_sync():
    for msg in query(prompt="Hello"):  # TypeError
        print(msg)

# Right
async def run_async():
    async for msg in query(prompt="Hello"):
        print(msg)
```

### Pitfall 3: Confusing Claude API and Claude Code SDK

- **Problem**:
  - Claude API (`anthropic` package) — direct HTTP API, API Key only
  - Claude Code SDK (`claude-code-sdk`) — agent features, OAuth supported
- **Solution**: Pick the right package for your needs

| Aspect | Claude API | Claude Code SDK |
|--------|------------|-----------------|
| Auth | API Key only | OAuth + API Key |
| Capabilities | Chat only | Agent (files / terminal) |
| Billing | API usage | Max/Pro subscription eligible |
| Package | `anthropic` | `claude-code-sdk` |

## Patterns & Anti-Patterns

### Patterns (Do This)

**Full service wrapper**:

```python
from dataclasses import dataclass, field
from typing import AsyncIterator, Optional, List, Dict, Any
from claude_code_sdk import query, ClaudeCodeOptions, AssistantMessage, TextBlock

@dataclass
class ClaudeCodeService:
    """Claude Code service wrapper"""

    async def run(self, prompt: str, config: Optional[AgentConfig] = None) -> Dict[str, Any]:
        """Run and collect full result"""
        options = ClaudeCodeOptions(
            allowed_tools=config.allowed_tools if config else None,
            max_turns=config.max_turns if config else 30,
            cwd=config.cwd
        )

        result_texts = []
        tool_calls = []

        async for message in query(prompt=prompt, options=options):
            if isinstance(message, AssistantMessage):
                for block in message.content:
                    if isinstance(block, TextBlock):
                        result_texts.append(block.text)

        return {
            'status': 'success',
            'result': '\n'.join(result_texts),
            'tool_calls': tool_calls
        }

    async def stream(self, prompt: str, config: Optional[AgentConfig] = None) -> AsyncIterator[dict]:
        """Stream execution, yield chunks as they arrive"""
        options = ClaudeCodeOptions(
            allowed_tools=config.allowed_tools if config else None,
            max_turns=config.max_turns if config else 30
        )

        async for message in query(prompt=prompt, options=options):
            if isinstance(message, AssistantMessage):
                for block in message.content:
                    if isinstance(block, TextBlock):
                        yield {'type': 'text', 'content': block.text}
```

**FastAPI streaming endpoint**:

```python
from fastapi import FastAPI
from fastapi.responses import StreamingResponse
import json

app = FastAPI()

@app.post("/api/agent/stream")
async def agent_stream(prompt: str):
    async def event_generator():
        service = ClaudeCodeService()
        async for msg in service.stream(prompt):
            yield f"data: {json.dumps(msg)}\n\n"
        yield "data: [DONE]\n\n"

    return StreamingResponse(
        event_generator(),
        media_type="text/event-stream"
    )
```

### Anti-Patterns (Avoid This)

```python
# Do not instantiate a new service on every request
@app.post("/api/generate")
async def bad_generate(prompt: str):
    service = ClaudeCodeService()  # new instance each time
    return await service.run(prompt)

# Do not ignore errors
async def bad_run(prompt: str):
    async for msg in query(prompt=prompt):  # may throw
        print(msg)

# Do not grant excessive permissions
config = AgentConfig(
    allowed_tools=['Read', 'Write', 'Edit', 'Bash', 'WebFetch'],  # everything on
    max_turns=100  # too high
)
```

## Tools & Resources

| Tool | Purpose | Link |
|------|---------|------|
| claude-code-sdk | Official Python SDK | `pip install claude-code-sdk` |
| Claude Code CLI | Command-line tool | `npm install -g @anthropic-ai/claude-code` |
| FastAPI | Backend framework | [fastapi.tiangolo.com](https://fastapi.tiangolo.com) |

## Decision Guide

Use Claude Code SDK when:
- [x] You need agent capabilities (files, terminal)
- [x] You want Max/Pro subscription instead of API billing
- [x] You are building multi-turn AI applications
- [x] You need streaming responses

Consider alternatives when:
- [ ] You only need simple chat → use the `anthropic` package
- [ ] Pure frontend app → use `anthropic` + `anthropic-dangerous-direct-browser-access`
- [ ] You do not need agent features → use the standard Claude API

## Examples

### Example 1: Full backend service

**Context**: Backend API that can use a Claude Max subscription

**Implementation**:

```python
# backend/main.py
import os
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from pydantic import BaseModel
import json

from claude_code_sdk import query, ClaudeCodeOptions, AssistantMessage, TextBlock

app = FastAPI()

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

class GenerateRequest(BaseModel):
    prompt: str
    max_turns: int = 30

def check_auth():
    """Check authentication state"""
    api_key = bool(os.environ.get('ANTHROPIC_API_KEY'))
    oauth = os.path.exists(os.path.expanduser('~/.claude/credentials.json'))
    return api_key or oauth

@app.get("/api/health")
async def health():
    return {
        "status": "ok",
        "auth_available": check_auth()
    }

@app.post("/api/generate")
async def generate(request: GenerateRequest):
    if not check_auth():
        raise HTTPException(401, "Run claude login or set ANTHROPIC_API_KEY")

    options = ClaudeCodeOptions(max_turns=request.max_turns)
    results = []

    async for message in query(prompt=request.prompt, options=options):
        if isinstance(message, AssistantMessage):
            for block in message.content:
                if isinstance(block, TextBlock):
                    results.append(block.text)

    return {"result": "\n".join(results)}

@app.post("/api/stream")
async def stream(request: GenerateRequest):
    if not check_auth():
        raise HTTPException(401, "Not authenticated")

    async def event_generator():
        options = ClaudeCodeOptions(max_turns=request.max_turns)
        async for message in query(prompt=request.prompt, options=options):
            if isinstance(message, AssistantMessage):
                for block in message.content:
                    if isinstance(block, TextBlock):
                        yield f"data: {json.dumps({'text': block.text})}\n\n"
        yield "data: [DONE]\n\n"

    return StreamingResponse(event_generator(), media_type="text/event-stream")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

**requirements.txt**:
```
fastapi>=0.100.0
uvicorn>=0.23.0
claude-code-sdk>=0.1.0
python-dotenv>=1.0.0
```

**Explanation**: This backend detects OAuth or API Key auth and supports normal and streaming responses.

### Example 2: Frontend integration

**Context**: Frontend calling the backend API

**Implementation**:

```javascript
// Standard request
async function generate(prompt) {
    const response = await fetch('http://localhost:8000/api/generate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ prompt })
    });
    const data = await response.json();
    return data.result;
}

// Streaming request
async function streamGenerate(prompt, onChunk) {
    const response = await fetch('http://localhost:8000/api/stream', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ prompt })
    });

    const reader = response.body.getReader();
    const decoder = new TextDecoder();

    while (true) {
        const { done, value } = await reader.read();
        if (done) break;

        const chunk = decoder.decode(value);
        const lines = chunk.split('\n');

        for (const line of lines) {
            if (line.startsWith('data: ') && line !== 'data: [DONE]') {
                const data = JSON.parse(line.slice(6));
                onChunk(data.text);
            }
        }
    }
}
```

### Example 3: Docker deployment

**Context**: Containerized deployment including Claude Code CLI

**Implementation**:

```dockerfile
# Dockerfile
FROM python:3.11-slim

# Install Node.js (required for Claude Code CLI)
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

```yaml
# docker-compose.yml
version: '3.8'
services:
  backend:
    build: .
    ports:
      - "8000:8000"
    environment:
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
    volumes:
      - ~/.claude:/root/.claude:ro  # Mount OAuth credentials
```

## Related Skills

- [[api-design]] — Designing REST API endpoints
- [[backend]] — Python/FastAPI backend development
- [[devops-cicd]] — Docker deployment and CI/CD
- [[security-practices]] — API authentication and security

## References

- [Claude Code SDK GitHub](https://github.com/anthropics/claude-code)
- [Anthropic API Documentation](https://docs.anthropic.com)
- [FastAPI Documentation](https://fastapi.tiangolo.com)
