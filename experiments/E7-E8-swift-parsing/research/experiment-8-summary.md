# Experiment #8 — Summary

**Repository:** [pointfreeco/swift-parsing](https://github.com/pointfreeco/swift-parsing)  
**Pinned SHA:** `7160b25d39e4a38258a7fe71591fbe182b026d69`  
**Component:** `Sources/Parsing/ParserPrinters/Digits.swift`  
**Swift:** Apple Swift 6.3.3  
**Date (UTC):** `2026-08-13`

**Production SHA-256:** `551333cb817917cdce03362e1949e848cd7245b9d8c1a91257407e3c531157ce`  
**AI suite SHA-256:** `f5525799b968cb0c7b43c35874b0c9843fa602dad66644be26c47858f39e888d`  

**Human filter:** `swift test --filter ParsingTests.DigitsTests`  
**AI filter:** `swift test --filter AIGeneratedDigitsTests`  

**Diversity vs E7:** Numeric digit→`Int` accumulation, overflow, zero-pad printing — **not** Prefix subsequence matching.

---

## Compact results

| Metric | Human | AI |
|---|---:|---:|
| Test methods | 2 | 25 |
| Assertions (static) | 13 | 37 |
| Line coverage | 81.82% | 95.80% |
| Region coverage | 78.26% | 89.13% |
| Function coverage | 73.33% | 86.67% |
| Valid mutants | 24 | 24 |
| Mutants killed | 22 | 24 |
| Mutation score | **91.7%** | **100.0%** |
| Unique kills | 0 | **2** |

**Planned mutants:** 24 (none excluded).

---

## Observed findings (this experiment only)

1. **Coverage:** AI higher on all three metrics (overflow + negative print paths).
2. **Mutation score:** AI **100%** vs Human **91.7%**.
3. **Human-only:** none.
4. **AI-only:** **E8-M18** (exact print max boundary), **E8-M24** (negative print).
5. **Shared valid survivors:** none.
6. Do **not** generalize beyond this Digits component.

---

## Methodology (Runbook v2)

Qualified Human filter; inventory recorded; zero `AIGenerated*` (incl. E7 Prefix AI suite). AI from production only; inventories disjoint; mutations frozen pre-execution; contamination flags all false.

---

## Artifacts

| Artifact | Path |
|---|---|
| Candidate | `research/experiment-8-candidate.md` |
| Human / AI baselines | `research/experiment-8-human-baseline.md`, `…-ai-baseline.md` |
| Coverage | `research/experiment-8-*-coverage*.txt` |
| Mutation plan / results | `research/experiment-8-mutation-plan.md`, `…-results.md`, `…-results.jsonl` |
| Logs / mutants / runner | `research/mutation-logs-e8/`, `research/mutants-e8/`, `research/run_e8_mutations.py` |

---

## Final integrity

| Check | Result |
|---|---|
| Production restored + SHA-256 | **PASS** |
| AI SHA-256 | **PASS** |
| Human PASS (2) / AI PASS (25) | **PASS** |
| Contamination | **CLEAN** |

Experiment #8 complete.
