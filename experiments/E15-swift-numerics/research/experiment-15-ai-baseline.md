# Experiment #15 — AI Baseline (`Complex+AlgebraicField.swift`)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/ComplexModule/Complex+AlgebraicField.swift`  
**Repo SHA:** `899af71c0256d0ad181e3b7eb3453c1065d928a5`  
**Baseline date (UTC):** `2026-08-15T17:40:30Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Production SHA-256:** `9f984d0229c4851537e5367bb944a7bd8073d35ea0e94084a201724baaca6f5b`  
**AI suite SHA-256:** `51e41c584bd813adc3bd40b6040c631437bb30ed0c57430bfec954582d926695`

AI suite generated from production API only. Human tests, Human coverage, and mutation plans were **not** consulted during generation.

---

## 1. Frozen AI suite

**Path:** `Tests/ComplexTests/AIGeneratedComplexAlgebraicFieldTests.swift`  
**Filter (frozen):**

```bash
swift test --filter AIGeneratedComplexAlgebraicFieldTests
```

**19** XCTest methods. Assertion sites (`XCTAssert*` / `XCTFail`): **41**.

### AI executed-test inventory

```
-[ComplexTests.AIGeneratedComplexAlgebraicFieldTests testConjugate_negatesImaginary]
-[ComplexTests.AIGeneratedComplexAlgebraicFieldTests testConjugate_realIsFixedPoint]
-[ComplexTests.AIGeneratedComplexAlgebraicFieldTests testDivide_andMultiplyRoundTripWellScaled]
-[ComplexTests.AIGeneratedComplexAlgebraicFieldTests testDivide_assignOperator]
-[ComplexTests.AIGeneratedComplexAlgebraicFieldTests testDivide_byInfinityYieldsZero]
-[ComplexTests.AIGeneratedComplexAlgebraicFieldTests testDivide_byOneLeavesValue]
-[ComplexTests.AIGeneratedComplexAlgebraicFieldTests testDivide_byZeroYieldsNonFinite]
-[ComplexTests.AIGeneratedComplexAlgebraicFieldTests testDivide_floatSimple]
-[ComplexTests.AIGeneratedComplexAlgebraicFieldTests testDivide_iOverIIsOne]
-[ComplexTests.AIGeneratedComplexAlgebraicFieldTests testDivide_largeOverLarge]
-[ComplexTests.AIGeneratedComplexAlgebraicFieldTests testDivide_simpleValues]
-[ComplexTests.AIGeneratedComplexAlgebraicFieldTests testDivide_tinyDenominatorUsesRescaledPath]
-[ComplexTests.AIGeneratedComplexAlgebraicFieldTests testNormalized_nilForInfinity]
-[ComplexTests.AIGeneratedComplexAlgebraicFieldTests testNormalized_nilForZero]
-[ComplexTests.AIGeneratedComplexAlgebraicFieldTests testNormalized_unitLengthForFiniteNonZero]
-[ComplexTests.AIGeneratedComplexAlgebraicFieldTests testOne_isMultiplicativeIdentity]
-[ComplexTests.AIGeneratedComplexAlgebraicFieldTests testReciprocal_matchesDivisionForm]
-[ComplexTests.AIGeneratedComplexAlgebraicFieldTests testReciprocal_ofOne]
-[ComplexTests.AIGeneratedComplexAlgebraicFieldTests testReciprocal_ofWellScaled]
```

---

## 2. Results

| Metric | Value |
|---|---|
| AI test methods | **19** |
| AI assertion call sites | **41** |
| Test result | **PASS** |
| Line coverage | **44.92%** (53 / 118) |
| Region coverage | **78.12%** (25 / 32) |
| Function coverage | **66.67%** (8 / 12) |

Uncovered / lightly covered: Priest-style `rescaledDivide` body (AI mostly hits fast `/` and special cases), `_relaxedAdd` / `_relaxedMul`, some `reciprocal` nil branches.

---

## 3. Disjointness + contamination

| Check | Result |
|---|---|
| Human ∩ AI inventory | **empty** |
| Human filter executes AI tests? | **No** (CLEAN) |
| AI filter executes Human tests? | **No** |

---

## 4. Freeze confirmation

- AI suite **FROZEN** (SHA-256 recorded)  
- No further AI suite edits after this point
