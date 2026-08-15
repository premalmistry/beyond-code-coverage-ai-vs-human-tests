# AI Test Baseline — URLRequest Snapshotting

**Component:** `Sources/SnapshotTesting/Snapshotting/URLRequest.swift`  
**AI test file (frozen):** `Tests/SnapshotTestingTests/AIGeneratedURLRequestTests.swift`  
**Repo SHA:** `59a99c458de4d2dee580529b61b4f78dca7b7fa6`  
**Baseline date (UTC):** `2026-08-13T00:43:37Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**Freeze fingerprint (SHA-256):**
```
1eba2811acf4de49c78c9f6c2ce1bf60d345317877a780c363587fd2bce0d2b4  Tests/SnapshotTestingTests/AIGeneratedURLRequestTests.swift
```

Human tests, snapshot fixtures, and the experiment mutation list were **not** consulted while authoring or fixing this suite. Production code and existing human tests were **not** modified.

---

## Approach

- Exercised public strategies: `.raw`, `.raw(pretty:)`, `.curl`.
- Rendered strategy output via `Snapshotting.snapshot(_:).run` and asserted with **deterministic** `XCTAssert*`.
- Covered HTTP methods, headers, cookies, bodies, query sorting, nil URL, pretty JSON, invalid JSON fallback, non-UTF8 body, and combined curl cases.

---

## Commands used

```bash
# Run only the AI-generated suite with coverage instrumentation
swift test --filter AIGeneratedURLRequestTests --enable-code-coverage

# Coverage for the selected production file
PROF=".build/arm64-apple-macosx/debug/codecov/default.profdata"
BIN=".build/arm64-apple-macosx/debug/swift-snapshot-testingPackageTests.xctest/Contents/MacOS/swift-snapshot-testingPackageTests"

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" \
  Sources/SnapshotTesting/Snapshotting/URLRequest.swift

xcrun llvm-cov show "$BIN" -instr-profile="$PROF" \
  Sources/SnapshotTesting/Snapshotting/URLRequest.swift

# Optional: per-function breakdown
xcrun llvm-cov report "$BIN" -instr-profile="$PROF" -show-functions \
  Sources/SnapshotTesting/Snapshotting/URLRequest.swift

# Freeze checksum
shasum -a 256 Tests/SnapshotTestingTests/AIGeneratedURLRequestTests.swift
```

Artifacts:

- `research/ai-urlrequest-coverage.txt`
- `research/ai-urlrequest-coverage-detail.txt`

---

## Results

| Metric | Value |
|---|---|
| AI test methods | **44** |
| Assertions (`XCTAssert*` call sites) | **56** |
| Test result | **PASS** (44 tests, 0 failures) |
| Line coverage | **98.44%** (126 / 128 lines; 2 missed) |
| Region coverage | **94.44%** (34 / 36 regions; 2 missed) |
| Function coverage | **86.67%** (13 / 15 functions; 2 missed) |

### Notes on residual uncovereds

`llvm-cov -show-functions` attributes the two missed regions/functions to short closures inside `raw(pretty:)`’s `map` / error-handling chain (1 line each at 0%). No executable source lines in the coverage listing show a `0` hit count on the main formatting paths; `.raw(pretty: true)` success and fallback paths were exercised.

---

## Suite inventory (frozen)

| Area | Tests (representative) |
|---|---|
| raw methods | GET (nil + explicit), POST, PUT, DELETE, HEAD, PATCH |
| raw headers | sorted headers, Cookie included in raw, empty headers |
| raw body | blank-line prefix, with headers, no body, pretty:false JSON |
| raw(pretty:) | sorted pretty JSON (exact + key-order), invalid JSON fallback, empty body, JSON array |
| raw query | name sorting, value preservation, no-query |
| raw edges | nil URL, nil URL + headers/body, `.raw` ≡ `.raw(pretty: false)` |
| curl methods | GET / HEAD / POST / PUT / DELETE / PATCH |
| curl headers/cookies | sorted headers excluding Cookie, quote escape, cookie-only, cookie escape |
| curl body | UTF-8 `--data`, quote escape, missing body, non-UTF8 body omitted |
| curl query / combined | sorted query; full POST with headers+cookie+body+query |
| meta | `pathExtension == "txt"` for strategies |

---

## Stop line

AI baseline complete. **Do not run or inspect the mutation list yet.**
