# Experiment #5 Candidate Selection

**Repository:** [apple/swift-algorithms](https://github.com/apple/swift-algorithms)  
**Pinned SHA:** `5b7143f8e291dee0e14c118fd0212487f0b37af5`  
**Date (UTC):** `2026-08-13T13:50:00Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**This document only selects the Experiment #5 component.** No AI tests, no mutations, no production/test edits.  
**Out of scope relative to prior experiments:** Heap (E3), OrderedSet insertions (E4), URLRequest/Any dump (E1–E2) — all in other repos.

---

## 1. Setup reminder

```bash
cd /Users/premalmistry/Desktop/Projects/AppPerformanceAnalyzer/swift-algorithms
git rev-parse HEAD   # 5b7143f8e291dee0e14c118fd0212487f0b37af5
swift --version      # Apple Swift 6.3.3

swift test --filter CombinationsTests   # 4 tests PASS (~0.003s body; first build ~23s)
swift test --filter WindowsTests        # 8 tests PASS (~0.004s)
swift test --filter PartitionTests      # 10 tests PASS (~0.07s)
swift test --filter AdjacentPairsTests  # 12 tests PASS (~0.009s)
```

---

## 2. Candidates evaluated

| Component | Target file(s) | LOC | Human tests | Logic type | Mutation potential | Difficulty |
|---|---|---:|---|---|---|---|
| **`combinations`** | `Sources/Algorithms/Combinations.swift` | **311** | **`CombinationsTests`**: **4** methods (~154 LOC); count, enumeration, empty/`k`-oob, lazy | Combinatorial generation: `kRange` clamp, binomial `count`, lexicographic index advance, multi-`k` iteration | **High** — off-by-one in advance, wrong binomial cases, clamp/`nil` range, empty-`k` finishing; **~24–28** solid mutants | **Low** — filter ~instant; single file; deterministic |
| **`windows(ofCount:)`** | `Sources/Algorithms/Windows.swift` | **365** | **`WindowsTests`**: **8** methods (~112 LOC) | Sliding-window `Collection` indices, bidirectional/offset/distance | **High** — dense index arithmetic (~49 ctrl); **~25–30** mutants | **Low–Medium** — strong, but similar “collection wrapper index math” flavor to AdjacentPairs |
| **`partition` family** | `Sources/Algorithms/Partition.swift` | **389** | **`PartitionTests`**: **10** methods (~208 LOC) | `stablePartition`, `partition`, `partitioningIndex`, `partitioned` | **High** — multiple algorithms in one file; **~25–30** | **Medium** — upper LOC band; several APIs; mutations spread across unrelated helpers |
| **`adjacentPairs`** | `Sources/Algorithms/AdjacentPairs.swift` | **323** | **`AdjacentPairsTests`**: **12** methods (~84 LOC) | Pairwise sequence + collection index machinery | **Medium–High** — good branching; some wrappers/index boilerplate | **Low** — fast; slightly thinner algorithmic novelty vs Combinations |
| **`uniqued`** | `Sources/Algorithms/Unique.swift` | **145** | **`UniqueTests`**: thin suite | Seen-set uniqueness filter | **Low–Medium** — few branches (~3 ctrl); **&lt;20** without padding | **Low** — rejected for mutant budget |

Other guidance areas (`Chunked` ~929, `Permutations` ~608, `Intersperse` ~684) exceed the focused **100–400 LOC** preference or are multi-algorithm sprawls.

### Evidence: human tests ↔ production (recommended target)

| Test method | Production surface |
|---|---|
| `testCount` | `CombinationsSequence.count` / `underestimatedCount`, range/`k` clamping effects on totals |
| `testCombinations` | Iterator/`next` lexicographic combinations for fixed `k` and ranges (`2...4`, `0...`, `...3`, `1...`) |
| `testEmpty` | `k == 0` single empty combo; `k`/`kRange` beyond `base.count` → empty sequence |
| `testCombinationsLazy` | `LazySequenceProtocol` conditional conformance |

All four methods call `combinations(ofCount:)` / `combinations(ofCount: RangeExpression)` on the selected file.

---

## 3. Recommendation: `Combinations.swift`

**Exact production file(s):**

- Primary (frozen): `Sources/Algorithms/Combinations.swift` (**311 LOC**)

**Exact human test suite/filter:**

```bash
# Use the fully qualified class name. Bare "CombinationsTests" also matches
# AIGeneratedCombinationsTests once that file exists.
swift test --filter SwiftAlgorithmsTests.CombinationsTests
```

Expected: **4** tests, sub-second after build.

**Estimated meaningful mutations:** **24–28** (range clamp/`nil`, binomial special cases, `advance` / `advanceKRange` off-by-ones, empty-index finishing, precondition on negative `k`).

**Expected experiment duration:** ~**2.5–4 hours** end-to-end (coverage + AI suite + ~25 mutants × human+AI).

**Why this component (≤5 bullets):**

1. Fits **100–400 LOC** with a single cohesive combinatorial algorithm — not Heap/OrderedSet/snapshot dump from prior experiments.
2. Human suite **directly** exercises count + enumeration + empty/oob + lazy on this file only.
3. Branchy iterator/`binomial`/`kRange` logic supports **~24–28** realistic mutants without padding.
4. Deterministic SwiftPM XCTest; filterable and extremely fast for repeated mutation runs.
5. Stronger than Unique (too thin), Chunked/Permutations (too large), Partition (broader multi-API surface at the upper LOC edge).

### Fairness concerns

| Concern | Mitigation / note |
|---|---|
| Only **4** human test methods | Methods are dense (many assertions); freeze filter as-is — do not expand after coverage/mutation. |
| Lazy tests may not stress iterator bugs | Fair shared limitation; AI suite should also target behavioral enumeration, not only lazy typing. |
| Some binomial edge cases may be hard to hit with small `n` | Prefer mutants that change observable combo lists/counts for modest inputs (`n≈4–6`). |
| Negative-`k` precondition | May yield crash kills for both suites; document as `KILLED-CRASH` if so. |

### Explicitly not recommended for #5

| Component | Why not |
|---|---|
| `Unique.swift` | Too few control-flow sites for 20+ non-padded mutants |
| `Chunked` / `Permutations` / `Intersperse` | LOC / fan-out too large for focused campaign |
| `Partition.swift` as primary | Viable, but multi-algorithm file at upper LOC band; Combinations is tighter |
| `Windows` / `AdjacentPairs` | Strong backups; deferred to keep algorithmic variety vs collection-index wrappers |

---

## Stop line

Candidate selection for Experiment #5 is complete. Production scope and human filter are **frozen** as above. Proceed to Stage 2 (Human Baseline).
