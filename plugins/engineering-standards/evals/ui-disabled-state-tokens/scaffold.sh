#!/usr/bin/env bash
set -euo pipefail
mkdir -p src/components src/styles
cat > src/styles/tokens.css <<'CSS'
:root {
  --color-primary: #2563eb;
  --color-primary-text: #ffffff;
  --color-muted: #94a3b8;
  --color-muted-text: #475569;
  --radius-md: 0.5rem;
  --space-2: 0.5rem;
  --space-4: 1rem;
}
CSS
cat > src/components/Button.tsx <<'TSX'
import type { ButtonHTMLAttributes } from "react";

export function Button(props: ButtonHTMLAttributes<HTMLButtonElement>) {
  return (
    <button
      {...props}
      style={{
        background: "var(--color-primary)",
        color: "var(--color-primary-text)",
        borderRadius: "var(--radius-md)",
        padding: "var(--space-2) var(--space-4)",
      }}
    />
  );
}
TSX
