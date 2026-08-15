# Experiment #14 — Mutation Results

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/Parsing/Builders/OneOfBuilder.swift`  
**Repo SHA:** `7160b25d39e4a38258a7fe71591fbe182b026d69`  
**Production SHA-256:** `af44508de74348ae4be49bbff0548538eb36793d38ff956eb0424dfb9699a55e`  
**AI suite SHA-256:** `f8749111c158c88eb1083e7053653a2da9e91e5ba118114f007269881f6b232d`  
**Execution date (UTC):** `2026-08-15T17:09:13Z`

Contamination: **0** contaminated Human runs (qualified filter `ParsingTests.OneOfBuilderTests`).

---

## Per-mutant outcomes

| ID | Human | AI |
|---|---|---|
| E14-M01 | KILLED | SURVIVED |
| E14-M02 | SURVIVED | SURVIVED |
| E14-M03 | KILLED | KILLED |
| E14-M04 | KILLED | KILLED |
| E14-M05 | KILLED-CRASH | KILLED-CRASH |
| E14-M06 | KILLED-CRASH | KILLED-CRASH |
| E14-M07 | KILLED | KILLED |
| E14-M08 | KILLED-CRASH | KILLED-CRASH |
| E14-M09 | KILLED-CRASH | KILLED-CRASH |
| E14-M10 | KILLED-CRASH | KILLED-CRASH |
| E14-M11 | SURVIVED | SURVIVED |
| E14-M12 | SURVIVED | SURVIVED |
| E14-M13 | SURVIVED | KILLED |
| E14-M14 | SURVIVED | KILLED-CRASH |
| E14-M15 | SURVIVED | KILLED |
| E14-M16 | KILLED-CRASH | KILLED-CRASH |
| E14-M17 | KILLED-CRASH | KILLED-CRASH |
| E14-M18 | KILLED | KILLED |
| E14-M19 | KILLED | KILLED |
| E14-M20 | KILLED | KILLED |
| E14-M21 | KILLED | SURVIVED |
| E14-M22 | SURVIVED | SURVIVED |

---

## Equivalence adjudication

Shared survivors (M02, M11, M12, M22) were reviewed. None meet the bar for **code-level behavioral identity**:

- **M02:** skipping `input = original` before the fallback parse changes observable residual input when the first parser fails after consuming; not equivalent.
- **M11:** swapping print try-order changes which printer runs first and can change `PrintingError.manyFailed` payload ordering when all printers fail; not equivalent.
- **M12:** skipping print restore can leave mutated input after a failed printer; not equivalent.
- **M22:** error-array order in `PrintingError.manyFailed` is observable in error descriptions; not equivalent.

**Invalid/equivalent exclusions:** **0**.

---

## Scores

| Metric | Human | AI |
|---|---:|---:|
| Planned / valid mutants | 22 | 22 |
| Equivalent exclusions | 0 | 0 |
| Killed | 15 | 16 |
| Survived | 7 | 6 |
| **Mutation score** | **68.2%** (15/22) | **72.7%** (16/22) |

| Bucket | Count | IDs |
|---|---:|---|
| Human-only kills | **2** | E14-M01, E14-M21 |
| AI-only kills | **3** | E14-M13, E14-M14, E14-M15 |
| Shared survivors | **4** | E14-M02, E14-M11, E14-M12, E14-M22 |

---

## Integrity

| Check | Result |
|---|---|
| Production restored | **Yes** |
| Production SHA-256 | match |
| AI suite SHA-256 | match |
| Human re-run | **PASS** (2; CLEAN) |
| AI re-run | **PASS** (18) |
| Suites modified after outcomes? | **No** |
