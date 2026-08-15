# Experiment #2 — Mutation Results (`Any.swift`)

**Component:** `Sources/SnapshotTesting/Snapshotting/Any.swift`  
**Frozen set:** E2-M01–E2-M27 (27) from `research/experiment-2-mutation-plan.md`  
**Repo SHA:** `59a99c458de4d2dee580529b61b4f78dca7b7fa6`  
**AI suite SHA-256:** `20a9a829d91fc7f947b50a1199e24a6cc9bd24732a00dbb559ee8c8297efaf43`  

## Integrity

- One mutant at a time; production restored after each (`research/Any.swift.ORIG`).
- `SNAPSHOT_TESTING_RECORD=never`; fixtures restored via `git checkout -- __Snapshots__/`.
- Suites not modified.
- Final verify: human dump filter **PASS** (6/0); AI **PASS** (51/0).
- Logs: `research/mutation-logs-e2/`; machine rows: `research/mutation-results-e2.jsonl`.

### Reclassification notes

Initial automatics labeled some AI runs `INVALID` when `xctest` aborted (signal 5/11) after failures, and M15 as `INVALID` on segfault. Per plan (M15 hang/crash → KILLED) and standard mutation practice (runtime crash under tests = killed), these were reclassified:
- **E2-M01** ai: INVALID→KILLED; Reclassified: multiple AI assertion failures then xctest signal 5
- **E2-M11** ai: INVALID→KILLED; Reclassified: AI assertion failures + fatal error / signal 5
- **E2-M15** human: INVALID→KILLED; Reclassified: xctest signal 11 during testRecursion (stack/segfault)
- **E2-M15** ai: INVALID→KILLED; Reclassified: xctest signal 11 during circular-reference dump
- **E2-M25** ai: INVALID→KILLED; Reclassified: AI fatal error / signal 5 under mutant

## Commands (per mutant)

```bash
cp research/mutants-e2/E2-MXX.swift Sources/SnapshotTesting/Snapshotting/Any.swift
SNAPSHOT_TESTING_RECORD=never swift test --filter 'SnapshotTestingTests.testAny$|...|testNamedAssertion'
SNAPSHOT_TESTING_RECORD=never swift test --filter AIGeneratedAnyTests
cp research/Any.swift.ORIG Sources/SnapshotTesting/Snapshotting/Any.swift
git checkout -- Tests/SnapshotTestingTests/__Snapshots__/
```

## Results table

| Mutation | Human | AI | Human failing tests | AI failing tests | Notes |
|---|---|---|---|---|---|
| E2-M01: Bullet `-`/`▿` swap (L99) | KILLED | KILLED | testAny, testDeterministicDictionaryAndSetSnapshots, testMultipleSnapshots, testNamedAssertion, … (+2) | testDump_containerUsesTriangleBullet, testDump_customConvertible_withRenderChildren, testDump_deeplyNestedArrays, testDump_dictionary_childrenSortedDeterministically, … (+9) | see reclassification |
| E2-M02: Array always plural `elements` (L105) | KILLED | KILLED | testMultipleSnapshots | testDump_singleElementArray |  |
| E2-M03: Array singular uses `count==0` (L105) | KILLED | KILLED | testMultipleSnapshots | testDump_emptyArray, testDump_singleElementArray |  |
| E2-M04: Dict always plural pairs (L107) | SURVIVED | KILLED | — | testDump_singleKeyValuePair |  |
| E2-M05: Set always plural members (L110) | SURVIVED | KILLED | — | testDump_singleMemberSet |  |
| E2-M06: Remove dict `sort` (L108) | KILLED | KILLED | testDeterministicDictionaryAndSetSnapshots | testDump_dictionary_childrenSortedDeterministically |  |
| E2-M07: Remove set `sort` (L111) | SURVIVED | KILLED | — | testDump_set_childrenSortedDeterministically | Human set unsorted still matched fixture order this run |
| E2-M08: Reverse sort comparator (L158) | KILLED | KILLED | testAny, testDeterministicDictionaryAndSetSnapshots, testNamedAssertion, named | testDump_dictionary_childrenSortedDeterministically, testDump_set_childrenSortedDeterministically, testDump_structWithProperties_sortedChildren |  |
| E2-M09: `indent+2` → `+4` (L147) | KILLED | SURVIVED | testAny, testDeterministicDictionaryAndSetSnapshots, testMultipleSnapshots, testNamedAssertion, … (+2) | — | Human-only: AI indent asserts use `contains("  ▿…")` which also matches 4-space indent |
| E2-M10: `indent+2` → `+1` (L147) | KILLED | KILLED | testAny, testDeterministicDictionaryAndSetSnapshots, testMultipleSnapshots, testNamedAssertion, … (+2) | testDump_indentationIncreasesByTwo |  |
| E2-M11: Convertible early-return uses `▿` (L121) | KILLED | KILLED | testAny, testAnySnapshotStringConvertible, testDeterministicDictionaryAndSetSnapshots, testNamedAssertion, … (+8) | testDump_character, testDump_customConvertible_asProperty, testDump_customConvertible_withoutChildren, testDump_data, … (+3) | see reclassification |
| E2-M12: Invert optional none/some (L117) | KILLED | KILLED | testRecursion | testDump_optionalNone, testDump_optionalSome |  |
| E2-M13: Enum always `subjectType` only (L140) | SURVIVED | KILLED | — | testDump_enumWithoutAssociatedValues |  |
| E2-M14: Enum always `subjectType.value` (L140) | SURVIVED | SURVIVED | — | — | Equivalent for exercised enums: associated-value `\(value)` text matched expectations |
| E2-M15: Delete `visitedValues.insert` (L129) | KILLED | KILLED | crash (signal 11) in testRecursion | crash (signal 11) in circular dump | Both killed via segfault (signal 11) on circular dumps |
| E2-M16: Invert circular `contains` (L126) | KILLED | KILLED | testRecursion | testDump_circularReference_detected, testDump_simpleClass |  |
| E2-M17: Circular message → `(cycle)` (L127) | KILLED | KILLED | testRecursion | testDump_circularReference_detected, testDump_selfReference |  |
| E2-M18: `name ?? "value"` → `"object"` (L127) | SURVIVED | SURVIVED | — | — | Equivalent: Mirror supplied names so `??` fallback unused |
| E2-M19: `renderChildren` default `true` (L177) | KILLED | KILLED | testAnySnapshotStringConvertible, data, date, url | testDump_customConvertible_withoutChildren, testDump_data, testDump_date_usesUTCFormatter, testDump_url |  |
| E2-M20: Invert `where renderChildren` (L118) | KILLED | KILLED | testAnySnapshotStringConvertible, data, date, url | testDump_customConvertible_withoutChildren, testDump_customConvertible_withRenderChildren, testDump_data, testDump_date_usesUTCFormatter, … (+1) |  |
| E2-M21: Remove struct `sort` (L136) | KILLED | KILLED | testAny, testNamedAssertion, named | testDump_structWithProperties_sortedChildren |  |
| E2-M22: Remove class `sort` (L132) | SURVIVED | SURVIVED | — | — | Survived both: class property order already matched unsorted order / single meaningful child |
| E2-M23: Date format date-only (L231) | KILLED | KILLED | testAnySnapshotStringConvertible, date | testDump_date_usesUTCFormatter |  |
| E2-M24: Date TZ +3600s (L234) | KILLED | KILLED | testAnySnapshotStringConvertible, date | testDump_date_usesUTCFormatter |  |
| E2-M25: String uses `description` (L213) | KILLED | KILLED | testAny, testAnySnapshotStringConvertible, testDeterministicDictionaryAndSetSnapshots, testNamedAssertion, … (+2) | — | see reclassification |
| E2-M26: purgePointers short hex quantifier (L240) | KILLED | KILLED | testAnySnapshotStringConvertible, nsobject | testPurgePointers_removesColonPrefixedAddresses |  |
| E2-M27: purgePointers replacement `""` (L240) | SURVIVED | KILLED | — | testPurgePointers_removesColonPrefixedAddresses |  |

## Scores

Mutation score = Killed / (Killed + Survived) × 100

| Metric | Value |
|---|---|
| Total mutations | 27 |
| Valid mutations | 27 (human) / 27 (AI) |
| Invalid mutations | 0 (after reclassification: **0**) |
| Human killed | 19 |
| Human survived | 8 |
| Human mutation score | **70.4%** (19/27) |
| AI killed | 23 |
| AI survived | 4 |
| AI mutation score | **85.2%** (23/27) |
| Caught only by Human | 1 (E2-M09) |
| Caught only by AI | 5 (E2-M04, E2-M05, E2-M07, E2-M13, E2-M27) |
| Caught by both | 18 |
| Missed by both | 3 (E2-M14, E2-M18, E2-M22) |

### Catch lists

- **Both:** E2-M01, E2-M02, E2-M03, E2-M06, E2-M08, E2-M10, E2-M11, E2-M12, E2-M15, E2-M16, E2-M17, E2-M19, E2-M20, E2-M21, E2-M23, E2-M24, E2-M25, E2-M26
- **AI only:** E2-M04, E2-M05, E2-M07, E2-M13, E2-M27
- **Human only:** E2-M09
- **Neither:** E2-M14, E2-M18, E2-M22

## Stop line

Experiment #2 mutation campaign complete. Suites unchanged; production restored.
