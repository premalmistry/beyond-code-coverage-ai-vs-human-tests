# Experiment #6 — Mutation Results (`Partition.swift`)

**Component:** `Sources/Algorithms/Partition.swift`  
**Frozen set:** E6-M01–E6-M26 (**26**) from `research/experiment-6-mutation-plan.md`  
**Repo SHA:** `5b7143f8e291dee0e14c118fd0212487f0b37af5`  
**Run date (UTC):** `2026-08-13T14:17:00Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**AI suite SHA-256:** `2ed75624b2a22bf13f7911512fa3e1cf0b19385415a4d06916e8d92078725c59`  
**Production SHA-256 (restored):** `bef59fabc5958af321b728fb4bac230ff875db3135d17b6e5bee0216a8be3644`

## Integrity (pre/post)

| Check | Result |
|---|---|
| Repo SHA | ✓ |
| Production / AI SHA-256 | ✓ |
| Human filter disjoint from AI | ✓ (contamination flags all false) |
| Suites unmodified after freeze | ✓ |

## Protocol

- Runner: `research/run_e6_mutations.py`
- Human: `SwiftAlgorithmsTests.PartitionTests` (10)
- AI: `AIGeneratedPartitionTests` (29)
- Timeout: 30s; per-mutant contamination check on executed names
- Logs: `research/mutation-logs-e6/`; mutants: `research/mutants-e6/`; JSONL: `research/experiment-6-mutation-results.jsonl`

## Results table

| Mutation | Human | AI | Notes |
|---|---|---|---|
| E6-M01: empty `n==0` return upper | SURVIVED | SURVIVED | → **INVALID-EQUIVALENT** |
| E6-M02: n==1 ternary swap | KILLED | KILLED | |
| E6-M03: `h = n/2+1` | KILLED-CRASH | KILLED-CRASH | |
| E6-M04: swap recurse counts | KILLED | KILLED | |
| E6-M05: `toStartAt: j` | KILLED | KILLED | |
| E6-M06: no-match → lowerBound | KILLED | KILLED | |
| E6-M07: invert swap predicate | KILLED | KILLED | |
| E6-M08: omit `swapAt` | KILLED | KILLED | |
| E6-M09: omit `formIndex` after swap | KILLED | KILLED | |
| E6-M10: `return j` | KILLED | KILLED | |
| E6-M11: `lo <= hi` | KILLED-CRASH* | KILLED-CRASH | *JSONL said INVALID; logs show assert + fatal → **killed** |
| E6-M12: invert FindLo break | KILLED | KILLED | |
| E6-M13: invert FindHi break | KILLED | KILLED | |
| E6-M14: omit `swapAt(lo,hi)` | KILLED | KILLED | |
| E6-M15: omit `formIndex(after:&lo)` | SURVIVED | SURVIVED | → **INVALID-EQUIVALENT** |
| E6-M16: `return hi` | SURVIVED | SURVIVED | → **INVALID-EQUIVALENT** |
| E6-M17: `while n > 1` | KILLED | KILLED | |
| E6-M18: half `(n+1)/2` | KILLED-CRASH | KILLED-TIMEOUT | Both killed |
| E6-M19: invert binary-search arms | KILLED | KILLED | |
| E6-M20: `n -= half` | KILLED-CRASH | KILLED-CRASH | |
| E6-M21: Sequence append swap | **SURVIVED** | **KILLED** | **AI-only** |
| E6-M22: remove empty guard | SURVIVED | SURVIVED | → **INVALID-EQUIVALENT** |
| E6-M23: Collection append swap | KILLED | KILLED | |
| E6-M24: omit `reverse()` | KILLED | KILLED | |
| E6-M25: `midPoint = 0` | KILLED | KILLED | |
| E6-M26: Sequence `return (rhs,lhs)` | **SURVIVED** | **KILLED** | **AI-only** |

## Equivalence assessments

### E6-M01 — INVALID-EQUIVALENT

For `n == 0`, `subrange` is empty, so `lowerBound == upperBound`. Returning either is the same index.

### E6-M15 — INVALID-EQUIVALENT

After `swapAt(lo, hi)`, `self[lo]` already belongs in the second partition. `FindHi` always starts with `formIndex(before: &hi)`, so progress is preserved on the high side. When the loop exits, `lo` still denotes the start of the second partition. Exhaustive bidirectional partition tests still pass — observable partition semantics unchanged.

### E6-M16 — INVALID-EQUIVALENT

On loop exit, Hoare-style invariants leave `lo == hi` (the pivot). Returning `hi` vs `lo` is the same index.

### E6-M22 — INVALID-EQUIVALENT

Removing the empty early-return still runs `unsafeUninitializedCapacity: 0` for empty collections, yields empty `elements`, `midPoint == 0`, and returns `([], [])`. Non-empty path unchanged.

### E6-M11 classifier note

JSONL recorded Human `INVALID` due to a heuristic on compile-ish log lines during a crashing run. Raw log shows XCTest failures and `Fatal error: Range requires lowerBound <= upperBound` / signal 5. **Scored as KILLED-CRASH** for Human.

## Scores

Mutation score = Killed / (Killed + Survived) × 100.

| Metric | Value |
|---|---|
| Total planned | **26** |
| Invalid / equivalent excluded | **4** (M01, M15, M16, M22) |
| Valid mutants | **22** |
| Human killed | **20** |
| Human survived | **2** (E6-M21, E6-M26) |
| Human mutation score | **90.9%** (20/22) |
| AI killed | **22** |
| AI survived | **0** |
| AI mutation score | **100.0%** (22/22) |
| Both killed | **20** |
| Human-only kills | **none** |
| AI-only kills | **E6-M21, E6-M26** |
| Both survived (valid) | **none** |
| Timeout kills | E6-M18 (AI) |

## Bucket IDs

| Bucket | IDs |
|---|---|
| INVALID-EQUIVALENT | E6-M01, E6-M15, E6-M16, E6-M22 |
| AI-only kills | E6-M21, E6-M26 |
| Human-only kills | — |
| Shared valid survivors | — |

## Notes

- AI-only kills are exactly the **`Sequence.partitioned`** mutants — Human baseline left that overload at 0% coverage (Array uses Collection overload); AI explicitly tested `AnySequence`.
- Coverage gap predicted mutation gap: similar pattern to prior experiments where equal-ish coverage still hid behavioral differences — here AI’s higher line coverage on Sequence path translated into unique kills.
