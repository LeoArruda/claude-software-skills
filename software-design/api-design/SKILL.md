---
name: api-design
description: RESTful, GraphQL, gRPC, and API best practices
domain: software-design
version: 1.0.0
tags: [rest, graphql, grpc, websocket, openapi, versioning]
triggers:
  keywords:
    primary: [api, rest, restful, graphql, grpc, endpoint, openapi]
    secondary: [swagger, websocket, webhook, versioning, rate limit, pagination]
  context_boost: [backend, microservice, integration, http]
  context_penalty: [frontend, ui, css]
  priority: high
collaboration:
  prerequisites: []
  delegation_triggers:
    - trigger: Implementation of API endpoints
      delegate_to: backend
      context: Framework-specific implementation patterns
    - trigger: Data model for API responses
      delegate_to: database
      context: Schema design, query requirements
    - trigger: API contract testing
      delegate_to: testing-strategies
      context: Contract tests, integration tests
  receives_context_from:
    - skill: backend
      receives:
        - Framework capabilities
        - Middleware available
        - Authentication mechanism
    - skill: database
      receives:
        - Available data structures
        - Query performance characteristics
  provides_context_to:
    - skill: backend
      provides:
        - Endpoint specifications
        - Request/response formats
        - Error code conventions
    - skill: frontend
      provides:
        - API documentation
        - Authentication flow
        - Rate limiting rules
    - skill: testing-strategies
      provides:
        - API contract specifications
        - Expected behaviors
---

# API Design

## Overview

Design principles for building APIs that are intuitive, consistent, and scalable. Covers REST, GraphQL, gRPC, and real-time protocols.

---

## RESTful API Design

### Resource Naming

```
✅ Good (nouns, plural):
GET    /users           # List users
GET    /users/123       # Get user
POST   /users           # Create user
PUT    /users/123       # Update user
DELETE /users/123       # Delete user

❌ Bad (verbs, actions):
GET    /getUsers
POST   /createUser
POST   /users/123/delete
```

### Nested Resources

```
# Hierarchical relationship
GET /users/123/orders              # User's orders
GET /users/123/orders/456          # Specific order

# Alternative: Query parameter for filtering
GET /orders?userId=123             # Filter orders by user

# Rule: Nest max 2 levels deep
❌ /users/123/orders/456/items/789/reviews
✅ /order-items/789/reviews
```

### HTTP Methods & Status Codes

| Method | Purpose | Success | Error |
|--------|---------|---------|-------|
| GET | Read | 200 | 404 |
| POST | Create | 201 | 400, 409 |
| PUT | Replace | 200 | 400, 404 |
| PATCH | Partial update | 200 | 400, 404 |
| DELETE | Remove | 204 | 404 |

```typescript
// Response structure
interface ApiResponse<T> {
  data: T;
  meta?: {
    page: number;
    limit: number;
    total: number;
  };
}

interface ApiError {
  error: {
    code: string;        // Machine-readable
    message: string;     // Human-readable
    details?: object;    // Validation errors, etc.
  };
}
```

### Pagination

```typescript
// Offset-based (simple, has issues with large datasets)
GET /users?page=2&limit=20

// Cursor-based (stable, performant)
GET /users?cursor=eyJpZCI6MTIzfQ&limit=20

// Response
{
  "data": [...],
  "meta": {
    "nextCursor": "eyJpZCI6MTQzfQ",
    "hasMore": true
  }
}
```

### Filtering & Sorting

```typescript
// Query parameters
GET /products?category=electronics&minPrice=100&maxPrice=500
GET /products?sort=-createdAt,name  // - prefix for descending

// Filter operators
GET /users?age[gte]=18&age[lte]=65
GET /users?status[in]=active,pending
GET /users?name[like]=john*
```

---

## GraphQL Design

### Schema Design

```graphql
type User {
  id: ID!
  email: String!
  name: String!
  posts(first: Int, after: String): PostConnection!
  createdAt: DateTime!
}

type Post {
  id: ID!
  title: String!
  content: String!
  author: User!
  comments: [Comment!]!
}

# Connections for pagination (Relay spec)
type PostConnection {
  edges: [PostEdge!]!
  pageInfo: PageInfo!
}

type PostEdge {
  node: Post!
  cursor: String!
}

type Query {
  user(id: ID!): User
  users(first: Int, after: String, filter: UserFilter): UserConnection!
}

type Mutation {
  createUser(input: CreateUserInput!): CreateUserPayload!
  updateUser(id: ID!, input: UpdateUserInput!): UpdateUserPayload!
}

input CreateUserInput {
  email: String!
  name: String!
  password: String!
}

type CreateUserPayload {
  user: User
  errors: [Error!]
}
```

### Resolver Patterns

```typescript
// N+1 prevention with DataLoader
const userLoader = new DataLoader(async (ids: string[]) => {
  const users = await db.users.findMany({ where: { id: { in: ids } } });
  return ids.map(id => users.find(u => u.id === id));
});

const resolvers = {
  Post: {
    author: (post, _, { loaders }) => loaders.user.load(post.authorId),
  },
};

// Field-level authorization
const resolvers = {
  User: {
    email: (user, _, { currentUser }) => {
      if (currentUser.id !== user.id && !currentUser.isAdmin) {
        return null; // Hide from other users
      }
      return user.email;
    },
  },
};
```

### Error Handling

```typescript
// Union types for expected errors
type CreatePostResult = Post | ValidationError | NotAuthorizedError

// Or use errors field in payload
type CreatePostPayload {
  post: Post
  errors: [CreatePostError!]
}

union CreatePostError = ValidationError | RateLimitError
```

---

## gRPC Design

### Protocol Buffers

```protobuf
syntax = "proto3";

package users.v1;

service UserService {
  rpc GetUser(GetUserRequest) returns (GetUserResponse);
  rpc ListUsers(ListUsersRequest) returns (ListUsersResponse);
  rpc CreateUser(CreateUserRequest) returns (CreateUserResponse);

  // Streaming
  rpc WatchUsers(WatchUsersRequest) returns (stream UserEvent);
  rpc BatchCreateUsers(stream CreateUserRequest) returns (BatchCreateResponse);
}

message User {
  string id = 1;
  string email = 2;
  string name = 3;
  google.protobuf.Timestamp created_at = 4;
}

message GetUserRequest {
  string id = 1;
}

message GetUserResponse {
  User user = 1;
}

message ListUsersRequest {
  int32 page_size = 1;
  string page_token = 2;
  UserFilter filter = 3;
}

message ListUsersResponse {
  repeated User users = 1;
  string next_page_token = 2;
}
```

### When to Use gRPC

| Use Case | REST | GraphQL | gRPC |
|----------|------|---------|------|
| Public API | ✅ | ✅ | ❌ |
| Mobile apps | ✅ | ✅ | ⚠️ |
| Microservices | ⚠️ | ❌ | ✅ |
| Real-time | ❌ | ⚠️ | ✅ |
| Browser clients | ✅ | ✅ | ⚠️ |

---

## API Versioning

### Strategies

```
# URL versioning (most common)
GET /v1/users
GET /v2/users

# Header versioning
GET /users
Accept: application/vnd.api+json; version=2

# Query parameter
GET /users?version=2
```

### Breaking vs Non-Breaking Changes

```
Non-Breaking (safe):
✅ Add new optional field
✅ Add new endpoint
✅ Add new optional query parameter
✅ Expand enum values (if client ignores unknown)

Breaking (requires new version):
❌ Remove field
❌ Rename field
❌ Change field type
❌ Make optional field required
❌ Change URL structure
```

### Deprecation Strategy

```typescript
// OpenAPI deprecation
/**
 * @deprecated Use /v2/users instead. Will be removed on 2025-06-01.
 */
app.get('/v1/users', ...);

// Response header
res.setHeader('Deprecation', 'true');
res.setHeader('Sunset', 'Sat, 01 Jun 2025 00:00:00 GMT');
res.setHeader('Link', '</v2/users>; rel="successor-version"');
```

---

## Real-time APIs

### WebSocket

```typescript
// Server
wss.on('connection', (ws) => {
  ws.on('message', (data) => {
    const message = JSON.parse(data);

    switch (message.type) {
      case 'subscribe':
        subscriptions.add(ws, message.channel);
        break;
      case 'unsubscribe':
        subscriptions.remove(ws, message.channel);
        break;
    }
  });
});

// Client
const ws = new WebSocket('wss://api.example.com/ws');

ws.send(JSON.stringify({
  type: 'subscribe',
  channel: 'orders:user:123'
}));

ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  handleUpdate(data);
};
```

### Server-Sent Events (SSE)

```typescript
// Server
app.get('/events', (req, res) => {
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');

  const sendEvent = (data: object) => {
    res.write(`data: ${JSON.stringify(data)}\n\n`);
  };

  // Subscribe to events
  eventEmitter.on('update', sendEvent);

  req.on('close', () => {
    eventEmitter.off('update', sendEvent);
  });
});

// Client
const source = new EventSource('/events');
source.onmessage = (event) => {
  const data = JSON.parse(event.data);
  handleUpdate(data);
};
```

---

## API Documentation

### OpenAPI (Swagger)

```yaml
openapi: 3.0.3
info:
  title: User API
  version: 1.0.0

paths:
  /users:
    get:
      summary: List users
      parameters:
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/User'

components:
  schemas:
    User:
      type: object
      required: [id, email, name]
      properties:
        id:
          type: string
          format: uuid
        email:
          type: string
          format: email
        name:
          type: string
```

---

## Security Best Practices

| Practice | Implementation |
|----------|----------------|
| Authentication | Bearer tokens, API keys |
| Rate limiting | X-RateLimit-* headers |
| Input validation | Schema validation (Zod, Joi) |
| CORS | Whitelist allowed origins |
| HTTPS | Always in production |
| Request IDs | X-Request-ID for tracing |

```typescript
// Rate limit headers
res.setHeader('X-RateLimit-Limit', '100');
res.setHeader('X-RateLimit-Remaining', '95');
res.setHeader('X-RateLimit-Reset', '1640000000');
```

---

## Related Skills

- [[architecture-patterns]] - API Gateway, microservices
- [[security-practices]] - Authentication, authorization
- [[documentation]] - API documentation tools

---

## Sharp edges (common pitfalls)

> These are among the most common and costly mistakes in API design.

### SE-1: Breaking changes
- **Severity**: critical
- **Situation**: Existing API changes break clients without a versioning strategy
- **Causes**: Removing fields, changing types, tightening required fields, renaming
- **Symptoms**:
  - Clients suddenly error
  - Older apps stop working
  - “It worked yesterday” reports after a deploy
- **Detection**: `\-.*field|rename.*property|required.*true.*→.*false|type.*string.*→.*number`
- **Mitigation**: Version APIs; prefer additive changes; publish deprecation timelines

### SE-2: Over-fetching
- **Severity**: medium
- **Situation**: Responses include far more data than clients need
- **Causes**: Returning full rows by default; ignoring different client shapes
- **Symptoms**:
  - Large payloads with tiny usage
  - Slow mobile clients
  - Wasted bandwidth
- **Detection**: `select\s*\*|findMany\(\)|findAll\(\)(?!.*select)`
- **Mitigation**: Field selection, GraphQL, or purpose-built endpoints

### SE-3: Under-fetching
- **Severity**: medium
- **Situation**: Clients need many calls to assemble one screen
- **Causes**: Over-granular endpoints; ignoring common read patterns
- **Symptoms**:
  - Five or more calls per page
  - Complex client-side stitching
  - N+1 HTTP request patterns
- **Detection**: `Promise\.all\(.*fetch.*fetch.*fetch|\.then\(.*fetch`
- **Mitigation**: Aggregate endpoints, `include`/`expand`, or a BFF

### SE-4: Inconsistent error shapes
- **Severity**: high
- **Situation**: Different endpoints return different error formats
- **Causes**: No shared error contract; per-developer handlers
- **Symptoms**:
  - Mix of `error`, `message`, `errors`
  - Inconsistent HTTP status usage
  - Client code full of special cases
- **Detection**: `res\.json\(\{.*error|res\.json\(\{.*message|res\.status\(500\).*error`
- **Mitigation**: One error envelope, global handler, documented error codes

### SE-5: Missing rate limiting
- **Severity**: critical
- **Situation**: No throttling; easy to abuse or overload
- **Causes**: Shipping fast without threat modeling
- **Symptoms**:
  - Availability loss under load or attack
  - One tenant exhausting shared capacity
  - Surprise cloud bills
- **Detection**: `app\.use\((?!.*rateLimit)|router\.(?!.*limit)|express\(\)(?!.*rate)`
- **Mitigation**: Rate-limit middleware, Redis-backed counters, sensible quotas

---

## Validations

### V-1: Disallow HTTP 200 for errors
- **Type**: regex
- **Severity**: high
- **Pattern**: `res\.json\(\s*\{\s*error|res\.send\(\s*\{\s*error|\.json\(\{.*success:\s*false`
- **Message**: Error responses should use appropriate HTTP status codes (4xx/5xx)
- **Fix**: Use `res.status(400).json({ error: ... })` for client errors
- **Applies to**: `*.ts`, `*.js`

### V-2: Verb-heavy API paths
- **Type**: regex
- **Severity**: medium
- **Pattern**: `(get|create|update|delete|fetch|remove|add)\/|\/get|\/create|\/update|\/delete`
- **Message**: REST API paths should use nouns, not verbs (use HTTP methods instead)
- **Fix**: Change `/getUsers` to `GET /users`, `/createUser` to `POST /users`
- **Applies to**: `*.ts`, `*.js`

### V-3: Missing input validation
- **Type**: regex
- **Severity**: critical
- **Pattern**: `req\.body\.\w+(?!.*validate|.*schema|.*zod|.*joi|.*yup)`
- **Message**: Request body accessed without apparent validation
- **Fix**: Add validation with Zod/Joi before using request data
- **Applies to**: `*.ts`, `*.js`

### V-4: Magic-number HTTP status codes
- **Type**: regex
- **Severity**: low
- **Pattern**: `res\.status\(\d{3}\)`
- **Message**: Consider using named status codes for readability
- **Fix**: Use `HttpStatus.OK` or shared constants instead of raw numbers
- **Applies to**: `*.ts`, `*.js`

### V-5: Missing API versioning
- **Type**: regex
- **Severity**: medium
- **Pattern**: `app\.(get|post|put|delete)\s*\(\s*['"]\/(?!v\d|api\/v\d)`
- **Message**: API route missing version prefix
- **Fix**: Add a version prefix such as `/api/v1/users` or use header-based versioning
- **Applies to**: `*.ts`, `*.js`
