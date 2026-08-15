# Experiment #11 — Candidate Selection (CONFIRMATORY)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Repository:** [pointfreeco/swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing)  
**Pinned SHA:** `59a99c458de4d2dee580529b61b4f78dca7b7fa6` (same pin as Experiments #1 and #2)  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Date (UTC):** `2026-08-15T15:25:31Z`

**This document only selects the component.** No AI tests, no mutations, no production/test edits beyond recording this selection.

---

## Context

Experiments #1–#10 were **exploratory**. Experiments #11–#15 are **confirmatory**, designed to reduce component-selection bias.

The goal is **not** to find an interesting result. The goal is to select a component using a neutral, pre-declared rule and accept whatever result occurs.

Previously studied in this repository (must not be reused):

| Experiment | Component |
|---|---|
| E1 | `Sources/SnapshotTesting/Snapshotting/URLRequest.swift` |
| E2 | `Sources/SnapshotTesting/Snapshotting/Any.swift` |

---

## Eligibility criteria (pre-declared)

A production file is **eligible** only if **all** of the following hold:

1. Has **direct** existing human-written tests (a frozen filter can exercise the file’s observable behavior on the happy path of a **passing** suite).
2. Has **deterministic** tests (no material dependence on wall-clock timing, animation, or rendering noise).
3. Has **focused, observable** behavior (not a pure re-export / empty shim).
4. Can **reasonably support meaningful mutation testing** (enough local branching / observable decisions for a non-trivial mutant set; not a 1–2 branch wrapper).
5. Does **not** require network / external services.
6. Was **not** studied in Experiments #1–#10.
7. Is **reasonably isolated** enough for a Human-vs-AI comparison under repeated mutation restore cycles (mutating the file must not inherently rewrite unrelated fixtures or require a simulator/UI host).

---

## Neutral selection rule (pre-declared)

1. Enumerate every production `.swift` file under `Sources/`.
2. Apply the eligibility criteria above; record every exclusion with an **objective** reason.
3. Sort the **eligible** set **alphabetically by production file path**.
4. Select the **first** eligible path.
5. **Do not** skip the first eligible path because coverage may already be high, Human tests look strong, AI may struggle, mutations may tie, the result may be boring, or another component looks more interesting.

---

## Full inventory (alphabetical by path) and eligibility

| Production file path | LOC | Eligible? | Objective reason if excluded |
|---|---:|:---:|---|
| `Sources/InlineSnapshotTesting/AssertInlineSnapshot.swift` | 783 | **No** | (#7) Mutating this file under its human suite can rewrite test sources via SwiftSyntax inline-snapshot writeback; not reasonably isolated for repeatable mutation restore cycles. |
| `Sources/InlineSnapshotTesting/Exports.swift` | 1 | **No** | (#3/#4) Re-export only; no local logic. |
| `Sources/SnapshotTesting/AssertSnapshot.swift` | 655 | **No** | (#7/#3) Large orchestration / disk-snapshot machinery; not a focused isolated MUT surface (strategies were studied in E1–E2 instead). |
| `Sources/SnapshotTesting/Async.swift` | 42 | **No** | (#1) No dedicated human tests of `Async` itself. |
| `Sources/SnapshotTesting/Common/Internal.swift` | 11 | **No** | (#1/#4) Internal helper; no dedicated tests; insufficient surface. |
| `Sources/SnapshotTesting/Common/PlistEncoder.swift` | 2271 | **No** | (#1/#7) No focused direct suite; far too large / not isolated for this protocol. |
| `Sources/SnapshotTesting/Common/String+SpecialCharacters.swift` | 61 | **No** | (#1) No dedicated human tests; only reached via inline-snapshot helpers. |
| `Sources/SnapshotTesting/Common/View.swift` | 1157 | **No** | (#2/#5/#7) UI/layout helpers; rendering / host-dependent. |
| `Sources/SnapshotTesting/Common/XCTAttachment.swift` | 8 | **No** | (#1/#4) Tiny shim; no dedicated tests. |
| `Sources/SnapshotTesting/Diff.swift` | 131 | **No** | (#1) No direct human unit tests; LCS/`chunk` logic runs primarily on **mismatch** paths (`guard old != new`), so a passing human filter does not fairly exercise the component. |
| `Sources/SnapshotTesting/Diffing.swift` | 94 | **No** | (#1) Plumbing/type surface; no dedicated human tests. |
| `Sources/SnapshotTesting/Extensions/Wait.swift` | 31 | **No** | (#2/#4) Has `WaitTests`, but depends on wall-clock `asyncAfter` + `XCTWaiter` timing; local mutation surface is essentially duration arithmetic — insufficient for meaningful mutation testing. |
| `Sources/SnapshotTesting/Internal/Deprecations.swift` | 565 | **No** | (#3/#4) Deprecated forwarding shims; `DeprecationTests` covers a thin proxy, not dense local algorithm. |
| `Sources/SnapshotTesting/Internal/RecordIssue.swift` | 40 | **No** | (#1) No dedicated human tests. |
| `Sources/SnapshotTesting/SnapshotTestingConfiguration.swift` | 236 | **YES** | Direct human suites: `RecordTests` (8), `WithSnapshotTestingTests` (1); also related `SnapshotsTraitTests`. Deterministic config/Record/DiffTool behavior; no network; not studied in E1–E10; isolated for mutation. |
| `Sources/SnapshotTesting/SnapshotsTestTrait.swift` | 61 | **No** | *(Not evaluated as selected — listed after the first eligible.)* Thin Swift Testing trait wrapper over configuration; would be a weaker secondary if Configuration were ineligible. Excluded here as **not selected** once Configuration is chosen; independently would be borderline on (#4) thinness. |
| `Sources/SnapshotTesting/Snapshotting.swift` | 122 | **No** | (#1) Core `pullback` API exercised only indirectly; no dedicated direct suite. |
| `Sources/SnapshotTesting/Snapshotting/Any.swift` | 241 | **No** | (#6) Studied in Experiment #2. |
| `Sources/SnapshotTesting/Snapshotting/CALayer.swift` | 77 | **No** | (#2/#5/#7) Graphics / host-dependent image snapshotting. |
| `Sources/SnapshotTesting/Snapshotting/CGPath.swift` | 161 | **No** | (#2/#5/#7) Graphics / host-dependent. |
| `Sources/SnapshotTesting/Snapshotting/CaseIterable.swift` | 55 | **No** | (#4) Has `testCaseIterable`, but only a thin CSV map/join/`pathExtension` surface — insufficient branching for a meaningful mutation campaign. |
| `Sources/SnapshotTesting/Snapshotting/Data.swift` | 19 | **No** | (#4) Has `testData`, but only a few count/equality branches — insufficient mutation surface. |
| `Sources/SnapshotTesting/Snapshotting/Encodable.swift` | 78 | **No** | (#4) Thin encoder wrappers; little local branching beyond `pathExtension` / encoder setup. |
| `Sources/SnapshotTesting/Snapshotting/NSBezierPath.swift` | 113 | **No** | (#2/#5/#7) AppKit graphics. |
| `Sources/SnapshotTesting/Snapshotting/NSImage.swift` | 170 | **No** | (#2/#5/#7) AppKit image snapshotting. |
| `Sources/SnapshotTesting/Snapshotting/NSView.swift` | 74 | **No** | (#2/#5/#7) AppKit view snapshotting. |
| `Sources/SnapshotTesting/Snapshotting/NSViewController.swift` | 36 | **No** | (#2/#5/#7) AppKit. |
| `Sources/SnapshotTesting/Snapshotting/SceneKit.swift` | 58 | **No** | (#2/#5/#7) SceneKit / rendering. |
| `Sources/SnapshotTesting/Snapshotting/SpriteKit.swift` | 58 | **No** | (#2/#5/#7) SpriteKit / rendering. |
| `Sources/SnapshotTesting/Snapshotting/String.swift` | 28 | **No** | (#4) Thin `.lines` wrapper; real line-diff algorithm lives in `Diff.swift` (itself ineligible). |
| `Sources/SnapshotTesting/Snapshotting/SwiftUIView.swift` | 101 | **No** | (#2/#5/#7) SwiftUI / host-dependent. |
| `Sources/SnapshotTesting/Snapshotting/UIBezierPath.swift` | 56 | **No** | (#2/#5/#7) UIKit graphics. |
| `Sources/SnapshotTesting/Snapshotting/UIImage.swift` | 473 | **No** | (#2/#5/#7) UIKit image snapshotting. |
| `Sources/SnapshotTesting/Snapshotting/UIView.swift` | 96 | **No** | (#2/#5/#7) UIKit. |
| `Sources/SnapshotTesting/Snapshotting/UIViewController.swift` | 165 | **No** | (#2/#5/#7) UIKit. |
| `Sources/SnapshotTesting/Snapshotting/URLRequest.swift` | 130 | **No** | (#6) Studied in Experiment #1. |
| `Sources/SnapshotTestingCustomDump/CustomDump.swift` | 24 | **No** | (#4) One-line pullback to external `CustomDump`; insufficient local logic. |

### Eligible set (alphabetical)

1. **`Sources/SnapshotTesting/SnapshotTestingConfiguration.swift`**

*(Only one file satisfied all seven criteria under the objective exclusions above.)*

---

## Selection

**Selected component (first eligible alphabetically):**  
`Sources/SnapshotTesting/SnapshotTestingConfiguration.swift`

**Selection rule applied:** sort eligible paths alphabetically → take index 0.

**No skipping:** the selected file was not rejected for expected coverage, suite strength, predicted Human/AI outcome, tie risk, or “interestingness.”

### Intended frozen Human filter (to be validated in Stage 2)

```bash
swift test --filter 'RecordTests|WithSnapshotTestingTests'
```

Smoke check already run at selection time: **9 tests, 0 failures**.

Related but **out of scope** unless Stage 2 requires widening for contamination-safe coverage of the same production file only: `SnapshotsTraitTests` (Swift Testing traits). Default frozen scope prefers the XCTest config suites above.

### Focus for later stages (not yet executed)

- `withSnapshotTesting(record:diffTool:operation:)` (sync + async)
- `SnapshotTestingConfiguration.Record.init?(rawValue:)` and static cases / boolean literal bridge
- `SnapshotTestingConfiguration.DiffTool` (`ksdiff`, `default`, string-literal tool formatting, `callAsFunction`)

---

## FREEZE

Production scope for Experiment #11 is **frozen** as:

```text
Sources/SnapshotTesting/SnapshotTestingConfiguration.swift
```

Proceed to Stage 2 (Human Baseline) under Runbook v2. Do **not** replace this component because later results are a tie, weak, boring, Human-favoring, or AI-favoring.
