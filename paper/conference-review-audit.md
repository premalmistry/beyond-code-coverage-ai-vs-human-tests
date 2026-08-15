# Conference Review Audit — "Beyond Code Coverage: An Empirical Comparison of AI-Generated and Human-Written Unit Tests Using Mutation Testing"

**Manuscript reviewed:** `paper/paper_revised.md` (current revision: E1–E15, exploratory + confirmatory phases)
**Review stance:** Adversarial by design. This is a skeptical-reviewer audit whose job is to find legitimate grounds for rejection, not to be encouraging. No new experiments, mutants, or tests were run to produce this review; all findings are grounded in the manuscript text and the underlying artifacts already in the repository (candidate-selection records, human/AI baselines, mutation plans).

---

# Reviewer Summary

This paper compares human-written and independently AI-generated unit tests via mutation testing across fifteen paired experiments (ten exploratory, five "confirmatory") on five Swift repositories. The central claim — coverage does not imply mutation-based fault-detection effectiveness — is well supported by the paper's own case studies (E3/E4/E9, E13/E15/E14) but is not new to the literature (Inozemtseva & Holmes 2014; Zhao et al. 2026). The paper's most serious weakness is not disclosed anywhere in the manuscript: inspection of the underlying mutation-plan artifacts (e.g., `research/experiment-{3,7,11,12,13}-mutation-plan.md`) shows that mutants were routinely designed with explicit per-suite "Human pred./AI pred." annotations, several referencing specific human-suite content ("Human may not call rawValue," "Human uses .ksdiff," predictions stated to be "based on suite scope from the baselines"). This directly contradicts the design principle stated in-artifact ("not designed after inspecting suite-specific weaknesses to favor either side") and undermines the causal interpretation of every mutation-score gap in the paper. Combined with narrow, researcher-selected human test filters, a single-annotator/single-model/single-repository-set design, and a "confirmatory" phase that is pre-declared but not externally pre-registered, the empirical foundation is weaker than the polished presentation suggests. The paper is well-organized and unusually transparent about its own limitations, but transparency about *some* limitations does not offset an undisclosed, verifiable threat to the central comparison.

---

# Overall Recommendation

**Score: 2 = Reject**
**Confidence: 4 / 5**

---

# Scores

| Dimension | Score (1–5) |
|---|---|
| Novelty | 2 |
| Technical soundness | 2 |
| Empirical rigor | 2 |
| Reproducibility | 3 |
| Presentation | 2 |
| Significance | 2 |

---

# Top 5 Reasons to Reject

## 1. Mutation-design look-ahead bias, undisclosed in the manuscript
**Severity:** Critical
**Concern:** The manuscript states mutation plans were "defined only after both suites were frozen" (§4.4) and, for the confirmatory phase, explicitly asserts mutants were "not designed after inspecting suite-specific weaknesses to favor either side" (design-principle line repeated verbatim in `research/experiment-{11,12,13}-mutation-plan.md`). But the artifacts contradict this: E3's plan states outright that "Predictions are a priori, based on suite scope from the baselines" and gives per-mutant "Human expected / AI expected" columns with rationale like "AI may SURVIVE if it only checks numeric multiset / min/max values." E7's plan flags M19/M24 as "Human may miss" / "Human has dedicated test." E11's plan flags roughly half its 24 mutants "survive*" for Human specifically because "Human may not call rawValue," "Human uses .ksdiff," "Human has no async coverage." E13 does the same for two `underestimatedCount` mutants. This means the same person who wrote the AI-generation prompts also inspected each suite's specific coverage/behavior *before* selecting which behaviors to mutate, and used that knowledge to select mutants predicted to differentiate the suites — sometimes explicitly in AI's favor. Freezing suite *content* before mutation does not neutralize this if the mutant designer already knows that content in detail when choosing mutants. This is a look-ahead / experimenter-degrees-of-freedom problem that is real, verifiable in the linked artifacts, and never mentioned in the paper's Threats to Validity, which frames the single-annotator issue only as an *equivalence-adjudication* threat, not a *mutant-selection* threat.
**Why it matters:** If mutant selection is informed by known suite gaps, every mutation-score gap in the paper (especially the E11 41.7% vs. 91.7% split and the exploratory dissociation cases) is confounded with the researcher's own knowledge of what each suite does and doesn't test, rather than being an unbiased instrument applied blindly to both suites.
**Fixable without new experiments? NO** (for the existing evidence) / **Partially YES** for the write-up: the paper can and must disclose this threat honestly, re-audit which specific mutants were annotated with suite-specific rationale, and qualify claims accordingly; but removing the confound itself would require a genuinely blind mutation design (new experiments), which is out of scope here.
**Exact recommended fix:** Add a new, explicit Threats to Validity item ("mutant-selection look-ahead") citing the "Human pred./AI pred." columns as artifact evidence; quantify how many mutants per experiment were annotated with suite-specific rationale (e.g., "~12/24 in E11, 2/24 in E13, X/28 in E3, 2/24 in E7"); and soften every "coverage/mutation dissociation" claim to note that the specific mutants that create the gap were partly selected with knowledge of suite content, not chosen blind to it.

## 2. "Confirmatory" terminology overstates what a pre-declared (not pre-registered) rule provides
**Severity:** Major
**Concern:** The paper repeatedly uses "confirmatory phase," "confirmatory replication," and "independently reproduced" (§4.6, §5.6, §6, §8). But the selection rule was declared internally, by the same researchers, in the same repository, without an external timestamp, registry, or third party — it is *pre-declared*, not *pre-registered* in the sense the term carries in confirmatory research (e.g., OSF pre-registration, a public commit before data collection with independent verifiability of the *timestamp*). The paper's own Threats section admits the eligibility criteria are "researcher-designed" and the repositories are inherited, unchanged, from the exploratory phase — yet the discussion and conclusion still use "independently reproduces" (§5.6, "E13 independently reproduces...") to describe a same-team, same-tooling, same-repository-set result.
**Why it matters:** A reviewer will read "confirmatory" and "independently reproduced" as claims of a materially stronger evidentiary standard than what was actually done. This is exactly the kind of terminology inflation that experienced reviewers are primed to catch, and it invites a credibility challenge to the rest of the paper's careful hedging.
**Fixable without new experiments? YES.**
**Exact recommended fix:** Replace "confirmatory phase" with "second-round," "follow-up," or "neutral-selection phase" throughout; replace "independently reproduces" with "replicates under the same infrastructure" or "recurs under neutral selection"; add one sentence explicitly distinguishing "pre-declared" from "pre-registered" the first time the rule is introduced (§4.6), rather than only in the Threats section.

## 3. Human baseline may be a narrowed, unrepresentative subset of the repository's actual test suite
**Severity:** Major
**Concern:** The "Human suite" in every experiment is a *researcher-selected filter* over pre-existing tests, not the full repository test suite for that file. The E11 candidate-selection record explicitly notes a related suite (`SnapshotsTraitTests`) was available but excluded from the frozen filter ("Related but out of scope unless Stage 2 requires widening… Default frozen scope prefers the XCTest config suites above"), and the E11 human baseline scores only 41.7% mutation score against a 24-mutant set roughly half of which were pre-annotated as human-unfavorable. The paper never asks whether tests elsewhere in the repository (integration tests, other files' unit tests) indirectly exercise the selected component and would raise the "true" human coverage/mutation score if included. The title and abstract say "AI-Generated and Human-Written Unit Tests" / "AI suite" vs. "human suite," which reads as a suite-vs-suite comparison, when the more precise framing is "a freshly generated, comprehensive AI suite vs. a researcher-selected filter over a pre-existing, historically-written test suite."
**Why it matters:** If the human filter is narrower than the tests the repository's own maintainers would consider "the tests for this component," the comparison systematically disadvantages the human suite in a way that has nothing to do with human vs. AI test-writing ability — it is an artifact of the filtering methodology.
**Fixable without new experiments? YES** (via re-framing and additional disclosure) — **NO** for a definitive answer to "would broader Human filters change the scores," which would require re-running coverage/mutation (a new analysis on already-frozen artifacts, not a new experiment, could partially address this if broader existing tests are re-measured without new test writing — see Missing Analyses).
**Exact recommended fix:** (a) Rename "Human suite" to "selected Human test filter" or "existing Human test filter" in the title, abstract, and throughout; (b) add an explicit Threats item: "the Human baseline is a researcher-selected filter, not necessarily the full set of existing tests that exercise the component; broader existing suites might raise Human mutation scores in some experiments (e.g., E11)"; (c) report, for at least the lowest-scoring Human baselines (E11, E14), whether any *other already-existing* test file in the repository exercises the same production component and what its mutation contribution would be, without writing any new tests.

## 4. Statistical framing of the confirmatory 5/5 result risks being read as stronger evidence than it is, despite disclaimers
**Severity:** Moderate
**Concern:** The paper is commendably explicit that n=5 confirmatory wins should not be treated as a significance test, and it avoids computing one. But the abstract, results (§5.5), and discussion (§6 RQ1) still foreground "AI achieved the higher mutation score in all five" and "+16.1 percentage points" prominently, multiple times, immediately followed by a disclaimer. Repetition of a headline number even with a disclaimer is a known way that a "descriptive, not significant" framing still functions rhetorically as evidence of a trend to a skimming reader. A skeptical reviewer will note that with n=5 and a mutation-design process shown (Reason #1) to sometimes favor AI by construction, a 5/5 sweep is not surprising and provides very weak evidence of anything beyond "the researchers' own mutant choices, applied to suites of very different size and freshness, produced this pattern in this small sample."
**Why it matters:** Reviewers evaluate the gap between how strongly a result is stated and how much evidence actually supports it; repeated emphasis of "5/5" without a matching emphasis on effect-size uncertainty (e.g., a binomial reference: 5/5 wins under a null of p=0.5 has probability 1/32 ≈ 3.1%, not overwhelming) reads as advocacy dressed as caution.
**Why it matters (cont.):** This compounds with Reasons #1 and #3 — the 5/5 result is being used as the paper's second-most-prominent finding while resting on the least statistically supportable evidence in the paper.
**Fixable without new experiments? YES.**
**Exact recommended fix:** State the exact binomial probability of 5/5 under a null of independent, unbiased 50/50 outcomes (informational only, not a claim of population inference) alongside every mention of "5/5," and reduce the number of times the raw "5/5"/"+16.1 pp" figures are repeated verbatim across Abstract, §5.5, §6 RQ1, and §8 (currently at least 4 near-identical restatements).

## 5. Aggregate statistics mix heterogeneous, researcher-designed mutant sets as if they were commensurable
**Severity:** Moderate
**Concern:** The paired t-test and Wilcoxon test in §5.0 treat ten mutation-score percentages as directly comparable paired observations, but each experiment's mutant set (21–28 mutants) was manually designed by the same person for a different component, with different operators, different "realistic defect" judgment calls, and (per Reason #1) sometimes informed by suite-specific foreknowledge. A mutation score of 91.3% on a 23-mutant hand-picked set is not statistically equivalent in meaning to 91.3% on a 28-mutant hand-picked set from a different file. The paper acknowledges heterogeneity narratively ("heterogeneous mutant sets of different sizes") but still reports the parametric/non-parametric tests as if percentage-scale scores were a valid common unit for a paired test, and does not report a mutant-weighted alternative (e.g., pooled kills/pooled valid mutants) alongside the experiment-weighted mean, despite the review's suggestion that both should be reported when mutant-set sizes vary this much.
**Why it matters:** Presenting inferential statistics (even while immediately disclaiming them) on a nested, researcher-generated, heterogeneous-instrument dataset invites exactly the kind of "why compute a p-value here at all" objection reviewers raise when a test's assumptions (independence, commensurable measurement) are visibly violated.
**Fixable without new experiments? YES** (recompute from existing per-experiment kill/valid-mutant counts, which are already in the CSV/JSONL artifacts).
**Exact recommended fix:** Add a mutant-weighted (pooled) mutation score across all valid mutants per phase, next to the existing experiment-weighted mean, and either (a) remove the paired t-test/Wilcoxon entirely and replace with purely descriptive reporting, or (b) keep them but add one sentence explicitly stating why a percentage-scale paired test is being used despite non-commensurable denominators, rather than only noting non-independence.

---

# Top 5 Strengths

1. **Genuine methodological transparency and artifact discipline.** SHA-256 fingerprinting of both frozen suites, repository SHA pinning, contamination checks with named executed-test inventories, and machine-readable JSONL mutation results are present for all fifteen experiments — this is above the norm for this literature and materially aids reproducibility.
2. **The core coverage/mutation dissociation cases (E3, E4, E9, E13) are concrete, well-explained, and code-level.** The paper does not merely assert dissociation; it names the specific mutant classes (tie-break identity, capacity/overflow boundary, `underestimatedCount`) that caused each gap, which is good empirical storytelling.
3. **Honest, repeated refusal to over-claim AI superiority.** The paper explicitly and repeatedly declines to conclude "AI is better than human," including in the abstract, discussion, and conclusion — a discipline many LLM-testing papers lack.
4. **The neutral-selection idea itself is a reasonable methodological instinct**, even if its execution and terminology (Reason #2) need correction — pre-declaring an eligibility → alphabetical-sort → first-eligible rule and freezing before AI generation is a legitimate, auditable partial mitigation for component-cherry-picking, and the candidate-selection records (e.g., E11's 30-row inventory with objective exclusion reasons) are genuinely useful artifacts.
5. **Willingness to report null/complicating results.** E5 (equal coverage, equal effectiveness) and the E15 inverse line-coverage ranking are reported and discussed even though they complicate the paper's own narrative, rather than being pruned or downplayed.

---

# Methodology Audit

## §3 Exploratory vs. Confirmatory Design
- The rule (enumerate → 7 eligibility criteria → alphabetical sort → first eligible → freeze) is applied consistently and is auditable via the candidate-selection records (verified for E11: 30 files enumerated, exclusion reasons given for all 29 non-selected).
- However: (a) it is not externally pre-registered (no timestamped, third-party-verifiable commitment before any E11–E15 outcome existed) — "pre-declared" and "pre-registered" are conflated in places; (b) eligibility criteria themselves were authored by the same team with no independent review, and criterion (g) ("reasonably isolated... for repeated mutation restore cycles") gives real discretion — e.g., E11's exclusion of `AssertSnapshot.swift` cites this criterion; a different researcher could reasonably judge isolation differently; (c) n=5, one per repository, means each repository contributes exactly one confirmatory data point — this is a heavily stratified, not independent, sample, and the paper's own Threats section admits this but the Results/Discussion sections still use language ("5/5," "independently reproduces") that reads more strongly than the design supports; (d) "alphabetical-first" is a defensible tie-breaking convention but is not obviously less arbitrary than other neutral rules (e.g., first-by-file-size, first-by-test-count) — the paper does not justify why alphabetical order specifically severs any correlation between component identity and expected outcome, it just asserts unpredictability. Recommended terminology: "second-round, neutrally-selected replication phase" rather than "confirmatory phaseः independently reproduced."

## §4 Component Selection Bias
- Exploratory phase: openly disclosed as non-neutral ("explicitly favored components expected to distinguish the two suites") — this is good disclosure but means E1–E10's central claim (dissociation exists) is drawn from a sample selected in part *because* dissociation-like results were expected, a mild circularity the paper does not fully own in the Abstract/Contributions (only in Threats).
- Confirmatory phase: eligibility criteria reduce which components are *available*, but do not control what happens *after* selection — specifically, the human test filter is chosen post-selection by the same researcher (see §5 below), reopening a bias channel the component-selection rule does not close. Exactly one additional component per repository also means the "confirmation" is really five single-instance case studies re-using the same five ecosystems already used for the main claim — this is a narrower generalization boost than "confirmatory" implies.

## §5 Human Baseline Fairness — CRITICAL
- The "Human suite" is a filter, chosen by the researcher, over pre-existing tests, frozen before AI generation but not before the researcher inspects what that filter does and doesn't cover (the Human Baseline document for each experiment reports uncovered paths immediately after freezing, which the mutation designer later references — see §7 below).
- E11's candidate-selection record explicitly documents excluding a related suite (`SnapshotsTraitTests`) from the frozen filter "unless Stage 2 requires widening for contamination-safe coverage" — i.e., the researcher had discretion to widen the human filter and chose the narrower default, contributing to the component's 41.7% Human mutation score, the single most extreme gap in the paper (+50.0 pp) and the number most likely to draw reviewer scrutiny.
- E15 excludes a randomized existing human test (`testPolar`) "to keep the frozen human baseline deterministic" — a reasonable justification, but it is asymmetric: no equivalent exclusion criterion is applied to the AI suite (which is generated once, deterministically, by construction), so the determinism requirement structurally can only ever remove tests from the Human side.
- Recommendation: the paper should explicitly rename the comparison as "existing Human test filter vs. independently generated AI suite" in the title/abstract (already partially done via careful body language, but the title/abstract still say "Human-Written Unit Tests" unqualified), and report, for the lowest-scoring Human filters (E11, E14), whether broadening to all existing tests touching the file (without writing anything new) changes the picture.

## §6 AI Generation Fairness
- AI suites are freshly generated with full knowledge of the current production implementation and are iteratively self-corrected until passing, with no reported limit on iterations, tokens, or wall-clock time. The paper is aware size/iteration confound RQ4 (§5.4, §6 RQ4) but frames this only as limiting a *suite-size* causal claim, not as a more basic fairness asymmetry: the Human suite was written once, historically, under unknown time/knowledge constraints (possibly before some current behavior existed), while the AI suite is generated *now*, against the *current* implementation, with unlimited correction attempts. A plausible alternative interpretation of most results — "a larger, fresher, implementation-aware suite outperforms a smaller, older, filtered suite" — is never stated as an alternative hypothesis to be ruled out, even though the paper's own RQ1 discussion comes close ("we interpret it as showing that neither suite dominated") without naming this specific confound directly.
- No generation cost/time/token budget is reported for any experiment, in the paper or (as far as reviewed) in the linked baseline artifacts.

## §7 Mutation Methodology — CRITICAL (see Reason to Reject #1)
- Manually designed by a single researcher who also designed the AI-generation prompts and adjudicated equivalence — the paper discloses this as an *equivalence-adjudication* threat (§7, Internal validity) but not as a *mutant-selection* threat.
- Verified in the artifacts: mutation plans for E3, E7, E11, E12, and E13 contain explicit per-mutant "Human pred./AI pred." (or equivalent) columns with suite-content-specific rationale (quoted in Reason #1). E3's plan states predictions were made "based on suite scope from the baselines," i.e., after reviewing what each frozen suite's coverage report showed. This is look-ahead bias in mutant selection, not merely in equivalence adjudication, and it is not disclosed in the paper text at all.
- Mutant-set sizes vary (20–28), are not derived from a systematic mutation-operator tool (e.g., no off-the-shelf Swift mutation testing framework is used or cited), and equivalent/invalid exclusion rates vary from 0% to 19% with "no component-independent explanation" (the paper's own words) — an honest disclosure, but combined with single-annotator design, this variability is unexplained rather than merely acknowledged.
- Mutation score comparability across experiments is questionable given different denominators, different defect classes per component, and (per above) different degrees of suite-content awareness during design.

## §8 Coverage Claim
- The central claim ("structural code coverage alone is insufficient...") is defensible as stated, but some supporting evidence is narrower than the framing suggests: E15 shows *line* coverage disagreeing with mutation ranking while region/function coverage *agree* with it — the paper does note this precisely (§5.6, "it is line coverage specifically... not 'all coverage metrics'"), which is good, but the Abstract's "structural coverage" phrasing is broader than what E15 actually demonstrates. E3/E4/E9's "identical on every measured metric" claim rests on exactly three metrics (line/region/function) as recorded by one coverage tool (llvm-cov) at one point in time; "every measured metric" is accurate to what was measured but could be read as stronger than "every metric we happened to measure."
- Recommended narrower wording: "line, region, and function coverage — as reported by a single structural-coverage tool — are collectively insufficient to infer mutation-based fault-detection effectiveness," rather than the unqualified "structural code coverage."

## §9 Statistics
See Reasons to Reject #4 and #5. Additional notes: no confidence intervals or effect-size measures (e.g., Cliff's delta, rank-biserial) are reported anywhere for either phase; the paper does report exact test statistics and an independent SciPy re-verification, which is good practice, but the underlying design (n=9-10 clustered, heterogeneous-instrument pairs) makes the tests' formal validity questionable regardless of correct computation.

## §10 Complementarity Claim
- "Complementary" is asserted from raw unique-kill counts (8 human-only / 27 AI-only / 9 shared-survivors, confirmatory phase) without a union mutation score. A stronger, low-effort analysis (achievable from existing JSONL results without new experiments) would report MS(Human ∪ AI) per experiment, which would let a reader see how much value the union adds over the better single suite — this is explicitly listed as a SHOULD-DO below.
- The AI-only:human-only kill ratio (27:8 confirmatory) is presented as a "pattern," but is at least partly attributable to AI suites being systematically larger and fresher (per §6 above) rather than to a qualitative complementarity distinct from raw suite size — the paper does gesture at this ("plausibly reflecting that several neutrally selected human filters happened to be thin") but does not disentangle size from complementarity quantitatively.

---

# Claim Audit

| Claim | Evidence | Supported? | Risk | Recommended wording |
|---|---|---|---|---|
| "Structural code coverage alone is insufficient to infer mutation-based fault-detection effectiveness" (Abstract, Contributions, §6 RQ2, §8) | E3/E4/E9 (exploratory), E13/E15/E14 (confirmatory) | Partially — true for line/region/function coverage as measured by one tool; "structural coverage" is broader than what was tested | Moderate (over-generalization of metric scope) | "Line, region, and function coverage, as reported by a single coverage tool, are collectively insufficient..." |
| "AI achieved the higher mutation score in all five [confirmatory] experiments" (Abstract, §5.5, §6 RQ1) | Table 4 | Yes, numerically | Moderate (mutant-design confound not disclosed; small n restated 4+ times) | Keep the number but pair every restatement with the mutant-selection-bias caveat and a binomial-probability note |
| "Human-written and independently generated AI suites often detect different mutants, suggesting complementary testing value" (Abstract, Contributions, §8) | §5.2, §5.7 unique-kill counts | Partially — unique kills exist, but "complementary value" implies added value beyond size, which is not separately quantified (no union MS reported) | Moderate | "...suggesting each suite detects some mutants the other misses, though this is not yet separated from suite-size differences" |
| "[Confirmatory phase] specifically to address the exploratory phase's component-selection-bias threat" / "independently reproduces" (Intro, §4.6, §5.6) | Neutral-selection protocol, candidate-selection records | Partially — reduces one specific bias channel (which component), does not address human-filter selection, eligibility-criterion design, or repository-set reuse; "independently reproduces" overstates a same-team, same-tooling result | Major | Replace "confirmatory"/"independently reproduces" per Reason #2 |
| "We do not conclude that AI-generated tests are better than human-written tests" (§8 Conclusion) | Explicit disclaimer, repeated | Yes, as a disclaimer | Low, but tension with repeated 5/5 and +16.1pp emphasis (see Reason #4) | Keep, but reduce repetition of the headline numbers elsewhere to make the disclaimer's placement feel earned rather than pro forma |
| "Not designed after inspecting suite-specific weaknesses to favor either side" (mutation-plan artifacts, not the paper text itself, but load-bearing for §4.4/§7's framing) | Contradicted by same artifacts' "Human pred./AI pred." columns and E3's explicit "based on suite scope from the baselines" | **No** — internally contradicted | Critical | Must be corrected in the paper's Threats to Validity (§7) even though the exact sentence is not itself quoted in the paper; the paper's own "designed only after both suites were frozen" (§4.4) needs a companion sentence disclosing that mutant selection was informed by each suite's measured coverage/behavior |
| Reproducibility is adequately supported by "repository SHAs, fingerprints, filters, coverage artifacts, mutation plans, logs" (§4.5, §4.8, §7) | Verified present for sampled experiments (E9, E11, E15) | Yes for what is claimed | Low | No change needed, but add prompt/runbook exact version pinning as a named gap (already partially done) |

---

# Citation Audit

The following citations/claims should be independently verified by the authors before submission (not verified here beyond checking internal consistency and DOI/arXiv format plausibility):

1. **Inozemtseva & Holmes (2014), ICSE** — foundational; verify the exact reported correlation-strength language ("low to moderate") matches the original paper's conclusions rather than a paraphrase drift.
2. **Yuan et al. (2024/2023), FSE / arXiv:2305.04207** — verify the dual-dating (originally arXiv 2023, published FSE 2024) is stated identically in the `.bib` and in-text citation (spot-checked: consistent in this revision).
3. **Yang et al. (2024), ASE** — "17 projects" and "GPT-4 and EvoSuite" comparison claims should be checked against the actual paper for exact project count and baseline tool list.
4. **Ouédraogo et al. (2024), arXiv:2407.00225** — "216,300 generated tests across four LLMs and five prompting techniques" is a very specific number; verify against the source, since transcription errors in large specific numbers are a common reviewer catch.
5. **Moradi Dakhel et al. (2024) "MuTAP"** — verify venue/volume details (Information and Software Technology, vol. 171) and that "MuTAP" is the paper's own name for the method (not a nickname introduced by this manuscript).
6. **Wang et al. (2026) "MutGen"** — dated 2026 in an IEEE TSE volume 52(5); since this is a forward-dated/very recent reference relative to typical review-cycle timing, verify the DOI resolves and the volume/issue/page numbers are final (not a preprint DOI that could still change).
7. **Lops et al. (2025) "AgoneTest," arXiv:2511.20403** — verify this is a distinct, findable arXiv ID (the number is unusually high, consistent with a late-2025 posting, which is plausible but should be re-checked at submission time since arXiv IDs are easy to typo).
8. **Vathana et al. (2026), arXiv:2606.08588** — the specific effect ("69% vs. 17.2%, Fisher's exact p < .001") is a strong, specific empirical claim attributed to a third party; verify page/table reference in the source before repeating it as precisely as this manuscript does.
9. **Zhao et al. (2026), ISSTA / PACMSE** — verify "Article ISSTA002" is the correct article identifier format used by the venue (unusual identifier string; double-check against the publisher's page).
10. **General note:** Five of nine non-foundational citations are dated 2025–2026, i.e., very recent (or claimed-forthcoming) work. At submission time, authors must re-verify every one of these still resolves (DOI/arXiv) and that no metadata (author order, page numbers, volume/issue) has changed between preprint and camera-ready versions, since this is the single most common bibliographic error class reviewers flag.

---

# Missing Analyses

**MUST DO** (straightforward from existing JSONL/CSV artifacts, no new experiments):
- Compute and report **union mutation score, MS(Human ∪ AI)**, per experiment for both phases, directly from existing kill/survivor JSONL data. This would substantially strengthen the complementarity claim (§10 above) and costs nothing beyond re-aggregating existing results.
- Quantify, per experiment, **how many mutants in each mutation plan carry an explicit per-suite prediction annotation referencing suite-specific content** (the "Human pred./AI pred." columns identified in this review), and disclose this count in Threats to Validity.
- Report a **mutant-weighted (pooled) mutation score** alongside the existing experiment-weighted mean, for both phases, from existing per-experiment kill/valid-mutant counts.

**SHOULD DO** (existing artifacts likely sufficient, moderate effort):
- Report, for the two lowest human-scoring confirmatory experiments (E11, E14), whether other already-existing tests in the repository (not newly written) indirectly exercise the selected component, using existing coverage tooling on already-existing test targets.
- Add a simple binomial-probability note (informational, not inferential) next to the 5/5 confirmatory result (P(5/5 wins | p=0.5) ≈ 3.1%) to calibrate reader expectations without claiming significance.
- Report effect-size measures (e.g., a simple standardized mean paired difference) alongside the existing t-test/Wilcoxon results, or replace the significance tests with descriptive-only reporting per Reason to Reject #5.

**OPTIONAL** (would strengthen but is not essential):
- A sensitivity analysis excluding the single most extreme confirmatory experiment (E11, +50.0 pp) to show whether the qualitative "AI favored in all five" pattern is robust to its most influential data point.
- A short appendix table summarizing, per experiment, the count of mutants annotated with suite-specific predictive rationale vs. those without, to let readers assess look-ahead-bias exposure experiment-by-experiment.

---

# Required Paper Changes

**P0 — must fix before submission:**
1. Disclose the mutant-selection look-ahead issue (Reason #1) explicitly in Threats to Validity, with a quantified count of affected mutants per experiment.
2. Replace "confirmatory phase," "confirmatory replication," and "independently reproduces" with more precise terminology throughout (Reason #2), and add one sentence distinguishing pre-declared from pre-registered where the rule is first introduced.
3. Rename "Human suite" → "existing Human test filter" (or similar) in the title/abstract/throughout, and add the narrowed-filter threat explicitly (Reason #3), including the E11 `SnapshotsTraitTests` exclusion and the E15 randomized-test exclusion as named examples.
4. Add the union-mutation-score (MUST DO analysis above) to substantiate the complementarity claim quantitatively rather than only via raw unique-kill counts.

**P1 — strongly recommended:**
5. Reduce repetition of "5/5" and "+16.1 pp" (currently restated near-identically at least four times across Abstract/§5.5/§6/§8); pair each remaining mention with the binomial-probability calibration note.
6. Add mutant-weighted pooled mutation score alongside the experiment-weighted mean; reconsider whether the paired significance tests should be kept, replaced with descriptive statistics only, or supplemented with a stated rationale for testing despite heterogeneous instruments.
7. Explicitly name the "fresher/larger/implementation-aware AI suite vs. older/filtered/narrower Human suite" alternative explanation in the Discussion (§6 RQ1) rather than leaving it implicit.
8. Narrow the central claim's wording per §8 above ("line/region/function coverage from a single tool" rather than unqualified "structural code coverage").

**P2 — polish:**
9. Trim the Abstract from ~360 words toward a conference-typical 150–220 words; the two-phase framing can be conveyed more concisely.
10. Consider moving the exploratory-phase evolution-of-contamination-control narrative (§4.2) and the full 20-item Appendix A audit checklist to supplementary/artifact material; both currently read as audit-log prose inside the main text.
11. Reduce the number of times "we do not claim X" / "not Y" hedges are repeated verbatim across sections (RQ1, RQ2, Threats, Conclusion each restate similar hedges); consolidate into fewer, stronger statements.

---

# Venue Assessment

**ICSE:** Score 2 (Reject). Reasoning: ICSE reviewers are highly attuned to internal-validity threats in empirical methodology papers; the undisclosed mutant-design look-ahead issue (Reason #1) and the pre-declared/pre-registered terminology inflation (Reason #2) are exactly the class of finding that triggers a confident reject at this venue, regardless of the paper's genuine transparency elsewhere.

**FSE:** Score 2 (Reject). Reasoning: Similar profile to ICSE; FSE's empirical-SE reviewer pool overlaps heavily with ICSE's, and the paper's contribution (coverage/mutation dissociation applied to Human-vs-AI Swift tests) is incremental relative to Zhao et al. (2026) and Vathana et al. (2026), both already cited and both more directly on-point for the LLM-testing angle FSE reviewers would expect to be differentiated from.

**ASE:** Score 3 (Weak Reject). Reasoning: ASE's audience is somewhat more receptive to tool/artifact-heavy empirical studies and LLM-for-SE case studies, and the paper's artifact discipline (SHA fingerprints, JSONL results, candidate-selection audit trails) would be viewed more favorably here. Still, the same mutant-design confound is a methodology-track-relevant flaw that a careful ASE reviewer would likely catch and weight heavily, keeping this below Borderline.

**Best-fit track:** This work is currently better suited to a **NIER (New Ideas and Emerging Results) track or a workshop** (e.g., a workshop on AI for software testing, or a mutation-testing workshop) than a main research track. The "neutral-selection confirmatory design" is a promising *idea* worth surfacing to the community even in its current, imperfect execution, and a NIER-style venue expects exactly this: a smaller, more tentative contribution with explicit open questions, rather than a fully validated empirical result. It is not yet a strong industry-track fit (no industrial context or practitioner-facing tooling is presented) and is not yet mature enough for a journal extension (the core confound would need to be resolved with a genuinely blind mutation-design protocol first).

---

# Acceptance Path

**What is the smallest set of changes that could move this paper one full review category upward (e.g., Reject → Weak Reject/Borderline)?**

The single highest-leverage change is **honest, quantified disclosure of the mutant-selection look-ahead issue (Reason #1), combined with the terminology corrections in Reason #2**. Concretely:

1. Audit all fifteen mutation-plan artifacts (not just the five checked in this review) and report, per experiment, the count of mutants whose plan includes an explicit per-suite outcome prediction referencing specific suite content.
2. Add this as a first-class, explicitly named Threats to Validity item — not folded into the existing "single annotator" paragraph, but its own paragraph, because it is a distinct threat (mutant *selection*, not just equivalence *adjudication*).
3. Correct "confirmatory"/"independently reproduces" language throughout (a pure find-and-replace plus one clarifying sentence).
4. Add the union mutation score (MS(Human ∪ AI)) per experiment to give the complementarity claim a quantitative anchor beyond raw unique-kill counts.

None of these four changes requires new experiments, new mutants, or new tests — all are achievable from existing artifacts and honest re-framing of already-collected data. Together, they would not eliminate the underlying confound (that would require a genuinely blind mutation-design protocol in a future study), but they would convert an *undisclosed* critical threat into a *disclosed and partially quantified* one, which is typically enough to move a paper from "Reject" to "Weak Reject/Borderline" in reviewer scoring, since reviewers penalize undisclosed confounds far more heavily than disclosed ones of similar severity.
