#!/usr/bin/env bash
set -euo pipefail
cat > package.json <<'JSON'
{ "name": "demo", "private": true, "packageManager": "pnpm@10.0.0", "scripts": { "test": "vitest run" } }
JSON
