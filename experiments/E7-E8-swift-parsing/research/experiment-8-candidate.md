# Experiment #8 Candidate Selection

**Repository:** [pointfreeco/swift-parsing](https://github.com/pointfreeco/swift-parsing)  
**Pinned SHA:** `7160b25d39e4a38258a7fe71591fbe182b026d69` (same pin as Experiment #7)  
**Date (UTC):** `2026-08-13T15:01:00Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**Out of scope:** `Prefix.swift` and closely related prefix/boundary matchers (`PrefixThrough`, `PrefixUpTo`, `StartsWith`) from Experiment #7.

**This document only selects the component.** No AI tests, no mutations, no production/test edits.

---

## 1. Setup reminder

```bash
swift test --filter ParsingTests.DigitsTests      # 2 PASS
swift test --filter ParsingTests.IntTests         # 2 PASS
swift test --filter ParsingTests.WhitespaceTests  # 4 PASS
swift test --filter ParsingTests.OneOfTests       # 11 PASS
```

---

## 2. Candidates evaluated

| Component | Target file(s) | LOC | Human tests | Logic type | Mutation potential | Difficulty |
|---|---|---:|---|---|---|---|
| **`Digits`** | `Sources/Parsing/ParserPrinters/Digits.swift` | **190** | **`DigitsTests`**: **2** dense methods (parse lengths, print pad/max, zero-min composition) | UTF-8 digit → `Int` accumulation, length min/max, overflow, print pad/reject | **High** — loop bound, `*10`/`+n`, overflow guards, min check, unapply, print negative/max/pad; **~22–26** | **Low** |
| **`Int` parser** | `…/Int.swift` | **125** | **`IntTests`**: **2** methods | Signed integer + radix digits | **High** | Thin Human suite; overlaps Digits domain somewhat |
| **`Whitespace`** | `…/Whitespace.swift` | **190** | **4** methods | Unicode whitespace consume | **Medium** — many codepoint branches; equivalence risk | **Low** |
| **`OneOf`** | `…/OneOf.swift` | **183** | **11** methods | Alternation / error ranking | **Low–Medium** — thin core ctrl flow | — |
| **`Many`** | `…/Many.swift` | **913** | large suite | Repetition + separators | High but **oversized** | Reject LOC |
| **`Optionally` / `Peek` / `Backtracking`** | ≤61 LOC | existing | Optional / lookahead / restore | Too thin for 20+ mutants | Reject |

### Behavioral diversity vs Experiment #7 (`Prefix`)

| | Experiment #7 `Prefix` | Experiment #8 `Digits` (recommended) |
|---|---|---|
| Output | Subsequence / slice of input | Accumulated **`Int`** |
| Core loop | `prefix` / `prefix(while:)` | Digit decode + `*10` + add + overflow |
| Failure modes | Under-min length / predicate | Under-min **digits**, **integer overflow** |
| Print | Prepend slice; predicate/next-elem checks | Non-negative only; **zero-pad** to min; max digit-count |

This is numeric parsing / overflow / padding — not another prefix/boundary matcher.

---

## 3. Recommendation: `Digits.swift`

**Exact production file(s):**

- Primary (frozen): `Sources/Parsing/ParserPrinters/Digits.swift` (**190 LOC**)

**Exact human test filter (qualified):**

```bash
swift test --filter ParsingTests.DigitsTests
```

Expected: **2** tests. Must execute **zero** `AIGenerated*` tests (including Experiment #7’s `AIGeneratedPrefixTests`).

**Estimated meaningful mutations:** **22–26**.

**Why this component:** Fits 100–400 LOC; direct Human tests; strong observable Int/remainder/print behavior; clear diversity from Prefix; fast deterministic SwiftPM.

### Fairness concerns

| Concern | Mitigation |
|---|---|
| Only **2** Human test methods | Methods are assertion-dense (parse+print+errors); freeze as-is — do not expand |
| `inputToBytes` conversion helpers | Mutate Digits control flow only; treat conversions as fixed |
| Existing `AIGeneratedPrefixTests` in tree | Use fully qualified `ParsingTests.DigitsTests` filter |

---

## Stop line

Candidate selection for Experiment #8 is complete. Proceed to Stage 2.
