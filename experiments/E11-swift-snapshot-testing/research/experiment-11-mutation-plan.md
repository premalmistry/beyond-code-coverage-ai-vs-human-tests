# Experiment #11 — Mutation Plan (FROZEN)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/SnapshotTesting/SnapshotTestingConfiguration.swift`  
**Repo SHA:** `59a99c458de4d2dee580529b61b4f78dca7b7fa6`  
**Production SHA-256:** `03b9c85eff3222eb65884df4ae5ea2f383385357e64ca3efe1bb48fd8fee1217`  
**AI suite SHA-256:** `77ec567def90a1d0c4ccfe7ba12c593098494ead8065039df0906aaecf795bf9`  
**Plan date (UTC):** `2026-08-15T15:32:00Z`

Both Human and AI suites are **frozen**. This plan was defined **after** suite freeze and **before** any mutant execution.

Mutant sources: `research/mutants-e11/E11-MXX.swift` (24 files).

---

## Design principles

- Realistic defects in Record parsing, DiffTool formatting, configuration assignment, and `withSnapshotTesting` argument application.
- No comment-only / rename-only / guaranteed-compile-error mutants.
- Not designed after inspecting suite-specific weaknesses to favor either side.
- Target ~20–30; quality over padding → **24** mutants.

---

## Frozen mutant set

| ID | Location / theme | Original → Mutation | Expected defect | Human pred. | AI pred. | Risk |
|---|---|---|---|---|---|---|
| E11-M01 | Record rawValue `"all"` | storage `.all` → `.failed` | wrong Record for `"all"` | survive* | kill | *Human may not call rawValue |
| E11-M02 | Record rawValue `"failed"` | storage `.failed` → `.all` | wrong Record for `"failed"` | survive* | kill | |
| E11-M03 | Record rawValue `"missing"` | storage `.missing` → `.never` | wrong Record for `"missing"` | survive* | kill | |
| E11-M04 | Record rawValue `"never"` | storage `.never` → `.missing` | wrong Record for `"never"` | survive* | kill | |
| E11-M05 | Record rawValue default | `return nil` → `return .all` | invalid strings become `.all` | survive* | kill | |
| E11-M06 | Record rawValue `"all"` match | `"all"` → `"All"` | lowercase `"all"` no longer matches | survive* | kill | |
| E11-M07 | Record bool literal | `true→.all` → always `.missing` | `true` ≠ `.all` | survive* | kill | |
| E11-M08 | Record bool literal | `false→.missing` → always `.all` | `false` ≠ `.missing` | survive* | kill | |
| E11-M09 | Record bool literal | polarity inverted | true/false swapped | survive* | kill | |
| E11-M10 | DiffTool.ksdiff | drop path quotes | command string changes | kill | kill | Human uses `.ksdiff` |
| E11-M11 | DiffTool.ksdiff | swap path order | command string changes | kill | kill | |
| E11-M12 | DiffTool.ksdiff | `ksdiff` → `opendiff` | command string changes | kill | kill | |
| E11-M13 | DiffTool.default | drop `file://` | default help text changes | kill | kill | Human asserts default text |
| E11-M14 | DiffTool.default | swap file paths | default help text changes | kill | kill | |
| E11-M15 | DiffTool stringLiteral | swap path order | `"tool a b"` → `"tool b a"` | kill | kill | |
| E11-M16 | DiffTool stringLiteral | omit tool name | `"tool a b"` → `"a b"` | kill | kill | |
| E11-M17 | DiffTool nilLiteral | `.default` → `.ksdiff` | `nil` DiffTool ≠ default | survive* | kill | *Human may not use nil literal |
| E11-M18 | Configuration.init | `diffTool = diffTool` → `nil` | stored diffTool always nil | kill | kill | |
| E11-M19 | sync withSnapshotTesting | ignore explicit `record:` | nested/explicit record ignored | kill | kill | |
| E11-M20 | sync withSnapshotTesting | ignore explicit `diffTool:` | explicit diffTool ignored | kill | kill | |
| E11-M21 | async withSnapshotTesting | ignore explicit `record:` | async record ignored | survive* | kill | *Human has no async coverage |
| E11-M22 | async withSnapshotTesting | ignore explicit `diffTool:` | async diffTool ignored | survive* | kill | |
| E11-M23 | DiffTool.default help | `withSnapshotTesting` → `assertSnapshot` | help text changes | kill | kill | |
| E11-M24 | Record static `.all` | storage `.all` → `.never` | `.all == .never` | kill | kill | Broad equality impact |

\* “survive*” = prediction that Human suite may not exercise that path under the frozen filter; not a claim of equivalence.

---

## Execution protocol (frozen)

```text
Human filter: RecordTests|WithSnapshotTestingTests
AI filter:    AIGeneratedSnapshotTestingConfigurationTests
Timeout:      60 seconds per suite run
Order:        For each mutant — Human then AI (same mutant bytes)
Restore:      ORIG between mutants; re-verify production SHA-256
```

Contamination: every Human run must execute zero `AIGenerated*` tests.

---

## FREEZE

Mutation set **frozen**. Do not add/remove/alter mutants after seeing execution results.
