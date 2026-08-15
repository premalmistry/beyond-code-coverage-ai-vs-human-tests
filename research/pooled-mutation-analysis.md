# Pooled (Mutant-Weighted) Mutation Score Analysis

**Purpose.** The paper's existing summary statistics (mean mutation score across experiments) weight every experiment equally regardless of how many mutants it contains. Because mutant-set sizes range from 20 to 28 across the study, this section computes an alternative, **mutant-weighted pooled** score for each phase, and explains precisely how it differs from the existing **experiment-weighted mean**. Both are retained; they are not combined into one preferred figure, and the two phases are kept separate.

All per-experiment valid-mutant, Human-killed, and AI-killed counts are taken from the same source artifacts underlying `research/union-mutation-analysis.csv` (each experiment's `research/experiment-N-mutation-results.md`).

---

## What the two statistics measure

- **Experiment-weighted mean mutation score** = the arithmetic mean of the *per-experiment percentages*. Every experiment counts equally toward the average, regardless of how many mutants (20 vs. 28) it was scored against. This is what the paper currently reports in §5.0 and §5.5 (Tables 2 and 4).
- **Mutant-weighted pooled mutation score** = `(sum of killed mutants across all experiments in the phase) / (sum of valid mutants across all experiments in the phase) × 100`. Every individual mutant counts equally, so an experiment with 28 mutants contributes more to the pooled score than one with 20.

Neither statistic is "more correct" in an absolute sense; they answer different questions. The experiment-weighted mean answers *"on a typical experiment in this sample, which suite scores higher, on average?"* The mutant-weighted pooled score answers *"across all individually designed mutants in this phase, pooled together, what fraction did each suite kill?"* Because the underlying mutant sets were manually designed per-component rather than sampled from a common instrument, neither answers the question "how would this generalize to a randomly drawn mutant," and both remain descriptive.

---

## Exploratory phase (E1–E10)

| Exp. | Valid mutants | Human killed | AI killed |
|---|---:|---:|---:|
| E1 | 20 | 17 | 19 |
| E2 | 27 | 19 | 23 |
| E3 | 28 | 26 | 24 |
| E4 | 25 | 24 | 22 |
| E5 | 21 | 21 | 21 |
| E6 | 22 | 20 | 22 |
| E7 | 23 | 21 | 23 |
| E8 | 24 | 22 | 24 |
| E9 | 26 | 25 | 23 |
| E10 | 23 | 17 | 22 |
| **Total** | **239** | **212** | **223** |

- **Pooled Human MS** = 212 / 239 = **88.70%**
- **Pooled AI MS** = 223 / 239 = **93.31%**
- **Pooled AI − Human** = **+4.60 pp**

Compare to the existing **experiment-weighted** means already in the paper (§5.0): mean Human = 88.83%, mean AI = 93.81%, difference = +4.98 pp.

**Reading:** the two statistics are close (88.70% vs. 88.83%; 93.31% vs. 93.81%) because exploratory mutant-set sizes (20–28) are moderately uniform and not strongly correlated with which suite tends to win. The pooled and experiment-weighted views tell essentially the same story for this phase.

## Neutral-selection follow-up phase (E11–E15)

| Exp. | Valid mutants | Human killed | AI killed |
|---|---:|---:|---:|
| E11 | 24 | 10 | 22 |
| E12 | 22 | 20 | 21 |
| E13 | 23 | 21 | 23 |
| E14 | 22 | 15 | 16 |
| E15 | 24 | 13 | 16 |
| **Total** | **115** | **79** | **98** |

- **Pooled Human MS** = 79 / 115 = **68.70%**
- **Pooled AI MS** = 98 / 115 = **85.22%**
- **Pooled AI − Human** = **+16.52 pp**

Compare to the existing **experiment-weighted** means already in the paper (§5.5): mean Human = 69.2%, mean AI = 85.3%, difference = +16.1 pp.

**Reading:** again the two statistics are close (68.70% vs. 69.2%; 85.22% vs. 85.3%) because the five follow-up mutant sets are similarly sized (22–24). The pooled view does not change the qualitative picture for this phase either, but it is reported here because it is the more defensible aggregate when mutant-set sizes differ, and because §9 of the repair plan recommends reporting it alongside the mean rather than relying on inferential statistics computed on the experiment-weighted percentages alone.

---

## Why we do not pool the two phases into one statistic

Exploratory and neutral-selection follow-up mutants were designed under different selection protocols (component-selection criteria differed; see `paper/paper_revised.md` §4.1 vs. §4.6) and, per `research/mutation-lookahead-audit.md`, carry different levels of suite-specific look-ahead exposure (E1–E10 combined: 12/239 flagged mutants, 5.0%; E11–E15 combined: 14/115 flagged mutants, 12.2%, driven almost entirely by E11). Pooling 239 exploratory and 115 follow-up mutants into one 354-mutant statistic would treat these as a single homogeneous instrument, which they are not, and would obscure the phase-separation this study is designed to preserve. We therefore report the two pooled scores side by side, never combined.

## Summary

| Phase | Pooled Human MS | Pooled AI MS | Pooled Δ | Experiment-weighted mean Human | Experiment-weighted mean AI | Experiment-weighted Δ |
|---|---:|---:|---:|---:|---:|---:|
| Exploratory (E1–E10) | 88.70% | 93.31% | +4.60 pp | 88.83% | 93.81% | +4.98 pp |
| Neutral-selection follow-up (E11–E15) | 68.70% | 85.22% | +16.52 pp | 69.2% | 85.3% | +16.1 pp |

In both phases, the mutant-weighted pooled score and the experiment-weighted mean point in the same direction and are within ~0.5 pp of each other, so switching between the two views does not change any qualitative conclusion in the paper — but the pooled score is the more defensible number to report given that mutant-set sizes vary, and it is now available as a cross-check.
