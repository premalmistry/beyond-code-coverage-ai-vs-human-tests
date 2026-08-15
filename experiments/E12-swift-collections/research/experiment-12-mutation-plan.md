# Experiment #12 — Mutation Plan (FROZEN)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/BasicContainers/RigidArray/RigidArray+Append.swift`  
**Repo SHA:** `f3e778f17a438371c5b8c170f15c0d997bb417ee`  
**Production SHA-256:** `3075e1f0b035fae7b22025ae6c39ae4374e74894f1c05235e212ad815485c086`  
**AI suite SHA-256:** `2b970be758d46fca8a53b5a78c16916e14797489a4df00cd023e53200c8807c6`  
**Plan date (UTC):** `2026-08-15T16:08:00Z`

Both Human and AI suites are **frozen**. This plan was defined **after** suite freeze and **before** any mutant execution.

Mutant sources: `research/mutants-e12/E12-MXX.swift` (24 files).

---

## Design principles

- Realistic defects in capacity guards, count updates, move/copy append paths, and `pushLast` return behavior.
- No comment-only / rename-only / guaranteed-compile-error mutants.
- Not designed after inspecting suite-specific weaknesses to favor either side.
- Target ~20–30; quality over padding → **24** mutants.

---

## Frozen mutant set

| ID | Location / theme | Original → Mutation | Expected defect | Human pred. | AI pred. | Risk |
|---|---|---|---|---|---|---|
| E12-M01 | `append(_:)` capacity | `!isFull` → `isFull` | traps when space remains | kill | kill | crash |
| E12-M02 | `pushLast` polarity | `if isFull` → `if !isFull` | reject when space; append when full | kill | kill | crash |
| E12-M03 | `pushLast` no-op | body → `return item` | never appends | kill | kill | |
| E12-M04 | `pushLast` ignore full | drop full check | overflows when full | kill | kill | crash |
| E12-M05 | `addingCount` ≥0 | `>= 0` → `> 0` | zero count traps | kill | kill | crash |
| E12-M06 | `addingCount` capacity | `>=` → `>` | exact-fit traps | kill | kill | crash |
| E12-M07 | `addingCount` defer | skip `_count &+=` | count not updated | kill | kill | |
| E12-M08 | `addingCount` defer | `&+=` → `&-=` | count decreases | kill | kill | |
| E12-M09 | move unchecked | remove empty `guard` | empty-move edge | survive* | survive* | possible equivalent |
| E12-M10 | move unchecked | `_count &+= items.count` → `&+= 1` | wrong count | kill | kill | |
| E12-M11 | move UMBP capacity | `<=` → `>` | valid moves trap | kill | kill | crash |
| E12-M12 | move OutputSpan | `_extracting(first:)` → `last:` | wrong elements | kill | kill | may be equiv if full buffer |
| E12-M13 | move OutputSpan | `count = 0` → `count = count` | source not emptied | kill | kill | |
| E12-M14 | move OutputSpan capacity | `<=` → `<` | exact-fit traps | kill | kill | crash |
| E12-M15 | copy unchecked | remove empty `guard` | empty-copy edge | survive* | survive* | crash/equiv |
| E12-M16 | copy unchecked | `_count &+= newElements.count` → `&+= 1` | wrong count | kill | kill | |
| E12-M17 | copy UBP capacity | `<=` → `<` | exact-fit traps | kill | kill | crash |
| E12-M18 | copy Span capacity | `<=` → `>` | valid copies trap | kill | kill | crash |
| E12-M19 | copy Sequence fast-path | `done != nil` → `done == nil` | wrong control flow | kill | kill | |
| E12-M20 | copy Sequence overflow | `it.next() == nil` → `!= nil` | exact-fit traps | kill | kill | crash |
| E12-M21 | `_append(prefixOf:)` | skip `_count += c` | noncontig count wrong | kill | kill | |
| E12-M22 | `append(_:)` | skip `_appendUnchecked` | element not stored | kill | kill | |
| E12-M23 | move OutputSpan | skip `_appendUnchecked` | source emptied, dest unchanged | kill | kill | |
| E12-M24 | copy Span | skip `_appendUnchecked` | span copy no-op | kill | kill | |

\* “survive*” = prediction of possible semantic equivalence or unexercised empty edge; not a claim that both suites must survive.

---

## Execution protocol (frozen)

```text
Human filter: RigidArrayTests.test_append$|RigidArrayTests.test_pushLast|RigidArrayTests.test_append_addingCount_full|RigidArrayTests.test_append_addingCount_partial|RigidArrayTests.test_append_moving_UnsafeMutableBufferPointer|RigidArrayTests.test_append_moving_OutputSpan|RigidArrayTests.test_append_copying_MinimalSequence|RigidArrayTests.test_append_copying_Span
AI filter:    AIGeneratedRigidArrayAppendTests
Timeout:      60 seconds per suite run
Order:        For each mutant — Human then AI (same mutant bytes)
Restore:      ORIG between mutants; re-verify production SHA-256
```

Contamination: every Human run must execute zero `AIGenerated*` tests.

---

## FREEZE

Mutation set **frozen**. Do not add/remove/alter mutants after seeing execution results.
