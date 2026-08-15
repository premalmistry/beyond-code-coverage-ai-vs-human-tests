# Experiment #7 — Mutation Results (`Prefix.swift`)

**Component:** `Sources/Parsing/ParserPrinters/Prefix.swift`  
**Frozen set:** E7-M01–E7-M24 (**24**)  
**Repo SHA:** `7160b25d39e4a38258a7fe71591fbe182b026d69`  
**Run date (UTC):** `2026-08-13T14:32:00Z`  
**Swift:** Apple Swift 6.3.3  

**AI SHA-256:** `a0fc2c7ab3db3346e39497e73f9804098a92ae8a41ef37188975364005255b03`  
**Production SHA-256 (restored):** `da91af08f8fcf2116542fd1d423d1e1322312a15ba135de83a4085358f4159e6`

## Integrity

| Check | Result |
|---|---|
| Repo / production / AI SHA | ✓ |
| Contamination flags | all **false** |
| Suites frozen | ✓ |

## Protocol

- Runner: `research/run_e7_mutations.py`
- Human: `ParsingTests.PrefixTests` (13)
- AI: `AIGeneratedPrefixTests` (25)
- Timeout 30s; per-mutant name contamination checks
- Logs: `research/mutation-logs-e7/`; mutants: `research/mutants-e7/`

## Results table

| Mutation | Human | AI | Notes |
|---|---|---|---|
| E7-M01: ignore maximum | KILLED-TIMEOUT | KILLED | Both killed |
| E7-M02: skip predicate via `prefix=prefix` | INVALID | INVALID | Compile: self-assignment → **INVALID** |
| E7-M03: `removeFirst(0)` | KILLED | KILLED | |
| E7-M04: off-by-one remove | KILLED | KILLED | |
| E7-M05: `count > minimum` | KILLED | KILLED | |
| E7-M06: invert min guard | KILLED | KILLED | |
| E7-M07: return remainder | KILLED | KILLED | |
| E7-M08: guard before consume | KILLED | KILLED | |
| E7-M09: `prefix(minimum)` only | KILLED | KILLED | |
| E7-M10: while-init min=1 | KILLED | KILLED | |
| E7-M11: print `count > min` | KILLED | KILLED | |
| E7-M12: print invert min | KILLED | KILLED | |
| E7-M13: print `count < max` | KILLED | KILLED | |
| E7-M14: print invert max | KILLED | KILLED | |
| E7-M15: invert allSatisfy | KILLED | KILLED | |
| E7-M16: `count == maximum` | KILLED | KILLED | |
| E7-M17: next-elem `== true` | KILLED | KILLED | |
| E7-M18: omit prepend | KILLED | KILLED | |
| E7-M19: omit max print check | **SURVIVED** | **KILLED** | **AI-only** |
| E7-M20: omit allSatisfy print | **SURVIVED** | **KILLED** | **AI-only** |
| E7-M21: ignore real predicate | KILLED | KILLED | |
| E7-M22: omit min parse check | KILLED | KILLED | |
| E7-M23: while-init max=0 | KILLED | KILLED | |
| E7-M24: omit next-elem check | KILLED | KILLED | |

## Invalid assessment

### E7-M02 — INVALID

`prefix = prefix` does not compile (`error: assigning a variable to itself`). Excluded from score denominator (guaranteed compile failure; not a meaningful runtime mutant).

## Scores

| Metric | Value |
|---|---|
| Total planned | **24** |
| Invalid excluded | **1** (E7-M02) |
| Valid mutants | **23** |
| Human killed | **21** |
| Human survived | **2** (E7-M19, E7-M20) |
| Human mutation score | **91.3%** (21/23) |
| AI killed | **23** |
| AI survived | **0** |
| AI mutation score | **100.0%** (23/23) |
| Both killed | **21** |
| Human-only kills | **none** |
| AI-only kills | **E7-M19, E7-M20** |
| Both survived (valid) | **none** |
| Timeout kills | E7-M01 (Human) |

## Notes

- AI-only kills omit **print-path** validations (maximum length; predicate `allSatisfy`) that Human’s thinner print coverage (~50% of print lines at baseline) did not exercise, while AI’s dedicated print-failure tests did.
- Parser-specific defects (consumption, min/max, remainder, prepend) were largely killed by both.
