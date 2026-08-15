# Experiment #6 — Human Baseline (`Partition.swift`)

**Component (primary):** `Sources/Algorithms/Partition.swift`  
**Repo:** [apple/swift-algorithms](https://github.com/apple/swift-algorithms)  
**Repo SHA:** `5b7143f8e291dee0e14c118fd0212487f0b37af5`  
**Baseline date (UTC):** `2026-08-13T14:09:23Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**Production SHA-256:**
```
bef59fabc5958af321b728fb4bac230ff875db3135d17b6e5bee0216a8be3644  Sources/Algorithms/Partition.swift
```

Human tests and production code were **not** modified. No AI tests generated. No mutations defined or applied.

---

## 1. Frozen human suite + contamination guard

**Filter (frozen — do not expand later):**

```bash
swift test --filter SwiftAlgorithmsTests.PartitionTests
```

### Contamination check (Runbook v2)

| Check | Result |
|---|---|
| Proposed filter run | **PASS** (10 tests, 0 failures) |
| Any `AIGenerated*` executed? | **NO** — **CLEAN** |
| Inventory recorded | **Yes** (below) |

### Executed Human test inventory (frozen)

1. `-[SwiftAlgorithmsTests.PartitionTests testPartitionWithSubrangeBidirectionalCollection]`
2. `-[SwiftAlgorithmsTests.PartitionTests testPartitionWithSubrangeMutableCollection]`
3. `-[SwiftAlgorithmsTests.PartitionTests testPartitionedExample]`
4. `-[SwiftAlgorithmsTests.PartitionTests testPartitionedWithEmptyInput]`
5. `-[SwiftAlgorithmsTests.PartitionTests testPartitionedWithPredicate]`
6. `-[SwiftAlgorithmsTests.PartitionTests testPartitioningIndex]`
7. `-[SwiftAlgorithmsTests.PartitionTests testPartitioningIndexWithEmptyInput]`
8. `-[SwiftAlgorithmsTests.PartitionTests testPartitioningIndexWithOneEmptyPartition]`
9. `-[SwiftAlgorithmsTests.PartitionTests testStablePartition]`
10. `-[SwiftAlgorithmsTests.PartitionTests testStablePartitionWithSubrange]`

**Total human test methods:** **10**  
**Assertion call sites (static):** **39**  
(`XCTAssertEqual` / `expectEqualSequences`)

---

## 2. Commands used

```bash
cd /Users/premalmistry/Desktop/Projects/AppPerformanceAnalyzer/swift-algorithms
git rev-parse HEAD
swift --version
shasum -a 256 Sources/Algorithms/Partition.swift

FILTER='SwiftAlgorithmsTests.PartitionTests'
SRC='Sources/Algorithms/Partition.swift'
BIN='.build/arm64-apple-macosx/debug/swift-algorithmsPackageTests.xctest/Contents/MacOS/swift-algorithmsPackageTests'
PROF='.build/arm64-apple-macosx/debug/codecov/default.profdata'

swift test --filter "$FILTER"   # inventory + CLEAN contamination check
swift test --filter "$FILTER" --enable-code-coverage

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-6-human-coverage.txt
xcrun llvm-cov show "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-6-human-coverage-detail.txt

swift test --filter "$FILTER"
shasum -a 256 Sources/Algorithms/Partition.swift
```

---

## 3. Results

| Metric | Value |
|---|---|
| Production LOC (`wc -l`) | **389** |
| Executable lines (`llvm-cov`) | **216** |
| Human test methods | **10** |
| Human assertion call sites | **39** |
| Test result | **PASS** (10 tests, 0 failures) |
| Line coverage | **89.81%** (194 / 216; 22 missed) |
| Region coverage | **88.61%** (70 / 79; 9 missed) |
| Function coverage | **81.82%** (9 / 11; 2 missed) |

---

## 4. Important uncovered paths (observation only)

Do **not** add tests; do **not** expand the frozen filter.

| Path | Status |
|---|---|
| `stablePartition` recursive / public wrappers | **Covered** |
| `MutableCollection.partition(subrange:)` (non-bidirectional) | **Covered** |
| Bidirectional `partition(subrange:)` | **Covered** |
| `partitioningIndex(where:)` | **Covered** |
| `Collection.partitioned(by:)` | **Covered** |
| `Sequence.partitioned(by:)` | **Uncovered (0%)** — Array resolves to Collection overload |
| `partitioned` throwing / count-mismatch precondition path | **Mostly uncovered** (error/deinit arms) |

---

## 5. Integrity check (end of Stage 2)

| Check | Result |
|---|---|
| Production SHA-256 unchanged | **PASS** |
| Frozen human filter rerun | **PASS** (10 tests) |
| Contamination | **CLEAN** |

Human baseline is frozen. Proceed to Stage 3 (AI test generation from production only).
