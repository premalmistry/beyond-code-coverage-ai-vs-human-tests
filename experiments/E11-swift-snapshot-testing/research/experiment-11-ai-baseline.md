# Experiment #11 — AI Baseline (`SnapshotTestingConfiguration.swift`)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/SnapshotTesting/SnapshotTestingConfiguration.swift`  
**AI test file (frozen):** `Tests/SnapshotTestingTests/AIGeneratedSnapshotTestingConfigurationTests.swift`  
**Repo SHA:** `59a99c458de4d2dee580529b61b4f78dca7b7fa6`  
**Baseline date (UTC):** `2026-08-15T15:30:40Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**Production SHA-256:** `03b9c85eff3222eb65884df4ae5ea2f383385357e64ca3efe1bb48fd8fee1217` (unchanged)  
**AI suite SHA-256:** `77ec567def90a1d0c4ccfe7ba12c593098494ead8065039df0906aaecf795bf9`

---

## Isolation

AI generation inspected **only**:

- `Sources/SnapshotTesting/SnapshotTestingConfiguration.swift`
- Package / module imports required to compile tests (`@_spi(Internals) @testable import SnapshotTesting`)

AI generation did **not** inspect human test files, fixtures, human coverage reports, uncovered-path analysis, mutation plans, or mutation results.

Generation was iterative only against compiler / AI-suite failures until PASS, then frozen.

---

## Commands

```bash
SNAPSHOT_TESTING_RECORD=never \
  swift test --filter AIGeneratedSnapshotTestingConfigurationTests

SNAPSHOT_TESTING_RECORD=never \
  swift test --enable-code-coverage \
  --filter AIGeneratedSnapshotTestingConfigurationTests

PROF=".build/arm64-apple-macosx/debug/codecov/default.profdata"
BIN=".build/arm64-apple-macosx/debug/swift-snapshot-testingPackageTests.xctest/Contents/MacOS/swift-snapshot-testingPackageTests"
SRC="Sources/SnapshotTesting/SnapshotTestingConfiguration.swift"

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-11-ai-coverage.txt
xcrun llvm-cov show "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-11-ai-coverage-detail.txt
```

---

## Results

| Metric | Value |
|---|---|
| AI test methods | **24** |
| AI assertion call sites (`XCTAssert*`) | **42** |
| Test result | **PASS** (24 tests, 0 failures) |
| Line coverage | **97.78%** (88 / 90 lines; 2 missed) |
| Region coverage | **94.44%** (34 / 36 regions; 2 missed) |
| Function coverage | **91.30%** (21 / 23 functions; 2 missed) |

Missed coverage (2 lines / 2 functions): residual async `withSnapshotTesting` fallback closures attributed by `llvm-cov` when optional `record`/`diffTool` arguments take the `current ?? _record` / `_diffTool` arm in ways not separately hit as named functions. Main async path, Record rawValue switch, boolean/nil literals, DiffTool formatting, and sync nesting are covered.

---

## Human/AI inventory disjointness

| Filter | Suites executed | `AIGenerated*` present? |
|---|---|---|
| `RecordTests\|WithSnapshotTestingTests` | RecordTests, WithSnapshotTestingTests only | **No** |
| `AIGeneratedSnapshotTestingConfigurationTests` | AIGeneratedSnapshotTestingConfigurationTests only | **Yes (AI only)** |

Inventories are disjoint. Human filter contamination: **CLEAN**.

---

## Freeze

AI suite is **frozen**. Do not edit after this point.

Proceed to Stage 4 (Mutation Plan).
