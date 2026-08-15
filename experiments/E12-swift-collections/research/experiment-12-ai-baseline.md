# Experiment #12 — AI Baseline (`RigidArray+Append.swift`)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/BasicContainers/RigidArray/RigidArray+Append.swift`  
**Repo SHA:** `f3e778f17a438371c5b8c170f15c0d997bb417ee`  
**Baseline date (UTC):** `2026-08-15T16:06:31Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Production SHA-256:** `3075e1f0b035fae7b22025ae6c39ae4374e74894f1c05235e212ad815485c086`  
**AI suite SHA-256:** `2b970be758d46fca8a53b5a78c16916e14797489a4df00cd023e53200c8807c6`

AI tests were generated from **production API / module surface only**. Human tests, human fixtures, human coverage, and mutation plans were **not** consulted during generation. Suite is **FROZEN**.

---

## 1. Frozen AI suite + inventory

**Filter (frozen):**

```bash
swift test --filter 'AIGeneratedRigidArrayAppendTests'
```

**File:** `Tests/BasicContainersTests/AIGeneratedRigidArrayAppendTests.swift`

### AI executed-test inventory (28 methods)

```
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppend_afterPartialFillCopyingSpanToFull]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppend_capacityOne]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppend_intoZeroCapacityIsImpossibleWithoutTrap]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppend_mixPushLastAndAppend]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppend_preservesExistingPrefix]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppend_singleElementsUntilFull]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppendAddingCount_fillsToCapacity]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppendAddingCount_fullInitialization]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppendAddingCount_partialInitializationKeepsWrittenItems]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppendAddingCount_thenPushLastRejects]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppendAddingCount_zeroIsNoOp]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppendCopying_arraySequenceContiguous]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppendCopying_emptyNonContiguousSequence]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppendCopying_emptySequenceIsNoOp]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppendCopying_nonContiguousSequence]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppendCopying_span]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppendCopying_unsafeBufferPointer]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppendCopying_unsafeMutableBufferPointer]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppendMoving_emptySourceRigidArray]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppendMoving_emptyUnsafeBufferIsNoOp]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppendMoving_inoutRigidArray]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppendMoving_outputSpanViaEdit]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppendMoving_thenCopyingOntoRemainder]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testAppendMoving_unsafeMutableBufferPointer]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testPushLast_emptyThenFill]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testPushLast_returnsItemWhenFull]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testPushLast_returnsNilWhileSpaceRemains]
-[BasicContainersTests.AIGeneratedRigidArrayAppendTests testPushLast_zeroCapacityAlwaysRejects]
```

### Disjointness vs frozen Human inventory

| Check | Result |
|---|---|
| Human filter executes any `AIGenerated*`? | **No** |
| AI filter executes any `RigidArrayTests` method? | **No** |
| Inventories disjoint? | **Yes** |

---

## 2. Commands used

```bash
swift test --filter 'AIGeneratedRigidArrayAppendTests'
shasum -a 256 Tests/BasicContainersTests/AIGeneratedRigidArrayAppendTests.swift

swift test --enable-code-coverage --filter 'AIGeneratedRigidArrayAppendTests'

PROF=".build/arm64-apple-macosx/debug/codecov/default.profdata"
BIN=".build/arm64-apple-macosx/debug/swift-collectionsPackageTests.xctest/Contents/MacOS/swift-collectionsPackageTests"
SRC="Sources/BasicContainers/RigidArray/RigidArray+Append.swift"

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-12-ai-coverage.txt
xcrun llvm-cov show "$BIN" -instr-profile="$PROF" "$SRC" \
  > research/experiment-12-ai-coverage-detail.txt
xcrun llvm-cov report "$BIN" -instr-profile="$PROF" -show-functions "$SRC" \
  | tee research/experiment-12-ai-functions.txt
```

---

## 3. Results

| Metric | Value |
|---|---|
| Production LOC (`wc -l`) | **360** |
| Executable lines (`llvm-cov`) | **116** |
| AI test methods | **28** |
| AI assertion call sites | **77** |
| Test result | **PASS** (28 tests, 0 failures) |
| Line coverage | **93.10%** (108 / 116 lines; 8 missed) |
| Region coverage | **82.22%** (37 / 45 regions; 8 missed) |
| Function coverage | **77.14%** (27 / 35 functions; 8 missed) |

Missed regions are primarily precondition-failure string closures (trap-only paths) and compile-gated `UnstableContainersPreview` overloads.

---

## 4. Freeze confirmation

- Production SHA-256 unchanged
- AI suite SHA-256 recorded and frozen
- AI suite re-run: **PASS**
- **No further AI test edits after this freeze**
