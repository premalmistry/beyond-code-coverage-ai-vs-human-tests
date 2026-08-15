# Mutation-Selection Look-Ahead Audit (E1–E15)

**Purpose.** The adversarial review (`paper/conference-review-audit.md`, Reason to Reject #1) found that several mutation plans contain explicit per-suite outcome predictions, some with rationale that names specific suite content (e.g., "Human may not call rawValue," "Human uses .ksdiff"). This document audits **all fifteen** mutation-plan artifacts (`research/experiment-N-mutation-plan.md`, one per repository's `research/` directory) to quantify how widespread this is, without inferring intent beyond what the artifact text states.

**Method.** Every mutation-plan table for E1–E15 was read in full. For each experiment we counted:
- total planned mutants (the frozen set actually executed, not withdrawn "optional extra" mutants);
- mutants whose plan row contains an explicit **Human**-outcome prediction (a "Human pred./Human expected/H pred" column value, or equivalent);
- mutants whose plan row contains an explicit **AI**-outcome prediction (the AI-side equivalent column);
- mutants whose prediction is accompanied by **suite-specific rationale** — natural-language text that names a specific behavior, API, or gap in one suite's known content (e.g., "human dict has 3 keys," "Human may not call rawValue," "no enum dumps in human filter") rather than a generic "Both kill";
- mutants with **no** suite-specific rationale at all (uniform "Both kill" / no prediction column present).

We use the wording **"mutation selection was informed by suite-specific knowledge"** rather than **"biased toward AI"** throughout, except where noted, because intent to favor a side is not verifiable from the artifacts; what is verifiable is that the mutant designer had, and used, specific knowledge of each frozen suite's content when drafting predictions and framing several mutants (e.g., E2's up-front "Human suite gaps" narrative, E11's rawValue/async-coverage footnotes, E13's `underestimatedCount`-themed mutant names).

---

## Per-experiment summary

| Exp. | Phase | Total planned mutants | Mutants w/ explicit Human pred. column | Mutants w/ explicit AI pred. column | Mutants w/ suite-specific rationale (flagged) | Flagged / total | No suite-specific rationale |
|---|---|---:|---:|---:|---:|---:|---:|
| E1 | Exploratory | 20 | 20 | 0† | 0 | 0.0% | 20 |
| E2 | Exploratory | 27 | 27 | 27 | 7 | 25.9% | 20 |
| E3 | Exploratory | 28 | 28 | 28 | 3 | 10.7% | 25 |
| E4 | Exploratory | 26 | 26 | 26 | 0 | 0.0% | 26 |
| E5 | Exploratory | 26 | 26 | 26 | 0 | 0.0% | 26 |
| E6 | Exploratory | 26 | 26 | 26 | 2 | 7.7% | 24 |
| E7 | Exploratory | 24 | 24 | 24 | 2 | 8.3% | 22 |
| E8 | Exploratory | 24 | 0‡ | 0‡ | 1 | 4.2% | 23 |
| E9 | Exploratory | 26 | 0 | 0 | 0 | 0.0% | 26 |
| E10 | Exploratory | 24 | 0 | 0 | 0 | 0.0% | 24 |
| E11 | Follow-up | 24 | 24 | 24 | 12 | 50.0% | 12 |
| E12 | Follow-up | 24 | 24 | 24 | 0 | 0.0% | 24 |
| E13 | Follow-up | 24 | 24 | 24 | 2 | 8.3% | 22 |
| E14 | Follow-up | 22 | 0 | 0 | 0 | 0.0% | 22 |
| E15 | Follow-up | 24 | 0 | 0 | 0 | 0.0% | 24 |
| **Total** | | **369** | **249** | **248** | **29** | **7.9%** | **340** |

† E1's plan predates AI-suite generation (its own text states this was a "tonight: plan + human baseline only... AI test generation not started" document); the single prediction column is Human-only and could not, by construction, encode AI-suite-specific knowledge. The frozen mutant list (M01–M20) was carried forward unmodified after the AI suite was later generated and frozen — i.e., mutants were not re-selected with AI-suite knowledge.

‡ E8's plan has no per-suite prediction columns at all; a single free-text "Risk" column is present, empty for all but one row.

**Key finding: exposure is highly concentrated, not uniform.** Seven of fifteen experiments (E1, E4, E5, E9, E10, E12, E14, E15 — spanning both phases) have **zero** flagged mutants: their plans either omit per-suite prediction columns entirely (E1, E9, E10, E14, E15) or contain only uniform "Both kill" predictions with no suite-differentiated rationale (E4, E5, E12). Two experiments — **E2 (7/27, 25.9%)** and especially **E11 (12/24, 50.0%)** — account for 19 of the 29 flagged mutants study-wide. E11's frozen human baseline document (`research/experiment-11-human-baseline.md`) independently records the same "no async coverage" and "does not call `rawValue`" gaps the mutation plan later cites, confirming the mutant designer had specific, itemized knowledge of the frozen Human suite's uncovered behavior before selecting which mutants to include.

---

## What the flagged mutants show, precisely

1. **Suite-differentiated predictions that were subsequently realized as AI-only kills.** In E6 (M21, M26), E7 (M19), E11 (9 of its 12 flagged mutants), and E13 (M03, M20), the plan explicitly predicted "Human survives / AI kills" with rationale naming a specific Human-suite gap, and the actual mutation-execution results matched that prediction exactly. This is the clearest, most verifiable form of look-ahead: the predicted asymmetry and the observed asymmetry coincide for these 15 specific mutants across 4 experiments.
2. **Suite-differentiated predictions that were *not* realized.** E7-M24 predicted "Human possibly survives" but the actual result was Both-killed; E11-M05 and E11-M22 predicted outcomes ("kill" for Human on M05, "kill" for AI on M22) that did not hold. This shows the mutant designer's suite-specific knowledge did not translate into perfectly reliable foresight — the predictions were informed guesses, not guaranteed outcomes, and some were wrong in both directions (i.e., not exclusively wrong in a way that would suggest one-sided favoritism).
3. **Experiments with explicit design narrative referencing suite content, independent of individual mutant flags.** E2's plan opens with an itemized "Human suite gaps (from prior baseline): no dedicated enum dumps, no `renderChildren == true` custom types, no empty-collection roots, no direct `purgePointers` unit tests..." paragraph, and E3's plan states outright that "Predictions are a priori, based on suite scope from the baselines." This confirms the design-level awareness the review flagged, even where individual per-mutant rationale is terse.
4. **Experiments with no evidence of look-ahead in the plan text.** E9, E10, E14, and E15's plans contain no prediction columns and no suite-content-referencing language at all — mutants are described purely in terms of the production defect they introduce, with no reference to either frozen suite. E4, E5, and E12 have prediction columns but only ever record identical, non-differentiated predictions ("Both kill" for essentially every mutant), and in E12 the one mutant that actually produced an asymmetric outcome (E12-M06, an AI-only kill) was *not* among those flagged with differentiated predictions — i.e., the plan's foresight failed to anticipate the one asymmetry that occurred. This is direct evidence that suite-aware mutant design was not applied uniformly across the study, and in at least one confirmatory experiment (E12) it did not anticipate the actual asymmetry at all.

---

## Interpretation and scope of the claim

- We do **not** claim mutation selection was designed "to favor AI" as a general matter across the study. The evidence supports a narrower, verifiable claim: **in a minority of experiments (most concentrated in E2 and E11, present to a lesser degree in E3, E6, E7, and E13), specific mutants were selected and predicted with knowledge of what a specific frozen suite's tests do or do not call/assert**, and in most of those specific cases the predicted asymmetry matched the observed one.
- We do **not** claim this invalidates every mutation-score gap in the paper. E1, E4, E5, E9, E10, E12, E14, and E15 — including four of the five confirmatory/follow-up experiments' comparisons on their majority mutants, and the entirety of E9's and E10's plans — show no textual evidence of suite-differentiated foreknowledge influencing mutant selection.
- E11 is the single largest concentration of this threat and is also the experiment with the largest mutation-score gap in the paper (+50.0 percentage points, Human 41.7% vs. AI 91.7%). Because half of E11's mutant set was explicitly selected and predicted using itemized knowledge of the Human suite's uncovered behavior, **E11's mutation-score gap should be read as conditional on a mutant set that was not selected blind to the Human suite's content**, and readers should weight it accordingly relative to experiments (e.g., E9, E10, E14, E15) where no such textual evidence exists.
- This audit is based on the *plan documents' own language*; it cannot rule out unstated look-ahead that leaves no textual trace (e.g., a designer who mentally reviewed suite content but wrote a generic "Both kill" prediction anyway). The counts above are therefore a **lower bound** on how much suite-specific knowledge influenced mutant selection, not an exhaustive measure.

---

## Source artifacts consulted

`experiments/E1-E2-swift-snapshot-testing/research/experiment-plan.md`, `experiment-2-mutation-plan.md`; `experiments/E3-E4-swift-collections/research/experiment-3-mutation-plan.md`, `experiment-4-mutation-plan.md`; `experiments/E5-E6-swift-algorithms/research/experiment-5-mutation-plan.md`, `experiment-6-mutation-plan.md`; `experiments/E7-E8-swift-parsing/research/experiment-7-mutation-plan.md`, `experiment-8-mutation-plan.md`; `experiments/E9-E10-swift-numerics/research/experiment-9-mutation-plan.md`, `experiment-10-mutation-plan.md`; `swift-snapshot-testing/research/experiment-11-mutation-plan.md`; `swift-collections/research/experiment-12-mutation-plan.md`; `swift-algorithms/research/experiment-13-mutation-plan.md`; `swift-parsing/research/experiment-14-mutation-plan.md`; `swift-numerics/research/experiment-15-mutation-plan.md`; cross-checked against the corresponding `research/experiment-N-mutation-results.md` per-mutant outcome tables for realization/non-realization of each flagged prediction.
