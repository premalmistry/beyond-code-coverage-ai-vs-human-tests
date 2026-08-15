# Experiment #2 — Human Baseline (`Any.swift`)

**Component:** `Sources/SnapshotTesting/Snapshotting/Any.swift`  
**Repo SHA:** `59a99c458de4d2dee580529b61b4f78dca7b7fa6` (unchanged)  
**Baseline date (UTC):** `2026-08-13T01:00:41Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Production SHA-256:** `8bf07a75a11429a9900c340e1dff6495cb63d3c82290aec14c155322a5312efa`

Human tests and production code were **not** modified. No AI tests generated. No mutations defined or applied.

---

## 1. Human tests identified

Primary dump-exercising methods in `Tests/SnapshotTestingTests/SnapshotTestingTests.swift`:

| Test method | `assertSnapshot` calls | Strategy | Fixtures |
|---|---:|---|---|
| `testAny` | 1 | `.dump` | `testAny.1.txt` |
| `testRecursion` | 2 | `.dump` | `testRecursion.1.txt`, `testRecursion.2.txt` |
| `testAnySnapshotStringConvertible` | 7 | `.dump` | `character`, `data`, `date`, `nsobject`, `string`, `substring`, `url` |
| `testDeterministicDictionaryAndSetSnapshots` | 1 | `.dump` | `testDeterministicDictionaryAndSetSnapshots.1.txt` |
| `testMultipleSnapshots` | 2 | `.dump` | `testMultipleSnapshots.1.txt`, `.2.txt` |
| `testNamedAssertion` | 1 | `.dump` | `testNamedAssertion.named.txt` |
| **Total** | **14** | | **14** dump fixtures |

**Out of this baseline filter (same file, not run here):**

- `testAnyAsJson` uses `.json` (also defined in `Any.swift`) — excluded to match the candidate-selection dump focus.

---

## 2. Commands used

```bash
cd /Users/premalmistry/Desktop/Projects/AppPerformanceAnalyzer/swift-snapshot-testing
git rev-parse HEAD   # 59a99c458de4d2dee580529b61b4f78dca7b7fa6

export SNAPSHOT_TESTING_RECORD=never

# Run only the six human dump tests with coverage
swift test --enable-code-coverage \
  --filter 'SnapshotTestingTests.testAny$|SnapshotTestingTests.testRecursion|SnapshotTestingTests.testAnySnapshotStringConvertible|SnapshotTestingTests.testDeterministicDictionaryAndSetSnapshots|SnapshotTestingTests.testMultipleSnapshots|SnapshotTestingTests.testNamedAssertion'

# Coverage artifacts
PROF=".build/arm64-apple-macosx/debug/codecov/default.profdata"
BIN=".build/arm64-apple-macosx/debug/swift-snapshot-testingPackageTests.xctest/Contents/MacOS/swift-snapshot-testingPackageTests"
SRC="Sources/SnapshotTesting/Snapshotting/Any.swift"

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-2-human-coverage.txt

xcrun llvm-cov show "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-2-human-coverage-detail.txt

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" -show-functions "$SRC"

# Final verify (still passes)
SNAPSHOT_TESTING_RECORD=never swift test \
  --filter 'SnapshotTestingTests.testAny$|SnapshotTestingTests.testRecursion|SnapshotTestingTests.testAnySnapshotStringConvertible|SnapshotTestingTests.testDeterministicDictionaryAndSetSnapshots|SnapshotTestingTests.testMultipleSnapshots|SnapshotTestingTests.testNamedAssertion'
```

Artifacts:

- `research/experiment-2-human-coverage.txt`
- `research/experiment-2-human-coverage-detail.txt`

---

## 3. Results

| Metric | Value |
|---|---|
| Production LOC (`wc -l`) | **241** |
| Executable lines (`llvm-cov`) | **139** |
| Human test methods | **6** |
| Human assertions (`assertSnapshot` of `.dump`) | **14** |
| Test result | **PASS** (6 tests, 0 failures) |
| Line coverage | **77.70%** (108 / 139 lines; 31 missed) |
| Region coverage | **76.27%** (45 / 59 regions; 14 missed) |
| Function coverage | **81.48%** (22 / 27 functions; 5 missed) |

---

## 4. Important uncovered paths (observation only)

Do **not** add tests in this step. Notable gaps relative to `Any.swift`:

1. **`.description` strategy** (L16–18) — never invoked by the six dump tests (0 hits).
2. **`.json` strategy** (L72–86) — not in this filter; covered by excluded `testAnyAsJson` instead.
3. **`AnySnapshotStringConvertible` with `renderChildren == true`** (L118–119) — branch never taken; default `renderChildren` is `false` (L176–178) and no custom type overrides it to `true` in these tests.
4. **`.enum?` Mirror case** (L137–140) — 0 hits; human dump fixtures do not snapshot enums through `snap`’s enum arm.
5. **Fallback `default` case** (L141–142) — 0 hits.
6. **Non-Objective-C `NSObject` conformance** (L205–207) — inactive on this macOS/`canImport(ObjectiveC)` host (expected).

Covered and relevant for later mutation work: `.dump` entry, `snap` for structs/collections/dictionaries/sets/tuples/optionals/classes (incl. circular refs), `sort`, convertible conformances (`Character`/`Data`/`Date`/`String`/`Substring`/`URL`/`NSObject`), `purgePointers`, date formatter.

---

## 5. Integrity

- Production `Any.swift` unchanged.
- Human tests / `__Snapshots__` unchanged.
- Final re-run of the six tests: **PASS**.

---

## Stop line

Human baseline for Experiment #2 is complete. **Do not generate AI tests or mutations until the next step is requested.**
