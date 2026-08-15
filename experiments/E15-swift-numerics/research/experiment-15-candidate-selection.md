# Experiment #15 — Candidate Selection (CONFIRMATORY)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Repository:** [apple/swift-numerics](https://github.com/apple/swift-numerics)  
**Pinned SHA:** `899af71c0256d0ad181e3b7eb3453c1065d928a5` (same pin as Experiments #9 and #10)  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Date (UTC):** `2026-08-15T17:39:13Z`

**This document only selects the component.** Final confirmatory experiment (#15).

---

## Context

Experiments #1–#10 were **exploratory**. Experiments #11–#15 are **confirmatory**.

Protocol is **identical** to Experiments #11–#14. Do **not** modify methodology based on those outcomes.

Previously studied in this repository:

| Experiment | Component |
|---|---|
| E9 | `Sources/IntegerUtilities/SaturatingArithmetic.swift` |
| E10 | `Sources/ComplexModule/Polar.swift` |

---

## Eligibility criteria (pre-declared)

1. Direct existing human-written tests.
2. Deterministic tests.
3. Focused, observable behavior.
4. Reasonably supports meaningful mutation testing.
5. No network/external services.
6. Not studied in Experiments #1–#14.
7. Reasonably isolated for Human-vs-AI comparison.

---

## Neutral selection rule (identical to #11–#14)

1. Enumerate every production `.swift` file under `Sources/`.
2. Apply eligibility; record objective exclusions.
3. Sort eligible paths alphabetically.
4. Select the **first** eligible path.
5. Do **not** skip for predicted coverage, suite strength, outcome, or interestingness.

## Full inventory (34 files, alphabetical)

| Production file path | LOC | Eligible? | Objective reason if excluded |
|---|---:|:---:|---|
| `Sources/ComplexModule/Complex+AdditiveArithmetic.swift` | 42 | **No** | (#4/#3) Thin AdditiveArithmetic conformance (+/−/zero only); no dedicated addition suite — insufficient focused MUT surface. |
| `Sources/ComplexModule/Complex+AlgebraicField.swift` | 182 | **YES** | Direct deterministic ArithmeticTests (BaudinSmith, DivisionByZero) exercise `/` and rescaledDivide; focused; 182 LOC; not studied; isolated. |
| `Sources/ComplexModule/Complex+Codable.swift` | 36 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/ComplexModule/Complex+ElementaryFunctions.swift` | 482 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/ComplexModule/Complex+Hashable.swift` | 42 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/ComplexModule/Complex+IntegerLiteral.swift` | 19 | **No** | (#4) Insufficient local surface (19 LOC). |
| `Sources/ComplexModule/Complex+Numeric.swift` | 59 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/ComplexModule/Complex+StringConvertible.swift` | 26 | **No** | (#4) Insufficient local surface (26 LOC). |
| `Sources/ComplexModule/Complex.swift` | 208 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/ComplexModule/Polar.swift` | 130 | **No** | (#6) Studied in Experiments #9/#10. |
| `Sources/ComplexModule/Scale.swift` | 41 | **No** | (#4) Thin real-scale multiply/divide helpers; insufficient standalone MUT surface. |
| `Sources/IntegerUtilities/DivideWithRounding.swift` | 325 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/IntegerUtilities/GCD.swift` | 40 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/IntegerUtilities/Rotate.swift` | 43 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/IntegerUtilities/RoundingRule.swift` | 266 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/IntegerUtilities/SaturatingArithmetic.swift` | 167 | **No** | (#6) Studied in Experiments #9/#10. |
| `Sources/IntegerUtilities/ShiftWithRounding.swift` | 177 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Numerics/Numerics.swift` | 15 | **No** | (#4) Insufficient local surface (15 LOC). |
| `Sources/RealModule/AlgebraicField.swift` | 132 | **No** | (#3/#1) Protocol / umbrella module surface without dedicated focused suite. |
| `Sources/RealModule/ApproximateEquality.swift` | 247 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/RealModule/AugmentedArithmetic.swift` | 148 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/RealModule/Double+Real.swift` | 232 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/RealModule/ElementaryFunctions.swift` | 224 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/RealModule/Float+Real.swift` | 205 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/RealModule/Float16+Real.swift` | 192 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/RealModule/Float80+Real.swift` | 179 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/RealModule/Real.swift` | 150 | **No** | (#3/#1) Protocol / umbrella module surface without dedicated focused suite. |
| `Sources/RealModule/RealFunctions.swift` | 98 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/RealModule/RelaxedArithmetic.swift` | 82 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/_TestSupport/BlackHole.swift` | 19 | **No** | (#1/#7) Test-support module — not production MUT surface. |
| `Sources/_TestSupport/DoubleWidth.swift` | 782 | **No** | (#1/#7) Test-support module — not production MUT surface. |
| `Sources/_TestSupport/Error.swift` | 32 | **No** | (#1/#7) Test-support module — not production MUT surface. |
| `Sources/_TestSupport/Interval.swift` | 51 | **No** | (#1/#7) Test-support module — not production MUT surface. |
| `Sources/_TestSupport/RealTestSupport.swift` | 33 | **No** | (#1/#7) Test-support module — not production MUT surface. |

### Eligible set (alphabetical)

1. **`Sources/ComplexModule/Complex+AlgebraicField.swift`** *(selected)*

---

## Selection

**Selected:** `Sources/ComplexModule/Complex+AlgebraicField.swift`

**Rule:** alphabetical first eligible.

### Why eligible

- (#1) Direct `ArithmeticTests` methods exercise `/`, `rescaledDivide`, and related field ops.
- (#2) Frozen Human filter uses **deterministic** `testBaudinSmith` + `testDivisionByZero` (excludes RNG `testPolar`).
- (#3) Focused complex division / conjugate / normalized / reciprocal.
- (#4) 182 LOC with normal vs rescaled divide branches — meaningful MUT surface.
- (#5) No network.
- (#6) Not E9/E10; distinct from Polar coordinate API.
- (#7) Single isolated file.

### Intended frozen Human filter

```bash
swift test --filter 'ComplexTests.ArithmeticTests/testBaudinSmith|ComplexTests.ArithmeticTests/testDivisionByZero'
```

Smoke: **2 tests, 0 failures**.

### Production fingerprint

| File | SHA-256 |
|---|---|
| `Sources/ComplexModule/Complex+AlgebraicField.swift` | `9f984d0229c4851537e5367bb944a7bd8073d35ea0e94084a201724baaca6f5b` |

## FREEZE

**Component is FROZEN.** Do not replace after any experimental result.
