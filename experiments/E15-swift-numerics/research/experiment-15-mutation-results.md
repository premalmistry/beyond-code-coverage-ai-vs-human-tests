# Experiment #15 — Mutation Results

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/ComplexModule/Complex+AlgebraicField.swift`  
**Repo SHA:** `899af71c0256d0ad181e3b7eb3453c1065d928a5`  
**Production SHA-256:** `9f984d0229c4851537e5367bb944a7bd8073d35ea0e94084a201724baaca6f5b`  
**AI suite SHA-256:** `51e41c584bd813adc3bd40b6040c631437bb30ed0c57430bfec954582d926695`  
**Result date (UTC):** `2026-08-15T19:30:00Z`

Mutants frozen before execution. Same mutants vs both frozen suites.  
**Measurement note:** `@_transparent` / `@inlinable` APIs are emitted into test clients. The first runner pass used stale inlined clients after restoring ORIG; results below are from the corrected pass that force-touched `Tests/ComplexTests/*.swift` before each suite run.

---

## Per-mutant outcomes

| ID | Human | AI | Partition |
|---|---|---|---|
| E15-M01 | SURVIVED | KILLED | AI-only |
| E15-M02 | SURVIVED | KILLED | AI-only |
| E15-M03 | KILLED | KILLED | shared kill |
| E15-M04 | KILLED | KILLED | shared kill |
| E15-M05 | SURVIVED | KILLED | AI-only |
| E15-M06 | KILLED | KILLED | shared kill |
| E15-M07 | KILLED | KILLED | shared kill |
| E15-M08 | KILLED | KILLED | shared kill |
| E15-M09 | KILLED | KILLED | shared kill |
| E15-M10 | KILLED-CRASH | KILLED-CRASH | shared kill |
| E15-M11 | SURVIVED | KILLED | AI-only |
| E15-M12 | KILLED | KILLED-CRASH | shared kill |
| E15-M13 | KILLED | SURVIVED | Human-only |
| E15-M14 | KILLED | SURVIVED | Human-only |
| E15-M15 | KILLED | SURVIVED | Human-only |
| E15-M16 | KILLED | SURVIVED | Human-only |
| E15-M17 | KILLED | SURVIVED | Human-only |
| E15-M18 | SURVIVED | KILLED-CRASH | AI-only |
| E15-M19 | SURVIVED | KILLED | AI-only |
| E15-M20 | SURVIVED | KILLED | AI-only |
| E15-M21 | SURVIVED | KILLED-CRASH | AI-only |
| E15-M22 | SURVIVED | SURVIVED | shared survivor |
| E15-M23 | SURVIVED | SURVIVED | shared survivor |
| E15-M24 | SURVIVED | SURVIVED | shared survivor |

---

## Scores

| Metric | Human | AI |
|---|---:|---:|
| Valid mutants | 24 | 24 |
| Killed (incl. crash) | **13** | **16** |
| Mutation score | **54.2%** (13/24) | **66.7%** (16/24) |

| Partition | Mutants |
|---|---|
| Shared kills | E15-M03, M04, M06, M07, M08, M09, M10, M12 (**8**) |
| Human-only kills | E15-M13–M17 (**5**) — Priest / tiny-magnitude `rescaledDivide` path |
| AI-only kills | E15-M01, M02, M05, M11, M18–M21 (**8**) — `one`, `/=`, nonfinite return, `normalized`/`reciprocal` |
| Shared survivors | E15-M22, M23, M24 (**3**) |

---

## Equivalence / invalid exclusions

| Mutant | Decision | Justification |
|---|---|---|
| — | **0 excluded** | — |
| E15-M22 | **Not equivalent** | Dropping `isZero \|\| !isFinite` changes reciprocal of zero/non-finite (returns `nil` vs `recip`); neither frozen suite asserts those cases. |
| E15-M23 / M24 | **Not equivalent** | `_relaxedAdd` / `_relaxedMul` defects are observable if called; neither suite exercises them. |

Crashes (M10, M12-AI, M18-AI, M21-AI) count as **kills**.

---

## Machine-readable

`research/experiment-15-mutation-results.jsonl`
