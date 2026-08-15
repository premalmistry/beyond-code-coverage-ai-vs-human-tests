# Experiment #5 — AI Baseline (`Combinations.swift`)

**Component (primary):** `Sources/Algorithms/Combinations.swift`  
**Repo SHA:** `5b7143f8e291dee0e14c118fd0212487f0b37af5`  
**Baseline date (UTC):** `2026-08-13T13:50:45Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**Isolation:** AI suite generated from production `Combinations.swift` (+ Package/test target layout) only. Human `CombinationsTests`, human coverage artifacts, and mutation plans were **not** used as generation inputs.

**Production SHA-256:**
```
a47a9033683f9be178ebd992398c1bc7c4f269c2eb02c2ac34cc7d3bd4dc2263  Sources/Algorithms/Combinations.swift
```

**AI test file (frozen) SHA-256:**
```
e976602ed1a9a7546365a77dce298e130cee68d9645f8088bb7cdc8b52e529fa  Tests/SwiftAlgorithmsTests/AIGeneratedCombinationsTests.swift
```

---

## 1. Frozen AI suite

**File:** `Tests/SwiftAlgorithmsTests/AIGeneratedCombinationsTests.swift`  
**Filter:**

```bash
swift test --filter AIGeneratedCombinationsTests
```

| Metric | Value |
|---|---|
| AI test methods | **27** |
| AI assertion call sites (static) | **62** (`XCTAssert*` / `requireLazySequence`) |
| Test result | **PASS** (27 tests, 0 failures) |

Do **not** edit this file after freeze.

---

## 2. Commands used

```bash
cd /Users/premalmistry/Desktop/Projects/AppPerformanceAnalyzer/swift-algorithms

FILTER='AIGeneratedCombinationsTests'
SRC='Sources/Algorithms/Combinations.swift'
BIN='.build/arm64-apple-macosx/debug/swift-algorithmsPackageTests.xctest/Contents/MacOS/swift-algorithmsPackageTests'
PROF='.build/arm64-apple-macosx/debug/codecov/default.profdata'

swift test --filter "$FILTER" --enable-code-coverage
# → Executed 27 tests, with 0 failures

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-5-ai-coverage.txt

xcrun llvm-cov show "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-5-ai-coverage-detail.txt

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" -show-functions "$SRC"

shasum -a 256 Sources/Algorithms/Combinations.swift
shasum -a 256 Tests/SwiftAlgorithmsTests/AIGeneratedCombinationsTests.swift
swift test --filter "$FILTER"
```

---

## 3. Coverage results

| Metric | Value |
|---|---|
| Executable lines (`llvm-cov`) | **126** |
| Line coverage | **99.21%** (125 / 126; 1 missed) |
| Region coverage | **96.00%** (48 / 50; 2 missed) |
| Function coverage | **94.74%** (18 / 19; 1 missed) |

Missed function/line matches the negative-`k` precondition message closure (not exercised — suites do not pass `k < 0`).

---

## 4. Important uncovered paths (observation only)

Same primary miss as human baseline: precondition failure string for negative `k`. Do **not** expand the AI suite after this freeze.

---

## 5. Integrity check (end of Stage 3)

| Check | Result |
|---|---|
| Production SHA unchanged | **PASS** |
| AI test SHA recorded | **PASS** (`e976602e…52e529fa`) |
| AI suite rerun | **PASS** (27 tests) |

AI suite is frozen. Proceed to Stage 4 (mutation plan — no execution yet).
