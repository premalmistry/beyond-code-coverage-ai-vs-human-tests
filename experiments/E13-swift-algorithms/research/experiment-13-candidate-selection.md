# Experiment #13 — Candidate Selection (CONFIRMATORY)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Repository:** [apple/swift-algorithms](https://github.com/apple/swift-algorithms)  
**Pinned SHA:** `5b7143f8e291dee0e14c118fd0212487f0b37af5` (same pin as Experiments #5 and #6)  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Date (UTC):** `2026-08-15T16:28:14Z`

**This document only selects the component.** No AI tests, no mutations, no production/test edits beyond recording this selection.

---

## Context

Experiments #1–#10 were **exploratory**. Experiments #11–#15 are **confirmatory**.

Confirmatory protocol is **identical** to Experiments #11 and #12. Do **not** modify methodology based on those outcomes.

Previously studied in this repository (must not be reused):

| Experiment | Component |
|---|---|
| E5 | `Sources/Algorithms/Combinations.swift` |
| E6 | `Sources/Algorithms/Partition.swift` |

---

## Eligibility criteria (pre-declared)

A production file is **eligible** only if **all** hold:

1. Has **direct** existing human-written tests.
2. Has **deterministic** tests.
3. Has **focused, observable** behavior.
4. Can **reasonably support meaningful mutation testing**.
5. Does **not** require network / external services.
6. Was **not** studied in Experiments #1–#12.
7. Is **reasonably isolated** enough for Human-vs-AI comparison.

---

## Neutral selection rule (pre-declared — identical to #11/#12)

1. Enumerate every production `.swift` file under `Sources/`.
2. Apply eligibility criteria; record objective exclusions.
3. Sort the **eligible** set **alphabetically by production file path**.
4. Select the **first** eligible path.
5. **Do not** skip for predicted coverage, suite strength, outcome, tie risk, or interestingness.

## Full inventory (28 production files, alphabetical) and eligibility

| Production file path | LOC | Eligible? | Objective reason if excluded |
|---|---:|:---:|---|
| `Sources/Algorithms/AdjacentPairs.swift` | 323 | **YES** | Direct AdjacentPairsTests; deterministic; focused; good MUT surface; not studied. |
| `Sources/Algorithms/Chain.swift` | 328 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Algorithms/Chunked.swift` | 929 | **No** | (#7) Too large (929 LOC) / not reasonably isolated for focused MUT. |
| `Sources/Algorithms/Combinations.swift` | 311 | **No** | (#6) Studied in Experiments #5/#6. |
| `Sources/Algorithms/Compacted.swift` | 188 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Algorithms/Cycle.swift` | 223 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Algorithms/EitherSequence.swift` | 197 | **No** | (#1) No dedicated human test suite; support/internal collection. |
| `Sources/Algorithms/EndsWith.swift` | 83 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Algorithms/FirstNonNil.swift` | 44 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Algorithms/FlattenCollection.swift` | 332 | **No** | (#1) No dedicated human test suite; support/internal collection. |
| `Sources/Algorithms/Grouped.swift` | 27 | **No** | (#4) Insufficient local surface (27 LOC). |
| `Sources/Algorithms/Indexed.swift` | 116 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Algorithms/Intersperse.swift` | 684 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Algorithms/Joined.swift` | 499 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Algorithms/Keyed.swift` | 76 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Algorithms/MinMax.swift` | 490 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Algorithms/Partition.swift` | 389 | **No** | (#6) Studied in Experiments #5/#6. |
| `Sources/Algorithms/Permutations.swift` | 608 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Algorithms/Product.swift` | 526 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Algorithms/RandomSample.swift` | 268 | **No** | (#2) Random sampling — non-deterministic under default RNG. |
| `Sources/Algorithms/Reductions.swift` | 619 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Algorithms/Rotate.swift` | 285 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Algorithms/Split.swift` | 755 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Algorithms/Stride.swift` | 289 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Algorithms/Suffix.swift` | 95 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Algorithms/Trim.swift` | 242 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Algorithms/Unique.swift` | 145 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Algorithms/Windows.swift` | 365 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |

### Notes on `No*` rows

`No*` = not selected once the first alphabetical **YES** is frozen. Some may independently meet eligibility.

### Eligible set (alphabetical)

1. **`Sources/Algorithms/AdjacentPairs.swift`** *(selected)*

Additional paths marked `No*` above may also be eligible but were **not** selected under the frozen rule.

---

## Selection

**Selected component (first eligible alphabetically):**  
`Sources/Algorithms/AdjacentPairs.swift`

**Selection rule applied:** sort eligible paths alphabetically → take index 0.

### Why eligible

- (#1) Direct `AdjacentPairsTests` (12 methods).
- (#2) Deterministic sequence/collection pair enumeration.
- (#3) Focused `adjacentPairs()` Sequence/Collection APIs + iterator/index logic.
- (#4) 323 LOC with empty/single/multi paths — meaningful mutation surface.
- (#5) No network/external services.
- (#6) Not studied in E1–#12.
- (#7) Single isolated production file.

### Intended frozen Human filter (Stage 2)

```bash
swift test --filter 'SwiftAlgorithmsTests.AdjacentPairsTests'
```

(Unqualified `AdjacentPairsTests` also matches `AIGeneratedAdjacentPairsTests`; Stage 2 freezes the qualified filter.)

Smoke: **12 tests, 0 failures**.

### Production fingerprint

| File | SHA-256 |
|---|---|
| `Sources/Algorithms/AdjacentPairs.swift` | `3918587a45e298c5dd57e1f4adfcaaaa6d10a3301a5c759ec4a6f25cdc1ebce2` |

## FREEZE

**Component is FROZEN.** Do not replace after observing experimental results.
