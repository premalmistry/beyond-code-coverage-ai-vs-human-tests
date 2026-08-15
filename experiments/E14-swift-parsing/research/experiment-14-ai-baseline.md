# Experiment #14 — AI Baseline (`OneOfBuilder.swift`)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/Parsing/Builders/OneOfBuilder.swift`  
**Repo SHA:** `7160b25d39e4a38258a7fe71591fbe182b026d69`  
**Baseline date (UTC):** `2026-08-15T17:06:17Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Production SHA-256:** `af44508de74348ae4be49bbff0548538eb36793d38ff956eb0424dfb9699a55e`  
**AI suite SHA-256:** `f8749111c158c88eb1083e7053653a2da9e91e5ba118114f007269881f6b232d`

AI tests generated from **production API only**. Human tests / coverage / mutations were **not** consulted during generation. Suite is **FROZEN**.

---

## 1. Frozen AI suite

**Filter:** `swift test --filter 'AIGeneratedOneOfBuilderTests'`  
**File:** `Tests/ParsingTests/AIGeneratedOneOfBuilderTests.swift`

**18** XCTest methods; **36** `XCTAssert*` assertion sites.

### Disjointness

| Check | Result |
|---|---|
| Human filter executes any `AIGenerated*` test case? | **No** |
| Inventories disjoint? | **Yes** |

---

## 2. Results

| Metric | Value |
|---|---|
| Production LOC | **253** |
| Executable lines | **84** |
| AI test methods | **18** |
| AI assertion call sites | **36** |
| Test result | **PASS** (18 / 0 failures) |
| Line coverage | **79.76%** (67 / 84) |
| Region coverage | **86.11%** (31 / 36) |
| Function coverage | **73.68%** (14 / 19) |

Missed: `buildLimitedAvailability`, identity `buildBlock` overload, Substring↔UTF8 `buildExpression` overloads.

---

## 3. Freeze confirmation

- Production SHA-256 unchanged  
- AI suite SHA-256 frozen  
- **No further AI edits after this freeze**
