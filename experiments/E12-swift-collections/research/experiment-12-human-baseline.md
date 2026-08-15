# Experiment #12 — Human Baseline (`RigidArray+Append.swift`)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/BasicContainers/RigidArray/RigidArray+Append.swift`  
**Repo SHA:** `f3e778f17a438371c5b8c170f15c0d997bb417ee`  
**Baseline date (UTC):** `2026-08-15T16:04:45Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Production SHA-256:** `3075e1f0b035fae7b22025ae6c39ae4374e74894f1c05235e212ad815485c086`

Human tests and production code were **not** modified. No AI tests generated yet. No mutations defined or applied.

---

## 1. Frozen human suite + contamination guard

**Filter (frozen — do not expand later):**

```bash
swift test --filter 'RigidArrayTests.test_append$|RigidArrayTests.test_pushLast|RigidArrayTests.test_append_addingCount_full|RigidArrayTests.test_append_addingCount_partial|RigidArrayTests.test_append_moving_UnsafeMutableBufferPointer|RigidArrayTests.test_append_moving_OutputSpan|RigidArrayTests.test_append_copying_MinimalSequence|RigidArrayTests.test_append_copying_Span'
```

### Contamination check (Runbook v2)

| Check | Result |
|---|---|
| Executed suite | `RigidArrayTests` only (8 methods) |
| Any `AIGenerated*` test executed? | **No** |
| Contamination | **CLEAN** |

### Human executed-test inventory

```
-[BasicContainersTests.RigidArrayTests test_append]
-[BasicContainersTests.RigidArrayTests test_append_addingCount_full]
-[BasicContainersTests.RigidArrayTests test_append_addingCount_partial]
-[BasicContainersTests.RigidArrayTests test_append_copying_MinimalSequence]
-[BasicContainersTests.RigidArrayTests test_append_copying_Span]
-[BasicContainersTests.RigidArrayTests test_append_moving_OutputSpan]
-[BasicContainersTests.RigidArrayTests test_append_moving_UnsafeMutableBufferPointer]
-[BasicContainersTests.RigidArrayTests test_pushLast]
```

**8** XCTest methods. Zero AI-generated tests in inventory (none present in tree at baseline time).

Out of frozen scope (compile-gated / disabled): `test_append_moving_InputSpan` (`#if UnstableContainersPreview`), `test_append_copying_Container` (`#if false`).

---

## 2. Commands used

```bash
cd /Users/premalmistry/Desktop/Projects/beyond-code-coverage-ai-vs-human-tests/swift-collections
git rev-parse HEAD   # f3e778f17a438371c5b8c170f15c0d997bb417ee
shasum -a 256 Sources/BasicContainers/RigidArray/RigidArray+Append.swift

HUMAN_FILTER='RigidArrayTests.test_append$|RigidArrayTests.test_pushLast|RigidArrayTests.test_append_addingCount_full|RigidArrayTests.test_append_addingCount_partial|RigidArrayTests.test_append_moving_UnsafeMutableBufferPointer|RigidArrayTests.test_append_moving_OutputSpan|RigidArrayTests.test_append_copying_MinimalSequence|RigidArrayTests.test_append_copying_Span'

swift test --filter "$HUMAN_FILTER"   # inventory + CLEAN contamination check

swift test --enable-code-coverage --filter "$HUMAN_FILTER"

PROF=".build/arm64-apple-macosx/debug/codecov/default.profdata"
BIN=".build/arm64-apple-macosx/debug/swift-collectionsPackageTests.xctest/Contents/MacOS/swift-collectionsPackageTests"
SRC="Sources/BasicContainers/RigidArray/RigidArray+Append.swift"

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-12-human-coverage.txt

xcrun llvm-cov show "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-12-human-coverage-detail.txt

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" -show-functions "$SRC" \
  | tee research/experiment-12-human-functions.txt
```

Artifacts:

- `research/experiment-12-human-coverage.txt`
- `research/experiment-12-human-coverage-detail.txt`
- `research/experiment-12-human-functions.txt`
- `research/RigidArray+Append.swift.ORIG`

---

## 3. Results

| Metric | Value |
|---|---|
| Production LOC (`wc -l`) | **360** |
| Executable lines (`llvm-cov`) | **116** |
| Human test methods | **8** |
| Human assertion call sites (`expectEqual` / `expectTrue` / `expectNil` / `expectNotNil` / `expectRigidArrayContents`) | **21** |
| Test result | **PASS** (8 tests, 0 failures) |
| Line coverage | **83.62%** (97 / 116 lines; 19 missed) |
| Region coverage | **75.56%** (34 / 45 regions; 11 missed) |
| Function coverage | **68.57%** (24 / 35 functions; 11 missed) |

---

## 4. Uncovered paths (documentation only — not fed to AI generation)

Missed regions include:

- String-literal / precondition-failure closures (capacity overflow messages) that only run on trap paths
- `append(moving: inout RigidArray)` overload (not exercised by frozen filter)
- `append(copying: UnsafeMutableBufferPointer)` thin wrapper
- Compile-gated `InputSpan` / Iterable-borrow overloads under `UnstableContainersPreview`

---

## 5. Freeze confirmation

- Production SHA-256 verified unchanged vs `research/RigidArray+Append.swift.ORIG`
- Frozen Human filter re-run: **PASS** (8 / 0 failures)
- Human filter is **FROZEN** — will not be expanded after AI generation or mutation outcomes
