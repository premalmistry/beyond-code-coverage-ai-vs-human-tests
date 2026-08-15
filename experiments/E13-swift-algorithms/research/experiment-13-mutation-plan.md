# Experiment #13 — Mutation Plan (FROZEN)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/Algorithms/AdjacentPairs.swift`  
**Repo SHA:** `5b7143f8e291dee0e14c118fd0212487f0b37af5`  
**Production SHA-256:** `3918587a45e298c5dd57e1f4adfcaaaa6d10a3301a5c759ec4a6f25cdc1ebce2`  
**AI suite SHA-256:** `f6a39bdcd701de1eef7a911d832363ae09c71e45b3e832434100c6945f165cdd`  
**Plan date (UTC):** `2026-08-15T16:31:00Z`

Both Human and AI suites are **frozen**. Plan defined **after** suite freeze and **before** mutant execution.

Mutant sources: `research/mutants-e13/E13-MXX.swift` (24 files).

---

## Design principles

- Realistic defects in iterator pairing, index arithmetic, count/distance, and start/end handling.
- No comment-only / rename-only / guaranteed-compile-error mutants.
- Not designed after inspecting suite-specific weaknesses to favor either side.
- **24** mutants (quality over padding).

---

## Frozen mutant set

| ID | Theme | Expected defect | Human pred. | AI pred. | Risk |
|---|---|---|---|---|---|
| E13-M01 | iterator tuple swap | pair order reversed | kill | kill | |
| E13-M02 | skip previous update | stale first element | kill | kill | |
| E13-M03 | underestimatedCount +1 | wrong estimate | survive* | kill | |
| E13-M04 | empty secondBaseIndex polarity | broken indices | kill | kill | crash |
| E13-M05 | Index== on second | equality wrong | kill | kill | |
| E13-M06 | Index< inverted | order inverted | kill | kill | |
| E13-M07 | startIndex empty check | start wrong | kill | kill | |
| E13-M08 | index(after)→end | cannot advance | kill | kill | |
| E13-M09 | index(after) wrong first | non-overlap pairs | kill | kill | |
| E13-M10 | count without −1 | count large | kill | kill | |
| E13-M11 | count −2 | count small | kill | kill | |
| E13-M12 | distance swapped | sign flipped | kill | kill | |
| E13-M13 | index(before) end branch | before broken | kill | kill | |
| E13-M14 | offsetForward off-by-one | forward wrong | kill | kill | |
| E13-M15 | offsetBackward end offset | backward wrong | kill | kill | |
| E13-M16 | subscript swap | tuple swapped | kill | kill | |
| E13-M17 | limitedBy direction | wrong branch | kill | kill | crash |
| E13-M18 | zero offset→endIndex | zero offset wrong | kill | kill | |
| E13-M19 | offsetForward end map | landing wrong | kill | kill | |
| E13-M20 | underestimatedCount no max | negative estimate | survive* | kill | |
| E13-M21 | index(before) degenerate | first=second | kill | kill | |
| E13-M22 | distance via first | endIndex gap | kill | kill | |
| E13-M23 | limitedBy limit==i | early exit wrong | kill | kill | |
| E13-M24 | offsetBackward formula | backward wrong | kill | kill | |

---

## Execution protocol (frozen)

```text
Human filter: SwiftAlgorithmsTests.AdjacentPairsTests
AI filter:    AIGeneratedAdjacentPairsTests
Timeout:      90 seconds per suite run
Order:        For each mutant — Human then AI (same mutant bytes)
Restore:      ORIG between mutants; re-verify production SHA-256
```

Contamination: every Human run must execute zero `AIGenerated*` *test cases*.

---

## FREEZE

Mutation set **frozen**. Do not add/remove/alter mutants after seeing execution results.
