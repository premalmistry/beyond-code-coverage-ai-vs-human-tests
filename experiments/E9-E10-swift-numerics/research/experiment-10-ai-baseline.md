# Experiment #10 — AI Baseline (`Polar.swift`)

**Component:** `Sources/ComplexModule/Polar.swift`  
**AI test file (frozen):** `Tests/ComplexTests/AIGeneratedPolarTests.swift`  
**Repo SHA:** `899af71c0256d0ad181e3b7eb3453c1065d928a5`  
**Baseline date (UTC):** `2026-08-13T15:31:31Z`  
**Swift:** Apple Swift 6.3.3  

**Production SHA-256:**
```
d7c8056e0014a70367480efe161c64fb4bc525047a8681cf2fdba8be192e68d4  Sources/ComplexModule/Polar.swift
```

**AI suite SHA-256 (frozen):**
```
b8eb9d8ca821b9bd0e74d30509135ea852c8b3b8397a57a5cc53995739bbf7fe  Tests/ComplexTests/AIGeneratedPolarTests.swift
```

**Isolation:** Generated from production `Polar.swift` / Complex polar API only. Human tests, Human coverage, and mutation plans were **not** used as generation inputs.

---

## Frozen AI filter

```bash
swift test --filter ComplexTests.AIGeneratedPolarTests
```

| Check | Result |
|---|---|
| PASS | **18 tests, 0 failures** |
| Contaminates Human filter? | **NO** — Human still executes only `testPolar` |

### Inventory (18)

1. `testFloatInitSpecials`
2. `testFloatLengthAndPhaseBasics`
3. `testInitFiniteRoundTripDeterministic`
4. `testInitInfiniteLengthIgnoresPhase`
5. `testInitNegativeLengthReflectsThroughOrigin`
6. `testInitProducesExpectedComponentsOnAxes`
7. `testInitZeroLengthIgnoresPhase`
8. `testLengthAvoidsSpuriousOverflowLikeDocs`
9. `testLengthOf3_4_5Triangle`
10. `testLengthOfNonFiniteIsInfinity`
11. `testLengthOfUnitAxes`
12. `testLengthOfZeroIsZero`
13. `testLengthSquaredMatchesForNormalProducts`
14. `testPhaseOfNonFiniteIsNaN`
15. `testPhaseOfZeroIsNaN`
16. `testPhaseQuadrants`
17. `testPolarSpecials`
18. `testPolarTupleMatchesLengthAndPhase`

**Methods:** 18 · **Assertion call sites (static):** **49**

**Disjointness vs Human method names:** **EMPTY intersection** (`testPolar` vs AI `test*` names above).

**Numerical policy:** Exact equality for documented specials (zero/∞ length init, non-finite length, NaN phase). Finite length/phase/components compared with **16 ulp** tolerance relative to a justified magnitude scale.

---

## Coverage

| Metric | Value |
|---|---|
| Executable lines | **34** |
| Line | **97.06%** (33 / 34) |
| Region | **94.74%** (18 / 19) |
| Function | **90.00%** (9 / 10) |

Artifacts: `research/experiment-10-ai-coverage.txt`, `experiment-10-ai-coverage-detail.txt`

---

## Integrity

Production SHA unchanged; AI PASS; Human filter CLEAN. Suites frozen. Proceed to Stage 4.
