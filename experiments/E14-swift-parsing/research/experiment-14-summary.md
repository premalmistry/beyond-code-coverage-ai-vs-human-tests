# Experiment #14 — Summary

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  

**Repository:** [pointfreeco/swift-parsing](https://github.com/pointfreeco/swift-parsing)  
**Pinned SHA:** `7160b25d39e4a38258a7fe71591fbe182b026d69`  
**Component:** `Sources/Parsing/Builders/OneOfBuilder.swift`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Date (UTC):** `2026-08-15`

**Production SHA-256:** `af44508de74348ae4be49bbff0548538eb36793d38ff956eb0424dfb9699a55e`  
**AI suite SHA-256:** `f8749111c158c88eb1083e7053653a2da9e91e5ba118114f007269881f6b232d`

**Human filter (frozen):** `swift test --filter 'ParsingTests.OneOfBuilderTests'`  
**AI filter (frozen):** `swift test --filter 'AIGeneratedOneOfBuilderTests'`

**Out of scope / not reused:** `Prefix.swift` (E7), `Digits.swift` (E8).

---

## Neutral selection (identical to #11–#13)

1. Enumerated all `Sources/**/*.swift` files (95).
2. Applied seven eligibility criteria.
3. Sorted eligible paths alphabetically.
4. Selected the **first** eligible file: `Sources/Parsing/Builders/OneOfBuilder.swift`.

**Why eligible:** direct `OneOfBuilderTests`; deterministic; focused `@OneOfBuilder` + `OneOf2`/`OptionalOneOf` parse/print; 253 LOC; no network; not in E1–#13; isolated.

Component was **not** replaced after results (including after observing a thin Human suite and builder-style surface).

Full inventory: `research/experiment-14-candidate-selection.md`.

---

## Compact results

| Metric | Human | AI |
|---|---:|---:|
| Test methods | 2 | 18 |
| Assertions | 10 | 36 |
| Line coverage | 47.62% | 79.76% |
| Region coverage | 41.67% | 86.11% |
| Function coverage | 47.37% | 73.68% |
| Valid mutants | 22 | 22 |
| Mutants killed | 15 | 16 |
| Mutation score | **68.2%** | **72.7%** |
| Unique kills | 2 (M01, M21) | 3 (M13–M15) |

| Bucket | Detail |
|---|---|
| Human-only kills | **2** (E14-M01, E14-M21) |
| AI-only kills | **3** (E14-M13, E14-M14, E14-M15 — print/`OptionalOneOf` print paths) |
| Shared survivors | **4** (E14-M02, E14-M11, E14-M12, E14-M22) |
| Equivalent exclusions | **0** |
| Contamination status | **CLEAN** |
| Integrity status | **PASS** |

---

## Findings (Experiment #14 only)

Under the frozen neutral selection, the alphabetically first eligible component was the `@OneOfBuilder` implementation. Human’s 2-test suite still achieved **68.2%** mutation score (15/22), including two Human-only kills tied to parse try-order / aggregated parse-error payloads. AI reached **72.7%** (16/22) with three AI-only kills on print-side defects Human never exercises. Four shared survivors remain classified as valid (not equivalent).

This experiment does **not** reinterpret Experiments #1–#13 and does **not** update the paper. Experiment #15 was **not** selected.

---

## Artifacts

- `research/experiment-14-candidate-selection.md`
- `research/experiment-14-human-baseline.md`
- `research/experiment-14-ai-baseline.md`
- `research/experiment-14-mutation-plan.md`
- `research/experiment-14-mutation-results.md`
- `research/experiment-14-mutation-results.jsonl`
- `research/experiment-14-summary.md` (this file)
- Coverage / mutants / logs under `research/`
- ORIG: `research/OneOfBuilder.swift.ORIG`
