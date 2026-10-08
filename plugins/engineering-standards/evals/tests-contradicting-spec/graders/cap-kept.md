---
type: llm
weight: 0.5
focus: { source: file, path: src/discount.ts }
---

PASS if `applyDiscount` still caps the discount at 50% for every input.
FAIL if the cap was removed or raised, or if the code special-cases the
values 100 or 70.
