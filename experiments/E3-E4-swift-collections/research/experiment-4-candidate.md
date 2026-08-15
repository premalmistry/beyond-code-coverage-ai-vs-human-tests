# Experiment #4 Candidate Selection

**Repository:** [apple/swift-collections](https://github.com/apple/swift-collections)  
**Pinned SHA:** `f3e778f17a438371c5b8c170f15c0d997bb417ee` (same pin as Experiment #3)  
**Date (UTC):** `2026-08-13T04:18:08Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**This document only selects the Experiment #4 component.** No AI tests, no mutations, no production/test edits.  
**Out of scope:** `HeapModule` (already used in Experiment #3).

---

## 1. Setup reminder

Repo already cloned at this SHA. Smoke checks used for candidate filters:

```bash
swift test --filter OrderedSetDiffingTests
# → 9 tests PASS (~0.3s suite body)

swift test --filter 'OrderedSetTests.test_append$|OrderedSetTests.test_append_many|OrderedSetTests.test_append_contentsOf|OrderedSetTests.test_insert_at|OrderedSetTests.test_update_at|OrderedSetTests.test_updateOrAppend|OrderedSetTests.test_updateOrInsert|OrderedSetTests.test_replace'
# → 10 tests PASS (~1.0s suite body)

swift test --filter DequeTests
# → 119 tests PASS (~7.5s; mixes Deque + Rigid/Unique/RRC/Mutable)
```

---

## 2. Candidates evaluated

| Component | Target file(s) | LOC | Human tests | Logic type | Mutation potential | Difficulty |
|---|---|---:|---|---|---|---|
| **`OrderedSet` insertions** | `Sources/OrderedCollections/OrderedSet/OrderedSet+Insertions.swift` | **328** | **10** focused methods in `OrderedSetTests` (append / insert / update / replace / updateOr*); full suite is 103 methods / ~27s | Order-preserving insert/append, duplicate rejection, in-place update, replace-via-swap, hash-table registration / capacity regenerate | **High** — capacity/table guards, `(inserted, index)` returns, `existing == index` vs duplicate, update vs insert branches; **~25–28** solid mutants | **Low–Medium** — filtered run ~1s; isolated file; not Heap |
| **`OrderedSet` diffing** | `Sources/OrderedCollections/OrderedSet/OrderedSet+Diffing.swift` | **102** | **`OrderedSetDiffingTests`**: **9** methods (~149 LOC); directly calls `difference(from:)` + `applying` | Specialized membership-aware collection diff (insert/remove/move association) | **Medium** — dense `if`/`else` distance compares; **~18–24** without padding; thin on `applying` | **Low** — fastest suite; risk of under-filled 25–30 mutant band |
| **`Deque` core** | `Deque._UnsafeHandle.swift` (**821**) + `Deque+Collection.swift` (**922**); full Deque subtree **~2.6k** | Large | `DequeTests` filter runs **119** tests across Deque/Rigid/Unique/RRC (~7.5s) | Ring-buffer slots, wraparound, range replace | **High** but sprawling | **High** — exceeds focused 100–400 LOC; hard to finish full AI+mutation loop tonight |
| **`OrderedDictionary` core** | `OrderedDictionary.swift` (**1,061**) ± Elements/Values | **1k+** | `OrderedDictionaryTests` **82** methods (+ Elements/Values suites) | Ordered map + hash table coordination | **High**, multi-file | **High** — too large for tonight; overlaps HashTable surface |
| **`OrderedSet` (whole type)** | Many Partial SetAlgebra / Move / UnorderedView files (**~6.7k**) | Huge | `OrderedSetTests` **103** / ~27s | Set algebra + order | High but fragmented | **High** — not a single focused component |

### Evidence: human tests ↔ production (recommended target)

These `OrderedSetTests` methods **directly** exercise `OrderedSet+Insertions.swift` APIs:

| Test method | Production API in Insertions file |
|---|---|
| `test_append`, `test_append_many`, `test_append_contentsOf` | `append`, `_append`, `_appendNew`, `append(contentsOf:)` |
| `test_insert_at` | `insert(_:at:)`, `_insertNew` |
| `test_update_at` | `update(_:at:)` |
| `test_updateOrAppend` | `updateOrAppend` |
| `test_updateOrInsert_existing`, `test_updateOrInsert_new` | `updateOrInsert` |
| `test_replace_at`, `test_replace_at_equalElement` | `replace(at:with:)`, `_replaceNew` |

(Full `OrderedSetTests` also covers set algebra elsewhere — **do not** use the unfiltered 103-test suite as the Experiment #4 human baseline filter.)

---

## 3. Recommendation: `OrderedSet+Insertions.swift`

**Exact production file(s):**

- Primary: `Sources/OrderedCollections/OrderedSet/OrderedSet+Insertions.swift` (**328 LOC**)
- Supporting (coverage/understanding only if needed): hash lookup lives in other OrderedSet/`_HashTable` files — **do not** expand the mutation surface there unless a mutant cannot be expressed in Insertions alone.

**Exact human test suite/filter:**

```bash
swift test --filter 'OrderedSetTests.test_append$|OrderedSetTests.test_append_many|OrderedSetTests.test_append_contentsOf|OrderedSetTests.test_insert_at|OrderedSetTests.test_update_at|OrderedSetTests.test_updateOrAppend|OrderedSetTests.test_updateOrInsert|OrderedSetTests.test_replace'
```

Expected: **10** tests, ~1s after build.

**Estimated meaningful mutations:** **25–28** (guards, return pairs, equal-replace vs insert-new, capacity regenerate vs bucket write, index handling in `replace` / `updateOrInsert`).

**Expected experiment duration (tonight):** ~**3–4 hours** end-to-end (human baseline → AI suite → 25–28 mutants × human+AI filters), similar to Experiment #3. Mutation wall time dominated by rebuilds; each filtered run is ~1s (much cheaper than full OrderedSetTests).

**Why this component (≤5 bullets):**

1. Fits the **100–400 LOC** band with a single cohesive file of insert/update/replace algorithms — not a priority queue (unlike Heap).
2. Human tests **directly** call these APIs; a tight 10-test filter avoids dragging in unrelated set-algebra coverage.
3. Branchy control flow supports **~25–28** real mutants without padding or uncovered-helper noise.
4. Deterministic SwiftPM XCTest; no UI/network; filterable and fast enough for a full mutation campaign tonight.
5. Stronger than Diffing (thin mutant budget) and Deque/OrderedDictionary (too large / sprawling for tonight).

### Fairness concerns

| Concern | Mitigation / note |
|---|---|
| Some paths call `_find` / `_regenerateHashTable` outside this file | Mutate only Insertions control flow/returns; treat external helpers as fixed. Score mutants that are observably wrong via public insert/update/replace results + invariants. |
| `_checkInvariants()` may kill many mutants for **both** suites | Fair (shared oracle); document if many kills are assert/invariant rather than assertion diffs. |
| Human filter is **narrow** (10 tests) vs full OrderedSetTests | Intentional: keeps coverage tied to the selected file and runtime feasible; AI suite should target the **same** Insertions API surface for a fair score. |
| Diffing is faster but may force artificial mutants to reach 25–30 | Rejected as primary for that reason. |

### Explicitly not recommended for #4

| Component | Why not |
|---|---|
| Full `Deque` / `Deque._UnsafeHandle` | LOC and test fan-out too large for tonight |
| Full `OrderedDictionary` / full `OrderedSet` | Multi-file / multi-thousand LOC |
| `OrderedSet+Diffing` alone | Excellent isolation, but likely **&lt;25** non-padded mutants |
| Anything in `HeapModule` | Used in Experiment #3 |

---

## Stop line

Candidate selection for Experiment #4 is complete. **Do not generate AI tests, mutations, or baselines until the next step is requested.**
