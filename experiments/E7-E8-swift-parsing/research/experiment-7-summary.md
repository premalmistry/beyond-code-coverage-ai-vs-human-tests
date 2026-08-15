# Experiment #7 — Summary

**Repository:** [pointfreeco/swift-parsing](https://github.com/pointfreeco/swift-parsing)  
**Pinned SHA:** `7160b25d39e4a38258a7fe71591fbe182b026d69`  
**Component:** `Sources/Parsing/ParserPrinters/Prefix.swift`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Date (UTC):** `2026-08-13`

**Production SHA-256:** `da91af08f8fcf2116542fd1d423d1e1322312a15ba135de83a4085358f4159e6`  
**AI suite SHA-256:** `a0fc2c7ab3db3346e39497e73f9804098a92ae8a41ef37188975364005255b03`  

**Human filter:** `swift test --filter ParsingTests.PrefixTests`  
**AI filter:** `swift test --filter AIGeneratedPrefixTests`  

**Domain:** Parser-specific prefix consumption / bounds / predicates / printing (new vs E1–E6).

---

## Compact results

| Metric | Human | AI |
|---|---:|---:|
| Test methods | 13 | 25 |
| Assertions (static) | 27 | 42 |
| Line coverage | 64.00% | 98.00% |
| Region coverage | 58.14% | 83.72% |
| Function coverage | 66.67% | 83.33% |
| Valid mutants | 23 | 23 |
| Mutants killed | 21 | 23 |
| Mutation score | **91.3%** | **100.0%** |
| Unique kills | 0 | **2** |

**Invalid excluded:** E7-M02 (compile self-assignment).  
**Planned mutants:** 24.

---

## Observed findings (this experiment only)

1. **Coverage:** AI much higher (98% vs 64% lines), especially on `print` guards.
2. **Mutation score:** AI **100%** vs Human **91.3%** on 23 valid mutants.
3. **Human-only kills:** none.
4. **AI-only kills:** **E7-M19** (omit print max check), **E7-M20** (omit print `allSatisfy`) — print-path defects Human did not assert.
5. **Shared valid survivors:** none.
6. **Parser domain:** Consumption/remainder/min-parse mutants were killed by both; differentiation concentrated on printer round-trip validations. Do not generalize beyond this component.

---

## Methodology (Runbook v2)

- Qualified Human filter; inventory recorded; zero `AIGenerated*` on Human runs.
- AI from production only; inventories disjoint after freeze.
- Mutations frozen before execution; contamination flags all false.
- Equivalents/invalids justified (M02 compile-only).

---

## Artifacts

| Artifact | Path |
|---|---|
| Candidate | `research/experiment-7-candidate.md` |
| Human baseline | `research/experiment-7-human-baseline.md` |
| Human coverage | `research/experiment-7-human-coverage.txt` / `-detail.txt` |
| AI baseline | `research/experiment-7-ai-baseline.md` |
| AI coverage | `research/experiment-7-ai-coverage.txt` / `-detail.txt` |
| Mutation plan | `research/experiment-7-mutation-plan.md` |
| Mutation results | `research/experiment-7-mutation-results.md` |
| Results JSONL | `research/experiment-7-mutation-results.jsonl` |
| Logs / mutants | `research/mutation-logs-e7/` / `research/mutants-e7/` |
| Runner | `research/run_e7_mutations.py` |

---

## Final integrity

| Check | Result |
|---|---|
| Production restored + SHA-256 | **PASS** |
| AI suite SHA-256 | **PASS** |
| Human PASS (13) / AI PASS (25) | **PASS** |
| Contamination | **CLEAN** |
| Suites not edited after mutation results | **PASS** |

Experiment #7 complete.
