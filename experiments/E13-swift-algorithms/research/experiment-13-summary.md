# Experiment #13 — Summary

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  

**Repository:** [apple/swift-algorithms](https://github.com/apple/swift-algorithms)  
**Pinned SHA:** `5b7143f8e291dee0e14c118fd0212487f0b37af5`  
**Component:** `Sources/Algorithms/AdjacentPairs.swift`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Date (UTC):** `2026-08-15`

**Production SHA-256:** `3918587a45e298c5dd57e1f4adfcaaaa6d10a3301a5c759ec4a6f25cdc1ebce2`  
**AI suite SHA-256:** `f6a39bdcd701de1eef7a911d832363ae09c71e45b3e832434100c6945f165cdd`

**Human filter (frozen):** `swift test --filter 'SwiftAlgorithmsTests.AdjacentPairsTests'`  
**AI filter (frozen):** `swift test --filter 'AIGeneratedAdjacentPairsTests'`

**Out of scope / not reused:** `Combinations.swift` (E5), `Partition.swift` (E6).

---

## Neutral selection (pre-declared — identical to #11/#12)

1. Enumerated all `Sources/**/*.swift` production files (28).
2. Applied seven eligibility criteria.
3. Sorted eligible paths alphabetically.
4. Selected the **first** eligible file: `Sources/Algorithms/AdjacentPairs.swift`.

Full inventory: `research/experiment-13-candidate-selection.md`.

**Why eligible:** direct `AdjacentPairsTests`; deterministic pair iteration; focused API; 323 LOC mutation surface; no network; not in E1–#12; isolated file.

Component was **not** replaced after results.

---

## Compact results

| Metric | Human | AI |
|---|---:|---:|
| Test methods | 12 | 25 |
| Assertions | 14 | 63 |
| Line coverage | 92.95% | 92.95% |
| Region coverage | 89.04% | 80.82% |
| Function coverage | 80.56% | 83.33% |
| Valid mutants | 23 | 23 |
| Mutants killed | 21 | 23 |
| Mutation score | **91.3%** | **100%** |
| Unique kills | 0 | 2 (M03, M20) |

| Bucket | Detail |
|---|---|
| Human-only kills | **0** |
| AI-only kills | **2** (E13-M03, E13-M20 — `underestimatedCount`) |
| Shared survivors (valid) | **0** |
| Equivalent exclusions | **1** (E13-M05 — `Index.==` via `second` ≡ via `first`) |
| Contamination status | **CLEAN** |
| Integrity status | **PASS** |

---

## Findings (Experiment #13 only)

Both frozen suites strongly detected index/iterator/count defects on `AdjacentPairs`. Human mutation score **91.3%** (21/23); AI **100%** (23/23). AI uniquely killed two `underestimatedCount` mutants that Human does not assert. One shared survivor (M05) was adjudicated equivalent and excluded.

This experiment does **not** reinterpret Experiments #1–#12 and does **not** update the paper. Experiment #14 was **not** selected.

---

## Artifacts

- `research/experiment-13-candidate-selection.md`
- `research/experiment-13-human-baseline.md`
- `research/experiment-13-ai-baseline.md`
- `research/experiment-13-mutation-plan.md`
- `research/experiment-13-mutation-results.md`
- `research/experiment-13-mutation-results.jsonl`
- `research/experiment-13-summary.md` (this file)
- Coverage / mutants / logs under `research/`
- ORIG: `research/AdjacentPairs.swift.ORIG`
