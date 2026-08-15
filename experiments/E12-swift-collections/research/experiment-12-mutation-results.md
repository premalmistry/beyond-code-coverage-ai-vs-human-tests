# Experiment #12 — Mutation Results

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/BasicContainers/RigidArray/RigidArray+Append.swift`  
**Repo SHA:** `f3e778f17a438371c5b8c170f15c0d997bb417ee`  
**Production SHA-256:** `3075e1f0b035fae7b22025ae6c39ae4374e74894f1c05235e212ad815485c086`  
**AI suite SHA-256:** `2b970be758d46fca8a53b5a78c16916e14797489a4df00cd023e53200c8807c6`  
**Execution date (UTC):** `2026-08-15T16:12:34Z`

Contamination: **0** contaminated Human runs (no `AIGenerated*` *test cases* under the frozen Human filter; compile of the AI file during package rebuild is not contamination).

---

## Per-mutant outcomes

| ID | Human | AI |
|---|---|---|
| E12-M01 | KILLED-CRASH | KILLED-CRASH |
| E12-M02 | KILLED-CRASH | KILLED-CRASH |
| E12-M03 | KILLED | KILLED |
| E12-M04 | KILLED-CRASH | KILLED-CRASH |
| E12-M05 | KILLED-CRASH | KILLED-CRASH |
| E12-M06 | SURVIVED | KILLED-CRASH |
| E12-M07 | KILLED | KILLED |
| E12-M08 | KILLED-CRASH | KILLED-CRASH |
| E12-M09 | SURVIVED | SURVIVED |
| E12-M10 | KILLED | KILLED |
| E12-M11 | KILLED-CRASH | KILLED-CRASH |
| E12-M12 | KILLED-CRASH | KILLED |
| E12-M13 | KILLED-CRASH | KILLED |
| E12-M14 | SURVIVED | SURVIVED |
| E12-M15 | SURVIVED | SURVIVED |
| E12-M16 | KILLED | KILLED |
| E12-M17 | KILLED-CRASH | KILLED-CRASH |
| E12-M18 | KILLED-CRASH | KILLED-CRASH |
| E12-M19 | KILLED-CRASH | KILLED-CRASH |
| E12-M20 | KILLED-CRASH | KILLED-CRASH |
| E12-M21 | KILLED | KILLED |
| E12-M22 | KILLED | KILLED |
| E12-M23 | KILLED | KILLED |
| E12-M24 | KILLED | KILLED |

Machine-readable: `research/experiment-12-mutation-results.jsonl`  
Raw logs: `research/mutation-logs-e12/`

---

## Equivalence adjudication

### E12-M09 (SURVIVED / SURVIVED) — **EQUIVALENT**

**Mutation:** remove `guard items.count > 0 else { return }` before `_moveInitializePrefix` / `_count &+= items.count`.

**Code-level justification:** for `items.count == 0`, the remaining body still performs a zero-length move and adds `0` to `_count`. Observable post-state matches the early-return path for every empty buffer. Non-empty paths are unchanged.

**Decision:** exclude from valid denominator.

### E12-M15 (SURVIVED / SURVIVED) — **EQUIVALENT**

**Mutation:** remove `guard newElements.count > 0 else { return }` before `initialize(from:count:)` / `_count &+= newElements.count`.

**Code-level justification:** for `newElements.count == 0`, `initialize(..., count: 0)` is a no-op and `_count` increases by `0`. Observable post-state matches the early-return path. Non-empty paths unchanged.

**Decision:** exclude from valid denominator.

### E12-M14 (SURVIVED / SURVIVED) — **not equivalent**

**Mutation:** OutputSpan move capacity check `items.count <= freeCapacity` → `items.count < freeCapacity`.

**Why both suites survived:** neither frozen suite exercises an **exact-fit** `append(moving: OutputSpan)` (count == freeCapacity). Human `test_append_moving_OutputSpan` and AI OutputSpan/RigidArray moves use layouts with spare capacity or non-exact fills.

**Why not equivalent:** when `items.count == freeCapacity`, original accepts and mutant traps. Observable behavior differs for that legal input.

**Decision:** keep in denominator as **SURVIVED / SURVIVED**.

**Invalid/equivalent exclusions:** **2** (M09, M15).

---

## Scores

Mutation score = Killed / (Killed + Survived) × 100 among **valid** mutants.  
(`KILLED` / `KILLED-CRASH` / `KILLED-TIMEOUT` count as killed.)

| Metric | Human | AI |
|---|---:|---:|
| Planned mutants | 24 | 24 |
| Equivalent exclusions | 2 | 2 |
| Valid mutants | 22 | 22 |
| Killed | 20 | 21 |
| Survived | 2 | 1 |
| **Mutation score** | **90.9%** (20/22) | **95.5%** (21/22) |

| Bucket | Count | IDs |
|---|---:|---|
| Human-only kills | **0** | — |
| AI-only kills | **1** | E12-M06 |
| Shared kills | **20** | M01–M05, M07–M08, M10–M13, M16–M24 |
| Shared survivors (valid) | **1** | E12-M14 |
| Equivalent (excluded) | **2** | E12-M09, E12-M15 |

---

## Integrity (post-execution)

| Check | Result |
|---|---|
| Production restored to ORIG | **Yes** |
| Production SHA-256 | `3075e1f0…485c086` (match) |
| AI suite SHA-256 | `2b970be7…c8807c6` (unchanged) |
| Frozen Human suite re-run | **PASS** (8 tests, 0 failures; no AIGenerated test cases) |
| Frozen AI suite re-run | **PASS** (28 tests, 0 failures) |
| Suites edited after mutation outcomes? | **No** |
| Mutation set altered after outcomes? | **No** |
