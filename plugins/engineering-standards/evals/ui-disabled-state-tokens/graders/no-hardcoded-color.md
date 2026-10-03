---
type: regex
pattern: '#[0-9a-fA-F]{3,8}\b|rgba?\(|hsla?\('
match: not_contains
target: { source: file, path: src/components/Button.tsx }
---
