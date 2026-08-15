# Experiment #10 — Mutation Results (`Polar.swift`)

**Component:** `Sources/ComplexModule/Polar.swift`  
**Frozen set:** E10-M01–E10-M24 (**24**)  
**Repo SHA:** `899af71c0256d0ad181e3b7eb3453c1065d928a5`  
**Run date (UTC):** `2026-08-13T15:54:27Z`  

**AI SHA-256:** `b8eb9d8ca821b9bd0e74d30509135ea852c8b3b8397a57a5cc53995739bbf7fe`  
**Production SHA-256 (restored):** `d7c8056e0014a70367480efe161c64fb4bc525047a8681cf2fdba8be192e68d4`

## Integrity / execution notes

| Check | Result |
|---|---|
| Production restored + SHA | ✓ |
| AI suite SHA frozen | ✓ |
| Human / AI filters PASS after run | ✓ |
| Suites unmodified post-results | ✓ |

**Build:** Polar APIs are `@_transparent` / `@inlinable`. Runner runs `swift package clean` before each mutant suite so inlined binaries cannot retain prior mutants.

**Human nondeterminism:** `testPolar` uses RNG. Human kill requires **3 consecutive failures** on the same mutant; any PASS ⇒ `SURVIVED` (flake protection). AI suite is deterministic (1 run).

## Results

| Mutation | Human | AI | Notes |
|---|---|---|---|
| E10-M01 | KILLED | KILLED | |
| E10-M02 | KILLED | KILLED | |
| E10-M03 | KILLED | KILLED | |
| E10-M04 | KILLED | KILLED | |
| E10-M05 | KILLED | KILLED | |
| E10-M06: carefulLength `.zero` | **SURVIVED** | **KILLED** | **AI-only** |
| E10-M07 | KILLED | KILLED | |
| E10-M08 | KILLED | KILLED | |
| E10-M09 | KILLED | KILLED | |
| E10-M10: phase guard `\|\|` | **SURVIVED** | **KILLED** | **AI-only** |
| E10-M11 | KILLED | KILLED | |
| E10-M12: phase `.zero` vs `.nan` | **SURVIVED** | **KILLED** | **AI-only** |
| E10-M13 | KILLED | KILLED | |
| E10-M14: polar tuple swap | **SURVIVED** | **KILLED** | **AI-only** |
| E10-M15 | KILLED | KILLED | |
| E10-M16 | KILLED | KILLED | |
| E10-M17 | KILLED | KILLED | |
| E10-M18 | KILLED | KILLED | |
| E10-M19 | KILLED | KILLED | |
| E10-M20: `Complex(-length)` | SURVIVED | SURVIVED | **INVALID-EQUIVALENT** (see below) |
| E10-M21: omit precondition | **SURVIVED** | **SURVIVED** | Shared valid survivor |
| E10-M22 | KILLED | KILLED | |
| E10-M23 | KILLED | KILLED | |
| E10-M24: carefulLength `.nan` | **SURVIVED** | **KILLED** | **AI-only** |

### Equivalence reclassification

**E10-M20 — INVALID-EQUIVALENT.** Else-branch only runs when `length` is zero or infinite. `Complex(-length)` then yields `-0` or ±∞. Under `Complex.==`, all non-finite values compare equal (`Complex+Hashable.swift`), and signed zero equals zero. Observable equality of `Complex(length: ±∞/0, phase: non-finite)` is unchanged. Excluded from scores.

## Scores (valid mutants)

| Metric | Value |
|---|---|
| Total planned | **24** |
| Excluded equivalent | **E10-M20** (1) |
| Valid mutants | **23** |
| Human killed / survived | **17 / 6** |
| Human mutation score | **73.9%** (17/23) |
| AI killed / survived | **22 / 1** |
| AI mutation score | **95.7%** (22/23) |
| Human-only kills | **none** |
| AI-only kills | **E10-M06, E10-M10, E10-M12, E10-M14, E10-M24** |
| Both survived (valid) | **E10-M21** |

### AI-only rationale

- **E10-M06 / E10-M24:** Non-finite `length` via `carefulLength`. AI asserts `.infinity` (and rejects `.nan`/`.zero`); Human `testPolar` does not assert rectangular non-finite `.length`.
- **E10-M10 / E10-M12:** Phase NaN policy for zero / non-finite. AI asserts `phase.isNaN`; Human random finite polar round-trips do not.
- **E10-M14:** `polar` property swapped. Human never reads `.polar`; AI does.

### Shared survivor

- **E10-M21:** Omits precondition on finite length + non-finite phase. Neither suite constructs that illegal input (would trap).
