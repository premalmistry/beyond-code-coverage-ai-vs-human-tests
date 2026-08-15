# Experiment #11 — Summary

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  

**Repository:** [pointfreeco/swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing)  
**Pinned SHA:** `59a99c458de4d2dee580529b61b4f78dca7b7fa6`  
**Component:** `Sources/SnapshotTesting/SnapshotTestingConfiguration.swift`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Date (UTC):** `2026-08-15`

**Production SHA-256:** `03b9c85eff3222eb65884df4ae5ea2f383385357e64ca3efe1bb48fd8fee1217`  
**AI suite SHA-256:** `77ec567def90a1d0c4ccfe7ba12c593098494ead8065039df0906aaecf795bf9`

**Human filter (frozen):** `swift test --filter 'RecordTests|WithSnapshotTestingTests'`  
**AI filter (frozen):** `swift test --filter AIGeneratedSnapshotTestingConfigurationTests`

**Out of scope / not reused:** `URLRequest.swift` (E1), `Any.swift` (E2).

---

## Neutral selection (pre-declared)

1. Enumerated all `Sources/**/*.swift` production files.
2. Applied seven eligibility criteria (direct human tests, deterministic, focused, meaningful mutation surface, no network, not in E1–E10, reasonably isolated).
3. Sorted the eligible set alphabetically by path.
4. Selected the **first** eligible file: `Sources/SnapshotTesting/SnapshotTestingConfiguration.swift`.

Full inventory and exclusions: `research/experiment-11-candidate-selection.md`.

The component was **not** replaced after results were observed.

---

## Compact results

| Metric | Human | AI |
|---|---:|---:|
| Test methods | 9 | 24 |
| Assertions | 28 | 42 |
| Line coverage | 57.78% | 97.78% |
| Region coverage | 41.67% | 94.44% |
| Function coverage | 56.52% | 91.30% |
| Valid mutants | 24 | 24 |
| Mutants killed | 10 | 22 |
| Mutation score | **41.7%** | **91.7%** |
| Unique kills | 1 (M14) | 13 |

---

## Observed findings (this experiment only)

- **Higher coverage:** AI (97.78% line vs 57.78%).
- **Higher mutation score:** AI (91.7% vs 41.7%).
- **Human-only mutant:** E11-M14 (`DiffTool.default` path-order swap) — Human asserts exact default string; AI only checks substring presence of both URLs.
- **AI-only mutants:** Record `rawValue` / boolean / nil-literal DiffTool / `.ksdiff` formatting / async-record ignore (M01–M04, M06–M12, M17, M21) — paths largely absent from the frozen Human filter.
- **Shared survivor:** E11-M22 (async DiffTool ignore) — not equivalent; neither frozen suite exercises the async overload with a true async closure.
- **Contamination:** CLEAN throughout.
- **Integrity:** Production and AI SHA-256 restored/verified; both frozen suites PASS after the campaign.

This confirmatory experiment favors AI on both coverage and mutation score for this neutrally selected component. That is a single-experiment observation under the pre-declared rule, not a claim about AI vs humans in general.

---

## Artifact index

| Artifact | Path |
|---|---|
| Candidate selection | `research/experiment-11-candidate-selection.md` |
| Human baseline | `research/experiment-11-human-baseline.md` |
| AI baseline | `research/experiment-11-ai-baseline.md` |
| Mutation plan | `research/experiment-11-mutation-plan.md` |
| Mutation results | `research/experiment-11-mutation-results.md` / `.jsonl` |
| Mutants | `research/mutants-e11/` |
| Logs | `research/mutation-logs-e11/` |
| Runner | `research/run_e11_mutations.py` |
| AI tests | `Tests/SnapshotTestingTests/AIGeneratedSnapshotTestingConfigurationTests.swift` |

**STOP.** Experiment #11 complete. Do not select Experiment #12 in this session.
