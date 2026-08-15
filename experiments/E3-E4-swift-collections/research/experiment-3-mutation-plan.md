# Experiment #3 — Mutation Plan (`Heap+UnsafeHandle.swift`)

**Component (primary):** `Sources/HeapModule/Heap+UnsafeHandle.swift`  
**Supporting (one mutant only):** `Sources/HeapModule/_HeapNode.swift`  
**Repo SHA:** `f3e778f17a438371c5b8c170f15c0d997bb417ee`  
**Production SHA-256 (handle):** `c610016a3f2601a2cc6466f90ba05a843d219490ea994421f77bb56bceda2270`  
**Suites (frozen):**  
- Human: `HeapTests` + `HeapNodeTests` (**32** methods; do **not** include `AIGeneratedHeapTests`)  
- AI: `AIGeneratedHeapTests` (**50** methods; SHA-256 `5b0ed2763cf62f080029a76d911a10a1c5a23cec08c8eefe1e2289263aeca0ff`)  

**Status:** Plan only — **no mutants applied, no execution**

Predictions are **a priori**, based on suite scope from the baselines (not on mutation outcomes). Both suites reached identical primary-file coverage (99.03% line / 98.28% region / 97.14% function), so most core comparison flips are predicted **Yes/Yes**. Residual differences are expected mainly on **equality/tie-break** edges and a few path-specific guards.

### Prediction key

| Label | Meaning |
|---|---|
| **Yes** | Expected to fail ≥1 test in that frozen suite |
| **Likely** | Expected to fail; depends on inputs / equality cases |
| **No** | Suite unlikely to observe this fault |
| **Uncertain** | Subtle / may SURVIVE or only fail intermittently |

### Recommended execution filters (for later — not run now)

```bash
# Human only (exclude AI suite — `--filter HeapTests` also matches AIGeneratedHeapTests)
swift test --filter 'HeapTests.HeapTests|HeapNodeTests'

# AI only
swift test --filter AIGeneratedHeapTests
```

---

## Proposed mutations

| ID | Mutation | Source location | Expected bug | Human expected | AI expected |
|---|---|---|---|---|---|
| **E3-M01** | In `minValue`: `self[b] < self[a] ? b : a` → `self[b] > self[a] ? b : a` | `Heap+UnsafeHandle.swift` L91 | Descendant “min” selection becomes max → wrong trickle-down / corrupt heap | **Yes** | **Yes** |
| **E3-M02** | In `minValue`: `<` → `<=` | L91 | On equal keys, prefer `b` instead of `a` (breaks documented tie / identity order) | **Yes** (tie-break tests) | **Likely** (duplicates exercised; may not assert identity order) |
| **E3-M03** | In `maxValue`: `self[b] >= self[a] ? b : a` → `self[b] < self[a] ? b : a` | L97 | “Max” selection inverted | **Yes** | **Yes** |
| **E3-M04** | In `maxValue`: `>=` → `>` | L97 | On equal keys, prefer `a` instead of `b` (tie-break / identity) | **Yes** (tie-break max) | **Likely** |
| **E3-M05** | `bubbleUp` parent swap (min-level arm): `self[node] > self[parent]` → `self[node] < self[parent]` | L109 | Min-level node wrongly swaps toward larger parent / fails to swap when too large | **Yes** (insert / descending insert) | **Yes** |
| **E3-M06** | `bubbleUp` parent swap (max-level arm): `self[node] < self[parent]` → `self[node] > self[parent]` | L110 | Max-level parent-swap condition inverted | **Yes** | **Yes** |
| **E3-M07** | `bubbleUp` grandparent section: `if node.isMinLevel` → `if !node.isMinLevel` | L115 | Min- vs max-level grandparent bubble logic swapped | **Yes** | **Yes** |
| **E3-M08** | `bubbleUp` min-level grandparent: `self[node] < self[grandparent]` → `self[node] > self[grandparent]` | L117 | Bubbles the wrong direction on min levels | **Yes** | **Yes** |
| **E3-M09** | `bubbleUp` max-level grandparent: `self[node] > self[grandparent]` → `self[node] < self[grandparent]` | L123 | Bubbles the wrong direction on max levels | **Yes** | **Yes** |
| **E3-M10** | `bubbleUp` parent condition: drop max-level arm — keep only `(node.isMinLevel && self[node] > self[parent])` | L109–110 | Max-level nodes never parent-swap before grandparent loop | **Yes** | **Yes** |
| **E3-M11** | `_trickleDownMin` 4-grandchild loop: `gc0.offset &+ 3 < count` → `gc0.offset &+ 3 <= count` | L154 | Loop enters with `gc3` at `offset == count` → **OOB read / crash** | **Yes** (crash/fail) | **Yes** (crash/fail) |
| **E3-M12** | `_trickleDownMin` stop guard: `self[min] < value` → `self[min] > value` | L166 | Continues sinking when done / stops when should continue | **Yes** | **Yes** |
| **E3-M13** | `_trickleDownMin` parent re-check: `self[parent] < value` → `self[parent] > value` | L175 | Wrong parent↔value swap after moving to grandchild | **Yes** | **Yes** |
| **E3-M14** | `_trickleDownMin` no-child return: `c0.offset >= count` → `c0.offset > count` | L184 | Treats `offset == count` as valid child → **OOB** | **Yes** (crash/fail) | **Yes** (crash/fail) |
| **E3-M15** | `_trickleDownMin` partial stop: `self[min] < value` → `self[min] <= value` | L188 | On equal descendant, refuses to sink (ordering / duplicate edge) | **Likely** | **Likely** |
| **E3-M16** | `_trickleDownMin` child-vs-grandchild: `if min < gc0` → `if min > gc0` | L195 | Parent fix-up runs for children / skipped for grandchildren (inverted) | **Yes** | **Yes** |
| **E3-M17** | `_minDescendant` 3-gc gate: `gc0.offset &+ 2 < count` → `gc0.offset &+ 2 <= count` | L221 | Misclassifies 2-gc vs 3-gc case; may OOB on `gc2` | **Yes** | **Yes** |
| **E3-M18** | `_minDescendant` two-child return: `minValue(c0, c1)` → `maxValue(c0, c1)` | L242 | Picks larger child when only children exist | **Yes** | **Yes** |
| **E3-M19** | `_trickleDownMax` stop guard: `value < self[max]` → `value > self[max]` | L277 | Max-sink stop condition inverted | **Yes** | **Yes** |
| **E3-M20** | `_trickleDownMax` parent re-check: `value < self[parent]` → `value > self[parent]` | L286 | Wrong parent swap on max trickle | **Yes** | **Yes** |
| **E3-M21** | `_trickleDownMax` child-vs-grandchild: `if max < gc0` → `if max > gc0` | L306 | Parent fix-up inverted (symmetric to M16) | **Yes** | **Yes** |
| **E3-M22** | `_maxDescendant` two-child return: `maxValue(c0, c1)` → `minValue(c0, c1)` | L353 | Picks smaller child on max path | **Yes** | **Yes** |
| **E3-M23** | `_trickleDownMax` 4-gc loop bound: `gc0.offset &+ 3 < count` → `gc0.offset &+ 2 < count` | L265 | Treats incomplete grandchild sets as full 4-gc path; skips needed child compares / wrong node | **Yes** | **Yes** |
| **E3-M24** | `heapify` limit: `count / 2` → `count` | L368 | Runs trickle on leaves / wrong Floyd frontier → broken heap or wasted wrong nodes | **Yes** (collection init / `removeAll` rebuild) | **Yes** |
| **E3-M25** | `_heapify` level branch: `isMinLevel(level)` → `!isMinLevel(level)` | L380 | Floyd applies `trickleDownMax` on min levels and vice versa | **Yes** | **Yes** |
| **E3-M26** | `heapify` level walk: `level &-= 1` → `level &+= 1` | L373 | Level counter moves away from root → **infinite loop / hang** | **Yes** (hang/timeout = kill) | **Yes** (hang/timeout = kill) |
| **E3-M27** | `heapify` loop: `while level >= 0` → `while level > 0` | L370 | Skips root-level `trickleDownMin` → heapify incomplete | **Yes** | **Yes** |
| **E3-M28** | `_HeapNode.isMinLevel`: `level & 0b1 == 0` → `level & 0b1 == 1` | `_HeapNode.swift` L77 | Global min/max level polarity flipped (bubble + heapify + package `_isMinLevel`) | **Yes** (`test_levelCalculation` + heap ops) | **Yes** (`testIsMinLevelOffsetsEvenLevels` + heap ops) |

---

## Frozen set

| | |
|---|---|
| **Recommended frozen set** | **E3-M01 … E3-M28** (**28** mutants) |
| Band | Within requested 25–30 |
| Primary file | 27 mutants in `Heap+UnsafeHandle.swift` |
| Supporting file | **E3-M28** only (`_HeapNode.isMinLevel`) |

Do **not** pad further. These are all non-trivial algorithmic faults (comparisons, bounds, level polarity, Floyd control flow).

---

## Flags

### Possibly equivalent / weak signal

| ID | Note |
|---|---|
| **E3-M02 / E3-M04** | Only observable when equal elements exist **and** tests check identity / stable tie behavior. Human tie-break tests make **non-equivalence likely**; AI may SURVIVE if it only checks numeric multiset / min/max values. |
| **E3-M15** | `<=` vs `<` on stop may be hard to hit without equal descendant vs `value`; both suites use duplicates, but path may still be rare → **Uncertain/Likely**, not guaranteed. |

### Likely crash / hang

| ID | Risk |
|---|---|
| **E3-M11** | OOB read in 4-gc min loop (`<=` bound) — expect trap / XCTest crash → count as **KILLED** |
| **E3-M14** | OOB when `leftChild.offset == count` |
| **E3-M17** | Possible OOB on misclassified 3-gc branch |
| **E3-M26** | **Hang** in `heapify` (`level += 1`) — use a wall-clock timeout; timeout ⇒ **KILLED** |

### Overlapping behavior (keep all; distinct sites)

| Cluster | IDs | Relationship |
|---|---|---|
| Min vs max selection helpers | M01–M04, M18, M22 | Shared symptom (wrong extreme), different operators / call sites |
| `bubbleUp` ordering | M05–M10 | Parent vs grandparent vs level-gate; M07 overlaps conceptually with M28 but M07 is local to grandparent block |
| Trickle stop / parent fix-up | M12–M13, M19–M20 | Min/max symmetric pair |
| Child vs grandchild parent fix-up | M16, M21 | Symmetric |
| Level polarity | M07, M25, M28 | M28 is global; M07/M25 are local control-flow swaps |
| Floyd / heapify control | M24–M27 | Different failure modes (limit, polarity, hang, skip root) |

---

## Predicted catch matrix (frozen set)

| Prediction | IDs |
|---|---|
| Both **Yes** | M01, M03, M05–M14, M16–M23, M24–M28 |
| Human **Yes**, AI **Likely** | M02, M04 |
| Both **Likely** / **Uncertain** | M15 |
| AI-only / human-only expected | *(none strongly predicted)* — coverage parity implies few AI-only kills; M02/M04 are the main human-leaning edge |

**A priori expectation:** both suites kill the large majority; mutation-score gap (if any) likely concentrates on **tie-break equality** mutants (M02/M04) and possibly **M15**.

---

## Avoided (not proposed)

- Comment / doc-only edits  
- Uncovered unused helpers: `_modify`, `rightChild()`, `lastGrandchild()`, `_HeapNode.description`, `_HeapNode.==`  
- `_heapify` nil-`nodes` early-return (uncovered arm — low-quality mutant)  
- Purely cosmetic renames / dead local tweaks  
- Guaranteed compile errors (type mismatches, removing required returns)  
- Artificial “padding” mutants outside heap algorithm logic  
- Mutations only in `Heap.swift` public wrappers (out of primary surface)

---

## Protocol notes for later execution (do not run yet)

1. Apply **one** mutant at a time; restore production file(s) after each.  
2. Confirm production SHA-256 matches baseline before each apply.  
3. Run human filter, then AI filter, record PASS/FAIL/CRASH/TIMEOUT.  
4. Never edit frozen human or AI suites.  
5. For **E3-M26** (and any apparent hang), use an explicit timeout (e.g. 30–60s) and classify timeout as **KILLED**.

---

## Stop line

Mutation plan complete (**28** frozen mutants **E3-M01–E3-M28**). **Do not execute mutations until the next step is requested.**
