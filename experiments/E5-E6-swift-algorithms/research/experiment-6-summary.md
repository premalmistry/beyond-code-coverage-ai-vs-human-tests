# Experiment #6 — Summary

**Repository:** [apple/swift-algorithms](https://github.com/apple/swift-algorithms)  
**Pinned SHA:** `5b7143f8e291dee0e14c118fd0212487f0b37af5`  
**Component:** `Sources/Algorithms/Partition.swift`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Date (UTC):** `2026-08-13`

**Production SHA-256:** `bef59fabc5958af321b728fb4bac230ff875db3135d17b6e5bee0216a8be3644`  
**AI suite SHA-256:** `2ed75624b2a22bf13f7911512fa3e1cf0b19385415a4d06916e8d92078725c59`  

**Human filter (frozen):** `swift test --filter SwiftAlgorithmsTests.PartitionTests`  
**AI filter (frozen):** `swift test --filter AIGeneratedPartitionTests`  

**Out of scope:** `Combinations.swift` (Experiment #5).

---

## Compact results

| Metric | Human | AI |
|---|---:|---:|
| Test methods | 10 | 29 |
| Assertions (static call sites) | 39 | 59 |
| Line coverage | 89.81% | 95.83% |
| Region coverage | 88.61% | 96.20% |
| Function coverage | 81.82% | 90.91% |
| Valid mutants | 22 | 22 |
| Mutants killed | 20 | 22 |
| Mutation score | **90.9%** | **100.0%** |
| Unique kills | 0 | **2** |

**Invalid / excluded:** E6-M01, E6-M15, E6-M16, E6-M22 (**INVALID-EQUIVALENT**).  
**Planned mutants:** 26.

---

## Observed findings (this experiment only)

1. **Coverage:** AI higher than Human on all three metrics (notably by covering `Sequence.partitioned`).
2. **Mutation score:** AI **100.0%** vs Human **90.9%** on 22 valid mutants.
3. **Human-only mutants:** none.
4. **AI-only mutants:** **E6-M21**, **E6-M26** (both corrupt `Sequence.partitioned` polarity; Human never exercises that overload).
5. **Shared valid survivors:** none.
6. **Coverage vs mutation:** The Human coverage miss on `Sequence.partitioned` directly explains the two AI-only kills — a concrete case where a coverage gap matched mutation weakness. Do **not** generalize beyond this component.

---

## Methodology (Runbook v2)

- Fully qualified Human filter; inventory recorded; zero `AIGenerated*` on Human runs.
- AI generated from production only; inventories verified disjoint after freeze.
- Mutations frozen before execution; identical mutants; survivors preserved; equivalents justified at code level.
- Per-mutant contamination flags all false.

---

## Artifacts

| Artifact | Path |
|---|---|
| Candidate | `research/experiment-6-candidate.md` |
| Human baseline | `research/experiment-6-human-baseline.md` |
| Human coverage | `research/experiment-6-human-coverage.txt` / `-detail.txt` |
| AI baseline | `research/experiment-6-ai-baseline.md` |
| AI coverage | `research/experiment-6-ai-coverage.txt` / `-detail.txt` |
| Mutation plan | `research/experiment-6-mutation-plan.md` |
| Mutation results | `research/experiment-6-mutation-results.md` |
| Results JSONL | `research/experiment-6-mutation-results.jsonl` |
| Logs / mutants | `research/mutation-logs-e6/` / `research/mutants-e6/` |
| Runner | `research/run_e6_mutations.py` |

---

## Final integrity

| Check | Result |
|---|---|
| Production restored + SHA-256 | **PASS** |
| AI suite SHA-256 | **PASS** |
| Human suite PASS (10) | **PASS** |
| AI suite PASS (29) | **PASS** |
| Contamination | **CLEAN** |
| Suites not edited after mutation results | **PASS** |

Experiment #6 complete.
