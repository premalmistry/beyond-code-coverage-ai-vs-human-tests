# Experiment #7 — AI Baseline (`Prefix.swift`)

**Component:** `Sources/Parsing/ParserPrinters/Prefix.swift`  
**Repo SHA:** `7160b25d39e4a38258a7fe71591fbe182b026d69`  
**Baseline date (UTC):** `2026-08-13T14:27:58Z`  
**Swift:** Apple Swift 6.3.3  

**Isolation:** Generated from production `Prefix.swift` only. Human tests/coverage/mutations not used as generation inputs.

**Production SHA-256:** `da91af08f8fcf2116542fd1d423d1e1322312a15ba135de83a4085358f4159e6`  
**AI test SHA-256:** `a0fc2c7ab3db3346e39497e73f9804098a92ae8a41ef37188975364005255b03`

---

## Frozen AI suite

**File:** `Tests/ParsingTests/AIGeneratedPrefixTests.swift`  
**Filter:** `swift test --filter AIGeneratedPrefixTests`

| Metric | Value |
|---|---|
| AI test methods | **25** |
| Assertion call sites | **42** |
| Result | **PASS** |

### Disjoint inventory

| Check | Result |
|---|---|
| Human runs `AIGenerated*`? | **NO** (13 Human) |
| AI runs Human `PrefixTests`? | **NO** (25 AI) |
| Overlap | **empty** |

---

## Coverage

| Metric | Value |
|---|---|
| Line | **98.00%** (98 / 100) |
| Region | **83.72%** (36 / 43) |
| Function | **83.33%** (10 / 12) |

AI covers substantially more of the `print` path than Human (Human ~64% lines).

---

## Integrity

Production SHA unchanged; AI suite PASS; inventories disjoint. Proceed to Stage 4.
