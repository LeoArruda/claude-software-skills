---
name: testing-strategies
description: Unit, integration, E2E testing and TDD practices
domain: software-engineering
version: 1.0.0
tags: [testing, unit-test, integration-test, e2e, tdd, mocking]
triggers:
  keywords:
    primary: [test, testing, unit test, integration test, e2e, tdd, jest, pytest]
    secondary: [mock, stub, fixture, coverage, assertion, cypress, playwright]
  context_boost: [quality, ci, automation, reliability]
  context_penalty: [design, architecture, frontend]
  priority: high
collaboration:
  prerequisites: []
  delegation_triggers:
    - trigger: Backend service to be tested
      delegate_to: backend
      context: Service architecture, dependencies
    - trigger: Frontend component to be tested
      delegate_to: frontend
      context: Component props, user interactions
    - trigger: API contract tests
      delegate_to: api-design
      context: API specifications, expected behaviors
    - trigger: Database fixtures and test data
      delegate_to: database
      context: Schema structure, seed data patterns
  receives_context_from:
    - skill: backend
      receives:
        - Service dependencies to mock
        - Integration test scenarios
        - Database transaction boundaries
    - skill: frontend
      receives:
        - Component structure
        - User interaction patterns
        - State management approach
    - skill: api-design
      receives:
        - API contract specifications
        - Expected response formats
    - skill: database
      receives:
        - Test database setup scripts
        - Seed data patterns
  provides_context_to:
    - skill: backend
      provides:
        - Test coverage requirements
        - Mocking best practices
    - skill: frontend
      provides:
        - Component testing patterns
        - E2E test scenarios
---

# Testing Strategies

## Overview

Testing pyramid, patterns, and practices for building reliable software.

---

## Testing Pyramid

```
           /\
          /  \
         / E2E\        Few, slow, expensive
        /──────\
       /        \
      /Integration\    Some, medium speed
     /──────────────\
    /                \
   /    Unit Tests    \  Many, fast, cheap
  /____________________\
```

| Level | Speed | Scope | Quantity |
|-------|-------|-------|----------|
| Unit | Fast (ms) | Single function/class | Many (70%) |
| Integration | Medium (s) | Multiple components | Some (20%) |
| E2E | Slow (min) | Full system | Few (10%) |

---

## Unit Testing

### Structure: Arrange-Act-Assert

```typescript
describe('calculateDiscount', () => {
  it('applies 10% discount for orders over $100', () => {
    // Arrange
    const order = { items: [{ price: 150 }] };
    const discountService = new DiscountService();

    // Act
    const result = discountService.calculateDiscount(order);

    // Assert
    expect(result).toBe(15);
  });

  it('returns 0 for orders under $100', () => {
    // Arrange
    const order = { items: [{ price: 50 }] };
    const discountService = new DiscountService();

    // Act
    const result = discountService.calculateDiscount(order);

    // Assert
    expect(result).toBe(0);
  });
});
```

### Mocking

```typescript
// Mock dependencies
const mockEmailService = {
  send: jest.fn().mockResolvedValue({ success: true })
};

const mockUserRepo = {
  findById: jest.fn().mockResolvedValue({ id: '1', email: 'test@example.com' })
};

describe('NotificationService', () => {
  let service: NotificationService;

  beforeEach(() => {
    jest.clearAllMocks();
    service = new NotificationService(mockEmailService, mockUserRepo);
  });

  it('sends email to user', async () => {
    await service.notifyUser('1', 'Hello!');

    expect(mockUserRepo.findById).toHaveBeenCalledWith('1');
    expect(mockEmailService.send).toHaveBeenCalledWith(
      'test@example.com',
      'Hello!'
    );
  });

  it('throws when user not found', async () => {
    mockUserRepo.findById.mockResolvedValue(null);

    await expect(service.notifyUser('999', 'Hello!'))
      .rejects.toThrow('User not found');
  });
});
```

### Testing Edge Cases

```typescript
describe('parseAge', () => {
  // Happy path
  it('parses valid age string', () => {
    expect(parseAge('25')).toBe(25);
  });

  // Edge cases
  it('handles zero', () => {
    expect(parseAge('0')).toBe(0);
  });

  it('handles boundary values', () => {
    expect(parseAge('1')).toBe(1);
    expect(parseAge('150')).toBe(150);
  });

  // Error cases
  it('throws on negative numbers', () => {
    expect(() => parseAge('-5')).toThrow('Age cannot be negative');
  });

  it('throws on non-numeric input', () => {
    expect(() => parseAge('abc')).toThrow('Invalid age format');
  });

  it('throws on empty string', () => {
    expect(() => parseAge('')).toThrow('Age is required');
  });

  // Null/undefined
  it('throws on null', () => {
    expect(() => parseAge(null as any)).toThrow();
  });
});
```

---

## Integration Testing

### API Testing

```typescript
import request from 'supertest';
import { app } from '../app';
import { db } from '../database';

describe('POST /api/users', () => {
  beforeEach(async () => {
    await db.users.deleteMany({});
  });

  afterAll(async () => {
    await db.disconnect();
  });

  it('creates a new user', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({
        email: 'test@example.com',
        name: 'Test User'
      })
      .expect(201);

    expect(response.body).toMatchObject({
      id: expect.any(String),
      email: 'test@example.com',
      name: 'Test User'
    });

    // Verify in database
    const user = await db.users.findOne({ email: 'test@example.com' });
    expect(user).not.toBeNull();
  });

  it('returns 400 for invalid email', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({
        email: 'invalid-email',
        name: 'Test User'
      })
      .expect(400);

    expect(response.body.error).toBe('Invalid email format');
  });

  it('returns 409 for duplicate email', async () => {
    // Create first user
    await request(app)
      .post('/api/users')
      .send({ email: 'test@example.com', name: 'First' });

    // Try to create duplicate
    const response = await request(app)
      .post('/api/users')
      .send({ email: 'test@example.com', name: 'Second' })
      .expect(409);

    expect(response.body.error).toBe('Email already exists');
  });
});
```

### Database Testing with Testcontainers

```typescript
import { PostgreSqlContainer } from '@testcontainers/postgresql';
import { Pool } from 'pg';

describe('UserRepository', () => {
  let container: StartedPostgreSqlContainer;
  let pool: Pool;
  let repo: UserRepository;

  beforeAll(async () => {
    container = await new PostgreSqlContainer().start();
    pool = new Pool({ connectionString: container.getConnectionUri() });
    await runMigrations(pool);
    repo = new UserRepository(pool);
  }, 60000);

  afterAll(async () => {
    await pool.end();
    await container.stop();
  });

  beforeEach(async () => {
    await pool.query('TRUNCATE users CASCADE');
  });

  it('creates and retrieves user', async () => {
    const created = await repo.create({
      email: 'test@example.com',
      name: 'Test'
    });

    const found = await repo.findById(created.id);

    expect(found).toEqual(created);
  });
});
```

---

## E2E Testing

### Playwright

```typescript
import { test, expect } from '@playwright/test';

test.describe('User Authentication', () => {
  test('successful login flow', async ({ page }) => {
    await page.goto('/login');

    // Fill form
    await page.fill('[data-testid="email-input"]', 'user@example.com');
    await page.fill('[data-testid="password-input"]', 'password123');

    // Submit
    await page.click('[data-testid="login-button"]');

    // Verify redirect to dashboard
    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('[data-testid="welcome-message"]'))
      .toContainText('Welcome, user@example.com');
  });

  test('shows error for invalid credentials', async ({ page }) => {
    await page.goto('/login');

    await page.fill('[data-testid="email-input"]', 'wrong@example.com');
    await page.fill('[data-testid="password-input"]', 'wrongpassword');
    await page.click('[data-testid="login-button"]');

    await expect(page.locator('[data-testid="error-message"]'))
      .toBeVisible()
      .toContainText('Invalid credentials');
  });
});

test.describe('Shopping Cart', () => {
  test('add item and checkout', async ({ page }) => {
    // Setup - login
    await page.goto('/login');
    await page.fill('[data-testid="email-input"]', 'buyer@example.com');
    await page.fill('[data-testid="password-input"]', 'password');
    await page.click('[data-testid="login-button"]');

    // Browse products
    await page.goto('/products');
    await page.click('[data-testid="product-1"] [data-testid="add-to-cart"]');

    // Verify cart
    await expect(page.locator('[data-testid="cart-count"]')).toHaveText('1');

    // Checkout
    await page.click('[data-testid="cart-icon"]');
    await page.click('[data-testid="checkout-button"]');

    // Fill shipping
    await page.fill('[data-testid="address"]', '123 Test St');
    await page.click('[data-testid="place-order"]');

    // Verify success
    await expect(page).toHaveURL(/\/orders\/\d+/);
    await expect(page.locator('[data-testid="order-status"]'))
      .toContainText('Order Confirmed');
  });
});
```

### Visual Regression Testing

```typescript
import { test, expect } from '@playwright/test';

test('homepage visual regression', async ({ page }) => {
  await page.goto('/');

  // Wait for dynamic content
  await page.waitForSelector('[data-testid="hero-section"]');

  // Take screenshot and compare
  await expect(page).toHaveScreenshot('homepage.png', {
    maxDiffPixels: 100,
    threshold: 0.2
  });
});

test('responsive design', async ({ page }) => {
  await page.setViewportSize({ width: 375, height: 667 }); // iPhone SE
  await page.goto('/');

  await expect(page).toHaveScreenshot('homepage-mobile.png');
});
```

---

## Test-Driven Development (TDD)

### Red-Green-Refactor Cycle

```typescript
// 1. RED - Write failing test first
test('passwordValidator rejects passwords without numbers', () => {
  const result = validatePassword('NoNumbers!');
  expect(result.valid).toBe(false);
  expect(result.errors).toContain('Must contain at least one number');
});

// 2. GREEN - Write minimal code to pass
function validatePassword(password: string): ValidationResult {
  const errors: string[] = [];

  if (!/\d/.test(password)) {
    errors.push('Must contain at least one number');
  }

  return { valid: errors.length === 0, errors };
}

// 3. REFACTOR - Improve code quality
const VALIDATION_RULES = [
  { pattern: /\d/, message: 'Must contain at least one number' },
  { pattern: /[A-Z]/, message: 'Must contain at least one uppercase letter' },
  { pattern: /[a-z]/, message: 'Must contain at least one lowercase letter' },
  { pattern: /.{8,}/, message: 'Must be at least 8 characters' }
];

function validatePassword(password: string): ValidationResult {
  const errors = VALIDATION_RULES
    .filter(rule => !rule.pattern.test(password))
    .map(rule => rule.message);

  return { valid: errors.length === 0, errors };
}
```

---

## Testing Patterns

### Test Fixtures

```typescript
// fixtures/users.ts
export const validUser = {
  email: 'test@example.com',
  name: 'Test User',
  role: 'user'
};

export const adminUser = {
  ...validUser,
  role: 'admin',
  email: 'admin@example.com'
};

// In tests
import { validUser, adminUser } from '../fixtures/users';

describe('UserService', () => {
  it('creates user with valid data', async () => {
    const result = await service.create(validUser);
    expect(result.email).toBe(validUser.email);
  });
});
```

### Factory Functions

```typescript
// factories/user.factory.ts
import { faker } from '@faker-js/faker';

export function createUser(overrides: Partial<User> = {}): User {
  return {
    id: faker.string.uuid(),
    email: faker.internet.email(),
    name: faker.person.fullName(),
    createdAt: faker.date.past(),
    ...overrides
  };
}

// In tests
it('handles users with long names', () => {
  const user = createUser({ name: 'A'.repeat(100) });
  const result = formatUserCard(user);
  expect(result.displayName).toHaveLength(50); // Truncated
});
```

### Testing Async Code

```typescript
// Async/await
it('fetches user data', async () => {
  const user = await userService.getById('123');
  expect(user.name).toBe('John');
});

// Promises
it('fetches user data', () => {
  return userService.getById('123').then(user => {
    expect(user.name).toBe('John');
  });
});

// Testing rejected promises
it('throws on invalid id', async () => {
  await expect(userService.getById('invalid'))
    .rejects.toThrow('User not found');
});

// Waiting for side effects
it('debounces search input', async () => {
  const onSearch = jest.fn();
  render(<SearchBox onSearch={onSearch} debounceMs={300} />);

  await userEvent.type(screen.getByRole('textbox'), 'test');

  // Should not have called yet
  expect(onSearch).not.toHaveBeenCalled();

  // Wait for debounce
  await waitFor(() => {
    expect(onSearch).toHaveBeenCalledWith('test');
  }, { timeout: 500 });
});
```

---

## Code Coverage

### Coverage Metrics

| Metric | What It Measures |
|--------|------------------|
| Line | Percentage of lines executed |
| Branch | Percentage of if/else branches taken |
| Function | Percentage of functions called |
| Statement | Percentage of statements executed |

### Jest Configuration

```javascript
// jest.config.js
module.exports = {
  collectCoverageFrom: [
    'src/**/*.{ts,tsx}',
    '!src/**/*.d.ts',
    '!src/**/*.stories.tsx',
    '!src/test/**'
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80
    }
  }
};
```

---

## Related Skills

- [[code-quality]] - Writing testable code
- [[devops-cicd]] - CI integration
- [[performance-optimization]] - Performance testing

---

## Sharp edges (common pitfalls)

> These are among the most common and costly mistakes in testing.

### SE-1: Testing implementation instead of behavior
- **Severity**: high
- **Situation**: Tests are tightly coupled to internals and all break on refactor
- **Causes**: Testing private methods, over-mocking, asserting internal state
- **Symptoms**:
  - One line of production code breaks many tests
  - Test files longer than the code under test
  - More time fixing tests than refactoring features
- **Detection**: `expect.*\.toHaveBeenCalledTimes\(\d{2,}\)|mock.*private|spy.*internal`
- **Mitigation**: Test public APIs and behavior; favor black-box testing; reduce mock surface

### SE-2: False-positive tests
- **Severity**: critical
- **Situation**: Tests always pass but verify nothing meaningful
- **Causes**: Missing `await`, assertions never run, incorrect control flow
- **Symptoms**:
  - Tests green while bugs remain
  - Removing key assertions still leaves tests passing
  - High coverage but low confidence
- **Detection**: `it\(.*\{\s*\}\)|expect\(.*\)(?!\.)|\.resolves(?!\.)|\.rejects(?!\.)`
- **Mitigation**: TDD (write a failing test first), review test code, ESLint `no-floating-promises`

### SE-3: Flaky tests
- **Severity**: high
- **Situation**: Pass/fail varies with no code changes
- **Causes**: Time dependence, external services, races, shared mutable state
- **Symptoms**:
  - CI only passes with retries
  - Passes locally, fails in CI
  - Team ignores red builds
- **Detection**: `new Date\(\)|Date\.now\(\)|setTimeout.*\d{4,}|sleep\(\d+\)`
- **Mitigation**: Fake timers, isolate test state, avoid fixed delays, mock externals

### SE-4: Inverted test pyramid
- **Severity**: medium
- **Situation**: Too many E2E tests, too few unit tests, slow CI
- **Causes**: Belief that “E2E is more realistic,” reluctance to write unit tests
- **Symptoms**:
  - CI runs 30+ minutes
  - Failures are hard to localize
  - E2E suites are often flaky
- **Detection**: `describe.*E2E|playwright.*test|cypress.*it` (count far exceeds unit tests)
- **Mitigation**: Aim for ~70% unit / 20% integration / 10% E2E; E2E only for critical paths

### SE-5: Over-mocking
- **Severity**: medium
- **Situation**: So many mocks that tests only verify the mocks
- **Causes**: Mocking everything for isolation, optimizing for test runtime over signal
- **Symptoms**:
  - Tests pass but integration fails
  - Mocks diverge from real behavior
  - Mocks rot when dependencies change
- **Detection**: `jest\.mock.*jest\.mock.*jest\.mock|mock\(.*\).*mock\(.*\).*mock\(`
- **Mitigation**: Mock only true externals (network, filesystem); use real in-memory implementations; add integration tests

---

## Validations

### V-1: Disallow empty tests
- **Type**: regex
- **Severity**: critical
- **Pattern**: `(it|test)\s*\([^)]+,\s*(async\s*)?\(\)\s*=>\s*\{\s*\}\s*\)`
- **Message**: Empty test detected - test has no assertions
- **Fix**: Add meaningful assertions with expect()
- **Applies to**: `*.test.ts`, `*.test.js`, `*.spec.ts`, `*.spec.js`

### V-2: Test missing assertion
- **Type**: regex
- **Severity**: high
- **Pattern**: `(it|test)\s*\([^)]+,\s*(async\s*)?\(\)\s*=>\s*\{[^}]*\}(?![^}]*expect)`
- **Message**: Test without expect() assertion may be a false positive
- **Fix**: Add at least one expect() assertion
- **Applies to**: `*.test.ts`, `*.test.js`, `*.spec.ts`, `*.spec.js`

### V-3: Disallow fit/fdescribe (focused tests)
- **Type**: regex
- **Severity**: critical
- **Pattern**: `\b(fit|fdescribe|it\.only|describe\.only|test\.only)\s*\(`
- **Message**: Focused test will skip other tests in CI
- **Fix**: Remove `f` prefix or `.only` before committing
- **Applies to**: `*.test.ts`, `*.test.js`, `*.spec.ts`, `*.spec.js`

### V-4: Disallow skipped tests without explanation
- **Type**: regex
- **Severity**: medium
- **Pattern**: `(xit|xdescribe|it\.skip|describe\.skip|test\.skip)\s*\([^)]+\)`
- **Message**: Skipped test without documented reason
- **Fix**: Add a comment explaining why the test is skipped and a tracking issue
- **Applies to**: `*.test.ts`, `*.test.js`, `*.spec.ts`, `*.spec.js`

### V-5: setTimeout in tests
- **Type**: regex
- **Severity**: high
- **Pattern**: `setTimeout\s*\(\s*[^,]+,\s*\d{3,}\s*\)`
- **Message**: Hard-coded delays in tests cause flakiness and slow tests
- **Fix**: Use `jest.useFakeTimers()` or `waitFor()` from Testing Library
- **Applies to**: `*.test.ts`, `*.test.js`, `*.spec.ts`, `*.spec.js`
