Reviewer Repair Change Log

Source review: `paper/conference-review-audit.md`. Source data for this repair cycle: `research/mutation-lookahead-audit.csv`/`.md`, `research/union-mutation-analysis.csv`/`.md`, `research/pooled-mutation-analysis.md`. No new experiments, tests, or mutants were run to produce any change in this log; every change is a terminology correction, a new disclosure, or a re-aggregation of already-frozen E1–E15 results. Both `paper/paper_revised.md` and `paper/paper_revised.tex` were edited to stay semantically synchronized; where a specific wording differs slightly between the two, the underlying claim and numbers are identical.

Status values used below: **RESOLVED** (the reviewer's concern is fully addressed by disclosure, re-analysis, or reframing, with no meaningful residual gap), **MITIGATED** (materially improved and honestly disclosed, but a real limitation remains that this repair cycle cannot remove without new experiments), **UNRESOLVED** (not addressed in this cycle).

---

## Top 5 Reasons to Reject

### 1. Mutation-design look-ahead bias, undisclosed in the manuscript
**Severity:** Critical

**What changed:** Audited all 369 planned mutants across E1–E15 for suite-specific outcome predictions and rationale (`research/mutation-lookahead-audit.csv`, `research/mutation-lookahead-audit.md`). Found 29 flagged mutants (7.9%), concentrated almost entirely in E2 (7/27, 25.9%) and E11 (12/24, 50.0%), with smaller traces in E3, E6, E7, E13, and no textual evidence in the other nine experiments. Added a new, first-class Threats to Validity subsection, "Mutation-Selection Look-Ahead" (§7.3 in the Markdown; `\S\ref{sec:lookahead}` in the LaTeX), stating explicitly that mutant selection was not blind to suite content, quantifying the exposure, and naming E11's mutation-score gap as the case most conditioned on this threat. Added a shorter disclosure earlier, in Methodology §4.4/`\S\ref{sec:mutdesign}`, at the point mutation design is first described, rather than leaving it only in Threats. Every place E11 or E13's gap is discussed (Results §5.5–§5.6, Discussion RQ1/RQ2/Selection-Bias-Revisited, Conclusion) now cross-references this threat.

**Where:** Abstract; Contributions (#6, new); §4.4 Mutation Design and Execution; §5.5 (Neutral-Selection Follow-Up Results intro paragraph); §5.6 (E13 paragraph); §6 RQ1, RQ2; §7.3 Mutation-Selection Look-Ahead (new, first-class subsection); §8 Conclusion.

**Remaining limitation:** The audit is based on the plan documents' own language and is a lower bound on how much suite-specific knowledge influenced mutant selection; it cannot detect unstated look-ahead that left no textual trace. The confound itself — that mutant selection in E2 and E11 was not blind to suite content — cannot be removed from the existing E1–E15 data; only a genuinely blind re-design (new experiments) could remove it, which is out of scope for this repair cycle.

**Status: MITIGATED.**

---

### 2. "Confirmatory" terminology overstates what a pre-declared (not pre-registered) rule provides
**Severity:** Major

**What changed:** Replaced "confirmatory phase" with "neutral-selection follow-up phase" everywhere it describes the study design (56 occurrences audited in the Markdown; mirrored in the LaTeX). Replaced "confirmatory replication" with "recurrence under neutral component selection" / "replication under neutral component selection." Replaced "independently reproduces" with "recurs under the same experimental infrastructure but neutral component selection" (or the shorter "recurs under neutral component selection" where space-constrained). Removed all uses of "pre-registered" to describe the internal selection rule; added an explicit distinguishing sentence at first introduction of the rule (Introduction §1 and Methodology §4.6): the rule "was pre-declared internally... before any E11 outcome was observed, but was not externally pre-registered (e.g., via a timestamped, third-party-verifiable commitment); we therefore treat it as a bias-reduction mechanism, not a formal preregistration." The one remaining use of "pre-registered" in Threats to Validity now explicitly negates it ("pre-declared, but not externally pre-registered, rule"). Filenames and CSV column names that predate this repair (e.g., `research/confirmatory-e11-e15.csv`) were left unchanged and are explicitly flagged as legacy filenames in Appendix A, since renaming frozen artifact filenames was judged out of scope for a text-only repair.

**Where:** Note at top of document; Abstract; §1 Introduction; Contributions; §4 Methodology intro and §4.6/§4.7/§4.8 headings and body; §5 Results intro and all subsection headings (§5.5–§5.7); §6 Discussion (RQ1, Selection Bias Revisited); §7.1 Component Selection; §8 Conclusion; Appendix A.2/A.3.

**Remaining limitation:** None identified — this was a terminology-only fix, fully achievable without new data, and we believe it is now consistently applied.

**Status: RESOLVED.**

---

### 3. Human baseline may be a narrowed, unrepresentative subset of the repository's actual test suite
**Severity:** Major

**What changed:** Replaced "Human suite" with "existing Human test filter" (or "selected existing Human test filter") in every methodologically load-bearing sentence in Methodology, Threats, Discussion, and Conclusion; retained informal lowercase "human suite" only in narrative Results prose and figure captions where space and readability make the longer term awkward (audited and listed explicitly in Appendix A.3, #25). Added a new Methodology subsection framing, "existing Human test filter" vs. "independently generated AI suite," stating plainly that the study does not compare human ability against AI ability under matched effort. Named the two most concrete instances of filter-narrowing directly: E11's exclusion of the related `SnapshotsTraitTests` suite from the frozen filter's default scope, and E15's exclusion of the randomized `testPolar` test to preserve determinism. Added these to §4.2/§4.8 (Methodology), §7.1/§7.2 (Threats), and the E11-specific discussion in §5.5.

**Where:** §4.2 Existing Human Test Filter; §4.3 (asymmetry framing); §4.8 (E11/E15 procedural notes); §5.5 (E11 caveat); §7.1 Component Selection; §7.2 Human-Filter Selection and AI-Generation Effort Asymmetry (new, first-class subsection); §8 Conclusion.

**Remaining limitation:** We did not re-measure coverage/mutation score with a broadened Human filter (e.g., including `SnapshotsTraitTests` for E11, or other existing repository tests that might indirectly exercise the studied components). The review notes this could be done "without writing any new tests," and we agree it is the single most valuable follow-up analysis, but we did not execute it in this cycle because it requires re-running coverage/mutation tooling against a different filter definition, which we judged to cross the line into "new analysis requiring test execution" rather than "re-aggregation of existing frozen results," and the user's instructions for this repair cycle were explicit that no new test execution should occur. We flag this as the most concrete, actionable piece of future work (see `paper/paper_revised.md` §8, Future Work).

**Status: MITIGATED.**

---

### 4. Statistical framing of the follow-up 5/5 result risks being read as stronger evidence than it is, despite disclaimers
**Severity:** Moderate

**What changed:** Reduced repetition of the raw "5/5" and "+16.1 pp" figures across the Abstract, Results, and Discussion; the Abstract no longer headlines "AI won 5/5" as its main result (the main abstract finding is now the coverage/mutation dissociation). Every remaining mention of the follow-up win count is immediately paired with the mutant-weighted pooled score and/or the look-ahead-exposure caveat, rather than standing alone with only a generic disclaimer. We deliberately did **not** add the reviewer-suggested binomial reference probability (5/5 under a null of independent 50/50 outcomes ≈ 3.1%) to the main claims, per explicit instruction in this repair cycle to avoid introducing a new statistic that could itself be read as inferential evidence; if a future revision wants to include it, it should be presented purely as an informational aside, not as support for any claim.

**Where:** Abstract; §5.5 Neutral-Selection Follow-Up Results; §6 RQ1.

**Remaining limitation:** The underlying tension the reviewer identified — a small, non-randomly-drawn win count is inherently hard to caveat without either underselling or overselling it — is a structural property of an n=5 sample and cannot be fully "resolved" by wording alone. We consider the current framing (pairing every win-count mention with the pooled score and the look-ahead caveat) a substantial improvement, not a complete resolution.

**Status: MITIGATED.**

---

### 5. Aggregate statistics mix heterogeneous, researcher-designed mutant sets as if they were commensurable
**Severity:** Moderate

**What changed:** Computed mutant-weighted pooled mutation scores for each phase separately (`research/pooled-mutation-analysis.md`): exploratory pooled Human 88.70% / AI 93.31% (+4.60 pp); follow-up pooled Human 68.70% / AI 85.22% (+16.52 pp). Removed the paired *t*-test and Wilcoxon signed-rank test from the main narrative entirely (§5.0/§5.5, mirrored in the LaTeX); the original computation is retained only in Appendix A.1 (#10) as a reproducibility record, explicitly marked as **not** used as evidence for any claim in the paper. Replaced the removed tests with descriptive statistics: experiment-weighted mean, median paired difference, paired-difference range, and the new mutant-weighted pooled score, for both phases. Added an explicit explanation of why formal inference is de-emphasized (clustering within five repositories, heterogeneous manually constructed mutant sets, non-blind mutant selection in a subset of experiments) in the new §7.7 Conclusion Validity and Statistical Treatment subsection. Did not introduce a new significance test (e.g., a binomial test) as a replacement, per instruction.

**Where:** §5.0 Exploratory Results; §5.5 Neutral-Selection Follow-Up Results; §7.7 Conclusion Validity and Statistical Treatment; Appendix A.1 #10, A.3 #27.

**Remaining limitation:** None identified relative to the reviewer's specific ask — the pooled score is now reported, and the inferential tests are removed from the main claims. A fully rigorous treatment (e.g., a mixed-effects model accounting for repository clustering) remains future work but was not requested by the reviewer as a blocking fix.

**Status: RESOLVED.**

---

## Additional issues from the Methodology Audit (not already covered above)

### §3 / §4 — "Alphabetical-first" tie-break not justified as less arbitrary than alternatives; n=5 stratification (one per repository) is not independent
**What changed:** §7.1 (Component Selection) and §4.6 now state explicitly that the follow-up sample is small (five components, one per repository), that this is a heavily stratified rather than independent sample, and that several sources of researcher discretion remain in the eligibility criteria and rule design itself. We did not add a justification for why alphabetical ordering specifically severs correlation with expected outcome beyond noting it is fixed and applied without exception; we consider this a reasonable, if not uniquely optimal, tie-break convention and did not find a compelling reason to argue it is superior to alternatives the reviewer named (first-by-file-size, first-by-test-count).

**Status: MITIGATED** (disclosed as a limitation; not eliminated).

### §6 — AI generation fairness / effort asymmetry framed only as a suite-size confound, not a basic fairness asymmetry
**What changed:** Added §7.2 (Human-Filter Selection and AI-Generation Effort Asymmetry) as a first-class Threats subsection, stating the alternative explanation nearly verbatim as instructed: "a plausible contributor to AI-favoring results is that the AI suites were freshly generated against the current implementation, were usually larger, and were iteratively repaired until passing, whereas the Human filters were historically written and not augmented for this study." This is now referenced from §4.3 (AI generation), §6 RQ1/RQ4, and §8 Conclusion, not confined to a single RQ4 sentence.

**Status: MITIGATED** (disclosed prominently; the asymmetry itself is not, and cannot be, removed from the existing data).

### §8 — Coverage claim broader than what E15 demonstrates
**What changed:** Replaced "structural code coverage alone is insufficient..." with "line, region, and function coverage, as measured by llvm-cov, are insufficient on their own to infer mutation-based fault-detection effectiveness" consistently in the Abstract, Contributions/RQ2 discussion, Results (§5.6), and Conclusion. Every mention of E15 now states precisely that line coverage misranked the suites while region and function coverage favored the higher-mutation-score suite, and explicitly says this is not "all coverage metrics failing."

**Status: RESOLVED.**

### §10 — Complementarity claim rests on raw unique-kill counts without a union mutation score
**What changed:** Computed MS(Human ∪ AI) and the gain over the better single suite for all fifteen experiments (`research/union-mutation-analysis.csv`, `research/union-mutation-analysis.md`). Added new subsections §5.4b (exploratory) and expanded §5.7 (follow-up) reporting these figures, including the null (zero-gain) result in 9 of 10 exploratory and 2 of 5 follow-up experiments. Explicitly used "additive detection value" / "complementary mutant detection" language rather than claiming causal synergy, per instruction.

**Status: RESOLVED.**

---

## Self-audit summary (mapped to the 15-point checklist)

1. Mutation-selection look-ahead clearly disclosed — yes (§7.3, first-class subsection).
2. Quantified — yes (29/369, 7.9%, with per-experiment breakdown).
3. No implication that mutant selection was blind — checked; §4.4 and §7.3 both state explicitly it was not blind in a subset of experiments.
4. Second phase no longer called externally preregistered — checked; "pre-registered" only appears negated ("not externally pre-registered").
5. "Confirmatory" terminology softened — checked; replaced with "neutral-selection follow-up" throughout prose (legacy filenames excepted and flagged).
6. Human-filter framing — checked; "existing Human test filter" used in all load-bearing methodology/threats sentences.
7. AI effort/size/freshness asymmetry acknowledged — yes (§7.2, new subsection).
8. Coverage claim narrowed — yes ("line, region, and function coverage, as measured by llvm-cov").
9. Complementarity has union-MS evidence — yes (§5.4b, §5.7, `research/union-mutation-analysis.md`).
10. Inferential statistics removed/qualified — yes; paired *t*-test/Wilcoxon removed from main text, retained only as an Appendix A.1 reproducibility record with an explicit "not used as evidence" note; no replacement significance test introduced.
11. Exploratory and follow-up phases still separate — checked; no combined win-rate or pooled-across-phases statistic anywhere.
12. Contradictory/null evidence preserved — checked; E5 (equal coverage, equal effectiveness), E12/E13 zero union gain, and E7-M24/E11-M05/E11-M22 unrealized look-ahead predictions are all still reported.
13. No claim of AI superiority — checked; Conclusion explicitly states "we explicitly do not conclude that AI-generated tests are better than human-written tests."
14. New calculations reproducible from existing artifacts — yes; all figures trace to `research/mutation-lookahead-audit.csv`, `research/union-mutation-analysis.csv`, and per-experiment `research/experiment-N-mutation-results.md` files, with no new experiment, test, or mutant run.
15. Markdown and LaTeX synchronized — checked section-by-section; both files carry the same claims, numbers, and section structure (label names differ only as required by each format).

## Recommended title (not applied)

The current title, "Beyond Code Coverage: An Empirical Comparison of AI-Generated and Human-Written Unit Tests Using Mutation Testing," does not itself use "confirmatory" or "Human suite" language, and "Human-Written Unit Tests" remains accurate — the tests genuinely are human-written; the repair's re-framing concerns which *subset* of those tests was selected as the frozen filter, not their authorship. We therefore did **not** change the title. If the authors want a title that foregrounds the filter-vs-suite distinction more explicitly, "Beyond Code Coverage: Comparing AI-Generated Tests with Existing Human Test Filters Using Mutation Analysis" (as suggested in the repair-cycle prompt) is a reasonable alternative, but we judge the current title clearly accurate enough that a change is not required.
