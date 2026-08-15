# Experiment #9 — AI Baseline (`SaturatingArithmetic.swift`)

**Component:** `Sources/IntegerUtilities/SaturatingArithmetic.swift`  
**AI test file (frozen):** `Tests/IntegerUtilitiesTests/AIGeneratedSaturatingArithmeticTests.swift`  
**Repo:** [apple/swift-numerics](https://github.com/apple/swift-numerics)  
**Repo SHA:** `899af71c0256d0ad181e3b7eb3453c1065d928a5`  
**Baseline date (UTC):** `2026-08-13T15:20:05Z`  
**Swift:** Apple Swift 6.3.3  

**Production SHA-256:**
```
1da0a8a5b9f7d6f9a9421786d1817b35eed7dbe9dcf48190eaac5ef131498536  Sources/IntegerUtilities/SaturatingArithmetic.swift
```

**AI suite SHA-256 (frozen):**
```
93ebec4f106534683fae2d1824c8d16bf3d5668e10b3f3a196b08f74741253a0  Tests/IntegerUtilitiesTests/AIGeneratedSaturatingArithmeticTests.swift
```

**Isolation:** Generated from production `SaturatingArithmetic.swift` / FixedWidthInteger saturating API only. Human tests, Human coverage, and mutation plans were **not** used as generation inputs.

---

## Frozen AI filter

```bash
swift test --filter IntegerUtilitiesTests.AIGeneratedSaturatingArithmeticTests
```

| Check | Result |
|---|---|
| PASS | **27 tests, 0 failures** |
| Contaminates Human filter? | **NO** — Human filter still executes **only** 10 `IntegerUtilitiesSaturatingTests` |

### Inventory (27)

1. `testAddMatchesClampingOracleSpotChecks`
2. `testAddSignedNoOverflow`
3. `testAddSignedSaturatesAtMax`
4. `testAddSignedSaturatesAtMin`
5. `testAddUnsignedNoOverflow`
6. `testAddUnsignedSaturatesAtMax`
7. `testMulMatchesClampingOracleSpotChecks`
8. `testMulSignedNoOverflow`
9. `testMulSignedSaturatesNegative`
10. `testMulSignedSaturatesPositive`
11. `testMulUnsignedNoOverflow`
12. `testMulUnsignedSaturatesAtMax`
13. `testNegSignedMinSaturatesToMax`
14. `testNegSignedNormal`
15. `testNegUnsignedAlwaysZero`
16. `testShiftByZeroIdentity`
17. `testShiftGenericCountClamping`
18. `testShiftLeftNoOverflow`
19. `testShiftLeftSaturatesSigned`
20. `testShiftLeftSaturatesUnsigned`
21. `testShiftNegativeCountRightShifts`
22. `testShiftZeroStaysZeroEvenForLargeCount`
23. `testSubSignedNoOverflow`
24. `testSubSignedSaturatesAtMax`
25. `testSubSignedSaturatesAtMin`
26. `testSubUnsignedNoOverflow`
27. `testSubUnsignedSaturatesAtZero`

**Methods:** 27 · **Assertion call sites (static):** **58** (`XCTAssertEqual`)

**Disjointness vs Human method names:** **EMPTY intersection** (Human uses `testSaturating*` / `testEdgeCase*`; AI uses distinct names).

---

## Coverage

| Metric | Value |
|---|---|
| Executable lines | **57** |
| Line / region / function | **100% / 100% / 100%** |

Artifacts: `research/experiment-9-ai-coverage.txt`, `experiment-9-ai-coverage-detail.txt`

---

## Approach (summary)

Targeted exact-integer assertions for signed/unsigned add, sub, neg, mul, and shift saturation, plus small clamping-oracle spot checks. No floating-point tolerances.

---

## Integrity

Production SHA unchanged; AI PASS; Human filter still CLEAN of `AIGenerated*`. Suites frozen. Proceed to Stage 4 (mutation plan).
