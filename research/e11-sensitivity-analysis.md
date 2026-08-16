# Sensitivity Analysis Excluding the Highest-Look-Ahead Experiment (E11)

**Purpose.** `research/mutation-lookahead-audit.md` finds that E11 has both the largest neutral-selection follow-up-phase mutation-score gap (+50.0 percentage points) and the highest mutation-selection look-ahead exposure in the study (12/24 mutants, 50.0%, flagged with explicit suite-content-aware predictions). This raises the question: how much of the follow-up phase's descriptive "5/5 AI-favoring" pattern depends on that single, most-exposed experiment?

This is **not a new experiment**. It is a re-aggregation of the four already-frozen E12–E15 results (`research/confirmatory-e11-e15.csv`) with E11 removed from the average. No test, mutant, or measurement is re-run or altered.

**Framing.** We call this a *sensitivity analysis excluding the highest-look-ahead experiment*, not a validation, correction, or "clean" replacement result. Excluding E11 does not resolve the look-ahead concern for the remaining four experiments (E13 in particular still has 2 flagged mutants; see `research/mutation-lookahead-audit.md` and §7.3/RQ2 discussion in the paper) — it only shows how dependent the phase-level descriptive summary is on the single most-exposed data point.

## Source data (E12–E15, from `research/confirmatory-e11-e15.csv`)

| Exp. | Valid mutants | Human killed | AI killed | Human MS | AI MS | AI − Human (pp) |
|---|---:|---:|---:|---:|---:|---:|
| E12 | 22 | 20 | 21 | 90.9% | 95.5% | +4.6 |
| E13 | 23 | 21 | 23 | 91.3% | 100.0% | +8.7 |
| E14 | 22 | 15 | 16 | 68.2% | 72.7% | +4.5 |
| E15 | 24 | 13 | 16 | 54.2% | 66.7% | +12.5 |

## Results excluding E11

- **Remaining experiments:** 4 (E12, E13, E14, E15)
- **AI-higher count:** 4 / 4
- **Human-higher count:** 0 / 4
- **Ties:** 0 / 4
- **Experiment-weighted mean Human mutation score:** (90.9 + 91.3 + 68.2 + 54.2) / 4 = **76.15%**
- **Experiment-weighted mean AI mutation score:** (95.5 + 100.0 + 72.7 + 66.7) / 4 = **83.73%**
- **Mean AI − Human difference:** (4.6 + 8.7 + 4.5 + 12.5) / 4 = **+7.58 pp**
- **Median AI − Human difference:** sorted differences [4.5, 4.6, 8.7, 12.5] → **+6.65 pp** (average of the two middle values)
- **Mutant-weighted pooled score (for consistency with `research/pooled-mutation-analysis.md`):** total valid mutants = 91; total Human kills = 69 (pooled Human MS = 75.82%); total AI kills = 76 (pooled AI MS = 83.52%); pooled difference = **+7.70 pp**

## Comparison with the full five-experiment result

| Statistic | All 5 (E11–E15) | Excluding E11 (E12–E15) | Change |
|---|---:|---:|---:|
| AI-higher count | 5/5 | 4/4 | direction unchanged |
| Mean Human MS | 69.2% | 76.15% | +6.95 pp |
| Mean AI MS | 85.3% | 83.73% | −1.57 pp |
| Mean AI − Human diff | +16.1 pp | +7.58 pp | **less than half** |
| Median AI − Human diff | +8.7 pp | +6.65 pp | −2.05 pp |
| Pooled AI − Human diff | +16.52 pp | +7.70 pp | **less than half** |

## Interpretation

The **qualitative direction does not change**: AI scores higher than the existing Human filter in all four remaining experiments (4/4), just as it did in all five (5/5) including E11. The follow-up phase's central descriptive observation — that AI suites scored numerically higher on this small, neutrally selected sample — is not solely an artifact of E11.

The **magnitude changes materially**. The mean and pooled AI-favoring gap is **less than half** as large once E11 is excluded (+16.1 pp → +7.58 pp mean; +16.52 pp → +7.70 pp pooled). E11 alone contributes roughly half of the phase's total AI-favoring "signal" as measured by the pooled gap. This is consistent with — and quantifies — the concern raised by the look-ahead audit: E11's unusually large gap coincides with its unusually high look-ahead exposure, and readers should not treat the phase-level +16.1 pp figure as representative of what a "typical" neutrally selected component shows.

We do **not** claim this sensitivity check "solves" or removes the look-ahead concern. E13, one of the four remaining experiments, still has 2 of its 23 mutants flagged with suite-content-aware rationale (`research/mutation-lookahead-audit.md`), and those 2 mutants account for E13's entire AI-favoring gap (Human 21/23, AI 23/23). The honest summary is: excluding the single most-exposed experiment roughly halves the phase's average AI-favoring gap while leaving its direction unchanged, and even the remaining four experiments are not entirely free of the same limitation, just far less affected by it than E11.
