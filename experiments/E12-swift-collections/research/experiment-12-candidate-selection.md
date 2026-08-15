# Experiment #12 — Candidate Selection (CONFIRMATORY)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Repository:** [apple/swift-collections](https://github.com/apple/swift-collections)  
**Pinned SHA:** `f3e778f17a438371c5b8c170f15c0d997bb417ee` (same pin as Experiments #3 and #4)  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Date (UTC):** `2026-08-15T16:03:36Z`

**This document only selects the component.** No AI tests, no mutations, no production/test edits beyond recording this selection.

---

## Context

Experiments #1–#10 were **exploratory**. Experiments #11–#15 are **confirmatory**, designed to reduce component-selection bias.

The goal is **not** to find an interesting result. The goal is to select a component using a neutral, pre-declared rule and accept whatever result occurs.

**Confirmatory protocol:** identical to Experiment #11. Do **not** modify methodology based on Experiment #11’s outcome.

Previously studied in this repository (must not be reused):

| Experiment | Component |
|---|---|
| E3 | `Sources/HeapModule/Heap+UnsafeHandle.swift` (supporting `_HeapNode.swift`) |
| E4 | OrderedSet insertion behavior (`OrderedSet+Insertions.swift`) |

---

## Eligibility criteria (pre-declared)

A production file is **eligible** only if **all** of the following hold:

1. Has **direct** existing human-written tests (a frozen filter can exercise the file’s observable behavior on the happy path of a **passing** suite).
2. Has **deterministic** tests (no material dependence on wall-clock timing, animation, or rendering noise).
3. Has **focused, observable** behavior (not a pure re-export / empty shim).
4. Can **reasonably support meaningful mutation testing** (enough local branching / observable decisions for a non-trivial mutant set; not a 1–2 branch wrapper).
5. Does **not** require network / external services.
6. Was **not** studied in Experiments #1–#11.
7. Is **reasonably isolated** enough for a Human-vs-AI comparison under repeated mutation restore cycles.

---

## Neutral selection rule (pre-declared — identical to Experiment #11)

1. Enumerate every production `.swift` file under `Sources/`.
2. Apply the eligibility criteria above; record every exclusion with an **objective** reason.
3. Sort the **eligible** set **alphabetically by production file path**.
4. Select the **first** eligible path.
5. **Do not** skip the first eligible path because coverage may already be high, Human tests look strong, AI may struggle, mutations may tie, the result may be boring, or another component looks more interesting.

---

## Full inventory (565 production files, alphabetical by path) and eligibility

| Production file path | LOC | Eligible? | Objective reason if excluded |
|---|---:|:---:|---|
| `Sources/BasicContainers/HashTable/_HTable+Bitmap.swift` | 124 | **No** | (#1/#7) No dedicated BasicContainers `_HTable` suite; only incidental sizing via RigidSet/UniqueSet — not focused/isolated MUT. |
| `Sources/BasicContainers/HashTable/_HTable+Bucket.swift` | 161 | **No** | (#1/#7) No dedicated BasicContainers `_HTable` suite; only incidental sizing via RigidSet/UniqueSet — not focused/isolated MUT. |
| `Sources/BasicContainers/HashTable/_HTable+Consumption.swift` | 29 | **No** | (#1/#7) No dedicated BasicContainers `_HTable` suite; only incidental sizing via RigidSet/UniqueSet — not focused/isolated MUT. |
| `Sources/BasicContainers/HashTable/_HTable+Debug.swift` | 170 | **No** | (#1/#7) No dedicated BasicContainers `_HTable` suite; only incidental sizing via RigidSet/UniqueSet — not focused/isolated MUT. |
| `Sources/BasicContainers/HashTable/_HTable+Deprecated.swift` | 63 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/HashTable/_HTable+Find.swift` | 66 | **No** | (#1/#7) No dedicated BasicContainers `_HTable` suite; only incidental sizing via RigidSet/UniqueSet — not focused/isolated MUT. |
| `Sources/BasicContainers/HashTable/_HTable+Insert.swift` | 87 | **No** | (#1/#7) No dedicated BasicContainers `_HTable` suite; only incidental sizing via RigidSet/UniqueSet — not focused/isolated MUT. |
| `Sources/BasicContainers/HashTable/_HTable+Iteration.swift` | 391 | **No** | (#1/#7) No dedicated BasicContainers `_HTable` suite; only incidental sizing via RigidSet/UniqueSet — not focused/isolated MUT. |
| `Sources/BasicContainers/HashTable/_HTable+Removal.swift` | 124 | **No** | (#1/#7) No dedicated BasicContainers `_HTable` suite; only incidental sizing via RigidSet/UniqueSet — not focused/isolated MUT. |
| `Sources/BasicContainers/HashTable/_HTable+Resizing.swift` | 76 | **No** | (#1/#7) No dedicated BasicContainers `_HTable` suite; only incidental sizing via RigidSet/UniqueSet — not focused/isolated MUT. |
| `Sources/BasicContainers/HashTable/_HTable+Sizing.swift` | 154 | **No** | (#1/#7) No dedicated BasicContainers `_HTable` suite; only incidental sizing via RigidSet/UniqueSet — not focused/isolated MUT. |
| `Sources/BasicContainers/HashTable/_HTable.swift` | 239 | **No** | (#1/#7) No dedicated BasicContainers `_HTable` suite; only incidental sizing via RigidSet/UniqueSet — not focused/isolated MUT. |
| `Sources/BasicContainers/RigidArray/RigidArray+Append.swift` | 360 | **YES** | Direct `RigidArrayTests` append/pushLast/append_* methods; deterministic; focused append APIs; 360 LOC; no network; not studied; isolated file. |
| `Sources/BasicContainers/RigidArray/RigidArray+Consumption.swift` | 220 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidArray/RigidArray+Container.swift` | 495 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidArray/RigidArray+Deprecated.swift` | 491 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/RigidArray/RigidArray+Descriptions.swift` | 47 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/RigidArray/RigidArray+Equatable.swift` | 56 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/RigidArray/RigidArray+Experimental.swift` | 103 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/RigidArray/RigidArray+Formatter.swift` | 53 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/RigidArray/RigidArray+Hashable.swift` | 44 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/RigidArray/RigidArray+Initializers.swift` | 205 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidArray/RigidArray+Insertions.swift` | 386 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidArray/RigidArray+Removals.swift` | 138 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidArray/RigidArray+Replacements.swift` | 764 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidArray/RigidArray.swift` | 494 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidDictionary/RigidDictionary+Consumption.swift` | 59 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidDictionary/RigidDictionary+Debugging.swift` | 53 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/RigidDictionary/RigidDictionary+Equatable.swift` | 70 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/RigidDictionary/RigidDictionary+Hashable.swift` | 47 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/RigidDictionary/RigidDictionary+Index.swift` | 103 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidDictionary/RigidDictionary+Indices.swift` | 94 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidDictionary/RigidDictionary+Initializers.swift` | 51 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidDictionary/RigidDictionary+Insertions.swift` | 149 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidDictionary/RigidDictionary+Keys.swift` | 35 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidDictionary/RigidDictionary+Lookup.swift` | 100 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidDictionary/RigidDictionary+Removals.swift` | 87 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidDictionary/RigidDictionary+Resizing.swift` | 90 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidDictionary/RigidDictionary.swift` | 152 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidSet/RigidSet+BorrowingSequence.swift` | 82 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidSet/RigidSet+Consumption.swift` | 48 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidSet/RigidSet+Debugging.swift` | 167 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/RigidSet/RigidSet+Deprecated.swift` | 67 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/RigidSet/RigidSet+Equatable.swift` | 63 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/RigidSet/RigidSet+Hashable.swift` | 59 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/RigidSet/RigidSet+Index.swift` | 111 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidSet/RigidSet+Initializers.swift` | 151 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidSet/RigidSet+Insertions.swift` | 294 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidSet/RigidSet+Lookup.swift` | 54 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidSet/RigidSet+Removals.swift` | 70 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidSet/RigidSet+Resizing.swift` | 84 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/RigidSet/RigidSet.swift` | 180 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueArray/UniqueArray+Append.swift` | 372 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueArray/UniqueArray+Consumption.swift` | 133 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueArray/UniqueArray+Container.swift` | 436 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueArray/UniqueArray+Deprecated.swift` | 511 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/UniqueArray/UniqueArray+Descriptions.swift` | 32 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/UniqueArray/UniqueArray+Equatable.swift` | 55 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/UniqueArray/UniqueArray+Experimental.swift` | 108 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/UniqueArray/UniqueArray+Hashable.swift` | 42 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/UniqueArray/UniqueArray+Initializers.swift` | 167 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueArray/UniqueArray+Insertions.swift` | 331 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueArray/UniqueArray+Removals.swift` | 127 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueArray/UniqueArray+Replacements.swift` | 664 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueArray/UniqueArray.swift` | 327 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueDictionary/UniqueDictionary+Consumption.swift` | 45 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueDictionary/UniqueDictionary+Debugging.swift` | 55 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/UniqueDictionary/UniqueDictionary+Equatable.swift` | 52 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/UniqueDictionary/UniqueDictionary+Hashable.swift` | 30 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/UniqueDictionary/UniqueDictionary+Index.swift` | 71 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueDictionary/UniqueDictionary+Indices.swift` | 29 | **No** | (#4) Insufficient local surface (29 LOC). |
| `Sources/BasicContainers/UniqueDictionary/UniqueDictionary+Initializers.swift` | 35 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueDictionary/UniqueDictionary+Insertions.swift` | 117 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueDictionary/UniqueDictionary+Keys.swift` | 35 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueDictionary/UniqueDictionary+Lookup.swift` | 74 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueDictionary/UniqueDictionary+Removals.swift` | 48 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueDictionary/UniqueDictionary+Resizing.swift` | 42 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueDictionary/UniqueDictionary.swift` | 85 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueSet/UniqueSet+BorrowingSequence.swift` | 41 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueSet/UniqueSet+Consumption.swift` | 44 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueSet/UniqueSet+Debugging.swift` | 55 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/UniqueSet/UniqueSet+Deprecations.swift` | 30 | **No** | (#4) Insufficient local surface (30 LOC). |
| `Sources/BasicContainers/UniqueSet/UniqueSet+Equatable.swift` | 43 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/UniqueSet/UniqueSet+Hashable.swift` | 37 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BasicContainers/UniqueSet/UniqueSet+Index.swift` | 68 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueSet/UniqueSet+Initializers.swift` | 108 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueSet/UniqueSet+Insertions.swift` | 190 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueSet/UniqueSet+Lookup.swift` | 24 | **No** | (#4) Insufficient local surface (24 LOC). |
| `Sources/BasicContainers/UniqueSet/UniqueSet+Removals.swift` | 47 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueSet/UniqueSet+Resizing.swift` | 42 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BasicContainers/UniqueSet/UniqueSet.swift` | 77 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitArray/BinaryInteger extensions.swift` | 218 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitArray/BitArray+BitwiseOperations.swift` | 200 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitArray/BitArray+ChunkedBitsIterators.swift` | 102 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitArray/BitArray+Codable.swift` | 81 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BitCollections/BitArray/BitArray+Collection.swift` | 190 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitArray/BitArray+Copy.swift` | 178 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitArray/BitArray+CustomReflectable.swift` | 21 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BitCollections/BitArray/BitArray+Descriptions.swift` | 89 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BitCollections/BitArray/BitArray+Equatable.swift` | 31 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BitCollections/BitArray/BitArray+ExpressibleByArrayLiteral.swift` | 20 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BitCollections/BitArray/BitArray+ExpressibleByStringLiteral.swift` | 25 | **No** | (#4) Insufficient local surface (25 LOC). |
| `Sources/BitCollections/BitArray/BitArray+Extras.swift` | 53 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitArray/BitArray+Fill.swift` | 48 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitArray/BitArray+Hashable.swift` | 30 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BitCollections/BitArray/BitArray+Initializers.swift` | 100 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitArray/BitArray+Invariants.swift` | 44 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BitCollections/BitArray/BitArray+LosslessStringConvertible.swift` | 68 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitArray/BitArray+RandomBits.swift` | 44 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitArray/BitArray+RangeReplaceableCollection.swift` | 553 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitArray/BitArray+Shifts.swift` | 164 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitArray/BitArray+Testing.swift` | 23 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BitCollections/BitArray/BitArray._UnsafeHandle.swift` | 165 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitArray/BitArray.swift` | 126 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+BidirectionalCollection.swift` | 297 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+Codable.swift` | 40 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BitCollections/BitSet/BitSet+CustomDebugStringConvertible.swift` | 21 | **No** | (#4) Insufficient local surface (21 LOC). |
| `Sources/BitCollections/BitSet/BitSet+CustomReflectable.swift` | 21 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BitCollections/BitSet/BitSet+CustomStringConvertible.swift` | 25 | **No** | (#4) Insufficient local surface (25 LOC). |
| `Sources/BitCollections/BitSet/BitSet+Equatable.swift` | 27 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BitCollections/BitSet/BitSet+ExpressibleByArrayLiteral.swift` | 29 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BitCollections/BitSet/BitSet+Extras.swift` | 198 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+Hashable.swift` | 26 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BitCollections/BitSet/BitSet+Initializers.swift` | 219 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+Invariants.swift` | 43 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/BitCollections/BitSet/BitSet+Random.swift` | 35 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+SetAlgebra basics.swift` | 137 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+SetAlgebra conformance.swift` | 14 | **No** | (#4) Insufficient local surface (14 LOC). |
| `Sources/BitCollections/BitSet/BitSet+SetAlgebra formIntersection.swift` | 101 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+SetAlgebra formSymmetricDifference.swift` | 100 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+SetAlgebra formUnion.swift` | 102 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+SetAlgebra intersection.swift` | 93 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+SetAlgebra isDisjoint.swift` | 108 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+SetAlgebra isEqualSet.swift` | 110 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+SetAlgebra isStrictSubset.swift` | 161 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+SetAlgebra isStrictSuperset.swift` | 131 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+SetAlgebra isSubset.swift` | 139 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+SetAlgebra isSuperset.swift` | 113 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+SetAlgebra subtract.swift` | 119 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+SetAlgebra subtracting.swift` | 94 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+SetAlgebra symmetricDifference.swift` | 97 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+SetAlgebra union.swift` | 94 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet+Sorted Collection APIs.swift` | 51 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet.Counted.swift` | 1362 | **No** | (#7) Too large (1362 LOC) / not reasonably isolated for focused MUT. |
| `Sources/BitCollections/BitSet/BitSet.Index.swift` | 95 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet._UnsafeHandle.swift` | 255 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/BitSet/BitSet.swift` | 103 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/Shared/Range+Utilities.swift` | 38 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/Shared/Slice+Utilities.swift` | 18 | **No** | (#4) Insufficient local surface (18 LOC). |
| `Sources/BitCollections/Shared/UInt+Tricks.swift` | 38 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/BitCollections/Shared/_Word.swift` | 76 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/Collections/BitCollections reexports.swift` | 166 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/Collections/DequeModule reexports.swift` | 18 | **No** | (#4) Insufficient local surface (18 LOC). |
| `Sources/Collections/HashTreeCollections reexports.swift` | 19 | **No** | (#4) Insufficient local surface (19 LOC). |
| `Sources/Collections/HeapModule reexports.swift` | 18 | **No** | (#4) Insufficient local surface (18 LOC). |
| `Sources/Collections/OrderedCollections reexports.swift` | 19 | **No** | (#4) Insufficient local surface (19 LOC). |
| `Sources/ContainersPreview/Conformances/Array+Iterable.swift` | 30 | **No** | (#4) Insufficient local surface (30 LOC). |
| `Sources/ContainersPreview/Conformances/ClosedRange+Iterable.swift` | 69 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Conformances/InputSpan+Container.swift` | 100 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Conformances/InputSpan+Iterable.swift` | 30 | **No** | (#4) Insufficient local surface (30 LOC). |
| `Sources/ContainersPreview/Conformances/MutableSpan+Container.swift` | 153 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Conformances/OutputSpan+Container.swift` | 92 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Conformances/Range+Iterable.swift` | 68 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Conformances/Span+Container.swift` | 151 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Container/BidirectionalContainer.swift` | 199 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Container/Container+Filter.swift` | 116 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Container/Container+SpanwiseZip.swift` | 64 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Container/Container.swift` | 480 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Container/ContainerIterator.swift` | 102 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Container/DynamicContainer.swift` | 120 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Container/MutableContainer.swift` | 185 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Container/PermutableContainer+HeapSort.swift` | 93 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Container/PermutableContainer+MoveSubrange.swift` | 48 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Container/PermutableContainer+Reverse.swift` | 53 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Container/PermutableContainer+Shuffle.swift` | 75 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Container/PermutableContainer.swift` | 24 | **No** | (#4) Insufficient local surface (24 LOC). |
| `Sources/ContainersPreview/Protocols/Container/RandomAccessContainer.swift` | 261 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Container/RangeExpression2.swift` | 80 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Container/RangeReplaceableContainer.swift` | 875 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Container/Strideable+Limits.swift` | 76 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Drain/Drain+Map.swift` | 93 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Drain/Drain+Reduce.swift` | 55 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Drain/Drain.swift` | 217 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Iterable/BorrowingIteratorProtocol+Copy.swift` | 63 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Iterable/BorrowingIteratorProtocol+ElementsEqual.swift` | 210 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Iterable/BorrowingIteratorProtocol+Filter.swift` | 73 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Iterable/BorrowingIteratorProtocol+Map.swift` | 142 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Iterable/BorrowingIteratorProtocol+MapError.swift` | 97 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Iterable/BorrowingIteratorProtocol+Reduce.swift` | 59 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Iterable/BorrowingIteratorProtocol+SpanwiseZip.swift` | 90 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Iterable/BorrowingIteratorProtocol.swift` | 54 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Iterable/Iterable+ElementsEqual.swift` | 66 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Iterable/Iterable+Reduce.swift` | 60 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Iterable/Iterable+Utilities.swift` | 41 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Producer/CountedProducer.swift` | 32 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Producer/Producer+Collect.swift` | 63 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Producer/Producer+Filter.swift` | 108 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Producer/Producer+Map.swift` | 112 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Producer/Producer+Reduce.swift` | 73 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Producer/Producer+Unfold.swift` | 86 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Protocols/Producer/Producer.swift` | 323 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Types/InputSpan.swift` | 636 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Types/MutableRef.swift` | 103 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Types/OutputSpan+Helpers.swift` | 51 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Types/Shared.swift` | 166 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/ContainersPreview/Types/UniqueBox.swift` | 220 | **No** | (#3/#7) Shared utilities / preview protocol surface — not a focused single-component MUT. |
| `Sources/DequeModule/Deque/Deque+Codable.swift` | 53 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/DequeModule/Deque/Deque+Collection.swift` | 922 | **No** | (#7) Too large (922 LOC) / not reasonably isolated for focused MUT. |
| `Sources/DequeModule/Deque/Deque+CustomReflectable.swift` | 21 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/DequeModule/Deque/Deque+Descriptions.swift` | 32 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/DequeModule/Deque/Deque+Equatable.swift` | 34 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/DequeModule/Deque/Deque+ExpressibleByArrayLiteral.swift` | 29 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/DequeModule/Deque/Deque+Extras.swift` | 194 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/Deque/Deque+Hashable.swift` | 26 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/DequeModule/Deque/Deque+Testing.swift` | 92 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/DequeModule/Deque/Deque._Storage.swift` | 220 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/Deque/Deque._UnsafeHandle.swift` | 821 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/Deque/Deque.swift` | 109 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/Deque/_DequeBuffer.swift` | 51 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/Deque/_DequeBufferHeader.swift` | 51 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/RigidDeque/RigidDeque+Append.swift` | 393 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/RigidDeque/RigidDeque+Consumption.swift` | 253 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/RigidDeque/RigidDeque+Container.swift` | 237 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/RigidDeque/RigidDeque+Descriptions.swift` | 32 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/DequeModule/RigidDeque/RigidDeque+Equatable.swift` | 72 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/DequeModule/RigidDeque/RigidDeque+Experimental.swift` | 44 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/DequeModule/RigidDeque/RigidDeque+Hashable.swift` | 52 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/DequeModule/RigidDeque/RigidDeque+Initializers.swift` | 225 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/RigidDeque/RigidDeque+Insertions.swift` | 499 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/RigidDeque/RigidDeque+Prepend.swift` | 510 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/RigidDeque/RigidDeque+Removals.swift` | 171 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/RigidDeque/RigidDeque+Replacements.swift` | 626 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/RigidDeque/RigidDeque+Testing.swift` | 62 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/DequeModule/RigidDeque/RigidDeque.swift` | 384 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/UniqueDeque/UniqueDeque+Append.swift` | 391 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/UniqueDeque/UniqueDeque+Consumption.swift` | 166 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/UniqueDeque/UniqueDeque+Container.swift` | 151 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/UniqueDeque/UniqueDeque+Deprecated.swift` | 27 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/DequeModule/UniqueDeque/UniqueDeque+Descriptions.swift` | 32 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/DequeModule/UniqueDeque/UniqueDeque+Equatable.swift` | 55 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/DequeModule/UniqueDeque/UniqueDeque+Experimental.swift` | 38 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/DequeModule/UniqueDeque/UniqueDeque+Hashable.swift` | 38 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/DequeModule/UniqueDeque/UniqueDeque+Initializers.swift` | 218 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/UniqueDeque/UniqueDeque+Insertions.swift` | 524 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/UniqueDeque/UniqueDeque+Prepend.swift` | 549 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/UniqueDeque/UniqueDeque+Removals.swift` | 154 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/UniqueDeque/UniqueDeque+Replacements.swift` | 638 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/UniqueDeque/UniqueDeque.swift` | 342 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/_DequeSlot.swift` | 80 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/DequeModule/_UnsafeDequeHandle.swift` | 1506 | **No** | (#7) Too large (1506 LOC) / not reasonably isolated for focused MUT. |
| `Sources/DequeModule/_UnsafeDequeSegments.swift` | 297 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_AncestorHashSlots.swift` | 113 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_Bitmap.swift` | 223 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_Bucket.swift` | 73 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_Hash.swift` | 96 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashLevel.swift` | 103 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Builder.swift` | 362 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Debugging.swift` | 123 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HashTreeCollections/HashNode/_HashNode+Initializers.swift` | 265 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Invariants.swift` | 109 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HashTreeCollections/HashNode/_HashNode+Lookups.swift` | 271 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Primitive Insertions.swift` | 119 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Primitive Removals.swift` | 153 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Primitive Replacement.swift` | 92 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Storage.swift` | 285 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Structural compactMapValues.swift` | 48 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Structural filter.swift` | 85 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Structural intersection.swift` | 197 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Structural isDisjoint.swift` | 113 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Structural isEqualSet.swift` | 63 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Structural isSubset.swift` | 91 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Structural mapValues.swift` | 92 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Structural merge.swift` | 331 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Structural subtracting.swift` | 201 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Structural symmetricDifference.swift` | 270 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Structural union.swift` | 259 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Subtree Insertions.swift` | 580 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Subtree Modify.swift` | 274 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+Subtree Removals.swift` | 277 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode+UnsafeHandle.swift` | 297 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNode.swift` | 140 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashNodeHeader.swift` | 137 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashSlot.swift` | 113 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashStack.swift` | 122 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashTreeIterator.swift` | 133 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_HashTreeStatistics.swift` | 131 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_RawHashNode+UnsafeHandle.swift` | 118 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_RawHashNode.swift` | 75 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_UnmanagedHashNode.swift` | 111 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/HashNode/_UnsafePath.swift` | 892 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeDictionary/TreeDictionary+Codable.swift` | 190 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HashTreeCollections/TreeDictionary/TreeDictionary+Collection.swift` | 307 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeDictionary/TreeDictionary+CustomReflectable.swift` | 21 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HashTreeCollections/TreeDictionary/TreeDictionary+Debugging.swift` | 47 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HashTreeCollections/TreeDictionary/TreeDictionary+Descriptions.swift` | 32 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HashTreeCollections/TreeDictionary/TreeDictionary+Equatable.swift` | 25 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HashTreeCollections/TreeDictionary/TreeDictionary+ExpressibleByDictionaryLiteral.swift` | 37 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeDictionary/TreeDictionary+Filter.swift` | 60 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeDictionary/TreeDictionary+Hashable.swift` | 30 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HashTreeCollections/TreeDictionary/TreeDictionary+Initializers.swift` | 315 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeDictionary/TreeDictionary+Keys.swift` | 331 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeDictionary/TreeDictionary+MapValues.swift` | 70 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeDictionary/TreeDictionary+Merge.swift` | 269 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeDictionary/TreeDictionary+Sendable.swift` | 15 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HashTreeCollections/TreeDictionary/TreeDictionary+Sequence.swift` | 75 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeDictionary/TreeDictionary+Values.swift` | 168 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeDictionary/TreeDictionary.swift` | 554 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+Codable.swift` | 50 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HashTreeCollections/TreeSet/TreeSet+Collection.swift` | 374 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+CustomReflectable.swift` | 21 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HashTreeCollections/TreeSet/TreeSet+Debugging.swift` | 47 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HashTreeCollections/TreeSet/TreeSet+Descriptions.swift` | 32 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HashTreeCollections/TreeSet/TreeSet+Equatable.swift` | 33 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HashTreeCollections/TreeSet/TreeSet+ExpressibleByArrayLiteral.swift` | 36 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HashTreeCollections/TreeSet/TreeSet+Extras.swift` | 73 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+Filter.swift` | 57 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+Hashable.swift` | 30 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HashTreeCollections/TreeSet/TreeSet+Sendable.swift` | 14 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HashTreeCollections/TreeSet/TreeSet+Sequence.swift` | 55 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+SetAlgebra Initializers.swift` | 75 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+SetAlgebra basics.swift` | 136 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+SetAlgebra formIntersection.swift` | 78 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+SetAlgebra formSymmetricDifference.swift` | 73 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+SetAlgebra formUnion.swift` | 94 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+SetAlgebra intersection.swift` | 115 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+SetAlgebra isDisjoint.swift` | 82 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+SetAlgebra isEqualSet.swift` | 125 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+SetAlgebra isStrictSubset.swift` | 142 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+SetAlgebra isStrictSuperset.swift` | 127 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+SetAlgebra isSubset.swift` | 115 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+SetAlgebra isSuperset.swift` | 92 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+SetAlgebra subtract.swift` | 73 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+SetAlgebra subtracting.swift` | 102 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+SetAlgebra symmetricDifference.swift` | 117 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet+SetAlgebra union.swift` | 112 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HashTreeCollections/TreeSet/TreeSet.swift` | 86 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/HeapModule/Heap+Descriptions.swift` | 38 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HeapModule/Heap+ExpressibleByArrayLiteral.swift` | 27 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HeapModule/Heap+Invariants.swift` | 73 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HeapModule/Heap+Testing.swift` | 18 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/HeapModule/Heap+UnsafeHandle.swift` | 390 | **No** | (#6) Studied in Experiments #3/#4. |
| `Sources/HeapModule/Heap.swift` | 397 | **No** | (#6) HeapModule studied in Experiment #3; remaining files same-module overlap or thin helpers. |
| `Sources/HeapModule/_HeapNode.swift` | 176 | **No** | (#6) Studied in Experiments #3/#4. |
| `Sources/InternalCollectionsUtilities/Debugging.swift` | 27 | **No** | (#4) Insufficient local surface (27 LOC). |
| `Sources/InternalCollectionsUtilities/Descriptions.swift` | 69 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/InternalCollectionsUtilities/IntegerTricks/FixedWidthInteger+roundUpToPowerOfTwo.swift` | 23 | **No** | (#4) Insufficient local surface (23 LOC). |
| `Sources/InternalCollectionsUtilities/IntegerTricks/Integer rank.swift` | 152 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/InternalCollectionsUtilities/IntegerTricks/UInt+first and last set bit.swift` | 27 | **No** | (#4) Insufficient local surface (27 LOC). |
| `Sources/InternalCollectionsUtilities/IntegerTricks/UInt+reversed.swift` | 29 | **No** | (#4) Insufficient local surface (29 LOC). |
| `Sources/InternalCollectionsUtilities/LifetimeOverride.swift` | 94 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/InternalCollectionsUtilities/Optional+Extras.swift` | 59 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/InternalCollectionsUtilities/OutputSpan+Extras.swift` | 141 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/InternalCollectionsUtilities/RandomAccessCollection+Offsets.swift` | 29 | **No** | (#4) Insufficient local surface (29 LOC). |
| `Sources/InternalCollectionsUtilities/Span+Extras.swift` | 144 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/InternalCollectionsUtilities/String+Padding.swift` | 37 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/InternalCollectionsUtilities/TemporaryAllocation.swift` | 38 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/InternalCollectionsUtilities/UnsafeBitSet/_UnsafeBitSet+Index.swift` | 93 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/InternalCollectionsUtilities/UnsafeBitSet/_UnsafeBitSet+_Word.swift` | 360 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/InternalCollectionsUtilities/UnsafeBitSet/_UnsafeBitSet.swift` | 468 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/InternalCollectionsUtilities/UnsafeBufferPointer+Extras.swift` | 162 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/InternalCollectionsUtilities/UnsafeMutableBufferPointer+Extras.swift` | 395 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/InternalCollectionsUtilities/UnsafeMutablePointer+Extras.swift` | 42 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/InternalCollectionsUtilities/UnsafeMutableRawBufferPointer+Extras.swift` | 23 | **No** | (#4) Insufficient local surface (23 LOC). |
| `Sources/InternalCollectionsUtilities/UnsafePointer+Extras.swift` | 38 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/InternalCollectionsUtilities/UnsafeRawBufferPointer+Extras.swift` | 21 | **No** | (#4) Insufficient local surface (21 LOC). |
| `Sources/InternalCollectionsUtilities/_SortedCollection.swift` | 30 | **No** | (#4) Insufficient local surface (30 LOC). |
| `Sources/InternalCollectionsUtilities/_UniqueCollection.swift` | 40 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/HashTable/_HashTable+Bucket.swift` | 39 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/HashTable/_HashTable+BucketIterator.swift` | 267 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/HashTable/_HashTable+Constants.swift` | 100 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/HashTable/_HashTable+CustomStringConvertible.swift` | 63 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/HashTable/_HashTable+Testing.swift` | 66 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/OrderedCollections/HashTable/_HashTable+UnsafeHandle.swift` | 613 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/HashTable/_HashTable.swift` | 236 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/HashTable/_Hashtable+Header.swift` | 101 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedDictionary/OrderedDictionary+Codable.swift` | 91 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/OrderedCollections/OrderedDictionary/OrderedDictionary+CustomReflectable.swift` | 21 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/OrderedCollections/OrderedDictionary/OrderedDictionary+Deprecations.swift` | 54 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedDictionary/OrderedDictionary+Descriptions.swift` | 32 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/OrderedCollections/OrderedDictionary/OrderedDictionary+Elements.SubSequence.swift` | 360 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedDictionary/OrderedDictionary+Elements.swift` | 718 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedDictionary/OrderedDictionary+Equatable.swift` | 25 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/OrderedCollections/OrderedDictionary/OrderedDictionary+ExpressibleByDictionaryLiteral.swift` | 37 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedDictionary/OrderedDictionary+Hashable.swift` | 27 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/OrderedCollections/OrderedDictionary/OrderedDictionary+Initializers.swift` | 465 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedDictionary/OrderedDictionary+Invariants.swift` | 39 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/OrderedCollections/OrderedDictionary/OrderedDictionary+Move.swift` | 164 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedDictionary/OrderedDictionary+Partial MutableCollection.swift` | 266 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedDictionary/OrderedDictionary+Partial RangeReplaceableCollection.swift` | 186 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedDictionary/OrderedDictionary+Sendable.swift` | 15 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/OrderedCollections/OrderedDictionary/OrderedDictionary+Sequence.swift` | 68 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedDictionary/OrderedDictionary+Values.swift` | 407 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedDictionary/OrderedDictionary.swift` | 1061 | **No** | (#7) Too large (1061 LOC) / not reasonably isolated for focused MUT. |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Codable.swift` | 50 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+CustomReflectable.swift` | 21 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Descriptions.swift` | 32 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Diffing.swift` | 102 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Equatable.swift` | 30 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+ExpressibleByArrayLiteral.swift` | 38 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Hashable.swift` | 26 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Initializers.swift` | 155 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Insertions.swift` | 328 | **No** | (#6) Studied in Experiments #3/#4. |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Invariants.swift` | 70 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Move.swift` | 800 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Partial MutableCollection.swift` | 447 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Partial RangeReplaceableCollection.swift` | 224 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Partial SetAlgebra formIntersection.swift` | 87 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Partial SetAlgebra formSymmetricDifference.swift` | 89 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Partial SetAlgebra formUnion.swift` | 105 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Partial SetAlgebra intersection.swift` | 112 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Partial SetAlgebra isDisjoint.swift` | 132 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Partial SetAlgebra isEqualSet.swift` | 86 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Partial SetAlgebra isStrictSubset.swift` | 164 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Partial SetAlgebra isStrictSuperset.swift` | 162 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Partial SetAlgebra isSubset.swift` | 157 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Partial SetAlgebra isSuperset.swift` | 126 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Partial SetAlgebra subtract.swift` | 76 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Partial SetAlgebra subtracting.swift` | 112 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Partial SetAlgebra symmetricDifference.swift` | 139 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Partial SetAlgebra union.swift` | 110 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Partial SetAlgebra+Basics.swift` | 78 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+RandomAccessCollection.swift` | 309 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+ReserveCapacity.swift` | 131 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Sendable.swift` | 14 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+SubSequence.swift` | 382 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+Testing.swift` | 138 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+UnorderedView.swift` | 1012 | **No** | (#7) Too large (1012 LOC) / not reasonably isolated for focused MUT. |
| `Sources/OrderedCollections/OrderedSet/OrderedSet+UnstableInternals.swift` | 53 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/OrderedSet/OrderedSet.swift` | 595 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/OrderedCollections/Utilities/_UnsafeBitset.swift` | 19 | **No** | (#4) Insufficient local surface (19 LOC). |
| `Sources/RopeModule/BigString/Basics/BigString+Builder.swift` | 151 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Basics/BigString+Contents.swift` | 563 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Basics/BigString+Debugging.swift` | 23 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/RopeModule/BigString/Basics/BigString+Index.swift` | 241 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Basics/BigString+Ingester.swift` | 175 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Basics/BigString+Invariants.swift` | 41 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/RopeModule/BigString/Basics/BigString+Metrics.swift` | 299 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Basics/BigString+Summary.swift` | 84 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Basics/BigString.swift` | 29 | **No** | (#4) Insufficient local surface (29 LOC). |
| `Sources/RopeModule/BigString/Chunk/BigString+Chunk+Append and Insert.swift` | 245 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Chunk/BigString+Chunk+Breaks.swift` | 81 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Chunk/BigString+Chunk+Character.swift` | 304 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Chunk/BigString+Chunk+Counts.swift` | 154 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Chunk/BigString+Chunk+Description.swift` | 73 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Chunk/BigString+Chunk+Index.swift` | 145 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Chunk/BigString+Chunk+RopeElement.swift` | 158 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Chunk/BigString+Chunk+Splitting.swift` | 147 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Chunk/BigString+Chunk+UTF16.swift` | 181 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Chunk/BigString+Chunk+UTF8.swift` | 28 | **No** | (#4) Insufficient local surface (28 LOC). |
| `Sources/RopeModule/BigString/Chunk/BigString+Chunk+UnicodeScalar.swift` | 142 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Chunk/BigString+Chunk.swift` | 198 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Conformances/BigString+BidirectionalCollection.swift` | 77 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Conformances/BigString+Comparable.swift` | 41 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Conformances/BigString+CustomDebugStringConvertible.swift` | 23 | **No** | (#4) Insufficient local surface (23 LOC). |
| `Sources/RopeModule/BigString/Conformances/BigString+CustomStringConvertible.swift` | 23 | **No** | (#4) Insufficient local surface (23 LOC). |
| `Sources/RopeModule/BigString/Conformances/BigString+Equatable.swift` | 107 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/RopeModule/BigString/Conformances/BigString+ExpressibleByStringLiteral.swift` | 23 | **No** | (#4) Insufficient local surface (23 LOC). |
| `Sources/RopeModule/BigString/Conformances/BigString+Hashing.swift` | 57 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Conformances/BigString+LosslessStringConvertible.swift` | 21 | **No** | (#4) Insufficient local surface (21 LOC). |
| `Sources/RopeModule/BigString/Conformances/BigString+RangeReplaceableCollection.swift` | 224 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Conformances/BigString+Sequence.swift` | 237 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Conformances/BigString+TextOutputStream.swift` | 36 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Operations/BigString+Append.swift` | 200 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Operations/BigString+Initializers.swift` | 166 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Operations/BigString+Insert.swift` | 102 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Operations/BigString+Managing Breaks.swift` | 278 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Operations/BigString+RemoveSubrange.swift` | 50 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Operations/BigString+ReplaceSubrange.swift` | 90 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Operations/BigString+Split.swift` | 44 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Operations/Range+BigString.swift` | 23 | **No** | (#4) Insufficient local surface (23 LOC). |
| `Sources/RopeModule/BigString/Views/BigString+UTF16View.swift` | 154 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Views/BigString+UTF8View.swift` | 190 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Views/BigString+UnicodeScalarView.swift` | 400 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Views/BigSubstring+UTF16View.swift` | 207 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Views/BigSubstring+UTF8View.swift` | 179 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Views/BigSubstring+UnicodeScalarView.swift` | 326 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/BigString/Views/BigSubstring.swift` | 365 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Basics/Rope+Builder.swift` | 485 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Basics/Rope+Debugging.swift` | 96 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/RopeModule/Rope/Basics/Rope+Invariants.swift` | 72 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/RopeModule/Rope/Basics/Rope+_Node.swift` | 620 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Basics/Rope+_Storage.swift` | 60 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Basics/Rope+_UnmanagedLeaf.swift` | 50 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Basics/Rope+_UnsafeHandle.swift` | 231 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Basics/Rope.swift` | 73 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Basics/RopeElement.swift` | 79 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Basics/RopeMetric.swift` | 37 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Basics/RopeSummary.swift` | 64 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Basics/_RopeItem.swift` | 93 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Basics/_RopePath.swift` | 125 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Basics/_RopeVersion.swift` | 50 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Conformances/Rope+Collection.swift` | 495 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Conformances/Rope+Index.swift` | 96 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Conformances/Rope+Sequence.swift` | 49 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Operations/Rope+Append.swift` | 76 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Operations/Rope+Extract.swift` | 93 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Operations/Rope+Find.swift` | 88 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Operations/Rope+ForEachWhile.swift` | 92 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Operations/Rope+Insert.swift` | 223 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Operations/Rope+Join.swift` | 133 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Operations/Rope+MutatingForEach.swift` | 99 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Operations/Rope+Remove.swift` | 212 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Operations/Rope+RemoveSubrange.swift` | 323 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Rope/Operations/Rope+Split.swift` | 150 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Utilities/Optional Utilities.swift` | 21 | **No** | (#4) Insufficient local surface (21 LOC). |
| `Sources/RopeModule/Utilities/String Utilities.swift` | 136 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Utilities/String.Index+ABI.swift` | 115 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/RopeModule/Utilities/_CharacterRecognizer.swift` | 200 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/BTree/_BTree+BidirectionalCollection.swift` | 211 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/BTree/_BTree+CustomDebugStringConvertible.swift` | 31 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/BTree/_BTree+CustomReflectable.swift` | 26 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/SortedCollections/BTree/_BTree+Invariants.swift` | 108 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/SortedCollections/BTree/_BTree+Partial RangeReplaceableCollection.swift` | 147 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/BTree/_BTree+Sequence.swift` | 195 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/BTree/_BTree+SubSequence.swift` | 193 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/BTree/_BTree+UnsafeCursor.swift` | 514 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/BTree/_BTree.Builder.swift` | 376 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/BTree/_BTree.Index.swift` | 148 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/BTree/_BTree.swift` | 602 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/BTree/_FixedSizeArray.swift` | 141 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/BTree/_Node+CustomDebugString.swift` | 23 | **No** | (#4) Insufficient local surface (23 LOC). |
| `Sources/SortedCollections/BTree/_Node+Testing.swift` | 70 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/SortedCollections/BTree/_Node.Splinter.swift` | 57 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/BTree/_Node.Storage.swift` | 251 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/BTree/_Node.UnsafeHandle+CustomDebugStringConvertible.swift` | 157 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/BTree/_Node.UnsafeHandle+Deletion.swift` | 497 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/BTree/_Node.UnsafeHandle+Insertion.swift` | 528 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/BTree/_Node.UnsafeHandle.swift` | 791 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/BTree/_Node.swift` | 367 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedDictionary/SortedDictionary+BidirectionalCollection.swift` | 181 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedDictionary/SortedDictionary+Codable.swift` | 83 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/SortedCollections/SortedDictionary/SortedDictionary+CustomReflectable.swift` | 25 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/SortedCollections/SortedDictionary/SortedDictionary+CustomStringConvertible.swift` | 60 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedDictionary/SortedDictionary+Equatable.swift` | 39 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/SortedCollections/SortedDictionary/SortedDictionary+ExpressibleByDictionaryLiteral.swift` | 39 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedDictionary/SortedDictionary+Hashable.swift` | 32 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/SortedCollections/SortedDictionary/SortedDictionary+Initializers.swift` | 150 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedDictionary/SortedDictionary+Keys.swift` | 265 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedDictionary/SortedDictionary+Partial RangeReplaceableCollection.swift` | 179 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedDictionary/SortedDictionary+Sendable.swift` | 19 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/SortedCollections/SortedDictionary/SortedDictionary+Sequence.swift` | 56 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedDictionary/SortedDictionary+SubSequence.swift` | 327 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedDictionary/SortedDictionary+Subscripts.swift` | 182 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedDictionary/SortedDictionary+Values.swift` | 284 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedDictionary/SortedDictionary.Index.swift` | 62 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedDictionary/SortedDictionary.swift` | 227 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedSet/SortedSet+BidirectionalCollection.swift` | 181 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedSet/SortedSet+Codable.swift` | 60 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/SortedCollections/SortedSet/SortedSet+CustomReflectable.swift` | 25 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/SortedCollections/SortedSet/SortedSet+CustomStringConvertible.swift` | 53 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedSet/SortedSet+Equatable.swift` | 39 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/SortedCollections/SortedSet/SortedSet+ExpressibleByArrayLiteral.swift` | 38 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/SortedCollections/SortedSet/SortedSet+Hashable.swift` | 31 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/SortedCollections/SortedSet/SortedSet+Initializers.swift` | 59 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedSet/SortedSet+Partial RangeReplaceableCollection.swift` | 179 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedSet/SortedSet+Sendable.swift` | 18 | **No** | (#3/#4) Thin protocol/debug/deprecated/description/testing surface. |
| `Sources/SortedCollections/SortedSet/SortedSet+Sequence.swift` | 60 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedSet/SortedSet+SetAlgebra.swift` | 376 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedSet/SortedSet+SubSequence.swift` | 326 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedSet/SortedSet+Subscripts.swift` | 103 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedSet/SortedSet.Index.swift` | 94 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/SortedCollections/SortedSet/SortedSet.swift` | 43 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/TrailingElementsModule/TrailingArray.swift` | 408 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |
| `Sources/TrailingElementsModule/TrailingElements.swift` | 23 | **No** | (#4) Insufficient local surface (23 LOC). |
| `Sources/TrailingElementsModule/TrailingPadding.swift` | 143 | **No*** | Not selected — appears after first eligible under alphabetical rule; not further evaluated for selection (may independently satisfy criteria). |

### Notes on `No*` rows

Once the first alphabetical **YES** is frozen, later paths are marked `No*` = **not selected** under the rule. They were **not** rejected for predicted Human/AI outcomes. Some may independently meet eligibility; the confirmatory protocol does **not** reopen selection after the first eligible freeze.

### Eligible set (alphabetical)

1. **`Sources/BasicContainers/RigidArray/RigidArray+Append.swift`**

*(First eligible under objective walk; selection frozen here.)*

---

## Selection

**Selected component (first eligible alphabetically):**  
`Sources/BasicContainers/RigidArray/RigidArray+Append.swift`

**Selection rule applied:** sort eligible paths alphabetically → take index 0.

**No skipping:** the selected file was not rejected for expected coverage, suite strength, predicted Human/AI outcome, tie risk, or “interestingness.”

### Why eligible

- (#1) Direct human tests in `Tests/BasicContainersTests/RigidArrayTests.swift`: `test_append`, `test_pushLast`, `test_append_addingCount_*`, `test_append_moving_*`, `test_append_copying_*`.
- (#2) Deterministic container/lifetime-tracker tests (no network/UI).
- (#3) Focused append / `pushLast` / capacity-gated bulk append APIs.
- (#4) 360 LOC with capacity/`isFull` preconditions, partial vs full appends, moving/copying overloads — supports meaningful mutations.
- (#5) No network/external services.
- (#6) Not studied in E1–E11 (distinct from E3 Heap and E4 OrderedSet insertions).
- (#7) Single production file; mutation restore cycles are local.

### Intended frozen Human filter (to be validated in Stage 2)

```bash
swift test --filter 'RigidArrayTests.test_append$|RigidArrayTests.test_pushLast|RigidArrayTests.test_append_addingCount_full|RigidArrayTests.test_append_addingCount_partial|RigidArrayTests.test_append_moving_UnsafeMutableBufferPointer|RigidArrayTests.test_append_moving_OutputSpan|RigidArrayTests.test_append_copying_MinimalSequence|RigidArrayTests.test_append_copying_Span'
```

Smoke check: **8 tests, 0 failures** (InputSpan/Container append tests are behind `UnstableContainersPreview` / `#if false` and do not execute).

### Production fingerprint (pre-experiment)

| File | SHA-256 |
|---|---|
| `Sources/BasicContainers/RigidArray/RigidArray+Append.swift` | `3075e1f0b035fae7b22025ae6c39ae4374e74894f1c05235e212ad815485c086` |

## FREEZE

**Component is FROZEN.** Do not replace after observing coverage, mutation scores, ties, Human/AI dominance, or inconsistency with Experiments #1–#11.

