# Experiment #11 — Human Baseline (`SnapshotTestingConfiguration.swift`)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/SnapshotTesting/SnapshotTestingConfiguration.swift`  
**Repo SHA:** `59a99c458de4d2dee580529b61b4f78dca7b7fa6`  
**Baseline date (UTC):** `2026-08-15T15:28:18Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Production SHA-256:** `03b9c85eff3222eb65884df4ae5ea2f383385357e64ca3efe1bb48fd8fee1217`

Human tests and production code were **not** modified. No AI tests generated yet. No mutations defined or applied.

---

## 1. Frozen human suite + contamination guard

**Filter (frozen — do not expand later):**

```bash
swift test --filter 'RecordTests|WithSnapshotTestingTests'
```

### Contamination check (Runbook v2)

| Check | Result |
|---|---|
| Executed suites | `RecordTests`, `WithSnapshotTestingTests` only |
| Any `AIGenerated*` test executed? | **No** |
| Contamination | **CLEAN** |

### Human executed-test inventory

```
-[SnapshotTestingTests.RecordTests testRecordAll_Fresh]
-[SnapshotTestingTests.RecordTests testRecordAll_Overwrite]
-[SnapshotTestingTests.RecordTests testRecordFailed_MissingFile]
-[SnapshotTestingTests.RecordTests testRecordFailed_NoFailure]
-[SnapshotTestingTests.RecordTests testRecordFailed_WhenFailure]
-[SnapshotTestingTests.RecordTests testRecordMissing]
-[SnapshotTestingTests.RecordTests testRecordMissing_ExistingFile]
-[SnapshotTestingTests.RecordTests testRecordNever]
-[SnapshotTestingTests.WithSnapshotTestingTests testNesting]
```

**9** XCTest methods. Zero AI-generated tests in inventory (none present in tree at baseline time under this checkout).

---

## 2. Commands used

```bash
cd /Users/premalmistry/Desktop/Projects/beyond-code-coverage-ai-vs-human-tests/swift-snapshot-testing
git rev-parse HEAD   # 59a99c458de4d2dee580529b61b4f78dca7b7fa6
shasum -a 256 Sources/SnapshotTesting/SnapshotTestingConfiguration.swift

export SNAPSHOT_TESTING_RECORD=never

swift test --filter 'RecordTests|WithSnapshotTestingTests'   # inventory + CLEAN contamination check

swift test --enable-code-coverage \
  --filter 'RecordTests|WithSnapshotTestingTests'

PROF=".build/arm64-apple-macosx/debug/codecov/default.profdata"
BIN=".build/arm64-apple-macosx/debug/swift-snapshot-testingPackageTests.xctest/Contents/MacOS/swift-snapshot-testingPackageTests"
SRC="Sources/SnapshotTesting/SnapshotTestingConfiguration.swift"

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-11-human-coverage.txt

xcrun llvm-cov show "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-11-human-coverage-detail.txt

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" -show-functions "$SRC"
```

Artifacts:

- `research/experiment-11-human-coverage.txt`
- `research/experiment-11-human-coverage-detail.txt`
- `research/SnapshotTestingConfiguration.swift.ORIG`

---

## 3. Results

| Metric | Value |
|---|---|
| Production LOC (`wc -l`) | **236** |
| Executable lines (`llvm-cov`) | **90** |
| Human test methods | **9** |
| Human assertion call sites (`XCTAssert*` / `XCTExpectFailure` / `assertSnapshot`) | **28** |
| Test result | **PASS** (9 tests, 0 failures) |
| Line coverage | **57.78%** (52 / 90 lines; 38 missed) |
| Region coverage | **41.67%** (15 / 36 regions; 21 missed) |
| Function coverage | **56.52%** (13 / 23 functions; 10 missed) |

---

## 4. Uncovered paths (documentation only — not fed to AI generation)

From `llvm-cov` function report / detail (human filter only):

- Async `withSnapshotTesting(... operation: () async throws -> R)` entirely missed
- `Record.init?(rawValue:)` switch (`"all"` / `"failed"` / `"missing"` / `"never"` / default `nil`) entirely missed
- `Record` boolean-literal bridge (`true` → `.all`, `false` → `.missing`) entirely missed
- `DiffTool` nil-literal deprecated bridge entirely missed
- Some nested fallback closures inside sync `withSnapshotTesting` attributed as missed regions

Covered by human suite: sync `withSnapshotTesting`, nested record inheritance, `DiffTool.ksdiff` / `.default` / string-literal tool formatting, `callAsFunction`, and Record static cases via `.never` / `.missing` / `.all` / `.failed` usage.

---

## 5. Final verify

```bash
shasum -a 256 Sources/SnapshotTesting/SnapshotTestingConfiguration.swift
# 03b9c85eff3222eb65884df4ae5ea2f383385357e64ca3efe1bb48fd8fee1217

SNAPSHOT_TESTING_RECORD=never swift test --filter 'RecordTests|WithSnapshotTestingTests'
# PASS (9 tests, 0 failures); contamination CLEAN
```

Human baseline is frozen. Proceed to Stage 3 (AI test generation from production only).
