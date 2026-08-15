# Experiment #15 — Mutation Plan (FROZEN)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/ComplexModule/Complex+AlgebraicField.swift`  
**Repo SHA:** `899af71c0256d0ad181e3b7eb3453c1065d928a5`  
**Production SHA-256:** `9f984d0229c4851537e5367bb944a7bd8073d35ea0e94084a201724baaca6f5b`  
**AI suite SHA-256:** `51e41c584bd813adc3bd40b6040c631437bb30ed0c57430bfec954582d926695`  
**Plan date (UTC):** `2026-08-15T17:41:00Z`

Both suites frozen. Plan defined **after** suite freeze and **before** execution.

Mutants: `research/mutants-e15/E15-MXX.swift` (**24** — quality over padding; numerical defects only).

---

## Frozen mutant set

| ID | Theme |
|---|---|
| E15-M01 | `one` → `Complex(0,0)` |
| E15-M02 | `one` → `Complex(1,1)` |
| E15-M03 | conjugate drops imag negation |
| E15-M04 | conjugate negates real instead of imag |
| E15-M05 | `/=` uses `w/z` instead of `z/w` |
| E15-M06 | `/` invert `lenSq.isNormal` guard |
| E15-M07 | `/` uses `w` instead of `w.conjugate` |
| E15-M08 | `/` multiplies by `lenSq` instead of dividing |
| E15-M09 | `rescaledDivide` zero divisor → `.zero` not `.infinity` |
| E15-M10 | `rescaledDivide` invert `isZero` check |
| E15-M11 | `rescaledDivide` nonfinite → `.infinity` not `.zero` |
| E15-M12 | `rescaledDivide` invert `isFinite` check |
| E15-M13 | tiny-magnitude comparison flipped (`<` → `>`) |
| E15-M14 | Priest scale exponent `/4` → `/2` |
| E15-M15 | Priest scale exponent sign flipped |
| E15-M16 | Priest return `/` instead of `*` |
| E15-M17 | Priest scales only `w`, not `z` |
| E15-M18 | `normalized` invert `length.isNormal` |
| E15-M19 | `normalized` returns `self` instead of `nil` for zero/inf |
| E15-M20 | `normalized` multiplies by length |
| E15-M21 | `reciprocal` swaps nil vs return |
| E15-M22 | `reciprocal` drops `isZero \|\| !isFinite` clause |
| E15-M23 | `_relaxedAdd` uses product not sum |
| E15-M24 | `_relaxedMul` drops imag-product negation |

---

## Execution protocol

```text
Human filter: ComplexTests.ArithmeticTests/testBaudinSmith|ComplexTests.ArithmeticTests/testDivisionByZero
AI filter:    AIGeneratedComplexAlgebraicFieldTests
Timeout:      60s per suite
Order:        Human then AI per mutant; restore ORIG; verify SHA
```

## FREEZE

Do not alter mutants after seeing outcomes.
