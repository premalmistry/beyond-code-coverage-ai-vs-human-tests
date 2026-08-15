# Experiment #10 Candidate Selection

**Repository:** [apple/swift-numerics](https://github.com/apple/swift-numerics)  
**Pinned SHA:** `899af71c0256d0ad181e3b7eb3453c1065d928a5`  
**Date (UTC):** `2026-08-13T15:30:00Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**Diversity note:** Experiment #9 studied **fixed-width integer saturating** `+ − * <<`. Experiment #10 targets **complex polar / Euclidean length / phase** — floating-point magnitude geometry with special-value branches (zero, non-finite, negative length), not integer overflow clamps.

**This document only selects the component.** No AI tests, no mutations, no production/test edits.

---

## 1. Setup reminder

```bash
cd /Users/premalmistry/Desktop/Projects/AppPerformanceAnalyzer/swift-numerics
git rev-parse HEAD   # 899af71c0256d0ad181e3b7eb3453c1065d928a5
```

---

## 2. Candidates evaluated

| Component | Target file(s) | LOC | Human tests | Logic type | Mutation potential | Difficulty |
|---|---|---:|---|---|---|---|
| **Complex polar** | `Sources/ComplexModule/Polar.swift` | **130** | `ArithmeticTests/testPolar` (+ related property checks) | Euclidean length, phase, polar init, careful hypot path | **High** — guards, swap cos/sin, lengthSquared, phase NaN, negative length | **Low** — ~0.03s; needs ulp tolerances |
| Divide with rounding | `…/DivideWithRounding.swift` | 325 | `IntegerUtilitiesDivideTests` (5 methods) | Integer ÷ with RoundingRule | High | Medium — ~10s/run (Int128); still IntegerUtilities like E9 |
| Approximate equality | `…/ApproximateEquality.swift` | 247 | `RealTests.ApproximateEqualityTests` | Relative/absolute FP ≈ | Medium–High | FP tolerance semantics dominate |
| Augmented arithmetic | `…/AugmentedArithmetic.swift` | 148 | `AugmentedArithmeticTests` | twoSum / twoProduct | Medium | Narrow API; FMA-heavy |
| Shift with rounding | `…/ShiftWithRounding.swift` | 177 | `IntegerUtilitiesShiftTests` | Rounding right shifts | High | Overlaps E9 shift themes |

### Why polar adds diversity vs E9

| E9 SaturatingArithmetic | E10 Polar |
|---|---|
| Exact integer clamps to `min`/`max` | Complex **length / phase / polar** geometry |
| No floating point | Documented **ulp** tolerances + special values |
| Overflow reporting | Careful hypot / `lengthSquared` / NaN phase |

Excluded: SaturatingArithmetic (E9). DivideWithRounding rejected for weaker behavioral diversity (still FixedWidthInteger arithmetic utilities) and slower mutation loops.

---

## 3. Recommendation: `Polar.swift`

**Exact production file(s):**

- Primary (frozen): `Sources/ComplexModule/Polar.swift` (**130 LOC**)

**Exact human test filter (qualified):**

```bash
swift test --filter ComplexTests.ArithmeticTests/testPolar
```

Expected: **1** executed test method (`testPolar` covering Float/Double[/Float80]). Must execute **zero** `AIGenerated*` tests.

**Note:** `PropertyTests/testProperties` also asserts `length`/`phase` specials, but is **not** included — keep Human scope tightly bound to the polar round-trip suite already co-located with polar arithmetic checks.

**Estimated meaningful mutations:** **22–26**.

**Fairness:** `init(length:phase:)` calls `multiplied(by:)` in `Scale.swift`; `length` uses `isFinite`/`isZero` from `Complex.swift`. Mutate **only** `Polar.swift`; treat external helpers as fixed. AI/Human must use justified ulp tolerances for finite length/phase, exact equality for documented specials.

---

## Stop line

Candidate selection for Experiment #10 is complete. Proceed to Stage 2.
