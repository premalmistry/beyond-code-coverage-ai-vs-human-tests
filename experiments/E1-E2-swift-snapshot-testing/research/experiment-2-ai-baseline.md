# Experiment #2 — AI Baseline (`Any.swift`)

**Component:** `Sources/SnapshotTesting/Snapshotting/Any.swift`  
**AI test file (frozen):** `Tests/SnapshotTestingTests/AIGeneratedAnyTests.swift`  
**Repo SHA:** `59a99c458de4d2dee580529b61b4f78dca7b7fa6`  
**Baseline date (UTC):** `2026-08-13T01:07:33Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**Freeze fingerprint (SHA-256):**
```
20a9a829d91fc7f947b50a1199e24a6cc9bd24732a00dbb559ee8c8297efaf43  Tests/SnapshotTestingTests/AIGeneratedAnyTests.swift
```

Human dump tests, snapshot fixtures, and mutation lists were **not** consulted while authoring or fixing this suite. Production code and existing human tests were **not** modified.

---

## Approach

- Exercised public strategies: `.dump`, `.description`, `.json`.
- Exercised `AnySnapshotStringConvertible` (built-ins + custom `renderChildren` true/false).
- Exercised module-visible `purgePointers`.
- Rendered via `Snapshotting.snapshot(_:).run` with deterministic `XCTAssert*` (no on-disk fixtures).

Coverage targets included: structs, classes, tuples, arrays, dictionaries, sets, optionals, enums, circular references, deterministic sorting, indentation/bullets, pointer scrubbing, and edge cases.

---

## Commands used

```bash
# Run only the AI-generated suite with coverage
export SNAPSHOT_TESTING_RECORD=never
swift test --filter AIGeneratedAnyTests --enable-code-coverage

# Fingerprint
shasum -a 256 Tests/SnapshotTestingTests/AIGeneratedAnyTests.swift

# Coverage for the selected production file
PROF=".build/arm64-apple-macosx/debug/codecov/default.profdata"
BIN=".build/arm64-apple-macosx/debug/swift-snapshot-testingPackageTests.xctest/Contents/MacOS/swift-snapshot-testingPackageTests"
SRC="Sources/SnapshotTesting/Snapshotting/Any.swift"

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-2-ai-coverage.txt

xcrun llvm-cov show "$BIN" -instr-profile="$PROF" "$SRC" \
  > research/experiment-2-ai-coverage-detail.txt

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" -show-functions "$SRC"
```

Artifacts:

- `research/experiment-2-ai-coverage.txt`
- `research/experiment-2-ai-coverage-detail.txt`

---

## Results

| Metric | Value |
|---|---|
| AI test methods | **51** |
| Assertions (`XCTAssert*` call sites) | **101** |
| Test result | **PASS** (51 tests, 0 failures) |
| Line coverage | **98.56%** (137 / 139 lines; 2 missed) |
| Region coverage | **94.92%** (56 / 59 regions; 3 missed) |
| Function coverage | **96.30%** (26 / 27 functions; 1 missed) |

### Important uncovered paths

1. **`snap` default/`fallback` case** (`Any.swift` ~L141–142) — `description = String(describing: value)` never hit; all exercised values matched an earlier `Mirror.displayStyle` / protocol arm.
2. Residual missed regions/function attributed by `llvm-cov` to a short closure inside `snap` (1 line / 0%) — not a separate visible source path beyond the fallback arm above.
3. **Non-Objective-C `NSObject` conformance** (`#else` branch) inactive on this macOS host (compile-time).

---

## Suite inventory (frozen)

| Area | Coverage in AI suite |
|---|---|
| `.description` | String(describing:) parity; pathExtension |
| `.dump` structs | empty, nested, property sorting |
| Arrays | empty / 1 / many; order preserved; nesting |
| Dictionaries / sets | empty / singular / plural; deterministic sort stability |
| Tuples | labeled + unlabeled |
| Optionals | `.none` / `.some` |
| Enums | no payload / associated values |
| Classes | simple + mutual / self circular refs |
| Convertibles | Character, String, Substring, Data, Date (UTC), URL, NSObject |
| Custom convertible | `renderChildren` false (no children) / true (children rendered) |
| `purgePointers` | hex scrubbing, colon form, multi-address, plain text |
| `.json` | sorted keys + array; pathExtension |
| Edges | empty string, quotes, Bool/Double, `[Int?]`, mixed dict stability |

---

## Stop line

AI baseline for Experiment #2 is complete. **Do not create or run mutations yet.**
