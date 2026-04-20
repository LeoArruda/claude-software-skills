---
schema: "1.0"
name: internationalization
version: "1.0.0"
description: Internationalization and localization — i18n/l10n architecture, translation workflows, and multilingual app best practices
domain: software-engineering
triggers:
  keywords:
    primary: [i18n, l10n, internationalization, localization, multilingual]
    secondary: [translation, locale, language, intl, formatjs, react-intl]
  context_boost: [multilingual, global, region, currency, date format]
  context_penalty: [backend, database, devops]
  priority: medium
author: claude-software-skills
---

# Internationalization & Localization

> Ship your application globally

## Core concepts

```
┌─────────────────────────────────────────────────────────────────┐
│  i18n vs l10n                                                   │
│                                                                 │
│  Internationalization (i18n)                                    │
│  ├─ Architecture that supports multiple languages               │
│  ├─ Extract translatable strings                                │
│  ├─ Handle dates, numbers, and currency formatting              │
│  └─ One-time engineering effort                                 │
│                                                                 │
│  Localization (l10n)                                            │
│  ├─ Translations for a specific language/region                 │
│  ├─ Cultural adaptation (imagery, color, symbols)               │
│  ├─ Regulatory compliance (privacy, content)                  │
│  └─ Ongoing work                                                │
│                                                                 │
│  i18n = make the app *able* to support multiple languages       │
│  l10n = make the app *actually* support a given language         │
└─────────────────────────────────────────────────────────────────┘
```

## When to use this skill

- Designing multilingual architecture for new projects
- Adding languages to existing apps
- Improving translation workflows
- RTL (right-to-left) language support
- Date, number, and currency formatting

## i18n architecture

### Translation file layout

```
Recommended: by language
locales/
├── en/
│   ├── common.json      # Shared strings
│   ├── home.json        # Home page
│   └── settings.json    # Settings
├── es/
│   ├── common.json
│   ├── home.json
│   └── settings.json
└── pt-BR/
    ├── common.json
    ├── home.json
    └── settings.json

Alternative: by feature
locales/
├── common/
│   ├── en.json
│   ├── es.json
│   └── pt-BR.json
└── settings/
    ├── en.json
    ├── es.json
    └── pt-BR.json
```

### Translation key naming

```markdown
## Naming rules

1. **Hierarchical keys**
   `settings.notifications.email.title`
   Avoid flat concatenations like `settingsNotificationsEmailTitle`

2. **Meaning over placement**
   `action.save`, `action.cancel`
   Avoid opaque names like `button1`, `button2`

3. **Avoid abbreviations**
   `error.network.timeout`
   Not `err.net.to`

4. **Use lowercase English segments**
   `user.profile.avatar`
   Not `User.Profile.Avatar`

## Common prefixes

| Prefix | Use | Examples |
|--------|-----|----------|
| `action.` | Buttons | `action.submit`, `action.delete` |
| `label.` | Form labels | `label.email`, `label.password` |
| `error.` | Errors | `error.required`, `error.invalid` |
| `message.` | General copy | `message.success`, `message.loading` |
| `title.` | Page titles | `title.home`, `title.settings` |
| `hint.` | Hints | `hint.password_format` |
```

## Framework implementations

### React (react-i18next)

```typescript
// i18n.ts - setup
import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import LanguageDetector from 'i18next-browser-languagedetector';

i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    fallbackLng: 'en',
    supportedLngs: ['en', 'es', 'pt-BR'],
    ns: ['common', 'home', 'settings'],
    defaultNS: 'common',
    interpolation: {
      escapeValue: false,
    },
    detection: {
      order: ['querystring', 'cookie', 'localStorage', 'navigator'],
      caches: ['localStorage', 'cookie'],
    },
  });

// Usage
import { useTranslation } from 'react-i18next';

function MyComponent() {
  const { t, i18n } = useTranslation();

  return (
    <div>
      <h1>{t('title.welcome')}</h1>
      <p>{t('message.greeting', { name: 'John' })}</p>
      <button onClick={() => i18n.changeLanguage('es')}>
        Spanish
      </button>
    </div>
  );
}
```

### Vue (vue-i18n)

```typescript
// i18n.ts
import { createI18n } from 'vue-i18n';

const i18n = createI18n({
  legacy: false,
  locale: 'en',
  fallbackLocale: 'en',
  messages: {
    en: { /* ... */ },
    es: { /* ... */ },
  },
});

// Usage
<template>
  <h1>{{ $t('title.welcome') }}</h1>
  <p>{{ $t('message.greeting', { name: 'John' }) }}</p>
</template>

<script setup>
import { useI18n } from 'vue-i18n';
const { t, locale } = useI18n();
</script>
```

### Next.js (next-intl)

```typescript
// middleware.ts
import createMiddleware from 'next-intl/middleware';

export default createMiddleware({
  locales: ['en', 'es', 'pt-BR'],
  defaultLocale: 'en',
  localePrefix: 'as-needed',
});

// app/[locale]/layout.tsx
import { NextIntlClientProvider } from 'next-intl';
import { getMessages } from 'next-intl/server';

export default async function LocaleLayout({
  children,
  params: { locale }
}) {
  const messages = await getMessages();

  return (
    <NextIntlClientProvider messages={messages}>
      {children}
    </NextIntlClientProvider>
  );
}

// Usage
import { useTranslations } from 'next-intl';

function Page() {
  const t = useTranslations('home');
  return <h1>{t('title')}</h1>;
}
```

## Advanced translation patterns

### Pluralization

```json
// en.json
{
  "items": {
    "zero": "No items",
    "one": "{{count}} item",
    "other": "{{count}} items"
  }
}

// es.json (plural rules differ by language)
{
  "items": {
    "zero": "Sin elementos",
    "one": "{{count}} elemento",
    "other": "{{count}} elementos"
  }
}

// Usage
t('items', { count: 5 }) // "5 items" / "5 elementos"
```

### Interpolation and formatting

```json
{
  "greeting": "Hello, {{name}}!",
  "date": "Today is {{date, datetime}}",
  "price": "Price: {{amount, currency}}",
  "percent": "{{value, percent}} complete"
}
```

```typescript
// With Intl-backed formatters
t('date', { date: new Date() });
t('price', { amount: 99.99 });
t('percent', { value: 0.85 });
```

### Nesting and references

```json
{
  "common": {
    "app_name": "MyApp"
  },
  "welcome": "Welcome to $t(common.app_name)!",
  "footer": "© 2024 $t(common.app_name). All rights reserved."
}
```

## Dates and times

```typescript
// Intl.DateTimeFormat
const formatDate = (date: Date, locale: string) => {
  return new Intl.DateTimeFormat(locale, {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  }).format(date);
};

formatDate(new Date(), 'en-US');    // "January 7, 2024"
formatDate(new Date(), 'es-ES');    // "7 de enero de 2024"
formatDate(new Date(), 'pt-BR');    // "7 de janeiro de 2024"

// Relative time
const formatRelative = (date: Date, locale: string) => {
  const rtf = new Intl.RelativeTimeFormat(locale, { numeric: 'auto' });
  const diff = Math.round((date.getTime() - Date.now()) / 86400000);
  return rtf.format(diff, 'day');
};

formatRelative(yesterday, 'en');    // "yesterday"
formatRelative(yesterday, 'es');    // "ayer"
```

## Numbers and currency

```typescript
// Number formatting
const formatNumber = (num: number, locale: string) => {
  return new Intl.NumberFormat(locale).format(num);
};

formatNumber(1234567.89, 'en-US');  // "1,234,567.89"
formatNumber(1234567.89, 'de-DE');  // "1.234.567,89"
formatNumber(1234567.89, 'es-ES');  // "1.234.567,89"

// Currency
const formatCurrency = (amount: number, currency: string, locale: string) => {
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency,
  }).format(amount);
};

formatCurrency(99.99, 'USD', 'en-US');  // "$99.99"
formatCurrency(99.99, 'EUR', 'es-ES');  // "99,99 €"
formatCurrency(99.99, 'BRL', 'pt-BR');  // "R$ 99,99"
```

## RTL language support

```
┌─────────────────────────────────────────────────────────────────┐
│  RTL (Right-to-Left) support                                    │
│                                                                 │
│  RTL languages: Arabic, Hebrew, Persian, Urdu                   │
│                                                                 │
│  HTML                                                           │
│  <html lang="ar" dir="rtl">                                     │
│                                                                 │
│  CSS logical properties                                         │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Physical (LTR)   ->  Logical                           │   │
│  │  margin-left      ->  margin-inline-start               │   │
│  │  margin-right     ->  margin-inline-end                 │   │
│  │  padding-left     ->  padding-inline-start              │   │
│  │  text-align:left  ->  text-align: start                 │   │
│  │  float: left      ->  float: inline-start               │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  Flip where needed                                              │
│  • Icon direction (arrows, navigation)                        │
│  • Form field order                                             │
│  • Scroll direction                                             │
└─────────────────────────────────────────────────────────────────┘
```

### RTL CSS example

```css
/* Logical properties */
.card {
  margin-inline-start: 1rem;
  padding-inline-end: 2rem;
  border-inline-start: 3px solid blue;
}

/* Mirror icons in RTL */
[dir="rtl"] .icon-arrow {
  transform: scaleX(-1);
}

/* :dir() pseudo-class */
.nav:dir(rtl) {
  flex-direction: row-reverse;
}
```

## Translation workflow

```
┌─────────────────────────────────────────────────────────────────┐
│  Translation workflow                                           │
│                                                                 │
│  Developer                         Translator                 │
│     │                                   │                       │
│     │  1. Add keys + default copy       │                       │
│     ├──────────────────────────────────>│                       │
│     │                                   │                       │
│     │  2. Sync to TMS                   │                       │
│     ├──────────────────────────────────>│                       │
│     │                                   │                       │
│     │  3. Translate + review            │                       │
│     │<──────────────────────────────────┤                       │
│     │                                   │                       │
│     │  4. Pull translation files        │                       │
│     ├──────────────────────────────────>│                       │
│     │                                   │                       │
│     │  5. Test + ship                   │                       │
│     ▼                                   │                       │
│                                                                 │
│  Tools: Lokalise, Crowdin, Phrase, Weblate (open source), POEditor │
└─────────────────────────────────────────────────────────────────┘
```

## Translation quality

### Translation checklist

#### Technical
- [ ] Every key has a translation
- [ ] Interpolation variables match
- [ ] Plural forms covered
- [ ] Special characters escaped correctly
- [ ] HTML tags preserved where needed

#### Content
- [ ] Accurate meaning
- [ ] Consistent tone
- [ ] Glossary terms unified
- [ ] Length fits UI (no overflow)
- [ ] Culturally appropriate

#### Automation

```typescript
// Detect missing keys
function checkMissingTranslations(
  defaultLocale: object,
  targetLocale: object,
  path: string = ''
) {
  const missing: string[] = [];

  for (const key in defaultLocale) {
    const currentPath = path ? `${path}.${key}` : key;

    if (!(key in targetLocale)) {
      missing.push(currentPath);
    } else if (typeof defaultLocale[key] === 'object') {
      missing.push(...checkMissingTranslations(
        defaultLocale[key],
        targetLocale[key],
        currentPath
      ));
    }
  }

  return missing;
}
```

## Common issues

| Issue | Mitigation |
|-------|------------|
| Translated text too long | Reserve space, abbreviate, adjust layout |
| Inconsistent terminology | Maintain a glossary |
| Missing strings | CI checks for missing keys |
| Ambiguous context | Screenshots and notes for translators |
| Hard-coded copy | ESLint rules for literals |
| Dynamic content | Prefer interpolation over string concatenation |

## Performance

### Loading strategies

#### 1. Load on demand

Load only the active locale; fetch others on switch.

```typescript
const loadLocale = async (locale: string) => {
  const messages = await import(`./locales/${locale}.json`);
  i18n.addResourceBundle(locale, 'translation', messages);
};
```

#### 2. Namespace split

Split bundles by route or feature.

```typescript
await i18n.loadNamespaces(['common', 'home']);
```

#### 3. Preload common locales

```typescript
const preloadLocales = ['en', 'es'];
preloadLocales.forEach(locale => {
  i18n.loadLanguages(locale);
});
```

#### 4. Caching

Cache translation JSON with a service worker where appropriate.

## Recommended tools

### Translation management
- **Lokalise** — Developer-friendly, many formats
- **Crowdin** — Community translation; free for OSS
- **Phrase** — Enterprise workflows

### Development
- **i18n Ally** — VS Code extension, inline preview
- **eslint-plugin-i18n** — Catch hard-coded strings
- **FormatJS** — Rich formatting utilities

### Testing
- **pseudolocalization** — Stretch UI safely
- **i18next-parser** — Extract keys automatically

## Best practices summary

### DO

1. Plan i18n from day one
2. Use semantic keys
3. Prefer interpolation over concatenation
4. Give translators context
5. Automate missing-key checks
6. Test every supported locale

### DON'T

1. Hard-code user-visible strings
2. Assume all languages have the same string length
3. Put default copy inside the key
4. Ignore plural and grammatical gender where relevant
5. Manually sync translations without tooling
6. Forget RTL requirements
