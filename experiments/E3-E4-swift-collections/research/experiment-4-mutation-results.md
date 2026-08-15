# Experiment #4 — Mutation Results (`OrderedSet+Insertions.swift`)

**Component:** `Sources/OrderedCollections/OrderedSet/OrderedSet+Insertions.swift`  
**Frozen set:** E4-M01–E4-M26 (**26**) from `research/experiment-4-mutation-plan.md`  
**Repo SHA:** `f3e778f17a438371c5b8c170f15c0d997bb417ee`  
**Run date (UTC):** `2026-08-13T04:53:07Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**AI suite SHA-256:** `a175e50261c24830e0669209e58f7f48b3cdc413909073c8a80e30722770c2d4`  
**Production SHA-256 (restored):** `0eb00dc657e182f3254b10130bcaf6f9483b4b02d6126c47c01f0993caae5efd`

## Integrity (pre-run)

| Check | Result |
|---|---|
| Repo SHA | `f3e778f…` ✓ |
| Production SHA-256 | matches baseline ✓ |
| AI test SHA-256 | matches freeze ✓ |
| Human `OrderedSetTests.swift` | unmodified ✓ |

## Protocol

- One mutant at a time via `research/run_e4_mutations.py`; restore from `research/OrderedSet+Insertions.swift.ORIG` after each.
- Human: frozen 10-test filter (never expanded).
- AI: `AIGeneratedOrderedSetInsertionsTests` (41).
- Timeout: **30s** per suite run.
- Crash / precondition / invariant / signal abort ⇒ **KILLED-CRASH** (counts as killed).
- Suites not modified; mutation set not altered after observation.
- Logs: `research/mutation-logs-e4/`; mutants: `research/mutants-e4/`; machine rows: `research/experiment-4-mutation-results.jsonl`.

## Results table

| Mutation | Human | AI | Human failures | AI failures | Notes |
|---|---|---|---|---|---|
| E4-M01: dup append `inserted:true` | KILLED | KILLED | test_append, test_append_many, test_updateOrAppend | testAppendDuplicateReturnsExistingIndex, … | |
| E4-M02: remove dup early-return | KILLED-CRASH | KILLED-CRASH | assert L60 | assert L60 | |
| E4-M03: new append `inserted:false` | KILLED | KILLED | test_append, test_append_many, test_updateOrAppend | testAppendManyUniqueDeterministicSequence, … | |
| E4-M04: new append index→0 | KILLED | KILLED | test_append, test_append_many | testAppendManyUniqueDeterministicSequence, … | |
| E4-M05: `<=`→`<` early regenerate | SURVIVED | SURVIVED | — | — | See equivalence below → **INVALID-EQUIVALENT** |
| E4-M06: `hashTable[bucket]=count` | KILLED-CRASH | KILLED-CRASH | Fatal error | Fatal error | |
| E4-M07: dup insert `inserted:true` | KILLED | KILLED | test_insert_at | testDuplicateInsertReturnsExistingIndexNotRequested, … | |
| E4-M08: dup insert returns requested idx | KILLED | KILLED | test_insert_at | testDuplicateInsertReturnsExistingIndexNotRequested, … | |
| E4-M09: insert success `index+1` | KILLED-CRASH | KILLED | Index out of range | testInsertAtBeginning/Middle/End, … | |
| E4-M10: insert→`_appendNew` | KILLED | KILLED | test_insert_at | testInsertAtBeginning/Middle, … | |
| E4-M11: insert capacity `<`→`<=` | SURVIVED | SURVIVED | — | — | **Real survivor** (boundary not hit); not reclassified |
| E4-M12: `hashTable[bucket]=index+1` | KILLED-CRASH | KILLED-CRASH | Fatal error | Fatal error | |
| E4-M13: skip update write | KILLED | KILLED | test_update_at, test_replace_at_equalElement | testUpdate*, testReplaceEqualElement* | |
| E4-M14: update returns `item` | KILLED | KILLED | test_update_at, test_replace_at_equalElement | testUpdate*, testReplaceEqualElement* | |
| E4-M15: `swapAt(index,0)` | KILLED | KILLED | test_replace_at | testReplace*, mixed round-trip | |
| E4-M16: omit `swapAt` | KILLED | KILLED | test_replace_at | testReplace*, mixed round-trip | |
| E4-M17: `existing==index`→`!=` | KILLED-CRASH | KILLED-CRASH | signal 5 / abort | signal 5 / abort | |
| E4-M18: drop equal-replace branch | KILLED-CRASH | KILLED-CRASH | signal 5 / abort | signal 5 / abort | |
| E4-M19: invert `updateOrAppend` inserted | KILLED | KILLED | test_updateOrAppend | testUpdateOrAppend* | |
| E4-M20: existing `updateOrAppend`→`nil` | KILLED | KILLED | test_updateOrAppend | testUpdateOrAppendReplaces/DoesNotMove | |
| E4-M21: `updateOrInsert` wrong index | KILLED-CRASH | KILLED | Index out of range | testUpdateOrInsertExistingIgnoresRequestedIndex, … | |
| E4-M22: swap `updateOrInsert` arms | KILLED-CRASH | KILLED-CRASH | assert L138 | Index out of range (+ failures) | |
| E4-M23: new `updateOrInsert` index→0 | KILLED | KILLED | test_updateOrInsert_new | testUpdateOrInsertNewAtEnd/Middle, … | |
| E4-M24: skip append regenerate | KILLED-CRASH | SURVIVED | assert in Partial MutableCollection | — | **Human-only** |
| E4-M25: overflow insert→append | KILLED | SURVIVED | test_insert_at, test_updateOrInsert_new | — | **Human-only** |
| E4-M26: dup append `index+1` | KILLED-CRASH | KILLED-CRASH | Index out of range | Index out of range (+ failures) | |

## E4-M05 equivalence assessment

**Observed:** SURVIVED / SURVIVED.

**Analysis (not “survive ⇒ equivalent” alone):**  
`_appendNew(_:in:)` runs **after** `_elements.append`. Changing `count <= _capacity` to `count < _capacity` only triggers `_regenerateHashTable()` when `count == _capacity`, i.e. one element earlier. Regeneration rebuilds the hash table from the authoritative `_elements` array, so membership, order, and API return values remain the same. Both suites’ capacity-growth / append paths still pass.

**Final classification:** **INVALID-EQUIVALENT** (excluded from mutation-score denominator).

**E4-M11** also SURVIVED both sides but is **not** reclassified: `<`→`<=` on `_insertNew`’s pre-insert capacity guard can skip regeneration when `count == _capacity` (a real defect). Survival indicates the frozen suites did not hit that boundary, not behavioral equivalence.

## Scores

Mutation score = Killed / (Killed + Survived) × 100  
(`KILLED` + `KILLED-CRASH` + `KILLED-TIMEOUT` count as killed.)

| Metric | Value |
|---|---|
| Total planned mutations | **26** |
| Valid mutations | **25** |
| Invalid/equivalent mutations | **1** (E4-M05) |
| Human killed | **24** |
| Human survived | **1** (E4-M11) |
| Human mutation score | **96.0%** (24/25) |
| AI killed | **22** |
| AI survived | **3** (E4-M11, E4-M24, E4-M25) |
| AI mutation score | **88.0%** (22/25) |
| Both killed | **22** |
| Human-only kills | **E4-M24, E4-M25** |
| AI-only kills | *(none)* |
| Both survived (valid) | **E4-M11** |

### ID lists

| Bucket | IDs |
|---|---|
| Human-only kills | E4-M24, E4-M25 |
| AI-only kills | — |
| Both survived (valid) | E4-M11 |
| Crash kills (either suite) | E4-M02, M06, M09, M12, M17, M18, M21, M22, M24, M26 |
| Timeout kills | — |
| Invalid/equivalent | **E4-M05** |

### Raw (before M05 exclusion)

| Suite | Killed | Survived | Score |
|---|---:|---:|---:|
| Human | 24 | 2 | 92.3% |
| AI | 22 | 4 | 84.6% |

## Notable outcomes

- Despite **identical line coverage**, human mutation score **>** AI (96% vs 88%) after M05 exclusion.
- Human-only kills **M24/M25** are capacity/overflow-path defects; AI suite did not fail them.
- **M11** shared survivor: insert capacity-boundary mutant not exercised by either frozen filter.

## Final integrity

| Check | Result |
|---|---|
| Production restored SHA-256 | ✓ `0eb00dc6…` |
| AI test SHA-256 | ✓ `a175e502…` |
| Human frozen filter | **PASS** (10/0) |
| AI suite | **PASS** (41/0) |
| Frozen tests unmodified | ✓ |

---

## Stop line

Experiment #4 mutation execution complete. No further tests or mutations.
