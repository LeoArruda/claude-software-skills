---
name: frontend
description: Modern frontend development with React, Vue, and web technologies
domain: development-stacks
version: 1.1.0
tags: [react, vue, nextjs, typescript, css, state-management, bundlers]
triggers:
  keywords:
    primary: [frontend, react, vue, nextjs, ui, web, component]
    secondary: [css, tailwind, state, hooks, spa, pwa, vite]
  context_boost: [typescript, javascript, html, browser, client]
  context_penalty: [backend, server, database, api]
  priority: high
collaboration:
  prerequisites:
    - skill: typescript
      reason: Type-safe component development
  delegation_triggers:
    - trigger: API integration or backend communication
      delegate_to: backend
      context: API endpoints, authentication flow
    - trigger: API response format questions
      delegate_to: api-design
      context: Expected data structures, error handling
    - trigger: Component or integration testing
      delegate_to: testing-strategies
      context: Testing library patterns, mocking APIs
  receives_context_from:
    - skill: backend
      receives:
        - API endpoints list
        - Authentication flow
        - WebSocket events
    - skill: api-design
      receives:
        - API documentation
        - Error response formats
        - Pagination patterns
  provides_context_to:
    - skill: testing-strategies
      provides:
        - Component structure
        - User interaction patterns
        - State management approach
    - skill: backend
      provides:
        - Required API endpoints
        - Expected response formats
---

# Frontend Development

## Overview

Modern frontend development patterns, frameworks, and best practices for building performant web applications.

---

## React Ecosystem

### Component Patterns

```tsx
// Functional component with hooks
import { useState, useEffect, useCallback, useMemo } from 'react';

interface UserListProps {
  initialFilter?: string;
  onSelect: (user: User) => void;
}

function UserList({ initialFilter = '', onSelect }: UserListProps) {
  const [users, setUsers] = useState<User[]>([]);
  const [filter, setFilter] = useState(initialFilter);
  const [loading, setLoading] = useState(true);

  // Memoized filtered list
  const filteredUsers = useMemo(
    () => users.filter(u => u.name.toLowerCase().includes(filter.toLowerCase())),
    [users, filter]
  );

  // Stable callback reference
  const handleSelect = useCallback((user: User) => {
    onSelect(user);
  }, [onSelect]);

  useEffect(() => {
    async function fetchUsers() {
      setLoading(true);
      const data = await api.getUsers();
      setUsers(data);
      setLoading(false);
    }
    fetchUsers();
  }, []);

  if (loading) return <Skeleton count={5} />;

  return (
    <div>
      <SearchInput value={filter} onChange={setFilter} />
      {filteredUsers.map(user => (
        <UserCard
          key={user.id}
          user={user}
          onClick={() => handleSelect(user)}
        />
      ))}
    </div>
  );
}
```

### Custom Hooks

```tsx
// Data fetching hook
function useFetch<T>(url: string) {
  const [data, setData] = useState<T | null>(null);
  const [error, setError] = useState<Error | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const controller = new AbortController();

    async function fetchData() {
      try {
        setLoading(true);
        const response = await fetch(url, { signal: controller.signal });
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        const json = await response.json();
        setData(json);
        setError(null);
      } catch (err) {
        if (err instanceof Error && err.name !== 'AbortError') {
          setError(err);
        }
      } finally {
        setLoading(false);
      }
    }

    fetchData();
    return () => controller.abort();
  }, [url]);

  return { data, error, loading };
}

// Local storage hook
function useLocalStorage<T>(key: string, initialValue: T) {
  const [storedValue, setStoredValue] = useState<T>(() => {
    try {
      const item = window.localStorage.getItem(key);
      return item ? JSON.parse(item) : initialValue;
    } catch {
      return initialValue;
    }
  });

  const setValue = useCallback((value: T | ((val: T) => T)) => {
    const valueToStore = value instanceof Function ? value(storedValue) : value;
    setStoredValue(valueToStore);
    window.localStorage.setItem(key, JSON.stringify(valueToStore));
  }, [key, storedValue]);

  return [storedValue, setValue] as const;
}

// Debounce hook
function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState(value);

  useEffect(() => {
    const timer = setTimeout(() => setDebouncedValue(value), delay);
    return () => clearTimeout(timer);
  }, [value, delay]);

  return debouncedValue;
}
```

### State Management

```tsx
// Zustand - simple global state
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface CartStore {
  items: CartItem[];
  addItem: (item: CartItem) => void;
  removeItem: (id: string) => void;
  clearCart: () => void;
  total: () => number;
}

const useCartStore = create<CartStore>()(
  persist(
    (set, get) => ({
      items: [],
      addItem: (item) => set((state) => ({
        items: [...state.items, item]
      })),
      removeItem: (id) => set((state) => ({
        items: state.items.filter(i => i.id !== id)
      })),
      clearCart: () => set({ items: [] }),
      total: () => get().items.reduce((sum, item) => sum + item.price, 0)
    }),
    { name: 'cart-storage' }
  )
);

// React Query / TanStack Query
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';

function useUsers() {
  return useQuery({
    queryKey: ['users'],
    queryFn: () => api.getUsers(),
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
}

function useCreateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (newUser: CreateUserInput) => api.createUser(newUser),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
    },
  });
}
```

---

## Next.js / App Router

### Server Components

```tsx
// app/users/page.tsx - Server Component (default)
async function UsersPage() {
  // Direct database access in server component
  const users = await db.user.findMany();

  return (
    <div>
      <h1>Users</h1>
      <UserList users={users} />
    </div>
  );
}

// Client component for interactivity
'use client';

import { useState } from 'react';

function UserList({ users }: { users: User[] }) {
  const [selected, setSelected] = useState<string | null>(null);

  return (
    <ul>
      {users.map(user => (
        <li
          key={user.id}
          onClick={() => setSelected(user.id)}
          className={selected === user.id ? 'selected' : ''}
        >
          {user.name}
        </li>
      ))}
    </ul>
  );
}
```

### Server Actions

```tsx
// app/actions.ts
'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';

export async function createUser(formData: FormData) {
  const name = formData.get('name') as string;
  const email = formData.get('email') as string;

  await db.user.create({
    data: { name, email }
  });

  revalidatePath('/users');
  redirect('/users');
}

// Usage in component
function CreateUserForm() {
  return (
    <form action={createUser}>
      <input name="name" required />
      <input name="email" type="email" required />
      <button type="submit">Create</button>
    </form>
  );
}
```

### Route Handlers

```tsx
// app/api/users/route.ts
import { NextRequest, NextResponse } from 'next/server';

export async function GET(request: NextRequest) {
  const searchParams = request.nextUrl.searchParams;
  const limit = parseInt(searchParams.get('limit') || '10');

  const users = await db.user.findMany({ take: limit });
  return NextResponse.json(users);
}

export async function POST(request: NextRequest) {
  const body = await request.json();

  const user = await db.user.create({ data: body });
  return NextResponse.json(user, { status: 201 });
}
```

---

## CSS & Styling

### Tailwind CSS

```tsx
// Component with Tailwind
function Card({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div className="rounded-lg border border-gray-200 bg-white p-6 shadow-sm
                    hover:shadow-md transition-shadow duration-200
                    dark:bg-gray-800 dark:border-gray-700">
      <h2 className="text-xl font-semibold text-gray-900 dark:text-white mb-4">
        {title}
      </h2>
      <div className="text-gray-600 dark:text-gray-300">
        {children}
      </div>
    </div>
  );
}

// With clsx/cn for conditional classes
import { clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

function Button({
  variant = 'primary',
  size = 'md',
  className,
  ...props
}: ButtonProps) {
  return (
    <button
      className={cn(
        'inline-flex items-center justify-center rounded-md font-medium',
        'focus:outline-none focus:ring-2 focus:ring-offset-2',
        {
          'bg-blue-600 text-white hover:bg-blue-700': variant === 'primary',
          'bg-gray-200 text-gray-900 hover:bg-gray-300': variant === 'secondary',
          'px-3 py-1.5 text-sm': size === 'sm',
          'px-4 py-2 text-base': size === 'md',
          'px-6 py-3 text-lg': size === 'lg',
        },
        className
      )}
      {...props}
    />
  );
}
```

### CSS Modules

```tsx
// Button.module.css
.button {
  padding: 0.5rem 1rem;
  border-radius: 0.375rem;
  font-weight: 500;
}

.primary {
  background-color: var(--color-primary);
  color: white;
}

.secondary {
  background-color: var(--color-gray-200);
  color: var(--color-gray-900);
}

// Button.tsx
import styles from './Button.module.css';

function Button({ variant = 'primary', children }) {
  return (
    <button className={`${styles.button} ${styles[variant]}`}>
      {children}
    </button>
  );
}
```

---

## Performance Optimization

### Code Splitting

```tsx
// Dynamic imports
import dynamic from 'next/dynamic';

const HeavyChart = dynamic(() => import('./HeavyChart'), {
  loading: () => <ChartSkeleton />,
  ssr: false, // Client-only component
});

// React.lazy with Suspense
const Dashboard = lazy(() => import('./Dashboard'));

function App() {
  return (
    <Suspense fallback={<Loading />}>
      <Dashboard />
    </Suspense>
  );
}
```

### Virtualization

```tsx
import { useVirtualizer } from '@tanstack/react-virtual';

function VirtualList({ items }: { items: Item[] }) {
  const parentRef = useRef<HTMLDivElement>(null);

  const virtualizer = useVirtualizer({
    count: items.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 50,
  });

  return (
    <div ref={parentRef} className="h-[400px] overflow-auto">
      <div
        style={{
          height: `${virtualizer.getTotalSize()}px`,
          position: 'relative',
        }}
      >
        {virtualizer.getVirtualItems().map((virtualItem) => (
          <div
            key={virtualItem.key}
            style={{
              position: 'absolute',
              top: 0,
              transform: `translateY(${virtualItem.start}px)`,
              height: `${virtualItem.size}px`,
            }}
          >
            {items[virtualItem.index].name}
          </div>
        ))}
      </div>
    </div>
  );
}
```

### Image Optimization

```tsx
import Image from 'next/image';

function ProductImage({ src, alt }: { src: string; alt: string }) {
  return (
    <Image
      src={src}
      alt={alt}
      width={400}
      height={300}
      placeholder="blur"
      blurDataURL="data:image/jpeg;base64,/9j/4AAQ..."
      sizes="(max-width: 768px) 100vw, 400px"
      priority={false}
    />
  );
}
```

---

## Testing

### Component Testing

```tsx
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';

describe('LoginForm', () => {
  it('submits with valid credentials', async () => {
    const onSubmit = vi.fn();
    render(<LoginForm onSubmit={onSubmit} />);

    await userEvent.type(screen.getByLabelText(/email/i), 'test@example.com');
    await userEvent.type(screen.getByLabelText(/password/i), 'password123');
    await userEvent.click(screen.getByRole('button', { name: /sign in/i }));

    await waitFor(() => {
      expect(onSubmit).toHaveBeenCalledWith({
        email: 'test@example.com',
        password: 'password123',
      });
    });
  });

  it('shows validation errors', async () => {
    render(<LoginForm onSubmit={vi.fn()} />);

    await userEvent.click(screen.getByRole('button', { name: /sign in/i }));

    expect(await screen.findByText(/email is required/i)).toBeInTheDocument();
  });
});
```

---

## Related Skills

- [[testing-strategies]] - Frontend testing
- [[performance-optimization]] - Web performance
- [[ux-principles]] - User experience

---

## Sharp edges (common pitfalls)

> High-impact mistakes in frontend development

### SE-1: useEffect infinite loop
- **Severity**: critical
- **Situation**: Effect updates state that is also a dependency, causing a render loop
- **Why**: Misunderstanding dependency rules; objects/arrays as deps
- **Symptoms**:
  - UI freezes or becomes very slow
  - Browser memory grows
  - Network tab shows repeated requests
- **Detect**: `useEffect.*setState.*\].*\{|useEffect\(\(\).*fetch.*\[\]`
- **Fix**: Correct dependency lists; useCallback/useMemo; useRef for stable values

### SE-2: Memory leaks
- **Severity**: high
- **Situation**: After unmount, subscriptions, timers, or async work still update state
- **Why**: Missing cleanup; fetches not aborted
- **Symptoms**:
  - “Can't perform state update on unmounted component”
  - App slows over time
  - Stale UI flashes after navigation
- **Detect**: `useEffect.*setInterval(?!.*return)|useEffect.*addEventListener(?!.*return.*remove)|useEffect.*subscribe(?!.*return)`
- **Fix**: Return cleanup from useEffect; AbortController for fetch

### SE-3: Props drilling
- **Severity**: medium
- **Situation**: Deep trees pass props through layers that do not use them
- **Why**: No context or state store; poor component boundaries
- **Symptoms**:
  - Changing one prop touches many files
  - Middle components only forward props
  - Hard to trace data flow
- **Detect**: `props\.\w+.*props\.\w+.*props\.\w+|{.*,.*,.*,.*,.*,.*}.*=>`
- **Fix**: Context, Zustand/Redux, or composition

### SE-4: Premature optimization
- **Severity**: medium
- **Situation**: Heavy useMemo/useCallback/React.memo without measured need
- **Why**: Misunderstanding what these APIs buy you
- **Symptoms**:
  - Lots of memoization with no real win
  - Extra allocations/comparisons slow things down
  - Harder to read code
- **Detect**: `useMemo\(\(\).*return.*\d+|useCallback\(\(\).*console|React\.memo\(.*\)(?!.*areEqual)`
- **Fix**: Measure first; optimize hot paths only

### SE-5: Unsafe HTML rendering
- **Severity**: critical
- **Situation**: Raw HTML from users or unsanitized rich text
- **Why**: Rich text needs; ignoring XSS
- **Symptoms**:
  - XSS
  - Injected scripts
  - Phishing or data theft
- **Detect**: `dangerouslySetInnerHTML|innerHTML.*=.*user|v-html.*user`
- **Fix**: Sanitize with a trusted library; safe Markdown renderers; never trust raw user HTML

---

## Validations

### V-1: useEffect missing cleanup
- **Type**: regex
- **Severity**: high
- **Pattern**: `useEffect\s*\([^)]*=>\s*\{[^}]*(setInterval|addEventListener|subscribe)[^}]*\}(?![^}]*return)`
- **Message**: useEffect with subscription/timer missing cleanup function
- **Fix**: Add cleanup: `return () => clearInterval(id)` or `return () => unsubscribe()`
- **Applies to**: `*.tsx`, `*.jsx`

### V-2: Raw inner HTML props
- **Type**: regex
- **Severity**: critical
- **Pattern**: `dangerouslySetInnerHTML`
- **Message**: Setting raw HTML from strings is an XSS risk
- **Fix**: Pipe through an HTML sanitizer before assigning to inner HTML props
- **Applies to**: `*.tsx`, `*.jsx`

### V-3: Empty dependency array with state updates
- **Type**: regex
- **Severity**: high
- **Pattern**: `useEffect\s*\([^)]*=>\s*\{[^}]*set\w+\([^}]*\},\s*\[\s*\]\s*\)`
- **Message**: useEffect with empty deps but updates state - possible stale closure
- **Fix**: Add necessary dependencies or use useRef for values that should not retrigger the effect
- **Applies to**: `*.tsx`, `*.jsx`

### V-4: Inline style object literals
- **Type**: regex
- **Severity**: medium
- **Pattern**: `style=\{\s*\{[^}]+\}\s*\}`
- **Message**: Inline style object creates new reference on every render
- **Fix**: Hoist or memoize: `const styles = useMemo(() => ({...}), [])`
- **Applies to**: `*.tsx`, `*.jsx`

### V-5: Array index as key
- **Type**: regex
- **Severity**: medium
- **Pattern**: `key=\{(index|i|idx)\}`
- **Message**: Using array index as key can break on reorder
- **Fix**: Use stable ids: `key={item.id}` or `key={item.uniqueField}`
- **Applies to**: `*.tsx`, `*.jsx`

