# Experiment #5 — Summary

**Repository:** [apple/swift-algorithms](https://github.com/apple/swift-algorithms)  
**Pinned SHA:** `5b7143f8e291dee0e14c118fd0212487f0b37af5`  
**Component:** `Sources/Algorithms/Combinations.swift`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Date (UTC):** `2026-08-13`

**Production SHA-256:** `a47a9033683f9be178ebd992398c1bc7c4f269c2eb02c2ac34cc7d3bd4dc2263`  
**AI suite SHA-256:** `e976602ed1a9a7546365a77dce298e130cee68d9645f8088bb7cdc8b52e529fa`  

**Human filter (frozen):** `swift test --filter SwiftAlgorithmsTests.CombinationsTests`  
**AI filter (frozen):** `swift test --filter AIGeneratedCombinationsTests`

---

## Compact results

| Metric | Human | AI |
|---|---:|---:|
| Test methods | 4 | 27 |
| Assertions (static call sites) | 28 | 62 |
| Line coverage | 99.21% | 99.21% |
| Region coverage | 96.00% | 96.00% |
| Function coverage | 94.74% | 94.74% |
| Valid mutants | 21 | 21 |
| Mutants killed | 21 | 21 |
| Mutation score | **100.0%** | **100.0%** |
| Unique kills | 0 | 0 |

**Invalid / excluded:** E5-M01, E5-M03, E5-M08, E5-M15 (**INVALID-EQUIVALENT**); E5-M19 (**INVALID** compile failure).  
**Planned mutants:** 26.

---

## Observed findings (this experiment only)

1. **Coverage:** Human and AI achieved **identical** llvm-cov figures on `Combinations.swift` (99.21% / 96.00% / 94.74%). The shared miss is the negative-`k` precondition message path.
2. **Mutation score:** Both suites scored **100%** on the **21** valid mutants (no valid shared survivors; no human-only or AI-only kills).
3. **Human-only mutants:** none.
4. **AI-only mutants:** none.
5. **Shared survivors (raw):** E5-M01, M03, M08, M15 — all reclassified **INVALID-EQUIVALENT** after code-level analysis (not merely because both survived).
6. **Equal coverage, equal mutation effectiveness:** Unlike Experiment #4 (similar coverage, divergent mutation kills), here near-complete coverage coincided with identical kill sets on the valid mutant panel. Do **not** generalize beyond this component/suite pair.

---

## Methodology notes

- Strict Human/AI isolation for generation; AI suite frozen before mutation planning/execution.
- Same mutants applied to both suites; production restored between mutants; final SHA checks passed.
- Human filter refined to the fully qualified class name so it does not substring-match the AI suite (contaminated first pass archived, not scored).

---

## Artifacts

| Artifact | Path |
|---|---|
| Candidate selection | `research/experiment-5-candidate.md` |
| Human baseline | `research/experiment-5-human-baseline.md` |
| Human coverage | `research/experiment-5-human-coverage.txt` / `-detail.txt` |
| AI baseline | `research/experiment-5-ai-baseline.md` |
| AI coverage | `research/experiment-5-ai-coverage.txt` / `-detail.txt` |
| Mutation plan | `research/experiment-5-mutation-plan.md` |
| Mutation results | `research/experiment-5-mutation-results.md` |
| Results JSONL | `research/experiment-5-mutation-results.jsonl` |
| Logs / mutants | `research/mutation-logs-e5/` / `research/mutants-e5/` |
| Runner | `research/run_e5_mutations.py` |

---

## Final integrity

| Check | Result |
|---|---|
| Production restored + SHA-256 | **PASS** |
| AI suite SHA-256 | **PASS** |
| Human suite PASS (4 tests) | **PASS** |
| AI suite PASS (27 tests) | **PASS** |
| Suites not edited after mutation results | **PASS** |

Experiment #5 complete.
