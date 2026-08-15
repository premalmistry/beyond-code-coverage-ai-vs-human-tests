# Experiment #3 Candidate Selection

**Repository:** [apple/swift-collections](https://github.com/apple/swift-collections)  
**Pinned SHA:** `f3e778f17a438371c5b8c170f15c0d997bb417ee`  
**Date (UTC):** `2026-08-13T02:22:51Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**This document only selects the next component.** No AI tests, no mutations, no production/test edits.

---

## 1. Setup

### Clone / pin

```bash
git clone --depth 1 https://github.com/apple/swift-collections.git
cd swift-collections
git rev-parse HEAD
# f3e778f17a438371c5b8c170f15c0d997bb417ee
swift --version
```

### Repository structure (high level)

| Path | Role |
|---|---|
| `Sources/HeapModule/` | Min-max heap |
| `Sources/DequeModule/` | Double-ended queue (+ Rigid/Unique variants) |
| `Sources/OrderedCollections/` | `OrderedSet`, `OrderedDictionary`, hash table |
| `Sources/BitCollections/` | `BitSet` / `BitArray` |
| `Sources/HashTreeCollections/` | Persistent hash trees |
| `Sources/RopeModule/`, `SortedCollections/`, … | Other collections (some unstable traits) |
| `Tests/*Tests/` | Per-module XCTest suites |
| `Package.swift` | Multi-module SwiftPM package |

### Smoke test

```bash
swift test --filter HeapTests
```

**Result:** PASS — `Executed 32 tests, with 0 failures` (~3s wall for suite body after build).

---

## 2. Candidates evaluated

Criteria: pure Swift, algorithmic logic, strong human tests, SwiftPM-filterable, small enough for a 3–4h loop, 20–30 meaningful mutants, no UI/network, deterministic assertions, **different** from Experiment #1 (URLRequest formatting) and #2 (Mirror dump).

| Component | Production LOC | Human tests | Logic type | Mutation potential | Experiment difficulty |
|---|---:|---|---|---|---|
| **`HeapModule`** (esp. `Heap+UnsafeHandle.swift` + `_HeapNode.swift` + `Heap.swift`) | **1,119** module; **390** / **176** / **397** in the three core files | **`HeapTests`**: 32 methods (~742 LOC tests; dense min/max/pop/insert/replace coverage) | Min-max heap: bubble-up / trickle-down, min vs max levels, heapify | **High** — comparisons, level parity (`isMinLevel`), child/grandchild selection, swap paths; 20–30 clear mutants | **Low–Medium** — `swift test --filter HeapTests`; coverage on 1–2 files |
| **`OrderedSet+Diffing.swift`** | **102** | `OrderedSetDiffingTests` (~149 LOC) | Specialized set difference / LCS-style change list | **Medium** — loop bounds, insert vs remove branches; may be thin for 20–30 without stretching | **Low** — small surface; risk of under-powered mutant set |
| **`Deque` core** (`Deque+Collection.swift`, `Deque._UnsafeHandle.swift`, …) | **~4.5k** for Deque subtree; individual hot files **821–1506** | `DequeTests` + RRC/Mutable suites (**thousands** of LOC; 8 files) | Ring-buffer indexing, wraparound, range-replaceable ops | **High**, but sprawling | **High** — hard to keep weekend scope; filtered runs still heavy |
| **`OrderedDictionary.swift` (+ Elements/Values)** | **1,061** alone; **~4k** with satellites | Large `OrderedDictionary Tests.swift` (**1,573** LOC) + Elements/Values | Ordered map + hash table coordination | **High**, multi-file | **High** — too large for 3–4h fair AI/human freeze |
| **`OrderedSet` insertions / set-algebra cluster** | Insertions **328**; many Partial SetAlgebra files **~70–160** each; module **~6.7k** | `OrderedSetTests.swift` **2,136** LOC | Membership + order-preserving updates | **High** but fragmented across many files | **Medium–High** — picking one algebra file is awkward; full OrderedSet is huge |

### Notes

- **Deque / Ordered\*** are excellent libraries but fail the “focused ~100–300 LOC + easy filter” preference used in Experiments #1–#2.
- **`OrderedSet` diffing** is elegant and small, but may not sustain 20–30 *non-equivalent* mutants without padding.
- **Heap** sits in the sweet spot: classical algorithm, dedicated module tests, mutations kill via wrong min/max — orthogonal to string formatting / reflection dumping.

---

## 3. Recommendation: `HeapModule` (min-max heap)

**Suggested experiment focus (MUT surface):**

1. Primary: `Sources/HeapModule/Heap+UnsafeHandle.swift` (**390 LOC**) — `bubbleUp`, `trickleDownMin` / `trickleDownMax`, descendant selection, `heapify`.
2. Secondary (as needed for node/level mutants): `Sources/HeapModule/_HeapNode.swift` (**176 LOC**).
3. Public API exercised by tests: `Sources/HeapModule/Heap.swift` (**397 LOC**) — keep unchanged unless a mutant must touch a call site; prefer mutating handle/node logic.

**Why this component (≤5 bullets):**

1. Pure algorithmic priority-queue logic (min-max heap), unrelated to URLRequest formatting or `Any.swift` dumps.
2. Strong, filterable human suite: `swift test --filter HeapTests` (32 passing tests).
3. Dense branching (min vs max levels, child/grandchild compares, bubble vs trickle) supports **20–30** realistic mutants.
4. Core mutation files (~176–390 LOC) fit a 3–4 hour AI baseline + mutation loop; coverage via `llvm-cov` on those paths is straightforward.
5. Deterministic XCTest assertions on `min`/`max`/`popMin`/`popMax`/`insert` — no UI, network, or nondeterministic hashing required for the main suite.

### Suggested later commands (not run for mutations tonight)

```bash
swift test --filter HeapTests --enable-code-coverage
# llvm-cov report … Sources/HeapModule/Heap+UnsafeHandle.swift
# llvm-cov report … Sources/HeapModule/_HeapNode.swift
```

---

## 4. Explicitly not recommended for #3

| Component | Why not |
|---|---|
| Full `DequeModule` / `OrderedDictionary` / full `OrderedSet` | Too large for a fair weekend/3–4h experiment |
| `OrderedSet+Diffing` alone | Possibly too small for 20–30 solid mutants |
| Hash-tree / Rope / Sorted (unstable) | Heavier surface, trait/unstable complexity |

---

## Stop line

Candidate selection complete. **Do not generate AI tests, mutations, or baselines for Experiment #3 until the next step is requested.**
