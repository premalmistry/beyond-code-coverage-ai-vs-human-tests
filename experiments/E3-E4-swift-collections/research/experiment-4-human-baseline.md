# Experiment #4 — Human Baseline (`OrderedSet+Insertions.swift`)

**Component (primary):** `Sources/OrderedCollections/OrderedSet/OrderedSet+Insertions.swift`  
**Repo:** [apple/swift-collections](https://github.com/apple/swift-collections)  
**Repo SHA:** `f3e778f17a438371c5b8c170f15c0d997bb417ee` (unchanged)  
**Baseline date (UTC):** `2026-08-13T04:20:47Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**Production SHA-256:**
```
0eb00dc657e182f3254b10130bcaf6f9483b4b02d6126c47c01f0993caae5efd  Sources/OrderedCollections/OrderedSet/OrderedSet+Insertions.swift
```

Human tests and production code were **not** modified. No AI tests generated. No mutations defined or applied.

---

## 1. Frozen human suite

**Filter (frozen — do not expand later):**

```bash
swift test --filter 'OrderedSetTests.test_append$|OrderedSetTests.test_append_many|OrderedSetTests.test_append_contentsOf|OrderedSetTests.test_insert_at|OrderedSetTests.test_update_at|OrderedSetTests.test_updateOrAppend|OrderedSetTests.test_updateOrInsert|OrderedSetTests.test_replace'
```

| # | Test method | Exercises |
|---:|---|---|
| 1 | `test_append` | `append` / `_append` / duplicate vs new |
| 2 | `test_append_many` | bulk `append` (incl. existing re-append) |
| 3 | `test_append_contentsOf` | `append(contentsOf:)` |
| 4 | `test_insert_at` | `insert(_:at:)` / `_insertNew` (new + duplicate) |
| 5 | `test_update_at` | `update(_:at:)` |
| 6 | `test_updateOrAppend` | `updateOrAppend` |
| 7 | `test_updateOrInsert_existing` | `updateOrInsert` existing arm |
| 8 | `test_updateOrInsert_new` | `updateOrInsert` insert-new arm |
| 9 | `test_replace_at` | `replace` → `_replaceNew` |
| 10 | `test_replace_at_equalElement` | `replace` → equal-at-index → `update` |

**Total human test methods:** **10**  
**Assertion call sites (static, in these methods):** **73**  
(`expectEqual` / `expectTrue` / `expectFalse` / `expectNil` / `expectNotNil` / `expectIdentical` / `expectEqualElements`)

Do **not** use the full `OrderedSetTests` suite (103 methods) for this experiment.

---

## 2. Commands used

```bash
cd /Users/premalmistry/Desktop/Projects/AppPerformanceAnalyzer/swift-collections
git rev-parse HEAD   # f3e778f17a438371c5b8c170f15c0d997bb417ee
swift --version      # Apple Swift 6.3.3

shasum -a 256 Sources/OrderedCollections/OrderedSet/OrderedSet+Insertions.swift
# 0eb00dc657e182f3254b10130bcaf6f9483b4b02d6126c47c01f0993caae5efd

FILTER='OrderedSetTests.test_append$|OrderedSetTests.test_append_many|OrderedSetTests.test_append_contentsOf|OrderedSetTests.test_insert_at|OrderedSetTests.test_update_at|OrderedSetTests.test_updateOrAppend|OrderedSetTests.test_updateOrInsert|OrderedSetTests.test_replace'

swift test --filter "$FILTER" --enable-code-coverage
# → Executed 10 tests, with 0 failures

PROF=".build/arm64-apple-macosx/debug/codecov/default.profdata"
BIN=".build/arm64-apple-macosx/debug/swift-collectionsPackageTests.xctest/Contents/MacOS/swift-collectionsPackageTests"
SRC="Sources/OrderedCollections/OrderedSet/OrderedSet+Insertions.swift"

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-4-human-coverage.txt

xcrun llvm-cov show "$BIN" -instr-profile="$PROF" "$SRC" \
  | tee research/experiment-4-human-coverage-detail.txt

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" -show-functions "$SRC"

# Final verify
swift test --filter "$FILTER"
# → Executed 10 tests, with 0 failures
shasum -a 256 Sources/OrderedCollections/OrderedSet/OrderedSet+Insertions.swift
```

Artifacts:

- `research/experiment-4-human-coverage.txt`
- `research/experiment-4-human-coverage-detail.txt`

---

## 3. Results

| Metric | Value |
|---|---|
| Production LOC (`wc -l`) | **328** |
| Executable lines (`llvm-cov`) | **142** |
| Human test methods | **10** |
| Human assertion call sites | **73** |
| Test result | **PASS** (10 tests, 0 failures) |
| Line coverage | **82.39%** (117 / 142 lines; 25 missed) |
| Region coverage | **78.85%** (41 / 52 regions; 11 missed) |
| Function coverage | **73.08%** (19 / 26 functions; 7 missed) |

---

## 4. Important uncovered paths (observation only)

Do **not** add tests; do **not** expand the frozen filter.

### API / algorithm coverage status

| Path | Status under frozen filter |
|---|---|
| `append` / `_append` | **Covered** — new + existing (`if let index`) both hit |
| `_appendNew(_:in:)` | **Covered** — capacity regenerate (**2.68k**), table present, and `_table == nil` early-return all hit |
| `_appendNew(_:)` *(no bucket)* | **Uncovered (0 hits)** — entire overload unused; public `_append` always uses the bucketed variant |
| `append(contentsOf:)` | **Covered** |
| `insert(_:at:)` / `_insertNew` | **Covered** — new + duplicate; capacity regenerate; `_table == nil` insert-only arm; hash adjust path |
| `update(_:at:)` | **Covered** (happy path); **precondition-failure** message closure unused (expected) |
| `updateOrAppend` | **Covered** — inserted→`nil` and existing→replace both hit |
| `updateOrInsert` | **Covered** — existing + insert-new arms |
| `replace(at:with:)` / `_replaceNew` | **Covered** — `existing == index`→`update` and new→`_replaceNew` both hit |
| Duplicate-element paths | **Covered** via append/insert returning `inserted: false` |
| Existing-element update paths | **Covered** via `update` / `updateOr*` / equal `replace` |
| Capacity / hash-table regeneration | **Covered** in `_appendNew(_:in:)` and `_insertNew` |
| Index / boundary behavior | **Exercised** by insert-at offsets `0...count` and replace/update across layouts; **out-of-bounds** `replace` precondition fail path not taken (expected) |

### Gaps (do not fix in this step)

1. **Bucketless `_appendNew(_ item:)` (L25–39)** — dead relative to this call graph; accounts for essentially all missed lines (~15) plus related closures.
2. **Precondition-failure-only closures** in `update` / `replace` (unequal replacement, OOB index, duplicate replace) — not violated by the frozen suite; appear as missed 1-line “functions” in `llvm-cov`.
3. Residual missed regions align with the unused overload / failure arms above — **not** with the main insert/update/replace algorithms.

**Implication:** the frozen human suite already densely exercises the public Insertions surface and the bucketed internal helpers. Remaining line gaps are mostly an alternate unused internal entry point, not missing public API scenarios.

---

## 5. Integrity

- Production `OrderedSet+Insertions.swift` unchanged (SHA-256 match above).
- Human `OrderedSetTests.swift` untouched.
- Final re-run of frozen filter: **PASS** (10 tests, 0 failures).

### Methodology lock

This exact human-test filter is **frozen**. Do not expand it later based on coverage or mutation results.

---

## Stop line

Human baseline for Experiment #4 is complete. **Do not generate AI tests or mutations until the next step is requested.**
