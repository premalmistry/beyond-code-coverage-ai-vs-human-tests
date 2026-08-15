# Experiment #13 — Mutation Results

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/Algorithms/AdjacentPairs.swift`  
**Repo SHA:** `5b7143f8e291dee0e14c118fd0212487f0b37af5`  
**Production SHA-256:** `3918587a45e298c5dd57e1f4adfcaaaa6d10a3301a5c759ec4a6f25cdc1ebce2`  
**AI suite SHA-256:** `f6a39bdcd701de1eef7a911d832363ae09c71e45b3e832434100c6945f165cdd`  
**Execution date (UTC):** `2026-08-15T16:36:07Z`

Contamination: **0** contaminated Human runs (no `AIGenerated*` *test cases* under frozen Human filter `SwiftAlgorithmsTests.AdjacentPairsTests`).

---

## Per-mutant outcomes

| ID | Human | AI |
|---|---|---|
| E13-M01 | KILLED | KILLED |
| E13-M02 | KILLED | KILLED |
| E13-M03 | SURVIVED | KILLED-CRASH |
| E13-M04 | KILLED-CRASH | KILLED-CRASH |
| E13-M05 | SURVIVED | SURVIVED |
| E13-M06 | KILLED-CRASH | KILLED-CRASH |
| E13-M07 | KILLED-CRASH | KILLED-CRASH |
| E13-M08 | KILLED-CRASH | KILLED-CRASH |
| E13-M09 | KILLED-CRASH | KILLED |
| E13-M10 | KILLED | KILLED-CRASH |
| E13-M11 | KILLED | KILLED-CRASH |
| E13-M12 | KILLED | KILLED |
| E13-M13 | KILLED | KILLED-CRASH |
| E13-M14 | KILLED-CRASH | KILLED |
| E13-M15 | KILLED-CRASH | KILLED |
| E13-M16 | KILLED | KILLED |
| E13-M17 | KILLED-CRASH | KILLED-CRASH |
| E13-M18 | KILLED | KILLED |
| E13-M19 | KILLED | KILLED-CRASH |
| E13-M20 | SURVIVED | KILLED-CRASH |
| E13-M21 | KILLED | KILLED-TIMEOUT |
| E13-M22 | KILLED-CRASH | KILLED |
| E13-M23 | KILLED-CRASH | KILLED |
| E13-M24 | KILLED-CRASH | KILLED-CRASH |

Machine-readable: `research/experiment-13-mutation-results.jsonl`  
Raw logs: `research/mutation-logs-e13/`

---

## Equivalence adjudication

### E13-M05 (SURVIVED / SURVIVED) — **EQUIVALENT**

**Mutation:** `Index.==` compares `lhs.second == rhs.second` instead of `lhs.first == rhs.first`.

**Code-level justification:** For every valid `AdjacentPairsCollection` index, `second` is a deterministic function of `first` (either `index(after: first)` or both equal `endIndex`). Therefore two valid indices are equal iff their `first` components are equal iff their `second` components are equal. Observable equality behavior is unchanged on the type’s index domain.

**Decision:** exclude from valid denominator.

### E13-M03 / E13-M20 (SURVIVED / KILLED-*) — **not equivalent**

Human does not assert `underestimatedCount`; AI does. Behavioral change is real.

**Invalid/equivalent exclusions:** **1** (M05).

---

## Scores

Mutation score = Killed / (Killed + Survived) among **valid** mutants.  
(`KILLED` / `KILLED-CRASH` / `KILLED-TIMEOUT` count as killed.)

| Metric | Human | AI |
|---|---:|---:|
| Planned mutants | 24 | 24 |
| Equivalent exclusions | 1 | 1 |
| Valid mutants | 23 | 23 |
| Killed | 21 | 23 |
| Survived | 2 | 0 |
| **Mutation score** | **91.3%** (21/23) | **100%** (23/23) |

| Bucket | Count | IDs |
|---|---:|---|
| Human-only kills | **0** | — |
| AI-only kills | **2** | E13-M03, E13-M20 |
| Shared kills | **21** | all other valid mutants |
| Shared survivors (valid) | **0** | — |
| Equivalent (excluded) | **1** | E13-M05 |

---

## Integrity (post-execution)

| Check | Result |
|---|---|
| Production restored to ORIG | **Yes** |
| Production SHA-256 | `3918587a…1ebce2` (match) |
| AI suite SHA-256 | `f6a39bdc…165cdd` (unchanged) |
| Frozen Human suite re-run | **PASS** (12 tests; no AIGenerated test cases) |
| Frozen AI suite re-run | **PASS** (25 tests) |
| Suites edited after mutation outcomes? | **No** |
| Mutation set altered after outcomes? | **No** |
