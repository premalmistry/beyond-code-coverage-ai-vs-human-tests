# Experiment #4 — AI Baseline (`OrderedSet+Insertions.swift`)

**Component (primary):** `Sources/OrderedCollections/OrderedSet/OrderedSet+Insertions.swift`  
**AI test file (frozen):** `Tests/OrderedCollectionsTests/AIGeneratedOrderedSetInsertionsTests.swift`  
**Repo:** [apple/swift-collections](https://github.com/apple/swift-collections)  
**Repo SHA:** `f3e778f17a438371c5b8c170f15c0d997bb417ee`  
**Baseline date (UTC):** `2026-08-13T04:31:31Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**Freeze fingerprint (SHA-256):**
```
a175e50261c24830e0669209e58f7f48b3cdc413909073c8a80e30722770c2d4  Tests/OrderedCollectionsTests/AIGeneratedOrderedSetInsertionsTests.swift
```

**Production SHA-256 (unchanged):**
```
0eb00dc657e182f3254b10130bcaf6f9483b4b02d6126c47c01f0993caae5efd  Sources/OrderedCollections/OrderedSet/OrderedSet+Insertions.swift
```

Human `OrderedSetTests`, fixtures, coverage reports, and mutation artifacts were **not** consulted while authoring or fixing this suite. Production code and existing human tests were **not** modified. Coverage was measured **after** freeze; the suite was **not** edited based on coverage.

---

## Approach

- Designed solely from public APIs in `OrderedSet+Insertions.swift`: `append`, `append(contentsOf:)`, `insert(_:at:)`, `update(_:at:)`, `updateOrAppend`, `updateOrInsert`, `replace(at:with:)`.
- Asserted return tuples (`inserted` / `index` / replaced values) **and** resulting ordered contents.
- Used a local `IdentityInt` class (value-equal, identity-distinct) for in-place update / equal-replace paths.
- Covered empty/single/multi, duplicates, begin/middle/end insertion, capacity growth (hundreds of unique appends), and copy-on-write non-mutation of copies.
- Deterministic `XCTAssert*` only (no fixtures).

---

## Commands used

```bash
cd /Users/premalmistry/Desktop/Projects/AppPerformanceAnalyzer/swift-collections
git rev-parse HEAD   # f3e778f17a438371c5b8c170f15c0d997bb417ee
swift --version      # Apple Swift 6.3.3

swift test --filter AIGeneratedOrderedSetInsertionsTests --enable-code-coverage
# → Executed 41 tests, with 0 failures

shasum -a 256 Tests/OrderedCollectionsTests/AIGeneratedOrderedSetInsertionsTests.swift
# a175e50261c24830e0669209e58f7f48b3cdc413909073c8a80e30722770c2d4

shasum -a 256 Sources/OrderedCollections/OrderedSet/OrderedSet+Insertions.swift
# 0eb00dc657e182f3254b10130bcaf6f9483b4b02d6126c47c01f0993caae5efd

PROF=".build/arm64-apple-macosx/debug/codecov/default.profdata"
BIN=".build/arm64-apple-macosx/debug/swift-collectionsPackageTests.xctest/Contents/MacOS/swift-collectionsPackageTests"
SRC="Sources/OrderedCollections/OrderedSet/OrderedSet+Insertions.swift"

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-4-ai-coverage.txt

xcrun llvm-cov show "$BIN" -instr-profile="$PROF" "$SRC" \
  > research/experiment-4-ai-coverage-detail.txt

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" -show-functions "$SRC"

# Final verify
swift test --filter AIGeneratedOrderedSetInsertionsTests
# → Executed 41 tests, with 0 failures
```

Artifacts:

- `research/experiment-4-ai-coverage.txt`
- `research/experiment-4-ai-coverage-detail.txt`

---

## Results

| Metric | Value |
|---|---|
| AI test methods | **41** |
| Assertion call sites (`XCTAssert*`) | **139** |
| Test result | **PASS** (41 tests, 0 failures) |
| Executable lines (`llvm-cov`) | **142** |
| Line coverage | **82.39%** (117 / 142 lines; 25 missed) |
| Region coverage | **78.85%** (41 / 52 regions; 11 missed) |
| Function coverage | **73.08%** (19 / 26 functions; 7 missed) |

---

## Important uncovered paths

Observation only — suite **not** changed after measurement:

1. **Internal `_appendNew(_ item:)` (no bucket) L25–39** — 0 hits. Public `_append` / `append` always use `_appendNew(_:in:)` after `_find`.
2. **Precondition-failure-only closures** in `update` / `replace` (unequal update, OOB index, duplicate replace) — not violated by the suite (expected).
3. Public insert/update/replace/updateOr* paths and bucketed `_appendNew` / `_insertNew` / `_replaceNew` show full line coverage under this suite.

---

## Suite inventory (frozen)

41 methods covering: empty/single append; order-preserving append; duplicate append indexes; `append(contentsOf:)` empty/dupes/merge; insert begin/middle/end/empty/shifts; duplicate insert returns existing index; identity `update`; `updateOrAppend` insert vs replace; `updateOrInsert` new positions + existing; `replace` new + equal-identity; capacity growth; CoW; mixed round-trips; string duplicate ordering.

---

## Integrity

- Production SHA-256 unchanged.
- AI suite frozen at fingerprint above (no post-coverage edits).
- Human tests unmodified (`OrderedSetTests.swift` clean).
- Final AI re-run: **PASS** (41/0).

---

## Stop line

AI baseline for Experiment #4 is complete. **Do not compare suites, define mutations, or edit the frozen AI file until the next step is requested.**
