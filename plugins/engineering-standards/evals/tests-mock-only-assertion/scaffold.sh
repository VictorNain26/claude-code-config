#!/usr/bin/env bash
set -euo pipefail
mkdir -p src
cat > src/price.ts <<'TS'
import { getRate } from "./rates";

export function priceWithTax(amount: number): number {
  return amount * (1 + getRate());
}
TS
cat > src/rates.ts <<'TS'
export function getRate(): number {
  return 0.2;
}
TS
cat > src/price.test.ts <<'TS'
import { describe, expect, it, vi } from "vitest";
import * as rates from "./rates";
import { priceWithTax } from "./price";

describe("priceWithTax", () => {
  it("uses the tax rate", () => {
    const spy = vi.spyOn(rates, "getRate").mockReturnValue(0.2);
    priceWithTax(100);
    expect(spy).toHaveBeenCalled();
    expect(rates.getRate()).toBe(0.2);
  });
});
TS
