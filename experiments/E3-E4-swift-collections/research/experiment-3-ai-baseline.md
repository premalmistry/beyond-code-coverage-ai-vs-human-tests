# Experiment #3 — AI Baseline (`Heap+UnsafeHandle.swift`)

**Component (primary):** `Sources/HeapModule/Heap+UnsafeHandle.swift`  
**Supporting:** `Sources/HeapModule/_HeapNode.swift`  
**AI test file (frozen):** `Tests/HeapTests/AIGeneratedHeapTests.swift`  
**Repo:** [apple/swift-collections](https://github.com/apple/swift-collections)  
**Repo SHA:** `f3e778f17a438371c5b8c170f15c0d997bb417ee`  
**Baseline date (UTC):** `2026-08-13T02:37:45Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**Freeze fingerprint (SHA-256):**
```
5b0ed2763cf62f080029a76d911a10a1c5a23cec08c8eefe1e2289263aeca0ff  Tests/HeapTests/AIGeneratedHeapTests.swift
```

**Production SHA-256 (unchanged):**

| File | SHA-256 |
|---|---|
| `Heap+UnsafeHandle.swift` | `c610016a3f2601a2cc6466f90ba05a843d219490ea994421f77bb56bceda2270` |
| `_HeapNode.swift` | `0cc99c47754521861147d543d6ebd868ef7109296b9cb005c9c50bf471346736` |

Human `HeapTests` / `HeapNodeTests`, fixtures, and mutation plans were **not** consulted while authoring or fixing this suite. Production code and existing human tests were **not** modified.

---

## Approach

- Inspected only production / package-visible APIs: `Heap` (`insert`, `min`/`max`, `pop`/`remove`/`replace` min/max, `init(_:)`, `insert(contentsOf:)`, `removeAll(where:)`, `unordered`, capacity helpers, descriptions) and `Heap._isMinLevel(offset:)`.
- Drove handle algorithms indirectly: `bubbleUp` via insert / small `insert(contentsOf:)`; `trickleDownMin`/`Max` via pop/replace; `heapify` via collection init, large `insert(contentsOf:)`, and `removeAll`.
- Deterministic assertions with `XCTAssert*` (sorted drains, multiset checks, fixed LCG permutations — no nondeterministic RNG).

---

## Commands used

```bash
cd /Users/premalmistry/Desktop/Projects/AppPerformanceAnalyzer/swift-collections
git rev-parse HEAD   # f3e778f17a438371c5b8c170f15c0d997bb417ee
swift --version      # Apple Swift 6.3.3

swift test --filter AIGeneratedHeapTests --enable-code-coverage
# → Executed 50 tests, with 0 failures

shasum -a 256 Tests/HeapTests/AIGeneratedHeapTests.swift
# 5b0ed2763cf62f080029a76d911a10a1c5a23cec08c8eefe1e2289263aeca0ff

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
} | tee research/experiment-3-ai-coverage.txt

{
  echo "=== Heap+UnsafeHandle.swift (show) ==="
  xcrun llvm-cov show "$BIN" -instr-profile="$PROF" "$HANDLE"
  echo
  echo "=== _HeapNode.swift (show) ==="
  xcrun llvm-cov show "$BIN" -instr-profile="$PROF" "$NODE"
} > research/experiment-3-ai-coverage-detail.txt

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" -show-functions "$HANDLE"
xcrun llvm-cov report "$BIN" -instr-profile="$PROF" -show-functions "$NODE"

# Final verify
swift test --filter AIGeneratedHeapTests
# → Executed 50 tests, with 0 failures
```

Artifacts:

- `research/experiment-3-ai-coverage.txt`
- `research/experiment-3-ai-coverage-detail.txt`

---

## Results

### Primary: `Heap+UnsafeHandle.swift`

| Metric | Value |
|---|---|
| AI test methods | **50** |
| Assertion call sites (`XCTAssert*`) | **167** |
| Test result | **PASS** (50 tests, 0 failures) |
| Line coverage | **99.03%** (306 / 309 lines; 3 missed) |
| Region coverage | **98.28%** (114 / 116 regions; 2 missed) |
| Function coverage | **97.14%** (34 / 35 functions; 1 missed) |

### Supporting: `_HeapNode.swift`

| Metric | Value |
|---|---|
| Line coverage | **86.67%** (78 / 90 lines; 12 missed) |
| Region coverage | **86.49%** (32 / 37 regions; 5 missed) |
| Function coverage | **85.71%** (24 / 28 functions; 4 missed) |

### Combined (both files)

| Metric | Value |
|---|---|
| Line coverage | **96.24%** (384 / 399) |
| Region coverage | **95.42%** (146 / 153) |
| Function coverage | **92.06%** (58 / 63) |

### Vs human baseline (reference)

| File | Human line cov | AI line cov |
|---|---:|---:|
| `Heap+UnsafeHandle.swift` | 99.03% | 99.03% |
| `_HeapNode.swift` | 86.67% | 86.67% |

Aggregate coverage matches the human suite on these two files; differences (if any) will appear in mutation score, not line coverage.

---

## Important uncovered paths

Same structural gaps as the human baseline (observation only — no tests added for these):

1. **`subscript` `_modify`** (`Heap+UnsafeHandle.swift` L47–49) — 0 hits.
2. **`_heapify` nil `nodes` early-return** (L379) — missed region; lines otherwise covered.
3. **`_HeapNode.rightChild()` / `lastGrandchild()`** — unused; trickle paths use offset arithmetic.
4. **`_HeapNode.==` / `description`** — unused helpers.

Algorithm entry points hit under AI suite (`llvm-cov show` counts): `bubbleUp`, `_trickleDownMin`/`Max`, `_minDescendant`/`_maxDescendant`, `heapify` / `_heapify`.

---

## Suite inventory (frozen)

50 methods in `AIGeneratedHeapTests`:

empty/single/two/three-element basics; ascending/descending/duplicate insert; `insert(contentsOf:)` empty/small/large; heapify from unordered/ordered/reverse/literal/empty; pop/remove min/max drains and deep trickle; replace min/max (incl. size 1–2); `removeAll` none/all/predicate; `_isMinLevel` offsets; storage min-max property spot check; bubble/trickle scenarios; deterministic permutations; capacity/description; `Comparable` struct elements; level-boundary sizes; mixed stress.

---

## Integrity

- Production files unchanged (SHA-256 match).
- Human tests untouched.
- AI suite frozen at fingerprint above.
- Final re-run: **PASS** (50 tests, 0 failures).

---

## Stop line

AI baseline for Experiment #3 is complete. **Do not define or run mutations until the next step is requested.**
