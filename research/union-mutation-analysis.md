# Union Mutation Effectiveness Analysis (E1–E15)

**Purpose.** Quantify Human ∪ AI mutant detection for every experiment, to give the paper's "complementary testing value" claim a numeric anchor beyond raw unique-kill counts. All counts are taken directly from each experiment's `research/experiment-N-mutation-results.md` per-mutant outcome table and bucket breakdown (Both killed / Human-only / AI-only / shared survivors), cross-checked against the corresponding `.jsonl` machine-readable results. No new mutants, tests, or executions were used; this is a re-aggregation of existing frozen results.

**Formulas** (as specified):

```
union_killed = shared_kills + human_only_kills + ai_only_kills
union_ms = union_killed / valid_mutants * 100
union_gain_over_better_single_suite = union_ms - max(human_ms, ai_ms)
```

Full per-experiment data: `research/union-mutation-analysis.csv`.

---

## Results table

| Exp. | Phase | Valid | Human MS | AI MS | Shared | Human-only | AI-only | Union killed | Union MS | Gain over better suite |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| E1 | Exploratory | 20 | 85.0% | 95.0% | 17 | 0 | 2 | 19 | 95.0% | **+0.0** |
| E2 | Exploratory | 27 | 70.4% | 85.2% | 18 | 1 | 5 | 24 | 88.9% | **+3.7** |
| E3 | Exploratory | 28 | 92.9% | 85.7% | 24 | 2 | 0 | 26 | 92.9% | +0.0 |
| E4 | Exploratory | 25 | 96.0% | 88.0% | 22 | 2 | 0 | 24 | 96.0% | +0.0 |
| E5 | Exploratory | 21 | 100.0% | 100.0% | 21 | 0 | 0 | 21 | 100.0% | +0.0 |
| E6 | Exploratory | 22 | 90.9% | 100.0% | 20 | 0 | 2 | 22 | 100.0% | +0.0 |
| E7 | Exploratory | 23 | 91.3% | 100.0% | 21 | 0 | 2 | 23 | 100.0% | +0.0 |
| E8 | Exploratory | 24 | 91.7% | 100.0% | 22 | 0 | 2 | 24 | 100.0% | +0.0 |
| E9 | Exploratory | 26 | 96.2% | 88.5% | 23 | 2 | 0 | 25 | 96.2% | +0.0 |
| E10 | Exploratory | 23 | 73.9% | 95.7% | 17 | 0 | 5 | 22 | 95.7% | +0.0 |
| E11 | Neutral-selection follow-up | 24 | 41.7% | 91.7% | 9 | 1 | 13 | 23 | 95.8% | **+4.1** |
| E12 | Neutral-selection follow-up | 22 | 90.9% | 95.5% | 20 | 0 | 1 | 21 | 95.5% | +0.0 |
| E13 | Neutral-selection follow-up | 23 | 91.3% | 100.0% | 21 | 0 | 2 | 23 | 100.0% | +0.0 |
| E14 | Neutral-selection follow-up | 22 | 68.2% | 72.7% | 13 | 2 | 3 | 18 | 81.8% | **+9.1** |
| E15 | Neutral-selection follow-up | 24 | 54.2% | 66.7% | 8 | 5 | 8 | 21 | 87.5% | **+20.8** |

---

## Reading the gain column correctly

`union_gain_over_better_single_suite` is **not** an independent signal of "complementarity" — it is a direct, deterministic function of whether an experiment has kills on **both** sides (`human_only_kills > 0` **and** `ai_only_kills > 0`) simultaneously. Algebraically: if `human_only_kills = 0`, then `union_killed = shared_kills + ai_only_kills = ai_killed` exactly, so `union_ms = ai_ms` and the gain is exactly zero (not approximately zero — a tautology of the formula, not an empirical finding). The same holds symmetrically for `ai_only_kills = 0`.

**Ten of fifteen experiments (E1, E3, E4, E5, E6, E7, E8, E9, E10, E12, E13) have a gain of exactly 0.0** because kills were one-sided (all unique kills belonged to only one suite, or one suite had no unique kills at all) in each of those cases. This is not a null result to be hidden — it means that in two-thirds of the experiments, combining the two frozen suites would not have detected any mutant that the stronger of the two suites did not already detect alone.

**Five experiments have a positive union gain**, because both suites contributed at least one unique kill each:

| Exp. | Gain (pp) | Human-only kills | AI-only kills |
|---|---:|---:|---:|
| E15 | **+20.8** | 5 | 8 |
| E14 | **+9.1** | 2 | 3 |
| E11 | **+4.1** | 1 | 13 |
| E2 | **+3.7** | 1 | 5 |
| (all others) | 0.0 | 0 or one-sided | 0 or one-sided |

Three of these five (E11, E14, E15) are neutral-selection follow-up experiments — i.e., **3 of the 5 follow-up experiments (60%)** show measurable additive value from combining suites, versus **2 of the 10 exploratory experiments (20%)**. Phrased carefully: *combining the two frozen suites would have killed additional mutants, beyond what the stronger individual suite killed alone, in 2 of 10 exploratory experiments and 3 of 5 neutral-selection follow-up experiments.* We do not interpret this rate difference causally — the follow-up sample is small (n = 5) and was not selected to test complementarity specifically.

---

## Phase-level union statistics

| Phase | Total valid mutants | Total union kills | Union MS (mutant-weighted) | Pooled AI MS | Pooled Human MS | Union gain over pooled-AI |
|---|---:|---:|---:|---:|---:|---:|
| Exploratory (E1–E10) | 239 | 230 | **96.23%** | 93.31% | 88.70% | +2.92 pp |
| Neutral-selection follow-up (E11–E15) | 115 | 106 | **92.17%** | 85.22% | 68.70% | +6.95 pp |

(Pooled/mutant-weighted single-suite scores are derived identically to `research/pooled-mutation-analysis.md`, §"Pooled scores.") At the phase level, the union of both frozen suites detects more mutants than either suite alone in both phases, and the additive margin over the better-performing single suite (AI, pooled) is larger in the follow-up phase (+6.95 pp) than the exploratory phase (+2.92 pp) — consistent with, but not proof of, the qualitative pattern in §5.7 of the paper that follow-up human filters tended to be thinner relative to production surface.

---

## Recommended framing for the paper

- Use **"additive detection value"** or **"complementary mutant detection"**, and report the exact gain figures above, rather than characterizing complementarity only via raw unique-kill counts.
- State plainly that the gain is zero in most experiments, and explain *why* algebraically (one-sided uniqueness), so the zero-gain cases are not mistaken for a coding error or a hidden negative result.
- Do not claim "causal synergy" between the two suites — a union score is a hypothetical property of the two frozen artifacts taken together; the suites were never combined, executed together, or evaluated as a merged suite in this study.
- E15's +20.8 pp gain and E11's asymmetric 1-vs-13 unique-kill split are the two most quotable, verifiable numbers for the paper's complementarity discussion; both are now traceable to `research/union-mutation-analysis.csv` and the corresponding `research/experiment-{11,15}-mutation-results.md` bucket tables.
