# Experiment #12 — Summary

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  

**Repository:** [apple/swift-collections](https://github.com/apple/swift-collections)  
**Pinned SHA:** `f3e778f17a438371c5b8c170f15c0d997bb417ee`  
**Component:** `Sources/BasicContainers/RigidArray/RigidArray+Append.swift`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Date (UTC):** `2026-08-15`

**Production SHA-256:** `3075e1f0b035fae7b22025ae6c39ae4374e74894f1c05235e212ad815485c086`  
**AI suite SHA-256:** `2b970be758d46fca8a53b5a78c16916e14797489a4df00cd023e53200c8807c6`

**Human filter (frozen):**  
`swift test --filter 'RigidArrayTests.test_append$|RigidArrayTests.test_pushLast|RigidArrayTests.test_append_addingCount_full|RigidArrayTests.test_append_addingCount_partial|RigidArrayTests.test_append_moving_UnsafeMutableBufferPointer|RigidArrayTests.test_append_moving_OutputSpan|RigidArrayTests.test_append_copying_MinimalSequence|RigidArrayTests.test_append_copying_Span'`

**AI filter (frozen):** `swift test --filter AIGeneratedRigidArrayAppendTests`

**Out of scope / not reused:** Heap handle/`_HeapNode` (E3), OrderedSet insertions (E4).

---

## Neutral selection (pre-declared — identical to Experiment #11)

1. Enumerated all `Sources/**/*.swift` production files (565).
2. Applied seven eligibility criteria (direct human tests, deterministic, focused, meaningful mutation surface, no network, not in E1–#11, reasonably isolated).
3. Sorted the eligible set alphabetically by path.
4. Selected the **first** eligible file: `Sources/BasicContainers/RigidArray/RigidArray+Append.swift`.

Full inventory and exclusions: `research/experiment-12-candidate-selection.md`.

**Why eligible:** direct `RigidArrayTests` append/`pushLast` coverage; deterministic; focused capacity-gated append APIs; 360 LOC mutation surface; no network; not studied in E1–#11; isolated single file.

The component was **not** replaced after results were observed.

---

## Compact results

| Metric | Human | AI |
|---|---:|---:|
| Test methods | 8 | 28 |
| Assertions | 21 | 77 |
| Line coverage | 83.62% | 93.10% |
| Region coverage | 75.56% | 82.22% |
| Function coverage | 68.57% | 77.14% |
| Valid mutants | 22 | 22 |
| Mutants killed | 20 | 21 |
| Mutation score | **90.9%** | **95.5%** |
| Unique kills | 0 | 1 (M06) |

| Bucket | Detail |
|---|---|
| Human-only kills | **0** |
| AI-only kills | **1** (E12-M06: `addingCount` capacity `>=` → `>`) |
| Shared survivors (valid) | **1** (E12-M14: OutputSpan exact-fit capacity check) |
| Equivalent exclusions | **2** (E12-M09, E12-M15 empty-buffer early-return removals) |
| Contamination status | **CLEAN** |
| Integrity status | **PASS** (production + AI fingerprints restored/verified; both frozen suites re-PASS) |

---

## Findings (Experiment #12 only)

On this confirmatory component, both frozen suites were strong killers of capacity/count/move/copy defects (Human **90.9%**, AI **95.5%** mutation score on 22 valid mutants). AI uniquely killed M06 (exact-fit `append(addingCount:)` capacity guard). Neither suite killed M14 (exact-fit OutputSpan move capacity). Empty-move/copy guard removals (M09/M15) were adjudicated equivalent and excluded.

This experiment does **not** reinterpret Experiments #1–#11 and does **not** update the paper. Experiment #13 was **not** selected.

---

## Artifacts

- `research/experiment-12-candidate-selection.md`
- `research/experiment-12-human-baseline.md`
- `research/experiment-12-ai-baseline.md`
- `research/experiment-12-mutation-plan.md`
- `research/experiment-12-mutation-results.md`
- `research/experiment-12-mutation-results.jsonl`
- `research/experiment-12-summary.md` (this file)
- Coverage: `research/experiment-12-{human,ai}-coverage*.txt`
- Mutants/logs: `research/mutants-e12/`, `research/mutation-logs-e12/`
- ORIG backup: `research/RigidArray+Append.swift.ORIG`
