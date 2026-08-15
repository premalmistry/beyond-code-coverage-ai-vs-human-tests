# Experiment #5 — Mutation Plan (`Combinations.swift`)

**Component (primary):** `Sources/Algorithms/Combinations.swift`  
**Repo SHA:** `5b7143f8e291dee0e14c118fd0212487f0b37af5`  
**Production SHA-256:** `a47a9033683f9be178ebd992398c1bc7c4f269c2eb02c2ac34cc7d3bd4dc2263`  

**Suites (frozen — do not modify):**  
- Human: `CombinationsTests` (4 methods)  
- AI: `AIGeneratedCombinationsTests` (27 methods; SHA-256 `e976602ed1a9a7546365a77dce298e130cee68d9645f8088bb7cdc8b52e529fa`)  

**Coverage (both, independently):** line **99.21%** / region **96.00%** / function **94.74%**  

**Status:** Plan only — **no mutants applied, no execution**

Predictions are **a priori** from the production API surface and known suite scopes (enumeration, counts, empty/oob, lazy). Suites were **not** re-opened to mine gaps while drafting mutants.

### Prediction key

| Label | Meaning |
|---|---|
| **Both kill** | Both frozen suites expected to fail ≥1 test (or crash under test) |
| **Human kill** | Human likely kills; AI may miss |
| **AI kill** | AI likely kills; human may miss |
| **Possibly survives** | May be equivalent / weakly observed |

### Recommended execution filters (later — not run now)

```bash
swift test --filter SwiftAlgorithmsTests.CombinationsTests
swift test --filter AIGeneratedCombinationsTests
```

**Timeout:** 30 seconds wall-clock per suite run.

---

## Proposed mutations

| ID | Source location | Original | Mutation | Expected behavioral defect | Human prediction | AI prediction | Risk |
|---|---|---|---|---|---|---|---|
| **E5-M01** | init `kRange` L56 | `range.lowerBound < upperBound` | `range.lowerBound <= upperBound` | Ranges starting at `n+1` no longer become `nil`; may clamp to empty vs empty-nil inconsistently | Both kill | Both kill | possible equivalent for some empty cases |
| **E5-M02** | init clamp L57 | `range.clamped(to: 0..<upperBound)` | `range.clamped(to: 0..<(upperBound - 1))` | Drops largest legal `k` (`k == n`) from range | Both kill | Both kill | — |
| **E5-M03** | init L56–58 | else branch sets `nil` | else sets `0..<0` | Out-of-range `k` yields empty range object instead of `nil`; `count` path differs (`guard let` vs empty map) | Possibly survives | Possibly survives | **possible equivalent** (`count` of empty range vs `nil` both 0; iteration may match) |
| **E5-M04** | `count` L64 | `guard let k = self.kRange else { return 0 }` | `else { return 1 }` | Fully out-of-range sequences report count 1 | Both kill | Both kill | — |
| **E5-M05** | `count` L66 | `if k == 0..<(n + 1)` | `if k == 0..<n` | Full power-set range misses `k == n`; uses slow path / wrong total | Both kill | Both kill | — |
| **E5-M06** | `count` L67 | `return 1 << n` | `return 1 << (n - 1)` | Power-set count halved | Both kill | Both kill | — |
| **E5-M07** | binomial L72 | `case n, 0: return 1` | `case n, 0: return 0` | `C(n,0)`/`C(n,n)` become 0 → wrong counts / empty-looking totals | Both kill | Both kill | — |
| **E5-M08** | binomial L73 | `case n...: return 0` | `case n...: return 1` | `k > n` contributes 1 instead of 0 (when reachable) | Possibly survives | Possibly survives | may be hard to hit if clamp prevents `k > n` |
| **E5-M09** | binomial L74 | `binomial(n: n, k: n - k)` | `binomial(n: n, k: k - 1)` | Broken symmetry reduction → wrong mid-range binomials | Both kill | Both kill | — |
| **E5-M10** | binomial L75 | `n * binomial(...) / k` | `n + binomial(...) / k` | Wrong multiplicative recurrence | Both kill | Both kill | — |
| **E5-M11** | `count` reduce L79–81 | `.reduce(0, +)` | `.reduce(1, *)` | Product of binomials instead of sum | Both kill | Both kill | — |
| **E5-M12** | `isFinished` L106 | `kRange.isEmpty` | `!kRange.isEmpty` | Iterator immediately finished or never finishes | Both kill | Both kill | possible timeout if never finishes |
| **E5-M13** | Iterator init L115 | `combinations.kRange ?? 0..<0` | `combinations.kRange ?? 0..<1` | Nil `kRange` iterates one empty combination instead of none | Both kill | Both kill | — |
| **E5-M14** | Iterator init L116 | `prefix(kRange.lowerBound)` | `prefix(kRange.lowerBound + 1)` | Starts with wrong combination size (off-by-one) | Both kill | Both kill | possible crash if prefix too long |
| **E5-M15** | `advanceKRange` L142 | `if kRange.lowerBound < kRange.upperBound` | `if kRange.lowerBound <= kRange.upperBound` | Advances past empty / corrupts range when finished | Both kill | Both kill | possible timeout/crash |
| **E5-M16** | `advanceKRange` L143 | `kRange.lowerBound + 1` | `kRange.lowerBound + 2` | Skips a combination size in multi-`k` ranges | Both kill | Both kill | — |
| **E5-M17** | `advanceKRange` L146 | `prefix(kRange.lowerBound)` | `prefix(kRange.upperBound)` | After advancing size, rebuilds indexes with wrong length | Both kill | Both kill | possible crash |
| **E5-M18** | `advance` L150 | `guard !indexes.isEmpty else` | `guard indexes.isEmpty else` | Inverts empty-index finishing path vs normal advance | Both kill | Both kill | possible timeout |
| **E5-M19** | `advance` L159 | `formIndex(after: &indexes[i])` | `formIndex(before: &indexes[i])` | Moves last index backward → wrong/duplicate/trap | Both kill | Both kill | possible crash |
| **E5-M20** | `advance` L160 | `if indexes[i] != base.endIndex { return }` | `if indexes[i] == base.endIndex { return }` | Stops advancing when should continue / continues when should stop | Both kill | Both kill | possible timeout |
| **E5-M21** | `advance` L165 | `guard j >= 0 else` | `guard j > 0 else` | Finishes one step early when first index exhausts | Both kill | Both kill | — |
| **E5-M22** | `advance` L173 | `base.index(after: indexes[k - 1])` | `indexes[k - 1]` | Propagation copies prior index → duplicate indexes / wrong combos | Both kill | Both kill | — |
| **E5-M23** | `advance` L174 | `if indexes[k] == base.endIndex` | `if indexes[k] != base.endIndex` | Break condition inverted → broken cascade | Both kill | Both kill | possible timeout |
| **E5-M24** | `next` L183 | `guard !isFinished else { return nil }` | `guard isFinished else { return nil }` | Returns values only when finished (always nil in practice) | Both kill | Both kill | — |
| **E5-M25** | `next` L184–185 | `defer { advance() }; return indexes.map…` | remove `defer { advance() }` | Infinite first combination / never advances | Both kill | Both kill | possible timeout |
| **E5-M26** | fixed-`k` API L307 | `precondition(k >= 0, …)` | `precondition(k > 0, …)` | `k == 0` traps instead of yielding `[[]]` | Both kill | Both kill | crash kill |

---

## Frozen set

| | |
|---|---|
| **Recommended frozen set** | **E5-M01 … E5-M26** (**26** mutants) |
| Band | Within 20–30; quality over padding |
| File scope | Entirely in `Sources/Algorithms/Combinations.swift` |
| Excluded on purpose | Comment-only edits; renaming; LazySequenceProtocol empty extension; docs |

---

## Final review checklist

| # | Check | Result |
|---|---|---|
| 1 | All mutants in frozen production file | **Yes** |
| 2 | ~20–30 meaningful mutants | **26** |
| 3 | No suite edits after observing results | N/A (pre-execution) |
| 4 | Same mutants for Human and AI | **Yes** (protocol) |
| 5 | Predictions recorded before execution | **Yes** |

**Mutation set is frozen.** Proceed to Stage 5 execution without altering this plan.
