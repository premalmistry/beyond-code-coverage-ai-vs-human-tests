# Experiment #7 — Human Baseline (`Prefix.swift`)

**Component (primary):** `Sources/Parsing/ParserPrinters/Prefix.swift`  
**Repo:** [pointfreeco/swift-parsing](https://github.com/pointfreeco/swift-parsing)  
**Repo SHA:** `7160b25d39e4a38258a7fe71591fbe182b026d69`  
**Baseline date (UTC):** `2026-08-13T14:25:35Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**Production SHA-256:**
```
da91af08f8fcf2116542fd1d423d1e1322312a15ba135de83a4085358f4159e6  Sources/Parsing/ParserPrinters/Prefix.swift
```

Human tests and production code were **not** modified. No AI tests generated. No mutations defined.

---

## 1. Frozen human suite + contamination guard

**Filter (frozen):**

```bash
swift test --filter ParsingTests.PrefixTests
```

| Check | Result |
|---|---|
| Filter run | **PASS** (13 tests, 0 failures) |
| Any `AIGenerated*` executed? | **NO** — **CLEAN** |

### Executed Human test inventory (frozen)

1. `-[ParsingTests.PrefixTests testPrefixLengthFromWhileSuccess]`
2. `-[ParsingTests.PrefixTests testPrefixOver]`
3. `-[ParsingTests.PrefixTests testPrefixRangeFromFailure]`
4. `-[ParsingTests.PrefixTests testPrefixRangeFromSuccess]`
5. `-[ParsingTests.PrefixTests testPrefixRangeFromWhileSuccess]`
6. `-[ParsingTests.PrefixTests testPrefixRangeThroughSuccess]`
7. `-[ParsingTests.PrefixTests testPrefixRangeThroughWhileSuccess]`
8. `-[ParsingTests.PrefixTests testPrefixSuccess]`
9. `-[ParsingTests.PrefixTests testPrefixUnder]`
10. `-[ParsingTests.PrefixTests testPrefixWhile]`
11. `-[ParsingTests.PrefixTests testPrefixWhileAlwaysSucceeds]`
12. `-[ParsingTests.PrefixTests testPrintUpstreamInputFailure]`
13. `-[ParsingTests.PrefixTests testPrintWithMaxCountAllowMatchingNextElement]`

**Total human test methods:** **13**  
**Assertion call sites (static):** **27**

---

## 2. Commands

```bash
FILTER='ParsingTests.PrefixTests'
SRC='Sources/Parsing/ParserPrinters/Prefix.swift'
BIN='.build/arm64-apple-macosx/debug/swift-parsingPackageTests.xctest/Contents/MacOS/swift-parsingPackageTests'
PROF='.build/arm64-apple-macosx/debug/codecov/default.profdata'

swift test --filter "$FILTER"   # inventory + CLEAN
swift test --filter "$FILTER" --enable-code-coverage
xcrun llvm-cov report "$BIN" -instr-profile="$PROF" "$SRC" | tee research/experiment-7-human-coverage.txt
xcrun llvm-cov show "$BIN" -instr-profile="$PROF" "$SRC" | tee research/experiment-7-human-coverage-detail.txt
```

---

## 3. Results

| Metric | Value |
|---|---|
| Production LOC (`wc -l`) | **191** |
| Executable lines (`llvm-cov`) | **100** (report) / **101** (functions) |
| Human test methods | **13** |
| Human assertion call sites | **27** |
| Test result | **PASS** |
| Line coverage | **64.00%** (64 / 100; 36 missed) |
| Region coverage | **58.14%** (25 / 43; 18 missed) |
| Function coverage | **66.67%** (8 / 12; 4 missed) |

---

## 4. Uncovered paths (observation only)

Do **not** expand the frozen filter.

| Path | Status |
|---|---|
| `parse` success / under-min failure | **Covered** (lines) |
| `print` min/max/predicate/next-element arms | **Partially covered** (~50% of print) |
| Some print error-description closures | **Missed** |

---

## 5. Integrity

| Check | Result |
|---|---|
| Production SHA unchanged | **PASS** |
| Human filter rerun | **PASS** |
| Contamination | **CLEAN** |

Proceed to Stage 3.
