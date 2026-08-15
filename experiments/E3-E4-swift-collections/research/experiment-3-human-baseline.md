# Experiment #3 — Human Baseline (`Heap+UnsafeHandle.swift`)

**Component (primary):** `Sources/HeapModule/Heap+UnsafeHandle.swift`  
**Supporting (coverage only):** `Sources/HeapModule/_HeapNode.swift`  
**Repo:** [apple/swift-collections](https://github.com/apple/swift-collections)  
**Repo SHA:** `f3e778f17a438371c5b8c170f15c0d997bb417ee` (unchanged)  
**Baseline date (UTC):** `2026-08-13T02:29:40Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**Production SHA-256:**

| File | SHA-256 |
|---|---|
| `Sources/HeapModule/Heap+UnsafeHandle.swift` | `c610016a3f2601a2cc6466f90ba05a843d219490ea994421f77bb56bceda2270` |
| `Sources/HeapModule/_HeapNode.swift` | `0cc99c47754521861147d543d6ebd868ef7109296b9cb005c9c50bf471346736` |

Human tests and production code were **not** modified. No AI tests generated. No mutations defined or applied.

---

## 1. Human tests identified

Filter: `swift test --filter HeapTests`  
(runs both `HeapTests` and `HeapNodeTests` XCTest suites in target `HeapTests`)

| Suite | File | Test methods |
|---|---|---:|
| `HeapTests` | `Tests/HeapTests/HeapTests.swift` | **31** |
| `HeapNodeTests` | `Tests/HeapTests/HeapNodeTests.swift` | **1** (`test_levelCalculation`) |
| **Total** | | **32** |

**Assertion call sites (static):** **245**  
(`expectEqual` / `expectTrue` / `expectFalse` / `expectNil` / `expectNotNil` / `XCTAssertEqual` word-boundary matches in `Tests/HeapTests/`)

Coverage of public Heap API exercised by these tests: empty/count, insert (+ random / `contentsOf`), min/max, pop/remove min/max, min/max replacement, initializers (collection/sequence/array literal/random), tie-breaks, `removeAll`, plus `_HeapNode` min-level calculation.

---

## 2. Commands used

```bash
cd /Users/premalmistry/Desktop/Projects/AppPerformanceAnalyzer/swift-collections
git rev-parse HEAD   # f3e778f17a438371c5b8c170f15c0d997bb417ee
swift --version      # Apple Swift 6.3.3

shasum -a 256 \
  Sources/HeapModule/Heap+UnsafeHandle.swift \
  Sources/HeapModule/_HeapNode.swift

swift test --filter HeapTests --enable-code-coverage
# → Executed 32 tests, with 0 failures

PROF=".build/arm64-apple-macosx/debug/codecov/default.profdata"
BIN=".build/arm64-apple-macosx/debug/swift-collectionsPackageTests.xctest/Contents/MacOS/swift-collectionsPackageTests"
HANDLE="Sources/HeapModule/Heap+UnsafeHandle.swift"
NODE="Sources/HeapModule/_HeapNode.swift"

{
  echo "=== Heap+UnsafeHandle.swift ==="
  xcrun llvm-cov report "$BIN" -instr-profile="$PROF" "$HANDLE"
  echo
  echo "=== _HeapNode.swift ==="
  xcrun llvm-cov report "$BIN" -instr-profile="$PROF" "$NODE"
  echo
  echo "=== Combined (both files) ==="
  xcrun llvm-cov report "$BIN" -instr-profile="$PROF" "$HANDLE" "$NODE"
} | tee research/experiment-3-human-coverage.txt

{
  echo "=== Heap+UnsafeHandle.swift (show) ==="
  xcrun llvm-cov show "$BIN" -instr-profile="$PROF" "$HANDLE"
  echo
  echo "=== _HeapNode.swift (show) ==="
  xcrun llvm-cov show "$BIN" -instr-profile="$PROF" "$NODE"
} | tee research/experiment-3-human-coverage-detail.txt

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" -show-functions "$HANDLE"
xcrun llvm-cov report "$BIN" -instr-profile="$PROF" -show-functions "$NODE"

# Final verify
swift test --filter HeapTests
# → Executed 32 tests, with 0 failures
```

Artifacts:

- `research/experiment-3-human-coverage.txt`
- `research/experiment-3-human-coverage-detail.txt`

---

## 3. Results

### Primary: `Heap+UnsafeHandle.swift`

| Metric | Value |
|---|---|
| Production LOC (`wc -l`) | **390** |
| Executable lines (`llvm-cov`) | **309** |
| Human test methods (filter) | **32** |
| Human assertion call sites | **245** |
| Test result | **PASS** (32 tests, 0 failures) |
| Line coverage | **99.03%** (306 / 309 lines; 3 missed) |
| Region coverage | **98.28%** (114 / 116 regions; 2 missed) |
| Function coverage | **97.14%** (34 / 35 functions; 1 missed) |

Missed function: subscript `_modify` accessor (L47–49).  
Missed region #2: `_heapify` `guard let nodes else { return }` nil arm (L379) — never taken under this suite.

### Supporting: `_HeapNode.swift`

| Metric | Value |
|---|---|
| Production LOC (`wc -l`) | **176** |
| Executable lines (`llvm-cov`) | **90** |
| Line coverage | **86.67%** (78 / 90 lines; 12 missed) |
| Region coverage | **86.49%** (32 / 37 regions; 5 missed) |
| Function coverage | **85.71%** (24 / 28 functions; 4 missed) |

Missed functions: `==`, `description`, `rightChild()`, `lastGrandchild()`.

### Combined (both files)

| Metric | Value |
|---|---|
| Executable lines | **399** |
| Line coverage | **96.24%** (384 / 399) |
| Region coverage | **95.42%** (146 / 153) |
| Function coverage | **92.06%** (58 / 63) |

---

## 4. Important uncovered paths (observation only)

Do **not** add tests in this step.

### Algorithm paths in `Heap+UnsafeHandle.swift` — status

| Path | Coverage under `HeapTests` |
|---|---|
| **`bubbleUp`** | **Fully covered** (root early-return; parent swap; min- and max-level grandparent loops all hit) |
| **`trickleDownMin` / `_trickleDownMin`** | **Fully covered** (4-grandchild loop, early done, no-descendants, partial descendant via `_minDescendant`, parent re-check) |
| **`trickleDownMax` / `_trickleDownMax`** | **Fully covered** (symmetric to min) |
| **Child / grandchild selection** (`_minDescendant` / `_maxDescendant`) | **Fully covered** (0–3 grandchildren + 1–2 children arms all hit via offset arithmetic) |
| **Min / max level logic** | **Fully covered** in handle (`bubbleUp` / `_heapify` `isMinLevel` branches) and via `HeapNodeTests.test_levelCalculation` |
| **`heapify` / `_heapify`** | **Lines fully covered**; **one missed region**: nil `nodes` early-return in `_heapify` (L379) never executed |

### Gaps (non-algorithm / unused helpers)

1. **`subscript` `_modify`** (UnsafeHandle L47–49) — 0 hits; tests mutate via `swapAt` / `extract` / `initialize`, not `_modify`.
2. **`_heapify` nil `nodes`** (L379) — `allNodes` always non-nil when reached from `heapify` in this suite.
3. **`_HeapNode.rightChild()` / `lastGrandchild()`** — 0 hits; trickle paths use `leftChild` / `firstGrandchild` plus `offset &+ n` instead of these helpers.
4. **`_HeapNode.==` / `description`** — unused by human suite (Comparable `<` is used).
5. **`allNodes` nil return** — region miss when `first.offset >= limit` (function regions 80%); line counters still show activity on the guard line.

**Implication for later mutation work:** human suite already exercises the dense algorithmic surface extremely thoroughly. Expect a **high human mutation score** on comparison/branch mutants inside bubble/trickle/descendant selection; remaining gaps are mostly unused accessors, not untested heap algorithms.

---

## 5. Integrity

- Production `Heap+UnsafeHandle.swift` / `_HeapNode.swift` unchanged (SHA-256 match above).
- Human tests unchanged (`Tests/HeapTests/*` untracked-only delta is `research/`).
- Final re-run: `swift test --filter HeapTests` → **PASS** (32 tests, 0 failures).

---

## Stop line

Human baseline for Experiment #3 is complete. **Do not generate AI tests or mutations until the next step is requested.**
