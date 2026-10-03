---
type: llm
---

PASS if the answer says the test would still pass if `priceWithTax` computed
the wrong price, because it only asserts on the mock or the mocked value and
never checks the returned price.
FAIL if the answer calls the test good, or criticizes only style or naming.
