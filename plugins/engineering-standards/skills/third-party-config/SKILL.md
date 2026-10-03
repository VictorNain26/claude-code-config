---
name: third-party-config
user-invocable: false
description: Use when writing or changing a third-party tool's config file — ESLint, TypeScript, Next.js, Vite, Tailwind, Turborepo, Drizzle, GitHub Actions, Renovate, Dependabot, CodeRabbit, Docker, pnpm workspace — or bumping a major version.
paths:
  - "**/eslint.config.*"
  - "**/tsconfig*.json"
  - "**/next.config.*"
  - "**/vite.config.*"
  - "**/tailwind.config.*"
  - "**/app.config.*"
  - "**/turbo.json"
  - "**/drizzle.config.*"
  - ".github/workflows/*.{yml,yaml}"
  - "**/renovate.json"
  - ".github/dependabot.{yml,yaml}"
  - "**/.coderabbit.yaml"
  - "**/Dockerfile"
  - "**/Dockerfile.*"
  - "**/*.Dockerfile"
  - "**/compose*.{yml,yaml}"
  - "**/docker-compose*.{yml,yaml}"
  - "**/pnpm-workspace.yaml"
---

# Third-party config

A config key, its default or its accepted values are never written from
memory. Before writing, read the documentation for the installed version and
cite it — URL and key — in your answer and in the commit message:

1. Context7 MCP, when it is installed;
2. the official documentation;
3. the type definitions of the installed version (`node_modules/**/*.d.ts`);
4. web search, last.

A major version bump follows the same rule: read the migration guide before
touching the config.
