# Experiment #9 Candidate Selection

**Repository:** [apple/swift-numerics](https://github.com/apple/swift-numerics)  
**Pinned SHA:** `899af71c0256d0ad181e3b7eb3453c1065d928a5`  
**Date (UTC):** `2026-08-13T15:15:00Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**Diversity note:** Experiments #1–#8 covered serialization/reflection, collections, algorithms, and parsing. Experiment #9 targets a **numerical/computational** defect domain (integer saturating arithmetic — deterministic, no FP tolerance ambiguity).

**This document only selects the component.** No AI tests, no mutations, no production/test edits.

---

## 1. Setup reminder

```bash
cd /Users/premalmistry/Desktop/Projects/AppPerformanceAnalyzer/swift-numerics
git rev-parse HEAD   # 899af71c0256d0ad181e3b7eb3453c1065d928a5

swift test --filter IntegerUtilitiesTests.IntegerUtilitiesSaturatingTests  # 10 PASS
```

---

## 2. Candidates evaluated

| Component | Target file(s) | LOC | Human tests | Logic type | Mutation potential | Difficulty |
|---|---|---:|---|---|---|---|
| **Saturating arithmetic** | `Sources/IntegerUtilities/SaturatingArithmetic.swift` | **167** | **`IntegerUtilitiesSaturatingTests`**: **10** methods (~192 LOC) | Add/sub/neg/mul/shift with saturation clamps | **High** — overflow polarity, `max &- signbit`, unsigned vs signed clamps, shift bounds; **~22–26** | **Low** — ~0.2s; exact integer equality |
| **Divide with rounding** | `…/DivideWithRounding.swift` | **325** | **`IntegerUtilitiesDivideTests`**: many rounding modes | Integer divide + RoundingRule | **High** | Medium — larger file; depends heavily on RoundingRule |
| **Shift with rounding** | `…/ShiftWithRounding.swift` | **177** | **`IntegerUtilitiesShiftTests`** | Rounding right shifts | **High** | Overlaps shift portion of saturating API |
| **Approximate equality** | `…/ApproximateEquality.swift` | **247** | Real/Complex approx tests | Relative/absolute FP tolerance | Medium | FP tolerance risk — avoid for fairness |
| **Complex core** | `Complex.swift` / Polar | 208 / 130 | ComplexTests suites | Complex arithmetic / polar | Medium–High | FP + multi-file |

### Why saturating arithmetic adds diversity

| Prior domains (E1–E8) | This component |
|---|---|
| Snapshots, heaps, ordered sets, combinations, partitions, parsers | **Fixed-width integer overflow clamps** |
| Often string/collection remainder semantics | Exact `min`/`max` saturation of `+ − * <<` |

No floating-point tolerance required — Human and AI assert exact integer results.

---

## 3. Recommendation: `SaturatingArithmetic.swift`

**Exact production file(s):**

- Primary (frozen): `Sources/IntegerUtilities/SaturatingArithmetic.swift` (**167 LOC**)

**Exact human test filter (qualified):**

```bash
swift test --filter IntegerUtilitiesTests.IntegerUtilitiesSaturatingTests
```

Expected: **10** tests. Must execute **zero** `AIGenerated*` tests.

**Estimated meaningful mutations:** **22–26**.

**Fairness:** `shiftedWithSaturation` calls `shifted(rightBy:rounding:)` outside this file for negative counts — mutate only logic in this file; treat external shift helper as fixed.

---

## Stop line

Candidate selection for Experiment #9 is complete. Proceed to Stage 2.
