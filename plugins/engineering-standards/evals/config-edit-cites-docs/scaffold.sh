#!/usr/bin/env bash
set -euo pipefail
mkdir -p .github/workflows
cat > .github/workflows/ci.yml <<'YAML'
name: ci
on:
  pull_request:
  push:
    branches: [main]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm test
YAML
