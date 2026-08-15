# Experiment #14 — Human Baseline (`OneOfBuilder.swift`)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/Parsing/Builders/OneOfBuilder.swift`  
**Repo SHA:** `7160b25d39e4a38258a7fe71591fbe182b026d69`  
**Baseline date (UTC):** `2026-08-15T17:05:08Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Production SHA-256:** `af44508de74348ae4be49bbff0548538eb36793d38ff956eb0424dfb9699a55e`

Human tests and production code were **not** modified. No AI tests generated yet for this component. No mutations defined or applied.

---

## 1. Frozen human suite + contamination guard

**Filter (frozen — do not expand later):**

```bash
swift test --filter 'ParsingTests.OneOfBuilderTests'
```

**Filter note:** unqualified `OneOfBuilderTests` would also match a future `AIGeneratedOneOfBuilderTests` class name; the qualified module.class filter is required.

### Contamination check (Runbook v2)

| Check | Result |
|---|---|
| Executed suite | `OneOfBuilderTests` only (2 methods) |
| Any `AIGenerated*` *test case* executed? | **No** |
| Contamination | **CLEAN** |

### Human executed-test inventory

```
-[ParsingTests.OneOfBuilderTests testBuildArray]
-[ParsingTests.OneOfBuilderTests testBuildIf]
```

**2** XCTest methods.

---

## 2. Commands used

```bash
swift test --filter 'ParsingTests.OneOfBuilderTests'
swift test --enable-code-coverage --filter 'ParsingTests.OneOfBuilderTests'
# llvm-cov report/show/functions on Sources/Parsing/Builders/OneOfBuilder.swift
```

Artifacts: `research/experiment-14-human-coverage*.txt`, `research/OneOfBuilder.swift.ORIG`

---

## 3. Results

| Metric | Value |
|---|---|
| Production LOC (`wc -l`) | **253** |
| Executable lines (`llvm-cov`) | **84** |
| Human test methods | **2** |
| Human assertion call sites (`XCTAssert*`) | **10** |
| Test result | **PASS** (2 tests, 0 failures) |
| Line coverage | **47.62%** (40 / 84 lines; 44 missed) |
| Region coverage | **41.67%** (15 / 36 regions; 21 missed) |
| Function coverage | **47.37%** (9 / 19 functions; 10 missed) |

---

## 4. Uncovered paths (documentation only — not fed to AI)

Missed regions include empty `buildBlock()`, `buildEither` first/second, `buildLimitedAvailability`, `OneOf2.print`, `OptionalOneOf.print`, and Substring↔UTF8 `buildExpression` overloads.

---

## 5. Freeze confirmation

- Production SHA-256 verified vs ORIG
- Human filter **FROZEN**
