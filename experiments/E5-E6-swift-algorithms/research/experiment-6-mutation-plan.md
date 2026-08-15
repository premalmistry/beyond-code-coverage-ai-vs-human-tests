# Experiment #6 — Mutation Plan (`Partition.swift`)

**Component (primary):** `Sources/Algorithms/Partition.swift`  
**Repo SHA:** `5b7143f8e291dee0e14c118fd0212487f0b37af5`  
**Production SHA-256:** `bef59fabc5958af321b728fb4bac230ff875db3135d17b6e5bee0216a8be3644`  

**Suites (frozen — do not modify):**  
- Human: `SwiftAlgorithmsTests.PartitionTests` (10 methods; inventory in human-baseline)  
- AI: `AIGeneratedPartitionTests` (29 methods; SHA-256 `2ed75624b2a22bf13f7911512fa3e1cf0b19385415a4d06916e8d92078725c59`)  

**Coverage:** Human 89.81% / 88.61% / 81.82%; AI 95.83% / 96.20% / 90.91%  

**Status:** Plan only — **no mutants applied, no execution**

Predictions are **a priori** from the production API surface. Suites were **not** re-opened to mine gaps while drafting mutants.

### Prediction key

| Label | Meaning |
|---|---|
| **Both kill** | Both frozen suites expected to fail ≥1 test (or crash) |
| **Human kill** | Human likely kills; AI may miss |
| **AI kill** | AI likely kills; human may miss |
| **Possibly survives** | May be equivalent / weakly observed |

### Recommended execution filters

```bash
swift test --filter SwiftAlgorithmsTests.PartitionTests
swift test --filter AIGeneratedPartitionTests
```

**Timeout:** 30 seconds wall-clock per suite run.

---

## Proposed mutations

| ID | Source location | Original | Mutation | Expected behavioral defect | Human prediction | AI prediction | Risk |
|---|---|---|---|---|---|---|---|
| **E6-M01** | stablePartition n==0 | `return subrange.lowerBound` | `return subrange.upperBound` | Empty range returns wrong pivot | Both kill | Both kill | — |
| **E6-M02** | stablePartition n==1 ternary | true→lower / false→upper | **swap** arms | Single-element pivot polarity wrong | Both kill | Both kill | — |
| **E6-M03** | stablePartition half | `let h = n / 2` | `let h = n / 2 + 1` | Uneven split / off-by-one recursion | Both kill | Both kill | possible crash |
| **E6-M04** | stablePartition recurse counts | left `h`, right `n - h` | **swap** counts (`n-h` then `h`) | Wrong subtree sizes | Both kill | Both kill | possible crash |
| **E6-M05** | stablePartition rotate | `toStartAt: i` | `toStartAt: j` | Wrong merge of partitions | Both kill | Both kill | — |
| **E6-M06** | MC partition no-match | `return subrange.upperBound` | `return subrange.lowerBound` | Empty second partition reports start | Both kill | Both kill | AI half-stable tests |
| **E6-M07** | MC partition swap condition | `if try !belongs…` | `if try belongs…` | Swaps wrong elements | Both kill | Both kill | — |
| **E6-M08** | MC partition | `swapAt(i, j); formIndex(after: &i)` | omit `swapAt` keep advance | Misses moves into first partition | Both kill | Both kill | — |
| **E6-M09** | MC partition | keep swap; omit `formIndex(after: &i)` | pivot index stalls | Wrong pivot / broken invariant | Both kill | Both kill | — |
| **E6-M10** | MC partition return | `return i` | `return j` | Pivot off by scan position | Both kill | Both kill | — |
| **E6-M11** | BD partition FindLo | `while lo < hi` | `while lo <= hi` | Over-scans / may trap | Both kill | Both kill | possible crash |
| **E6-M12** | BD partition FindLo break | `if try belongs… { break FindLo }` | `if try !belongs…` | Never finds lo candidate correctly | Both kill | Both kill | — |
| **E6-M13** | BD partition FindHi break | `if try !belongs… { break FindHi }` | `if try belongs…` | Never finds hi candidate correctly | Both kill | Both kill | — |
| **E6-M14** | BD partition | `swapAt(lo, hi)` | omit swap | Elements not exchanged | Both kill | Both kill | — |
| **E6-M15** | BD partition | `formIndex(after: &lo)` after swap | omit | lo/hi invariants break | Both kill | Both kill | possible timeout |
| **E6-M16** | BD partition return | `return lo` | `return hi` | Wrong pivot index | Both kill | Both kill | — |
| **E6-M17** | partitioningIndex loop | `while n > 0` | `while n > 1` | Skips last element search step | Both kill | Both kill | — |
| **E6-M18** | partitioningIndex half | `let half = n / 2` | `let half = (n + 1) / 2` | Wrong mid → wrong index | Both kill | Both kill | — |
| **E6-M19** | partitioningIndex branch | `if belongs { n = half } else {…}` | **invert** if/else bodies | Binary search polarity wrong | Both kill | Both kill | — |
| **E6-M20** | partitioningIndex else | `n -= half + 1` | `n -= half` | Off-by-one remaining length | Both kill | Both kill | — |
| **E6-M21** | Sequence partitioned | append rhs on true / lhs on false | **swap** append targets | Partitions reversed | AI kill | Both kill | Human may miss Sequence path |
| **E6-M22** | Collection partitioned empty | `guard !self.isEmpty else { return ([], []) }` | remove guard (always use unsafe path) | Empty may trap or mis-handle | Possibly survives | Both kill | possible crash |
| **E6-M23** | Collection partitioned | `if try predicate` → rhs else lhs | **swap** arms | Partitions reversed | Both kill | Both kill | — |
| **E6-M24** | Collection partitioned | `buffer[rhsIndex...].reverse()` | omit reverse | trueElements reversed | Both kill | Both kill | — |
| **E6-M25** | Collection partitioned | `midPoint = rhsIndex` | `midPoint = 0` | All elements reported as true partition | Both kill | Both kill | — |
| **E6-M26** | Sequence partitioned return | `return (lhs, rhs)` | `return (rhs, lhs)` | Tuple polarity reversed | AI kill | Both kill | Human Sequence uncovered |

---

## Frozen set

| | |
|---|---|
| **Frozen set** | **E6-M01 … E6-M26** (**26** mutants) |
| File scope | Entirely in `Sources/Algorithms/Partition.swift` |
| Excluded | Comment-only; rename; guaranteed compile errors; mutating `rotate` in other files |

### Concrete notes

- **E6-M21 / E6-M26** target `Sequence.partitioned` — Human may survive if only Collection overload is exercised; AI should kill.
- **E6-M22** removes the empty early-return on Collection `partitioned`.

---

## Final review checklist

| # | Check | Result |
|---|---|---|
| 1 | All mutants in frozen production file | **Yes** |
| 2 | ~20–30 meaningful mutants | **26** |
| 3 | Predictions before execution | **Yes** |
| 4 | Same mutants for Human and AI | **Yes** |

**Mutation set is frozen.** Proceed to Stage 5 execution without altering this plan.
