# Experiment #15 — Summary (CONFIRMATORY)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  

Final confirmatory experiment (#15). Methodology unchanged from #11–#14. Result accepted as observed.

---

## Selected component

| Field | Value |
|---|---|
| Repository | apple/swift-numerics |
| Repo SHA | `899af71c0256d0ad181e3b7eb3453c1065d928a5` |
| Component | `Sources/ComplexModule/Complex+AlgebraicField.swift` |
| Eligibility | Direct deterministic Human ArithmeticTests (`testBaudinSmith`, `testDivisionByZero`); focused division / rescaledDivide / conjugate / normalized / reciprocal; not E9/E10; isolated MUT surface |
| Selection rule | Sort eligible production paths alphabetically; take **first** |
| Production SHA-256 | `9f984d0229c4851537e5367bb944a7bd8073d35ea0e94084a201724baaca6f5b` |
| AI-suite SHA-256 | `51e41c584bd813adc3bd40b6040c631437bb30ed0c57430bfec954582d926695` |
| Swift | Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS |

---

## Baseline comparison

| Metric | Human | AI |
|---|---:|---:|
| Test methods | 2 | 19 |
| Assertion sites | 7 | 41 |
| Line coverage | **71.19%** | **44.92%** |
| Region coverage | **40.62%** | **78.12%** |
| Function coverage | **25.00%** | **66.67%** |

Human filter (frozen):  
`ComplexTests.ArithmeticTests/testBaudinSmith|ComplexTests.ArithmeticTests/testDivisionByZero`  

AI filter (frozen): `AIGeneratedComplexAlgebraicFieldTests`

---

## Mutation testing

| Metric | Value |
|---|---:|
| Valid mutants | **24** |
| Human killed | **13** |
| AI killed | **16** |
| Human mutation score | **54.2%** (13/24) |
| AI mutation score | **66.7%** (16/24) |
| Shared kills | **8** |
| Human-only kills | **5** (E15-M13–M17) |
| AI-only kills | **8** (E15-M01, M02, M05, M11, M18–M21) |
| Shared survivors | **3** (E15-M22–M24) |
| Equivalent/invalid exclusions | **0** |

---

## Integrity

| Check | Status |
|---|---|
| Production restored + SHA-256 | **PASS** |
| AI-suite SHA-256 unchanged | **PASS** |
| Both frozen suites re-run on restored production | **PASS** (2 Human / 19 AI, 0 failures) |
| Human ∩ AI inventories | **disjoint** |
| Human filter contamination | **CLEAN** (executed Test Cases only; compile-path substring ignored) |
| Measurement integrity | Corrected for `@_transparent`/`@inlinable` client re-emit (force-rebuild ComplexTests per mutant run) |

---

## Experiment #15 only

This summary describes Experiment #15 only. It does not reinterpret Experiments #1–#14, update the paper, or propose Experiment #16.

**STOP.**
