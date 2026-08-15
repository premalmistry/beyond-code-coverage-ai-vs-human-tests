# Experiment #7 Candidate Selection

**Repository:** [pointfreeco/swift-parsing](https://github.com/pointfreeco/swift-parsing)  
**Pinned SHA:** `7160b25d39e4a38258a7fe71591fbe182b026d69`  
**Date (UTC):** `2026-08-13T14:25:00Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**Diversity note:** Experiments #1–#6 covered snapshot/reflection, collections/heaps, and algorithms. Experiment #7 targets **parser-specific** behavior (input consumption, min/max bounds, predicates, success/failure, remainder, printing round-trip).

**This document only selects the component.** No AI tests, no mutations, no production/test edits.

---

## 1. Setup reminder

```bash
cd /Users/premalmistry/Desktop/Projects/AppPerformanceAnalyzer/swift-parsing
git rev-parse HEAD   # 7160b25d39e4a38258a7fe71591fbe182b026d69

swift test --filter ParsingTests.PrefixTests       # 13 PASS
swift test --filter ParsingTests.DigitsTests       # 2 PASS
swift test --filter ParsingTests.WhitespaceTests   # 4 PASS
swift test --filter ParsingTests.IntTests          # 2 PASS
```

---

## 2. Candidates evaluated

| Component | Target file(s) | LOC | Human tests | Logic type | Mutation potential | Difficulty |
|---|---|---:|---|---|---|---|
| **`Prefix`** | `Sources/Parsing/ParserPrinters/Prefix.swift` | **191** | **`PrefixTests`**: **13** methods (~122 LOC) | Consume prefix with min/max length + optional predicate; fail under-min; printer round-trip guards | **High** — max/min bounds, predicate apply/skip, `removeFirst` count, success/fail, print min/max/predicate/next-element; **~22–26** mutants | **Low** — ~0.01s suite |
| **`Digits`** | `…/Digits.swift` | **190** | **`DigitsTests`**: **2** methods | UTF-8 digit loop, length range, overflow | **High** algorithmic | **Low** — but thin Human suite (2 tests) weakens comparison |
| **`Whitespace`** | `…/Whitespace.swift` | **190** | **`WhitespaceTests`**: **4** methods | Unicode whitespace consume (horizontal/vertical/all) | **Medium–High** — many codepoint branches; risk of equivalent/obscure mutants | **Low** |
| **`Int`** | `…/Int.swift` | **125** | **`IntTests`**: **2** methods | Integer parse/sign/overflow | **Medium** | Thin Human suite |
| **`OneOf`** | `…/OneOf.swift` | **183** | large suite | Alternation builder | **Low** ctrl-flow density (~2) | — |
| **`Many`** | `…/Many.swift` | **913** | **`ManyTests`** | Repeated parsing + separators | High but **oversized** | **High** — reject for LOC |

### Evidence: human tests ↔ production (recommended)

| Test themes in `PrefixTests` | Production surface |
|---|---|
| Fixed / ranged prefix success & under-length failure | `parse`: `maximum`/`minimum`, `removeFirst`, guard |
| `while` predicate success / always-succeeds | `predicate.map { prefix(while:) }` |
| Print failures (min, max, predicate, upstream) | `ParserPrinter.print` guards + `prepend` |

---

## 3. Recommendation: `Prefix.swift`

**Exact production file(s):**

- Primary (frozen): `Sources/Parsing/ParserPrinters/Prefix.swift` (**191 LOC**)

**Exact human test suite/filter (qualified — Runbook v2):**

```bash
swift test --filter ParsingTests.PrefixTests
```

Expected: **13** tests, sub-second after build. Must execute **zero** `AIGenerated*` tests.

**Estimated meaningful mutations:** **22–26** (consumption length, min/max comparisons, predicate presence, failure vs success, printer bound/predicate/next-element checks, omit prepend).

**Why this component:**

1. Fits **100–400 LOC**; cohesive parse+print of prefix consumption — **parser defect domain** new to the study.
2. Human suite **directly** exercises success, failure, ranges, predicates, and printing.
3. Clear observable outputs: parsed slice + remaining input; print errors vs prepended input.
4. Deterministic SwiftPM XCTest; fast mutation loops.
5. Stronger than Digits/Int (too few Human tests) and Many (too large); cleaner than Whitespace (unicode-branch equivalence risk).

### Fairness concerns

| Concern | Mitigation |
|---|---|
| Error message string mutations | Avoid; mutate control flow / consumption counts only |
| Printer path vs parse path | Include both; Human tests cover print failures |
| `CountingRange` lives elsewhere | Mutate only `Prefix.swift` uses of min/max |

---

## Stop line

Candidate selection for Experiment #7 is complete. Production scope and intended human filter are **frozen**. Proceed to Stage 2.
