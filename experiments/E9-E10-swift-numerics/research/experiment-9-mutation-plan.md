# Experiment #9 — Mutation Plan (`SaturatingArithmetic.swift`)

**Component:** `Sources/IntegerUtilities/SaturatingArithmetic.swift`  
**Repo SHA:** `899af71c0256d0ad181e3b7eb3453c1065d928a5`  
**Production SHA-256:** `1da0a8a5b9f7d6f9a9421786d1817b35eed7dbe9dcf48190eaac5ef131498536`  
**AI SHA-256:** `93ebec4f106534683fae2d1824c8d16bf3d5668e10b3f3a196b08f74741253a0`  

**Suites:**
- Human: `IntegerUtilitiesTests.IntegerUtilitiesSaturatingTests` (10)
- AI: `IntegerUtilitiesTests.AIGeneratedSaturatingArithmeticTests` (27)

**Status:** Plan only — **no execution yet**

```bash
swift test --filter IntegerUtilitiesTests.IntegerUtilitiesSaturatingTests
swift test --filter IntegerUtilitiesTests.AIGeneratedSaturatingArithmeticTests
```

Timeout: 60s per suite (Human exhaustive Int8 loops).

**Scope:** Mutate **only** `SaturatingArithmetic.swift`. External `shifted(rightBy:rounding:)` remains fixed.

---

## Mutations E9-M01…E9-M26

| ID | Location | Original | Mutation | Expected defect |
|---|---|---|---|---|
| **E9-M01** | `signbit` | `self < .zero` | `self <= .zero` | Treats zero as negative signbit |
| **E9-M02** | `signbit` | `? ~.zero : .zero` | `? .zero : ~.zero` | Inverts signbit |
| **E9-M03** | add | `overflow ? max&-signbit : wrapped` | invert arms | Wrong result on overflow vs not |
| **E9-M04** | add | `Self.max &- signbit` | `Self.min` | Always min on overflow |
| **E9-M05** | add | `Self.max &- signbit` | `Self.max` | Wrong clamp for negative overflow |
| **E9-M06** | add | `addingReportingOverflow` | `subtractingReportingOverflow` | Wrong operation |
| **E9-M07** | sub | `if !overflow` | `if overflow` | Inverts overflow branch |
| **E9-M08** | sub | unsigned overflow → `0` | → `Self.max` | Wrong unsigned clamp |
| **E9-M09** | sub | signed overflow → `max &- signbit` | → `Self.min` | Wrong signed overflow polarity |
| **E9-M10** | sub | `subtractingReportingOverflow` | `addingReportingOverflow` | Wrong operation |
| **E9-M11** | neg | `zero.subtractingWithSaturation(self)` | `return self` | Negation no-op |
| **E9-M12** | mul | `high == wrapped.signbit` | `high != wrapped.signbit` | Invert overflow detect |
| **E9-M13** | mul | `Self.max &- high.signbit` | `Self.max &+ high.signbit` | Wrong saturate magnitude |
| **E9-M14** | mul | overflow return clamp | always `return wrapped` | No saturation |
| **E9-M15** | mul | `multipliedFullWidth(by: other)` | `by: 1` | Ignores multiplicand |
| **E9-M16** | shift | `count == 0` | `count == 1` | Wrong identity / early exit |
| **E9-M17** | shift | `guard count > 0` | `guard count < 0` | Swaps left/right paths |
| **E9-M18** | shift | `count < Self.bitWidth` | `count <= Self.bitWidth` | Off-by-one width boundary |
| **E9-M19** | shift | `self == 0 ? 0 : clamped` | invert arms | Wrong large-shift zero/nonzero |
| **E9-M20** | shift | `isSigned ? 1 : 0` | `isSigned ? 0 : 1` | Wrong valueBits |
| **E9-M21** | shift | `== signbit ? wrapped : clamped` | invert arms | Wrong overflow decision |
| **E9-M22** | shift | `self &<< count` | `self &>> count` | Wrong shift direction |
| **E9-M23** | shift | `valueBits &- count` | `valueBits &+ count` | Wrong complement |
| **E9-M24** | shift neg path | `count.negatedWithSaturation()` | `count` (no negate) | Wrong right-shift amount |
| **E9-M25** | shift | `Self.max &- signbit` (clamped) | `Self.max` | Wrong signed clamp on overflow |
| **E9-M26** | generic | `Int(clamping: count)` | `Int(truncatingIfNeeded: count)` | Truncates huge counts |

---

## Frozen set

**E9-M01 … E9-M26** (26). File scope: `SaturatingArithmetic.swift` only.

**Mutation set frozen.** Proceed to Stage 5.
