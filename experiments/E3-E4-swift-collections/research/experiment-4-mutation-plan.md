# Experiment #4 — Mutation Plan (`OrderedSet+Insertions.swift`)

**Component (primary):** `Sources/OrderedCollections/OrderedSet/OrderedSet+Insertions.swift`  
**Repo SHA:** `f3e778f17a438371c5b8c170f15c0d997bb417ee`  
**Production SHA-256:** `0eb00dc657e182f3254b10130bcaf6f9483b4b02d6126c47c01f0993caae5efd`  

**Suites (frozen — do not modify):**  
- Human filter (10 methods):  
  `OrderedSetTests.test_append$|…|test_replace`  
- AI: `AIGeneratedOrderedSetInsertionsTests` (41 methods; SHA-256 `a175e50261c24830e0669209e58f7f48b3cdc413909073c8a80e30722770c2d4`)  

**Coverage (both, independently):** line **82.39%** / region **78.85%** / function **73.08%**  

**Status:** Plan only — **no mutants applied, no execution**

Predictions are **a priori** from API surface + known suite scope (append/insert/update/replace/updateOr*). Test sources were **not** re-opened while drafting mutants.

### Prediction key

| Label | Meaning |
|---|---|
| **Both kill** | Both frozen suites expected to fail ≥1 test (or crash under test) |
| **Human kill** | Human likely kills; AI may miss |
| **AI kill** | AI likely kills; human may miss |
| **Possibly survives** | May be equivalent / weakly observed |

### Recommended execution filters (later — not run now)

```bash
# Human (frozen)
swift test --filter 'OrderedSetTests.test_append$|OrderedSetTests.test_append_many|OrderedSetTests.test_append_contentsOf|OrderedSetTests.test_insert_at|OrderedSetTests.test_update_at|OrderedSetTests.test_updateOrAppend|OrderedSetTests.test_updateOrInsert|OrderedSetTests.test_replace'

# AI (frozen)
swift test --filter AIGeneratedOrderedSetInsertionsTests
```

---

## Proposed mutations

| ID | Source location | Original | Mutation | Expected behavioral defect | Human prediction | AI prediction | Risk |
|---|---|---|---|---|---|---|---|
| **E4-M01** | `_append` L71 | `return (false, index)` | `return (true, index)` | Duplicate append reports `inserted: true` while set unchanged | Both kill | Both kill | overlapping w/ M07 |
| **E4-M02** | `_append` L71 | `if let index = index { return (false, index) }` | delete early-return (always fall through) | Duplicates appended again → broken uniqueness / invariant failure | Both kill | Both kill | possible crash (invariant / assert) |
| **E4-M03** | `_append` L73 | `return (true, _elements.index(before: endIndex))` | `return (false, _elements.index(before: endIndex))` | Successful append reports `inserted: false` | Both kill | Both kill | overlapping w/ M01 (flag polarity) |
| **E4-M04** | `_append` L73 | return end index of new element | `return (true, 0)` | Wrong index for newly appended element (always 0) | Both kill | Both kill | — |
| **E4-M05** | `_appendNew(_:in:)` L53 | `count <= _capacity` | `count < _capacity` | Regenerates hash table one element earlier | Possibly survives | Possibly survives | **possible equivalent** (extra regenerate may still be correct) |
| **E4-M06** | `_appendNew(_:in:)` L61 | `hashTable[bucket] = _elements.count - 1` | `= _elements.count` | Hash table stores invalid offset → wrong membership / lookup | Both kill | Both kill | possible crash / invariant |
| **E4-M07** | `insert` L171 | `return (false, existing)` | `return (true, existing)` | Duplicate insert reports `inserted: true` | Both kill | Both kill | overlapping w/ M01 |
| **E4-M08** | `insert` L171 | `return (false, existing)` | `return (false, index)` *(parameter)* | Duplicate insert returns **requested** index, not actual location | Both kill | Both kill | — |
| **E4-M09** | `insert` L173 | `return (true, index)` | `return (true, index + 1)` | Off-by-one success index after positional insert | Both kill | Both kill | — |
| **E4-M10** | `insert` L172 | `_insertNew(item, at: index, in: bucket)` | `_appendNew(item, in: bucket)` | New member always appended; requested position ignored (order bug) | Both kill | Both kill | overlapping w/ order mutants |
| **E4-M11** | `_insertNew` L126 | `count < _capacity` | `count <= _capacity` | Skips regenerate when full → insert with stale/small table | Both kill | Both kill | possible crash / invariant |
| **E4-M12** | `_insertNew` L140 | `hashTable[bucket] = index` | `hashTable[bucket] = index + 1` | Table maps element to wrong offset after mid-insert | Both kill | Both kill | possible crash / invariant |
| **E4-M13** | `update` L199 | `_elements[index] = item` | *(delete assignment)* | `update` returns `old` but leaves storage unchanged | Both kill | Both kill | identity/oracle sensitive; both suites cover `update` |
| **E4-M14** | `update` L200 | `return old` | `return item` | Returns replacement instead of prior member | Both kill | Both kill | — |
| **E4-M15** | `_replaceNew` L220 | `swapAt(index, count - 1)` | `swapAt(index, 0)` | Swaps with first slot, not newly appended last → wrong final order / wrong removed value | Both kill | Both kill | — |
| **E4-M16** | `_replaceNew` L220 | `swapAt(...); return removeLast()` | delete `swapAt`; keep `removeLast()` | Removes the new element; original at `index` remains | Both kill | Both kill | overlapping w/ M15 |
| **E4-M17** | `replace` L260 | `if existing == index` | `if existing != index` | Equal-at-index path inverted → hits duplicate precondition or wrong branch | Both kill | Both kill | possible crash on equal replace |
| **E4-M18** | `replace` L260–262 | equal-at-index → `update` | remove equal branch (fall through to `precondition(existing == nil)`) | Equal-element replace traps instead of in-place update | Both kill | Both kill | possible crash |
| **E4-M19** | `updateOrAppend` L288 | `if inserted { return nil }` | `if !inserted { return nil }` | Nil/non-nil return inverted; may skip needed write or write wrongly | Both kill | Both kill | — |
| **E4-M20** | `updateOrAppend` L288–292 | on existing: write + return `old` | on existing: `return nil` *(skip write)* | Existing member not replaced; API claims append-success via `nil` | Both kill | Both kill | overlapping w/ M19 |
| **E4-M21** | `updateOrInsert` L323 | `return (old, existing)` | `return (old, index)` *(requested)* | Existing update returns wrong index (request site vs actual) | Both kill | Both kill | overlapping w/ M08 |
| **E4-M22** | `updateOrInsert` L320–326 | `if let existing = existing { update@existing; return (old, existing) } else { insertNew; return (nil, index) }` | **Swap arms:** `if let existing = existing { _insertNew(...); return (nil, index) } else { let old = _elements[index]; _elements[index] = item; return (old, index) }` | Present → wrongly inserts; absent → treats `index` as occupied (trap if `index == endIndex`) | Both kill | Both kill | possible crash |
| **E4-M23** | `updateOrInsert` L326 | `return (nil, index)` | `return (nil, 0)` | New insert reports wrong index (always 0) | Both kill | Both kill | — |
| **E4-M24** | `_appendNew(_:in:)` L53–55 | on overflow: `_regenerateHashTable(); return` | on overflow: `return` *(skip regenerate)* | Grows `_elements` past table capacity without rebuild → corrupt lookups | Both kill | Both kill | possible crash / invariant |
| **E4-M25** | `_insertNew` L126–129 | overflow arm inserts + regenerates | overflow arm: `_elements.append(item); _regenerateHashTable(); return` | When full, appends instead of inserting at `index` | Both kill | Both kill | overlapping w/ M10 |
| **E4-M26** | `_append` L71 | `return (false, index)` | `return (false, index + 1)` | Duplicate path returns off-by-one index | Both kill | Both kill | — |

### Concrete edit for **E4-M22**

```swift
if let existing = existing {
  _insertNew(item, at: index, in: bucket)
  return (nil, index)
} else {
  let old = _elements[index]  // traps when index == endIndex
  _elements[index] = item
  return (old, index)
}
```

Present → wrongly inserts; absent → treats `index` as occupied. Flagged **possible crash**.

---

## Frozen set

| | |
|---|---|
| **Recommended frozen set** | **E4-M01 … E4-M26** (**26** mutants) |
| Band | Within 25–28; quality over padding |
| File scope | Entirely in `OrderedSet+Insertions.swift` |
| Excluded on purpose | Bucketless `_appendNew(_:)` (unreachable via selected APIs); assert-only edits; `_HashTable` files |

---

## Final review checklist

| # | Check | Result |
|---:|---|---|
| 1 | Compiles in principle | Yes — local operator/branch/return edits only |
| 2 | Changes meaningful observable behavior | Yes — flags, indexes, order, identity update, table integrity |
| 3 | Reachable via Insertions public API | Yes — through `append` / `insert` / `update*` / `replace` |
| 4 | Fair for both frozen suites | Yes — both exercise this API surface; no suite edits |
| 5 | Independent of execution outcomes | Yes — plan-only |

### Possibly equivalent

| ID | Note |
|---|---|
| **E4-M05** | Earlier regenerate may still yield a correct set → **Possibly survives** both |

### Possible crash / invariant abort

| ID | Note |
|---|---|
| **E4-M02**, **E4-M06**, **E4-M11**, **E4-M12**, **E4-M17**, **E4-M18**, **E4-M22**, **E4-M24** | Uniqueness/table corruption or inverted replace/updateOrInsert → trap / `_checkInvariants` fail. Count as **KILLED**. |

### Overlapping clusters (keep all; distinct sites)

| Cluster | IDs |
|---|---|
| Inserted-flag polarity | M01, M03, M07 |
| Wrong returned index | M04, M08, M09, M21, M23, M26 |
| Append-vs-insert position | M10, M25 |
| Replace swap/removal | M15, M16 |
| updateOrAppend nil/write | M19, M20 |
| Hash regenerate / capacity | M05, M11, M24 |

### Avoided

- Bucketless `_appendNew(_:)` (uncovered / unreachable through chosen API)
- Comment-only / rename-only edits  
- Mutations only flipping `assert(...)`  
- Edits in `_HashTable` / `_find` outside this file  
- Padding mutants to force 28  

---

## Predicted catch matrix (a priori)

| Prediction | IDs |
|---|---|
| Both kill | M01–M04, M06–M26 (majority) |
| Possibly survives (both) | **M05** |
| Human-only / AI-only (strong a priori) | *(none expected)* — coverage parity + shared API focus |

---

## Stop line

Mutation plan complete (**26** frozen mutants **E4-M01–E4-M26**). **Do not execute mutations until the next step is requested.**
