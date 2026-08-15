# Experiment #5 — Human Baseline (`Combinations.swift`)

**Component (primary):** `Sources/Algorithms/Combinations.swift`  
**Repo:** [apple/swift-algorithms](https://github.com/apple/swift-algorithms)  
**Repo SHA:** `5b7143f8e291dee0e14c118fd0212487f0b37af5`  
**Baseline date (UTC):** `2026-08-13T13:49:19Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**Production SHA-256:**
```
a47a9033683f9be178ebd992398c1bc7c4f269c2eb02c2ac34cc7d3bd4dc2263  Sources/Algorithms/Combinations.swift
```

Human tests and production code were **not** modified. No AI tests generated. No mutations defined or applied.

---

## 1. Frozen human suite

**Filter (frozen — do not expand later):**

```bash
# Fully qualified class name required after AI suite exists (substring collision).
swift test --filter SwiftAlgorithmsTests.CombinationsTests
```

Baseline coverage was measured with `--filter CombinationsTests` **before** the AI file existed (4 tests only). Mutation execution uses the qualified filter above so Human runs never include AI tests.

| # | Test method | Exercises |
|---:|---|---|
| 1 | `testCount` | `count` / `underestimatedCount` for fixed `k` and ranges; clamp when upper bound exceeds `n` |
| 2 | `testCombinations` | Lexicographic enumeration for fixed `k` and several range forms |
| 3 | `testEmpty` | `k == 0` → one empty combo; `k`/`kRange` beyond `n` → empty sequence |
| 4 | `testCombinationsLazy` | Lazy sequence conformance for range/`k` overloads |

**Total human test methods:** **4**  
**Assertion call sites (static):** **28**  
(`XCTAssertEqual` / `expectEqualSequences` / `requireLazySequence`)

---

## 2. Commands used

```bash
cd /Users/premalmistry/Desktop/Projects/AppPerformanceAnalyzer/swift-algorithms
git rev-parse HEAD   # 5b7143f8e291dee0e14c118fd0212487f0b37af5
swift --version      # Apple Swift 6.3.3

shasum -a 256 Sources/Algorithms/Combinations.swift
# a47a9033683f9be178ebd992398c1bc7c4f269c2eb02c2ac34cc7d3bd4dc2263

FILTER='CombinationsTests'
SRC='Sources/Algorithms/Combinations.swift'
BIN='.build/arm64-apple-macosx/debug/swift-algorithmsPackageTests.xctest/Contents/MacOS/swift-algorithmsPackageTests'
PROF='.build/arm64-apple-macosx/debug/codecov/default.profdata'

swift test --filter "$FILTER" --enable-code-coverage
# → Executed 4 tests, with 0 failures

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-5-human-coverage.txt

xcrun llvm-cov show "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-5-human-coverage-detail.txt

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" -show-functions "$SRC"

# Final verify
swift test --filter "$FILTER"
# → Executed 4 tests, with 0 failures
shasum -a 256 Sources/Algorithms/Combinations.swift
```

Artifacts:

- `research/experiment-5-human-coverage.txt`
- `research/experiment-5-human-coverage-detail.txt`

---

## 3. Results

| Metric | Value |
|---|---|
| Production LOC (`wc -l`) | **311** |
| Executable lines (`llvm-cov`) | **126** |
| Human test methods | **4** |
| Human assertion call sites | **28** |
| Test result | **PASS** (4 tests, 0 failures) |
| Line coverage | **99.21%** (125 / 126 lines; 1 missed) |
| Region coverage | **96.00%** (48 / 50 regions; 2 missed) |
| Function coverage | **94.74%** (18 / 19 functions; 1 missed) |

---

## 4. Important uncovered paths (observation only)

Do **not** add tests; do **not** expand the frozen filter.

| Path | Status under frozen filter |
|---|---|
| `CombinationsSequence` init / `kRange` clamp | **Covered** |
| `count` / binomial / full-range `1 << n` | **Covered** (line hits); one binomial **region** miss remains |
| Iterator `advance` / `advanceKRange` / `next` | **Covered** |
| Range and fixed-`k` public APIs | **Covered** |
| Negative-`k` precondition failure message closure | **Uncovered (0 hits)** — expected; suite never passes `k < 0` |

---

## 5. Integrity check (end of Stage 2)

| Check | Result |
|---|---|
| Production SHA-256 unchanged | **PASS** (`a47a903…dc2263`) |
| Frozen human filter rerun | **PASS** (4 tests, 0 failures) |
| Production / human tests unmodified | **PASS** |

Human baseline is frozen. Proceed to Stage 3 (AI test generation from production only).
