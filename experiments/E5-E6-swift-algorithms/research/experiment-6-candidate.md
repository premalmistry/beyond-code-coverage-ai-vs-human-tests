# Experiment #6 Candidate Selection

**Repository:** [apple/swift-algorithms](https://github.com/apple/swift-algorithms)  
**Pinned SHA:** `5b7143f8e291dee0e14c118fd0212487f0b37af5`  
**Date (UTC):** `2026-08-13T14:15:00Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**Out of scope:** `Combinations.swift` (Experiment #5). Do not closely duplicate combinatorial generation.

**This document only selects the Experiment #6 component.** No AI tests, no mutations, no production/test edits.

---

## 1. Setup reminder

```bash
cd /Users/premalmistry/Desktop/Projects/AppPerformanceAnalyzer/swift-algorithms
git rev-parse HEAD   # 5b7143f8e291dee0e14c118fd0212487f0b37af5

# Qualified filters (Runbook v2)
swift test --filter SwiftAlgorithmsTests.PartitionTests      # 10 PASS
swift test --filter SwiftAlgorithmsTests.WindowsTests         # 8 PASS
swift test --filter SwiftAlgorithmsTests.AdjacentPairsTests   # 12 PASS
swift test --filter SwiftAlgorithmsTests.UniqueTests          # 3 PASS
```

---

## 2. Candidates evaluated

| Component | Target file(s) | LOC | Human tests | Logic type | Mutation potential | Difficulty |
|---|---|---:|---|---|---|---|
| **`partition` family** | `Sources/Algorithms/Partition.swift` | **389** | **`PartitionTests`**: **10** methods (~208 LOC) | Stable recursive partition + rotate; unstable half-stable & bidirectional two-pointer; binary `partitioningIndex`; `partitioned` split | **High** — n/2 split, predicate polarity, lo/hi walks, swap/omit, pivot returns; **~24–28** mutants | **Low–Medium** — ~0.1s suite; deterministic |
| **`windows(ofCount:)`** | `Sources/Algorithms/Windows.swift` | **365** | **`WindowsTests`**: **8** methods | Sliding-window Collection index arithmetic | **High** — dense offsets; **~25–30** | **Low** — but “index wrapper” flavor closer to AdjacentPairs than algorithmic contrast to Combinations |
| **`adjacentPairs`** | `Sources/Algorithms/AdjacentPairs.swift` | **323** | **`AdjacentPairsTests`**: **12** methods | Pairwise Sequence + Collection indices | **Medium–High** | **Low** — solid backup |
| **`uniqued`** | `Sources/Algorithms/Unique.swift` | **145** | **`UniqueTests`**: **3** methods | Seen-set uniqueness | **Low** — few branches; **&lt;20** without padding | **Low** — reject |
| **`indexed`** | `Sources/Algorithms/Indexed.swift` | **116** | thin | Index/element pairs wrapper | **Low** | **Low** — reject |
| **`permutations` / `chunked` / `interspersed`** | 608 / 929 / 684 LOC | Large | Existing suites | Generation / chunking / insert separators | High but oversize | **High** — exceed focused 100–400 preference |

### Evidence: human tests ↔ production (recommended)

| Test method | Production surface |
|---|---|
| `testStablePartition` / `testStablePartitionWithSubrange` | `stablePartition(by:)` / `stablePartition(subrange:by:)` (+ internal recursive helper) |
| `testPartitionWithSubrangeMutableCollection` | `MutableCollection.partition(subrange:by:)` (half-stable) |
| `testPartitionWithSubrangeBidirectionalCollection` | Bidirectional two-pointer `partition(subrange:by:)` |
| `testPartitioningIndex*` | `partitioningIndex(where:)` |
| `testPartitioned` / `testPartitionedWithPredicate` | `partitioned(by:)` |

---

## 3. Recommendation: `Partition.swift`

**Exact production file(s):**

- Primary (frozen): `Sources/Algorithms/Partition.swift` (**389 LOC**)

**Exact human test suite/filter (qualified — Runbook v2):**

```bash
swift test --filter SwiftAlgorithmsTests.PartitionTests
```

Expected: **10** tests, ~0.1s after build. Must execute **zero** `AIGenerated*` tests.

**Estimated meaningful mutations:** **24–28** (base cases `n==0`/`n==1`, half-split, predicate polarity, lo/hi loops, swap omission, pivot returns, binary-search midpoint, partitioned append polarity).

**Why this component:**

1. Fits **100–400 LOC**; cohesive partition API family — **not** Combinations.
2. Human suite **directly** exercises stable, unstable, indexing, and split APIs.
3. Branchy control flow supports **~24–28** real mutants without padding.
4. Deterministic SwiftPM XCTest; fast enough for full mutation campaign.
5. Stronger Human-vs-AI potential than Unique/Indexed (thin) and cleaner focus than Chunked/Permutations (oversized).

### Fairness concerns

| Concern | Mitigation |
|---|---|
| `stablePartition` calls `rotate(...)` outside this file | Mutate only `Partition.swift`; treat `rotate` as fixed. |
| Bidirectional vs MutableCollection overloads | Both covered by human tests; mutate each carefully with unique contexts. |
| Many crash kills possible from index misuse | Fair shared oracle; document crash/timeout kills. |

### Explicitly not recommended for #6

| Component | Why not |
|---|---|
| `Combinations.swift` | Experiment #5 |
| `Unique` / `Indexed` | Too thin for 20+ non-padded mutants |
| `Chunked` / `Permutations` / `Intersperse` | LOC / fan-out too large |
| `Windows` / `AdjacentPairs` | Strong backups; deferred for clearer algorithmic contrast |

---

## Stop line

Candidate selection for Experiment #6 is complete. Production scope and intended human filter are **frozen** as above. Proceed to Stage 2 (Human Baseline + contamination guard).
