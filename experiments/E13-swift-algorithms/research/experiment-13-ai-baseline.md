# Experiment #13 — AI Baseline (`AdjacentPairs.swift`)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/Algorithms/AdjacentPairs.swift`  
**Repo SHA:** `5b7143f8e291dee0e14c118fd0212487f0b37af5`  
**Baseline date (UTC):** `2026-08-15T16:29:03Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Production SHA-256:** `3918587a45e298c5dd57e1f4adfcaaaa6d10a3301a5c759ec4a6f25cdc1ebce2`  
**AI suite SHA-256:** `f6a39bdcd701de1eef7a911d832363ae09c71e45b3e832434100c6945f165cdd`

AI tests generated from **production API only**. Human tests / coverage / mutations were **not** consulted during generation. Suite is **FROZEN**.

---

## 1. Frozen AI suite + inventory

**Filter (frozen):**

```bash
swift test --filter 'AIGeneratedAdjacentPairsTests'
```

**File:** `Tests/SwiftAlgorithmsTests/AIGeneratedAdjacentPairsTests.swift`

### AI executed-test inventory (25 methods)

```
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testCollection_countIsBaseMinusOne]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testCollection_distanceMatchesCountAcrossFullRange]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testCollection_emptyStartEqualsEnd]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testCollection_formArrayEqualsZipShift]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testCollection_indexAfterAdvancesByOnePair]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testCollection_indexBeforeEndIndex]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testCollection_indexBeforeRoundTrips]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testCollection_indexEqualityUsesFirstComponent]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testCollection_offsetByLimitedByFailsPastLimit]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testCollection_offsetByLimitedBySameAsLimitReturnsNil]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testCollection_offsetByLimitedBySucceeds]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testCollection_offsetByLimitedByZeroDistance]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testCollection_offsetByPositiveAndNegative]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testCollection_reversedPairsViaBidirectional]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testCollection_singleElementEmptyPairs]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testCollection_subscriptReturnsAdjacentElements]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testCollection_twoElementsSinglePairIndices]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testLazySequenceStillProducesPairs]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testSequence_emptyYieldsNoPairs]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testSequence_makeIteratorConsumesOverlapping]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testSequence_singleElementYieldsNoPairs]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testSequence_stringCharacters]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testSequence_threeElementsTwoOverlappingPairs]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testSequence_twoElementsOnePair]
-[SwiftAlgorithmsTests.AIGeneratedAdjacentPairsTests testSequence_underestimatedCount]
```

### Disjointness vs frozen Human inventory

| Check | Result |
|---|---|
| Human filter (`SwiftAlgorithmsTests.AdjacentPairsTests`) executes any `AIGenerated*`? | **No** |
| Inventories disjoint? | **Yes** |

---

## 2. Results

| Metric | Value |
|---|---|
| Production LOC | **323** |
| Executable lines | **156** |
| AI test methods | **25** |
| AI assertion call sites (`XCTAssert*`) | **63** |
| Test result | **PASS** (25 / 0 failures) |
| Line coverage | **92.95%** (145 / 156) |
| Region coverage | **80.82%** (59 / 73) |
| Function coverage | **83.33%** (30 / 36) |

---

## 3. Freeze confirmation

- Production SHA-256 unchanged
- AI suite SHA-256 frozen
- **No further AI test edits after this freeze**
