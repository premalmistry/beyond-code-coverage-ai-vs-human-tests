# Experiment #13 — Human Baseline (`AdjacentPairs.swift`)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/Algorithms/AdjacentPairs.swift`  
**Repo SHA:** `5b7143f8e291dee0e14c118fd0212487f0b37af5`  
**Baseline date (UTC):** `2026-08-15T16:28:14Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Production SHA-256:** `3918587a45e298c5dd57e1f4adfcaaaa6d10a3301a5c759ec4a6f25cdc1ebce2`

Human tests and production code were **not** modified. No AI tests generated yet for this component. No mutations defined or applied.

---

## 1. Frozen human suite + contamination guard

**Filter (frozen — do not expand later):**

```bash
swift test --filter 'SwiftAlgorithmsTests.AdjacentPairsTests'
```

**Filter note:** unqualified `AdjacentPairsTests` also matches `AIGeneratedAdjacentPairsTests` (substring). The qualified module.class filter is required for a clean Human inventory.

### Contamination check (Runbook v2)

| Check | Result |
|---|---|
| Executed suite | `AdjacentPairsTests` only (12 methods) |
| Any `AIGenerated*` *test case* executed? | **No** |
| Contamination | **CLEAN** |

Note: package rebuild may compile other `AIGenerated*` files; that is **not** contamination unless those test cases execute under the Human filter.

### Human executed-test inventory

```
-[SwiftAlgorithmsTests.AdjacentPairsTests testEmptySequence]
-[SwiftAlgorithmsTests.AdjacentPairsTests testIndexTraversals]
-[SwiftAlgorithmsTests.AdjacentPairsTests testLaziness]
-[SwiftAlgorithmsTests.AdjacentPairsTests testManyElements]
-[SwiftAlgorithmsTests.AdjacentPairsTests testManySequences]
-[SwiftAlgorithmsTests.AdjacentPairsTests testOneElement]
-[SwiftAlgorithmsTests.AdjacentPairsTests testOneElementSequence]
-[SwiftAlgorithmsTests.AdjacentPairsTests testThreeElements]
-[SwiftAlgorithmsTests.AdjacentPairsTests testThreeElementSequence]
-[SwiftAlgorithmsTests.AdjacentPairsTests testTwoElements]
-[SwiftAlgorithmsTests.AdjacentPairsTests testTwoElementSequence]
-[SwiftAlgorithmsTests.AdjacentPairsTests testZeroElements]
```

**12** XCTest methods.

---

## 2. Commands used

```bash
swift test --filter 'SwiftAlgorithmsTests.AdjacentPairsTests'
swift test --enable-code-coverage --filter 'SwiftAlgorithmsTests.AdjacentPairsTests'

PROF=".build/arm64-apple-macosx/debug/codecov/default.profdata"
BIN=".build/arm64-apple-macosx/debug/swift-algorithmsPackageTests.xctest/Contents/MacOS/swift-algorithmsPackageTests"
SRC="Sources/Algorithms/AdjacentPairs.swift"

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-13-human-coverage.txt
xcrun llvm-cov show "$BIN" -instr-profile="$PROF" "$SRC" \
  > research/experiment-13-human-coverage-detail.txt
xcrun llvm-cov report "$BIN" -instr-profile="$PROF" -show-functions "$SRC" \
  | tee research/experiment-13-human-functions.txt
```

Artifacts: coverage txt/detail/functions; `research/AdjacentPairs.swift.ORIG`

---

## 3. Results

| Metric | Value |
|---|---|
| Production LOC (`wc -l`) | **323** |
| Executable lines (`llvm-cov`) | **156** |
| Human test methods | **12** |
| Human assertion call sites (`XCTAssert*` / `expectEqualSequences` / `requireLazy*`) | **14** |
| Test result | **PASS** (12 tests, 0 failures) |
| Line coverage | **92.95%** (145 / 156 lines; 11 missed) |
| Region coverage | **89.04%** (65 / 73 regions; 8 missed) |
| Function coverage | **80.56%** (29 / 36 functions; 7 missed) |

---

## 4. Uncovered paths (documentation only — not fed to AI)

Missed regions include `underestimatedCount`, some precondition-failure string closures, and `Index.hash(into:)`.

---

## 5. Freeze confirmation

- Production SHA-256 verified vs ORIG
- Human filter **FROZEN**
