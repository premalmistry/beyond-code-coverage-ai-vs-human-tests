# Experiment #2 — Mutation Plan (`Any.swift`)

**Component:** `Sources/SnapshotTesting/Snapshotting/Any.swift`  
**Repo SHA:** `59a99c458de4d2dee580529b61b4f78dca7b7fa6`  
**Suites (frozen):** human dump filter (6 methods / 14 asserts); AI `AIGeneratedAnyTests` (SHA `20a9a829…`)  
**Status:** Plan only — **no mutants applied, no execution**

Predictions below are **a priori**, based on known suite contents (not on mutation outcomes).

### Prediction key

| Label | Meaning |
|---|---|
| **Yes** | Expected to fail ≥1 test in that frozen suite |
| **Likely** | Expected to fail, but depends on fixture/input details |
| **No** | Suite does not appear to exercise this path |
| **Uncertain** | Behavior change may be subtle / order-dependent / host-dependent |

Human suite strengths: struct dumps, `[1]`/`[1,2]`, dict+set determinism, circular classes, built-in convertibles (incl. Date, NSObject).  
Human suite gaps (from prior baseline): no dedicated enum dumps, no `renderChildren == true` custom types, no empty-collection roots, no direct `purgePointers` unit tests, `.description` / `.json` not in the dump filter.  
AI suite: broad dump + enum + empty/singular/plural + `renderChildren` + `purgePointers` + `.description`/`.json`.

---

## Proposed mutations

| ID | Mutation | Source location | Expected behavior change | Human expected to catch? | AI expected to catch? |
|---|---|---|---|---|---|
| E2-M01 | `count == 0 ? "-" : "▿"` → `count == 0 ? "▿" : "-"` | L99 | Leaf/container bullets swapped | **Yes** (struct/array dumps) | **Yes** (`leafUsesDashBullet` / `containerUsesTriangleBullet`) |
| E2-M02 | `count == 1 ? "1 element" : "\(count) elements"` → always `"\(count) elements"` | L105 | Singular array labeled `"1 elements"` | **Yes** (`testMultipleSnapshots` dumps `[1]`) | **Yes** (`singleElementArray`) |
| E2-M03 | `count == 1 ? "1 element" : …` → `count == 0 ? "1 element" : …` | L105 | Empty array mislabeled; single-element uses plural | **Likely** (no empty array in human; `[1]` becomes plural → **Yes**) | **Yes** (empty + singular tests) |
| E2-M04 | `count == 1 ? "1 key/value pair" : …` → always plural form | L107 | Single-entry dict wrong wording | **No** (human dict has 3 keys) | **Yes** (`singleKeyValuePair`) |
| E2-M05 | `count == 1 ? "1 member" : …` → always plural form | L110 | Single-member set wrong wording | **No** (human set has 2 members) | **Yes** (`singleMemberSet`) |
| E2-M06 | Remove `children = sort(...)` in dictionary arm | L108 | Dict child order non-deterministic / unsorted | **Yes** (`testDeterministicDictionaryAndSetSnapshots`) | **Yes** (dict sort / stability tests) |
| E2-M07 | Remove `children = sort(...)` in set arm | L111 | Set child order unsorted | **Yes** (same deterministic test) | **Yes** (set sort tests) |
| E2-M08 | `$0.snap < $1.snap` → `$0.snap > $1.snap` | L158 | Reverse deterministic sort order | **Yes** (dict/set + struct property order) | **Yes** (struct/dict/set order asserts) |
| E2-M09 | `indent + 2` → `indent + 4` | L147 | Nested dump indentation doubled | **Yes** (nested fields in struct/recursion fixtures) | **Yes** (`indentationIncreasesByTwo`) |
| E2-M10 | `indent + 2` → `indent + 1` | L147 | Nested indentation off-by-one | **Yes** | **Yes** |
| E2-M11 | `"\(indentation)- \(name…)"` in convertible early-return → use `"\(indentation)▿ "` | L121 | Convertible leaves use triangle bullet | **Yes** (string/date/etc. dump fixtures) | **Yes** (exact convertible dumps) |
| E2-M12 | `count == 0 ? "\(subjectType).none" : "\(subjectType)"` → invert (`count != 0` / swap branches) | L117 | Optional none/some labels swapped | **Uncertain** (optionals only as nested children if at all) | **Yes** (`optionalNone` / `optionalSome`) |
| E2-M13 | Enum `count == 0 ? "\(subjectType).\(value)" : "\(subjectType)"` → always `"\(subjectType)"` | L140 | Simple enums lose case name suffix | **No** (no enum dumps in human filter) | **Yes** (`enumWithoutAssociatedValues`) |
| E2-M14 | Enum arm: always `"\(subjectType).\(value)"` even with associated values | L140 | Associated-value enums append noisy `.\(value)` | **No** | **Yes** (`enumWithAssociatedValues` / `enumErrorCase`) |
| E2-M15 | Delete `visitedValues.insert(objectID)` | L129 | Circular graphs may infinite-recurse or never mark visited | **Yes** (`testRecursion`) — likely hang/crash/fail | **Yes** (circular / self-ref tests) |
| E2-M16 | Invert `if visitedValues.contains(objectID)` | L126 | Treat first visit as circular / miss true cycles | **Yes** (`testRecursion`) | **Yes** |
| E2-M17 | Circular message `(circular reference detected)` → `(cycle)` | L127 | Failure text changes | **Yes** (exact snapshot text) | **Yes** (`contains "(circular reference detected)"`) |
| E2-M18 | Circular fallback `name ?? "value"` → `name ?? "object"` | L127 | Unlabeled circular node label changes | **Uncertain** (depends on Mirror labels in recursion fixtures) | **Likely** (self-ref / mutual dumps) |
| E2-M19 | Default `renderChildren` `false` → `true` | L177 | Built-in convertibles take `renderChildren` arm; children may appear | **Yes** (String/Date/etc. dump fixtures change) | **Yes** (`customConvertible_withoutChildren` + built-ins) |
| E2-M20 | `where type(of: value).renderChildren` → `where !type(of: value).renderChildren` | L118 | Swaps early-return vs render-children arms | **Yes** (convertible dumps) | **Yes** (both custom convertible tests) |
| E2-M21 | Remove `children = sort(...)` in struct arm | L136 | Struct property order unsorted | **Yes** (`testAny` / named user property order) | **Yes** (`structWithProperties_sortedChildren`) |
| E2-M22 | Remove `children = sort(...)` in class arm | L132 | Class property order unsorted | **Likely** (`testRecursion` class layouts) | **Yes** (`simpleClass` / circular dumps) |
| E2-M23 | Date format `yyyy-MM-dd'T'HH:mm:ssZZZZZ` → `yyyy-MM-dd` | L231 | Date dumps drop time/zone | **Yes** (`testAnySnapshotStringConvertible` date) | **Yes** (`date_usesUTCFormatter`) |
| E2-M24 | Date `timeZone = UTC` → `TimeZone(secondsFromGMT: 3600)` | L234 | Date string shifts by +1h | **Yes** (date fixture) | **Yes** (expects `…T00:00:00Z`) |
| E2-M25 | `String` `snapshotDescription` uses `description` instead of `debugDescription` | L213 | String dumps lose debug quoting style | **Yes** (string convertible fixtures) | **Yes** (exact `"- \"Hello\"\n"`) |
| E2-M26 | `purgePointers` regex `0x[\\da-f]+` → `0x[\\da-f]{1,4}` (too short) | L240 | Longer addresses not scrubbed | **Likely** (NSObject dump may show `0x…`) | **Yes** (`nsObject_scrubsPointers` + `purgePointers_*`) |
| E2-M27 | `purgePointers` replacement `"$1"` → `""` | L240 | Collapses spacing around removed addresses | **Likely** (NSObject text shape) | **Yes** (exact purge asserts) |
| E2-M28 | Tuple `count == 1 ? "(1 element)" : "(\(count) elements)"` → always plural | L113 | Single-element tuple wording wrong | **No** (human filter has no 1-tuples) | **Uncertain** (`singleElementTuple` assert is weak) |
| E2-M29 | `.json` options drop `.sortedKeys` | L75 | JSON key order non-deterministic / unsorted | **No** (`.json` not in human dump filter) | **Yes** (`json_prettyPrintedSortedKeys`) |
| E2-M30 | `.description` pullback `{ _ in "" }` (always empty string) | L17 | Description strategy returns empty | **No** (human dump filter unused) | **Yes** (`description_usesStringDescribing`) |

---

## Totals

| | Count |
|---|---:|
| Proposed mutations | **30** |
| Recommended frozen set | **E2-M01…E2-M27** (**27**) |
| Optional extras (keep only if needing ≥28) | E2-M28, E2-M29, E2-M30 |

**Recommended frozen set for execution: 27 mutants (E2-M01–E2-M27).**  
If the protocol requires a round 20–30 inclusive band with emphasis on dump/`snap`, prefer **E2-M01–E2-M27**. Add E2-M29–E2-M30 only if explicitly expanding beyond the dump-focused human filter for strategy-entry coverage.

---

## Questionable / possibly weak mutants

| ID | Concern |
|---|---|
| **E2-M15** | May **hang or crash** (stack overflow) rather than cleanly fail — still a kill if AI/human don’t finish green; treat timeouts as **KILLED**, record note |
| **E2-M18** | Label-only; may be **equivalent** if Mirror always supplies `name` in recursion fixtures |
| **E2-M28** | AI assertion is weak; human uncovered — **high survive risk / low signal**; exclude from frozen set |
| **E2-M03** | Partially overlaps M02 on the `[1]` case; still distinct on empty-array behavior (AI-only) |
| **E2-M26** | Regex narrowing may still scrub short addresses; prefer confirming non-equivalence on typical `NSObject` `debugDescription` |
| **E2-M29 / E2-M30** | Valid bugs, but **outside human dump filter** → inflate AI-only kills; optional |

### Avoided (not proposed)

- Comment/doc-only edits  
- Mutations that only rename locals without affecting output  
- `count == 0` → `count < 0` for bullets (equivalent for non-negative counts)  
- Compile-breaking signature changes  
- `#else` non-ObjC `NSObject` branch (inactive on macOS host)

---

## Predicted catch matrix (frozen set E2-M01–E2-M27)

| Prediction | IDs |
|---|---|
| Both catch | M01–M03, M06–M11, M15–M17, M19–M25, M21 (and likely M22, M26–M27) |
| AI only (expected) | **M04, M05, M12?, M13, M14** |
| Human only (expected) | — (none strongly predicted) |
| Both miss (risk) | **M18** (if equivalent), possibly **M12** if human never dumps optionals |

---

## Execution protocol (for later — do not run now)

```bash
# Per mutant (later):
cp research/mutants-e2/E2-MXX.swift Sources/SnapshotTesting/Snapshotting/Any.swift
SNAPSHOT_TESTING_RECORD=never swift test --filter '<human dump filter>'
SNAPSHOT_TESTING_RECORD=never swift test --filter AIGeneratedAnyTests
cp research/Any.swift.ORIG Sources/SnapshotTesting/Snapshotting/Any.swift
git checkout -- Tests/SnapshotTestingTests/__Snapshots__/
```

---

## Stop line

Mutation plan complete (**30 proposed, 27 recommended frozen**).  
**Do not apply mutants or run suites until the next step is requested.**
