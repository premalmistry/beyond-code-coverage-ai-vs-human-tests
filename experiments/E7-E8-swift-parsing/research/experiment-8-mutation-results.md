# Experiment #8 — Mutation Results (`Digits.swift`)

**Component:** `Sources/Parsing/ParserPrinters/Digits.swift`  
**Frozen set:** E8-M01–E8-M24 (**24**)  
**Repo SHA:** `7160b25d39e4a38258a7fe71591fbe182b026d69`  
**Run date (UTC):** `2026-08-13T15:05:00Z`  

**AI SHA-256:** `f5525799b968cb0c7b43c35874b0c9843fa602dad66644be26c47858f39e888d`  
**Production SHA-256 (restored):** `551333cb817917cdce03362e1949e848cd7245b9d8c1a91257407e3c531157ce`

## Integrity

| Check | Result |
|---|---|
| SHA / contamination | ✓ all clean |
| Suites frozen | ✓ |

## Results

| Mutation | Human | AI | Notes |
|---|---|---|---|
| E8-M01 | KILLED | KILLED | |
| E8-M02 | KILLED | KILLED | |
| E8-M03 | KILLED | KILLED | |
| E8-M04 | KILLED | KILLED | |
| E8-M05 | KILLED | KILLED | |
| E8-M06 | KILLED | KILLED | |
| E8-M07 | KILLED | KILLED | |
| E8-M08 | KILLED | KILLED | |
| E8-M09 | KILLED | KILLED | |
| E8-M10 | KILLED | KILLED | |
| E8-M11 | KILLED | KILLED | |
| E8-M12 | KILLED | KILLED | |
| E8-M13 | KILLED | KILLED | |
| E8-M14 | KILLED | KILLED | |
| E8-M15 | KILLED | KILLED | |
| E8-M16 | KILLED | KILLED | |
| E8-M17 | KILLED | KILLED | |
| E8-M18: `count >= maximum` | **SURVIVED** | **KILLED** | **AI-only** |
| E8-M19 | KILLED | KILLED | |
| E8-M20 | KILLED | KILLED | |
| E8-M21 | KILLED | KILLED | |
| E8-M22 | KILLED | KILLED | |
| E8-M23 | KILLED | KILLED | |
| E8-M24: omit negative print guard | **SURVIVED** | **KILLED** | **AI-only** |

No INVALID / INVALID-EQUIVALENT reclassifications.

## Scores

| Metric | Value |
|---|---|
| Total planned / valid | **24 / 24** |
| Human killed / survived | **22 / 2** |
| Human mutation score | **91.7%** (22/24) |
| AI killed / survived | **24 / 0** |
| AI mutation score | **100.0%** (24/24) |
| Human-only kills | **none** |
| AI-only kills | **E8-M18, E8-M24** |
| Both survived (valid) | **none** |

### AI-only rationale

- **E8-M18:** Tightens print max from `count > maximum` to `>=`. Human only asserts over-max (`255` into `Digits(2)`); AI also prints exact-width values (`Digits(2).print(42)`), which the mutant rejects.
- **E8-M24:** Removes negative print rejection. Human never prints negatives; AI’s `testPrintFailsOnNegative` kills it.
