# Experiment #9 — Human Baseline (`SaturatingArithmetic.swift`)

**Component:** `Sources/IntegerUtilities/SaturatingArithmetic.swift`  
**Repo:** [apple/swift-numerics](https://github.com/apple/swift-numerics)  
**Repo SHA:** `899af71c0256d0ad181e3b7eb3453c1065d928a5`  
**Baseline date (UTC):** `2026-08-13T15:17:46Z`  
**Swift:** Apple Swift 6.3.3  

**Production SHA-256:**
```
1da0a8a5b9f7d6f9a9421786d1817b35eed7dbe9dcf48190eaac5ef131498536  Sources/IntegerUtilities/SaturatingArithmetic.swift
```

---

## Frozen human suite + contamination

**Filter:**

```bash
swift test --filter IntegerUtilitiesTests.IntegerUtilitiesSaturatingTests
```

| Check | Result |
|---|---|
| PASS | **10 tests, 0 failures** |
| `AIGenerated*` executed? | **NO — CLEAN** |

### Inventory

1. `testEdgeCaseForNegativeCount`
2. `testSaturatingAddSigned`
3. `testSaturatingAddUnsigned`
4. `testSaturatingMulSigned`
5. `testSaturatingMulUnsigned`
6. `testSaturatingNegSigned`
7. `testSaturatingNegUnsigned`
8. `testSaturatingShifts`
9. `testSaturatingSubSigned`
10. `testSaturatingSubUnsigned`

**Methods:** 10 · **Assertion call sites (static):** **10** (`XCTFail` ×9 + `XCTAssertEqual` ×1)  
(Exhaustive Int8/UInt8 loops; fail via `XCTFail` on first mismatch.)

---

## Coverage

| Metric | Value |
|---|---|
| LOC | **167** |
| Executable lines | **57** |
| Line / region / function | **100% / 100% / 100%** |

Human suite exhaustively exercises add/sub/neg/mul/shift saturation for Int8/UInt8.

---

## Integrity

Production SHA unchanged; Human PASS; contamination CLEAN. Proceed to Stage 3.
