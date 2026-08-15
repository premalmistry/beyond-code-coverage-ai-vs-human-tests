# Experiment #10 — Mutation Plan (`Polar.swift`)

**Component:** `Sources/ComplexModule/Polar.swift`  
**Repo SHA:** `899af71c0256d0ad181e3b7eb3453c1065d928a5`  
**Production SHA-256:** `d7c8056e0014a70367480efe161c64fb4bc525047a8681cf2fdba8be192e68d4`  
**AI SHA-256:** `b8eb9d8ca821b9bd0e74d30509135ea852c8b3b8397a57a5cc53995739bbf7fe`  

**Suites:**
- Human: `ComplexTests.ArithmeticTests/testPolar` (1)
- AI: `ComplexTests.AIGeneratedPolarTests` (18)

**Status:** Plan only — **no execution yet**

```bash
swift test --filter ComplexTests.ArithmeticTests/testPolar
swift test --filter ComplexTests.AIGeneratedPolarTests
```

Timeout: 60s per suite.

**Scope:** Mutate **only** `Polar.swift`. External `multiplied(by:)`, `isFinite`, `isZero`, libm remain fixed.

---

## Mutations E10-M01…E10-M24

| ID | Location | Original | Mutation | Expected defect |
|---|---|---|---|---|
| **E10-M01** | length | `naive.isNormal` | `!naive.isNormal` | Wrong fast/slow path |
| **E10-M02** | length | `else { return carefulLength }` | `else { return naive }` | Return unsafed squared length |
| **E10-M03** | length | `.sqrt(naive)` | `naive` (no sqrt) | LengthSquared as length |
| **E10-M04** | length | `.sqrt(naive)` | `.sqrt(naive / 2)` | Wrong scale |
| **E10-M05** | carefulLength | `guard isFinite` | `guard !isFinite` | Invert finite check |
| **E10-M06** | carefulLength | `return .infinity` | `return .zero` | Wrong non-finite length |
| **E10-M07** | carefulLength | `.hypot(x, y)` | `.sqrt(x*x + y*y)` | Reintroduce overflow risk |
| **E10-M08** | lengthSquared | `x*x + y*y` | `x*x - y*y` | Wrong squared length |
| **E10-M09** | lengthSquared | `x*x + y*y` | `x*x` | Drop imaginary |
| **E10-M10** | phase | `isFinite && !isZero` | `isFinite \|\| !isZero` | Wrong NaN guard |
| **E10-M11** | phase | `&& !isZero` | `&& isZero` | Phase only for zero |
| **E10-M12** | phase | `return .nan` | `return .zero` | Zero instead of NaN |
| **E10-M13** | phase | `atan2(y: y, x: x)` | `atan2(y: x, x: y)` | Swap real/imag in atan2 |
| **E10-M14** | polar | `(length, phase)` | `(length: phase, phase: length)` | Swap polar components |
| **E10-M15** | init | `phase.isFinite` | `!phase.isFinite` | Invert finite-phase branch |
| **E10-M16** | init | `Complex(.cos(phase), .sin(phase))` | swap cos/sin | Swap real/imag unit vector |
| **E10-M17** | init | `.multiplied(by: length)` | `.divided(by: length)` | Wrong scale |
| **E10-M18** | init | `.multiplied(by: length)` | `.multiplied(by: -length)` | Wrong sign |
| **E10-M19** | init | `length.isZero \|\| length.isInfinite` | `length.isZero && length.isInfinite` | Precondition always fails / wrong |
| **E10-M20** | init | `self = Complex(length)` | `self = Complex(-length)` | Wrong non-finite mapping |
| **E10-M21** | init | omit precondition (always Complex(length)) | Drop validation | Accepts invalid phase |
| **E10-M22** | length | remove careful path; always `.sqrt(naive)` | Spurious overflow / wrong subnormals |
| **E10-M23** | phase | `atan2(y: y, x: x)` | `-atan2(...)` | Sign-flipped phase |
| **E10-M24** | carefulLength | `return .infinity` | `return .nan` | NaN length for non-finite |

---

## Frozen set

**E10-M01 … E10-M24** (24). File scope: `Polar.swift` only.

**Mutation set frozen.** Proceed to Stage 5.
