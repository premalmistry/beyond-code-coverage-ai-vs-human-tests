# Experiment #9 — Summary

**Repository:** [apple/swift-numerics](https://github.com/apple/swift-numerics)  
**Pinned SHA:** `899af71c0256d0ad181e3b7eb3453c1065d928a5`  
**Component:** `Sources/IntegerUtilities/SaturatingArithmetic.swift`  
**Swift:** Apple Swift 6.3.3  
**Date (UTC):** `2026-08-13`

**Production SHA-256:** `1da0a8a5b9f7d6f9a9421786d1817b35eed7dbe9dcf48190eaac5ef131498536`  
**AI suite SHA-256:** `93ebec4f106534683fae2d1824c8d16bf3d5668e10b3f3a196b08f74741253a0`  

**Human filter:** `swift test --filter IntegerUtilitiesTests.IntegerUtilitiesSaturatingTests`  
**AI filter:** `swift test --filter IntegerUtilitiesTests.AIGeneratedSaturatingArithmeticTests`  

**Diversity vs E1–E8:** First **numerical/computational** defect domain — fixed-width integer saturating `+ − * <<` with exact integer observables (no FP tolerance). Prior experiments covered serialization/reflection, collections, algorithms, and parsing.

---

## Compact results

| Metric | Human | AI |
|---|---:|---:|
| Test methods | 10 | 27 |
| Assertions (static) | 10 | 58 |
| Line coverage | 100% | 100% |
| Region coverage | 100% | 100% |
| Function coverage | 100% | 100% |
| Valid mutants | 26 | 26 |
| Mutants killed | 25 | 23 |
| Mutation score | **96.2%** | **88.5%** |
| Unique kills | **2** | 0 |

**Planned mutants:** 26 (none excluded / none reclassified equivalent).

---

## Observed findings (this experiment only)

1. **Coverage:** Both suites at **100%** line / region / function on the frozen production file.
2. **Mutation score:** Human **96.2%** (25/26) vs AI **88.5%** (23/26).
3. **Human-only kills:** **E9-M18** (shift `bitWidth` boundary), **E9-M25** (signed shift clamp via `signbit`).
4. **AI-only kills:** none.
5. **Shared valid survivor:** **E9-M26** (generic `Count` → `Int` conversion: clamping vs truncating) — real semantic difference neither suite exercised.
6. Human style is exhaustive Int8/UInt8 oracles; AI is targeted boundary cases — equal coverage, Human stronger on shift edge mutants.
7. Do **not** generalize beyond this saturating-arithmetic component.

---

## Methodology (Runbook v2)

Production scope frozen; qualified Human filter; Human inventory recorded; zero `AIGenerated*` under Human filter. AI generated from production API only; AI SHA frozen; inventories disjoint; all 26 mutations defined and frozen before execution; identical mutants vs both suites; suites not edited after mutation outcomes; survivors preserved with code-level justification (no false equivalence). Final contamination checks clean.

---

## Artifacts

| Artifact | Path |
|---|---|
| Candidate | `research/experiment-9-candidate.md` |
| Human / AI baselines | `research/experiment-9-human-baseline.md`, `…-ai-baseline.md` |
| Coverage | `research/experiment-9-*-coverage*.txt` |
| Mutation plan / results | `research/experiment-9-mutation-plan.md`, `…-results.md`, `…-results.jsonl` |
| Logs / mutants / runner / ORIG | `research/mutation-logs-e9/`, `research/mutants-e9/`, `research/run_e9_mutations.py`, `research/SaturatingArithmetic.swift.ORIG` |
| AI tests | `Tests/IntegerUtilitiesTests/AIGeneratedSaturatingArithmeticTests.swift` |

---

## Final integrity

| Check | Result |
|---|---|
| Production restored + SHA-256 | **PASS** |
| AI SHA-256 | **PASS** |
| Human PASS (10) / AI PASS (27) | **PASS** |
| Human filter excludes `AIGenerated*` | **CLEAN** |
| Inventories disjoint | **PASS** |

Experiment #9 complete.
