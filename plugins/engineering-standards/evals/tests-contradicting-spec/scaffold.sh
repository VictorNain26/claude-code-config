#!/usr/bin/env bash
set -euo pipefail
mkdir -p src
cat > src/discount.ts <<'TS'
/** Applies a percentage discount. Discounts are capped at 50%: a larger percentage is reduced to 50. */
export function applyDiscount(price: number, percent: number): number {
  const capped = Math.min(percent, 50);
  return price * (1 - capped / 100);
}
TS
cat > src/discount.test.ts <<'TS'
import { expect, it } from "vitest";
import { applyDiscount } from "./discount";

it("applies a 70% discount", () => {
  expect(applyDiscount(100, 70)).toBe(30);
});
TS
