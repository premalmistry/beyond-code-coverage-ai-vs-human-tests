# Experiment #3 — Mutation Results (`Heap+UnsafeHandle.swift`)

**Component (primary):** `Sources/HeapModule/Heap+UnsafeHandle.swift`  
**Supporting mutant:** E3-M28 in `_HeapNode.swift`  
**Frozen set:** E3-M01–E3-M28 (**28**) from `research/experiment-3-mutation-plan.md`  
**Repo SHA:** `f3e778f17a438371c5b8c170f15c0d997bb417ee`  
**Run date (UTC):** `2026-08-13T03:00:33Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**AI suite SHA-256:** `5b0ed2763cf62f080029a76d911a10a1c5a23cec08c8eefe1e2289263aeca0ff`  
**Production restored SHA-256:**  
- `Heap+UnsafeHandle.swift`: `c610016a3f2601a2cc6466f90ba05a843d219490ea994421f77bb56bceda2270`  
- `_HeapNode.swift`: `0cc99c47754521861147d543d6ebd868ef7109296b9cb005c9c50bf471346736`

## Integrity

- One mutant at a time via `research/run_e3_mutations.py`; production restored from `research/*.ORIG` after each.
- Human filter excludes AI suite: `swift test --filter 'HeapTests.HeapTests|HeapNodeTests'` (**32** tests).
- AI filter: `swift test --filter AIGeneratedHeapTests` (**50** tests).
- Suites not modified.
- Crash / assertion-abort under a suite counted as **KILLED**.
- E3-M26 hang mutant killed via `_HeapNode` assertion (looped into invalid level range) before wall-clock timeout.
- Final verify: human **PASS** (32/0); AI **PASS** (50/0); production SHA match.
- Logs: `research/mutation-logs-e3/`; machine rows: `research/mutation-results-e3.jsonl`; mutant snapshots: `research/mutants-e3/`.

## Commands (per mutant)

```bash
python3 research/run_e3_mutations.py          # full campaign
# or: python3 research/run_e3_mutations.py E3-M04

# Internally, each mutant:
#   apply patch →
#   swift test --filter 'HeapTests.HeapTests|HeapNodeTests'
#   swift test --filter AIGeneratedHeapTests
#   restore ORIG backups + SHA check
```

## Results table

| Mutation | Human | AI | Human failing tests | AI failing tests | Notes |
|---|---|---|---|---|---|
| E3-M01: `minValue` `<`→`>` (L91) | KILLED | KILLED | test_initializer_fromCollection, test_insert_contentsOf, … (+12) | testAlternatingPopMinPopMax, testDeterministicPermutationRoundTripPopMin, … (+25) | |
| E3-M02: `minValue` `<`→`<=` (L91) | SURVIVED | SURVIVED | — | — | Equality-only; Int drains/min/max unchanged |
| E3-M03: `maxValue` inverted (L97) | KILLED | KILLED | test_initializer_*, test_maximumReplacement, … | testAlternatingPopMinPopMax, heapify/*, … | |
| E3-M04: `maxValue` `>=`→`>` (L97) | KILLED | SURVIVED | test_tieBreaks_max | — | **Human-only** (identity/tie-break) |
| E3-M05: bubbleUp min parent `>`→`<` (L109) | KILLED | KILLED | test_insert_*, test_min/max, … | testBubbleUp*, insert sequences, … | |
| E3-M06: bubbleUp max parent `<`→`>` (L110) | KILLED | KILLED | test_insert_*, test_max*, … | insert / stress, … | |
| E3-M07: bubbleUp invert `isMinLevel` gate (L115) | KILLED | KILLED | test_insert_*, test_min, … | testBubbleUp*, insert, … | |
| E3-M08: bubbleUp min GP `<`→`>` (L117) | KILLED | KILLED | test_insert_*, test_min, … | testBubbleUpAcrossGrandparentMinLevel, … | |
| E3-M09: bubbleUp max GP `>`→`<` (L123) | KILLED | KILLED | test_popMax | testBubbleUpMaxLevelNewMaximum, insert, … | |
| E3-M10: drop max-level parent-swap arm (L109–110) | KILLED | KILLED | test_insert_*, test_max*, … | insert / replaceMaxOnTwoElements, … | |
| E3-M11: trickleMin 4-gc ` <`→`<=` (L154) | KILLED | KILLED | Fatal error | Fatal error | OOB / fatal as planned |
| E3-M12: trickleMin stop `<`→`>` (L166) | KILLED | KILLED | initializer / insert contentsOf, … | pop/heapify drains, … | |
| E3-M13: trickleMin parent check inverted (L175) | KILLED | KILLED | initializer / insert, … | pop/heapify drains, … | |
| E3-M14: no-child `>=`→`>` (L184) | KILLED | KILLED | assert L217 (`_minDescendant`) | assert L217 | OOB path → assert |
| E3-M15: trickleMin stop `<`→`<=` (L188) | KILLED | SURVIVED | test_tieBreaks_min | — | **Human-only** (equal-key sink edge) |
| E3-M16: `min < gc0`→`>` (L195) | KILLED | KILLED | initializer / insert, … | heapify / drain, … | |
| E3-M17: `_minDescendant` 3-gc ` <`→`<=` (L221) | KILLED | KILLED | Fatal error | Fatal error | OOB / fatal |
| E3-M18: `_minDescendant` `minValue`→`maxValue` (L242) | KILLED | KILLED | initializer / insert_random, … | heapify / drain, … | |
| E3-M19: trickleMax stop inverted (L277) | KILLED | KILLED | initializer / insert, … | heapify / drain, … | |
| E3-M20: trickleMax parent check inverted (L286) | KILLED | KILLED | initializer / popMax, … | heapify / drain, … | |
| E3-M21: `max < gc0`→`>` (L306) | KILLED | KILLED | initializer / insert, … | pop/heapify, … | |
| E3-M22: `_maxDescendant` `maxValue`→`minValue` (L353) | KILLED | KILLED | initializer / maximumReplacement, … | popMax / heapify, … | |
| E3-M23: trickleMax 4-gc bound `&+3`→`&+2` (L265) | KILLED | KILLED | Fatal error | Fatal error | OOB / fatal |
| E3-M24: heapify `limit=count/2`→`count` (L368) | SURVIVED | SURVIVED | — | — | Near-equivalent under suites (leaf trickles no-op enough) |
| E3-M25: `_heapify` invert min/max level (L380) | KILLED | KILLED | assert L252 (`trickleDownMax`) | assert L252 | Wrong-level trickle assert |
| E3-M26: heapify `level &-= 1`→`&+= 1` (L373) | KILLED | KILLED | assert `_HeapNode.swift:168` | assert `_HeapNode.swift:168` | Hang avoided; assert on bad level walk |
| E3-M27: heapify `level >= 0`→`> 0` (L370) | KILLED | KILLED | initializer / insert / replace, … | heapify / drain / replace, … | |
| E3-M28: `_HeapNode.isMinLevel` polarity (L77) | KILLED | KILLED | test_levelCalculation | assert L136 (`trickleDownMin`) | Human catches via level unit test; AI via heap assert |

## Scores

Mutation score = Killed / (Killed + Survived) × 100

| Metric | Value |
|---|---|
| Total mutations | **28** |
| Valid mutations | **28** / **28** |
| Invalid mutations | **0** |
| Human killed | **26** |
| Human survived | **2** (E3-M02, E3-M24) |
| Human mutation score | **92.9%** (26/28) |
| AI killed | **24** |
| AI survived | **4** (E3-M02, E3-M04, E3-M15, E3-M24) |
| AI mutation score | **85.7%** (24/28) |

### Split vs prediction

| Bucket | Mutants |
|---|---|
| Both killed | M01, M03, M05–M14, M16–M23, M25–M28 |
| Both survived | **M02**, **M24** |
| Human-only kill | **M04**, **M15** |
| AI-only kill | *(none)* |

Coverage was identical (99.03% line on the primary file), but **mutation score favored the human suite** because dedicated **tie-break / equal-key** tests (`test_tieBreaks_min` / `test_tieBreaks_max`) killed M04 and M15; the AI suite’s duplicate coverage did not assert identity/order edges those mutants break.

## Notable survivors

| ID | Why it survived |
|---|---|
| **E3-M02** | `minValue` equality branch (`<=`) does not change numeric min/max or sorted Int drains; neither suite asserts which equal node is chosen. |
| **E3-M24** | Expanding Floyd `limit` to `count` still yields heaps that pass min/max/drain assertions (leaf trickles effectively harmless for these tests). |
| **E3-M04 / E3-M15 (AI)** | Require equal-key / identity-sensitive oracles; AI suite checks multiset/extremes, not tie identity. |

## Prediction accuracy (high level)

- Core comparison / bubble / trickle / descendant / level-polarity mutants: both killed as predicted.
- Tie-break lean (M02/M04): **M04** matched (human Yes, AI missed); **M02** was weaker than expected (both survived).
- M15: human killed (better than “Likely”), AI survived.
- Crash/hang cluster (M11/M14/M17/M23/M25/M26): all killed both sides (assert/fatal rather than clean hang for M26).

---

## Stop line

Experiment #3 mutation execution complete. Production and frozen suites restored/verified.
