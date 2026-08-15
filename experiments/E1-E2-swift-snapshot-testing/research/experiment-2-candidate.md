# Experiment #2 Candidate Selection

**Repository:** pointfreeco/swift-snapshot-testing  
**Pinned SHA:** `59a99c458de4d2dee580529b61b4f78dca7b7fa6`  
**Date (UTC):** 2026-08-13T00:57:17Z  
**Context:** Experiment #1 (`URLRequest.swift`) complete — human 85%, AI 95%, 20 valid mutants.

**This document only selects the next component.** No AI tests, no mutations, no production/test edits.

---

## Selection criteria

Same constraints as Experiment #1, plus:

- Substantially different behavior from URLRequest HTTP/cURL formatting
- Enough branches for **15–30** meaningful mutations
- Prefer **100–300 LOC**
- Happy-path human assertions must exercise the logic (avoid mismatch-only paths)

Excluded early: UIKit/AppKit/SwiftUI/SceneKit/SpriteKit image strategies, `View.swift`, `UIImage`/`NSImage`, `AssertSnapshot.swift` (orchestration), `PlistEncoder.swift` (2.2k LOC, too large for a weekend), `URLRequest.swift` (already used).

---

## Candidates

| Component | LOC | Human tests | Logic type | Mutation potential | Difficulty |
|---|---:|---|---|---|---|
| **`Snapshotting/Any.swift`** (`.dump` / `snap` / `purgePointers`) | **241** | **6** primary XCTest methods with **14** `.dump` assertions + fixtures (`testAny`, `testRecursion`, `testAnySnapshotStringConvertible`×7, `testDeterministicDictionaryAndSetSnapshots`, `testMultipleSnapshots`×2, `testNamedAssertion`); also used by Swift Testing / assert-helper tests | Mirror-based structural dump: pluralization, dict/set sorting, optional/enum/class/struct cases, circular-ref detection, `AnySnapshotStringConvertible`, pointer scrubbing, date formatting | **High** (~20–30): `count == 0/1` boundaries, bullet `-/▿`, sort `<`→`>`, indent `+2`, circular message, regex, `renderChildren`, `.none` text, etc. Happy-path snapshots kill mutants | **Medium** |
| **`Diff.swift`** (`diff` / `chunk` / `Hunk`) | **131** | No direct unit tests; only via `Diffing.lines` on **mismatch** (`guard old != new`) | LCS-style longest overlap + hunk chunking with context window | **High** algorithmically (`>`, `ctx * 2`, empty checks, `.first`/`.second`/`both`) | **High / poor fit** — passing human suites often never execute `Diff`, so human mutation score is biased low vs AI that can unit-test `@testable` APIs |
| **`Snapshotting/CaseIterable.swift`** | **55** | `testCaseIterable` (1 CSV snapshot) | Map `allCases` → quoted CSV rows | **Low–Medium** (~5–8): separator, quoting, `pathExtension`) — below 15–30 target | **Low** |
| **`Common/String+SpecialCharacters.swift`** | **61** | No dedicated tests; only called from deprecated inline-snapshot helpers | Regex detection of escaped literals + `#` count | **Medium** (pattern / threshold / `max() ?? 1`) | **Medium** — fails “already have human-written tests” for a fair frozen-suite compare |
| **`SnapshotTestingConfiguration.swift`** (`Record` / `DiffTool` / `withSnapshotTesting`) | **236** | `WithSnapshotTestingTests`, `RecordTests`, `SnapshotsTraitTests` | Config scoping + `Record(rawValue:)` switch + diff-tool string building | **Medium** — many lines are docs/API surface; fewer dense algorithmic branches than `snap` | **Medium** — more plumbing than structure-dump logic; less distinct “algorithm under test” |

### Notes on near-misses

- **`Snapshotting/String.swift` (`Diffing.lines`)** — 28 LOC; inseparable from `Diff.swift` mismatch-path problem.
- **`Snapshotting/Encodable.swift`** — thin encoder wrappers; little local branching.
- **`Any.swift` `.json` / `.description`** — thin; Experiment #2 should treat **`snap` / `.dump` / helpers** as the MUT surface (same file, primary logic).

---

## Recommendation: `Sources/SnapshotTesting/Snapshotting/Any.swift`

**Focus:** private `snap`, `sort`, `purgePointers`, `AnySnapshotStringConvertible` defaults/conformances, and the `.dump` strategy entry point.

1. **Size & fit:** 241 LOC sits in the preferred 100–300 band; weekend-scoped without architecture changes.
2. **Human baseline is real:** multiple dump snapshots exercise structs, collections, dict/set sorting, circular references, and convertible primitives — mutants change dump text and fail existing fixtures.
3. **Mutation richness:** large `switch` on `Mirror.displayStyle` plus boundary pluralization and sort/indent/circular/regex edges easily support 15–30 non-trivial mutants.
4. **Different from Experiment #1:** reflection/structural pretty-printing vs URLRequest wire/cURL formatting — avoids repeating the same “string formatter” lesson.
5. **Platform-independent / SwiftPM:** Foundation + Mirror only; no UIKit/AppKit/simulator; filterable via existing dump-related test names.

### Suggested Experiment #2 human filter (for later baseline only)

```bash
swift test --filter 'SnapshotTestingTests.(testAny$|testRecursion|testAnySnapshotStringConvertible|testDeterministicDictionaryAndSetSnapshots|testMultipleSnapshots|testNamedAssertion)' \
  --enable-code-coverage
```

(Exact filter syntax to be validated when establishing the Experiment #2 baseline.)

---

## Explicitly not recommended for #2

| Component | Why not |
|---|---|
| `Diff.swift` | Interesting algorithm, but human passing tests rarely execute it → unfair mutation comparison |
| `CaseIterable.swift` | Too small / too few branches |
| `String+SpecialCharacters.swift` | Insufficient dedicated human tests |
| `SnapshotTestingConfiguration.swift` | Viable fallback, but weaker algorithmic density than `Any.swift` |

---

## Stop line

Candidate selection complete. **Do not generate AI tests, mutations, or baselines for Experiment #2 until the next step is requested.**
