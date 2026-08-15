# Experiment #11 — Mutation Results

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/SnapshotTesting/SnapshotTestingConfiguration.swift`  
**Repo SHA:** `59a99c458de4d2dee580529b61b4f78dca7b7fa6`  
**Production SHA-256:** `03b9c85eff3222eb65884df4ae5ea2f383385357e64ca3efe1bb48fd8fee1217`  
**AI suite SHA-256:** `77ec567def90a1d0c4ccfe7ba12c593098494ead8065039df0906aaecf795bf9`  
**Execution date (UTC):** `2026-08-15T15:38:00Z`

Contamination: **0** contaminated Human runs (no `AIGenerated*` test cases under the frozen Human filter).

---

## Per-mutant outcomes

| ID | Human | AI |
|---|---|---|
| E11-M01 | SURVIVED | KILLED |
| E11-M02 | SURVIVED | KILLED |
| E11-M03 | SURVIVED | KILLED |
| E11-M04 | SURVIVED | KILLED |
| E11-M05 | KILLED | KILLED |
| E11-M06 | SURVIVED | KILLED |
| E11-M07 | SURVIVED | KILLED |
| E11-M08 | SURVIVED | KILLED |
| E11-M09 | SURVIVED | KILLED |
| E11-M10 | SURVIVED | KILLED |
| E11-M11 | SURVIVED | KILLED |
| E11-M12 | SURVIVED | KILLED |
| E11-M13 | KILLED | KILLED |
| E11-M14 | KILLED | SURVIVED |
| E11-M15 | KILLED | KILLED |
| E11-M16 | KILLED | KILLED |
| E11-M17 | SURVIVED | KILLED |
| E11-M18 | KILLED | KILLED |
| E11-M19 | KILLED | KILLED |
| E11-M20 | KILLED | KILLED |
| E11-M21 | SURVIVED | KILLED |
| E11-M22 | SURVIVED | SURVIVED |
| E11-M23 | KILLED | KILLED |
| E11-M24 | KILLED | KILLED |

---

## Equivalence adjudication

### E11-M22 (SURVIVED / SURVIVED) — **not equivalent**

**Mutation:** async `withSnapshotTesting` ignores the explicit `diffTool:` argument and uses `current?.diffTool ?? _diffTool` only.

**Why both suites survived (observation, not equivalence):**

- Human frozen filter never calls the async overload.
- AI “async” tests use `await withSnapshotTesting { … }` with a **synchronous** closure body; Swift resolves the **sync** overload (compiler warns “no async operations occur within await”). Therefore the async-overload mutant is not exercised by either frozen suite.

**Why not INVALID-EQUIVALENT:** the async API’s observable behavior changes when a caller passes an explicit `diffTool` while `current?.diffTool` is nil (would fall back to `_diffTool` / `.default` instead of the explicit tool). A truly `async` operation closure would observe the defect. Per Runbook v2, survival by both suites is insufficient for equivalence without a code-level identity argument.

**Decision:** keep in denominator as **SURVIVED / SURVIVED**.

No other shared survivors. **Invalid/equivalent exclusions: 0.**

---

## Scores

Mutation score = Killed / (Killed + Survived) × 100  
(`KILLED` / `KILLED-CRASH` / `KILLED-TIMEOUT` count as killed.)

| Metric | Human | AI |
|---|---:|---:|
| Planned mutants | 24 | 24 |
| Valid mutants | 24 | 24 |
| Invalid/equivalent | 0 | 0 |
| Killed | 10 | 22 |
| Survived | 14 | 2 |
| **Mutation score** | **41.7%** (10/24) | **91.7%** (22/24) |

| Bucket | Count | IDs |
|---|---:|---|
| Both killed | 9 | M05, M13, M15, M16, M18, M19, M20, M23, M24 |
| Human-only kills | 1 | **M14** |
| AI-only kills | 13 | M01–M04, M06–M12, M17, M21 |
| Both survived | 1 | M22 |
| Crash kills | 0 | — |
| Timeout kills | 0 | — |

---

## Notable examples

- **Human-only M14:** `DiffTool.default` swaps current/failed paths. Human `WithSnapshotTestingTests.testNesting` asserts the **exact** default help string (path order). AI only asserts that both `file://` URLs appear via `contains`, so order swap survives AI.
- **AI-only cluster (Record rawValue / bool / nilLiteral / ksdiff):** Human filter never constructs `Record(rawValue:)` or boolean/`nil` DiffTool literals and never asserts `.ksdiff` command formatting; AI does.
- **Coverage vs mutation:** AI line coverage was 97.78% vs Human 57.78%; mutation gap (91.7% vs 41.7%) aligns with Human missing Record-parsing and DiffTool.ksdiff oracles, plus one Human-only kill inside a path AI already covered weakly (M14).
