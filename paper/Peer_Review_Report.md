% Peer Review Report

# Peer Review Report

## "Beyond Code Coverage: An Empirical Comparison of AI-Generated and Human-Written Unit Tests Using Mutation Testing"

**Reviewer role:** Senior academic researcher / peer reviewer / scientific editor (software engineering, empirical SE, software testing, AI-assisted development)

**Method:** Before writing any critique, every numeric claim in `paper.tex` was cross-checked against the underlying experiment artifacts — coverage reports, mutation-result logs, and JSONL outputs — for all ten experiments (E1–E10), not just the paper's own summary tables. All four bibliography entries were also checked against their real, published versions. Findings below distinguish **verified-accurate data** from **disclosure, framing, and citation problems**, which is where the real issues are.

---

## Headline Finding

The underlying empirical work is unusually well-documented and, as far as independent re-verification can show, **honest** — every number in Table 2 and every coverage/count figure in the narrative traces back to a real coverage report or mutation log. That is not something to take for granted in a paper like this, and it should be stated plainly rather than assumed. The problems identified below are about what the paper does and doesn't *say* about its own limitations, not about fabricated or incorrect data.

---

## Pass 1 — Critical Peer Review

### Critical

**C1. Candidate selection explicitly optimized for "good Human-vs-AI comparison potential," and this is never disclosed.**
Records of the experiment-design process show that components for later experiments were chosen using criteria that included expected discriminating power between the two suites, alongside more standard criteria (LOC, existing tests, mutation-count potential, determinism). Selecting subjects partly *because* they are expected to produce an interesting human/AI split is a serious selection-bias threat: it inflates the apparent frequency and size of divergences relative to what an unbiased sample of "components with existing tests" would show. The current External Validity paragraph only says the study "may not generalize... to other languages, systems, test levels, or LLMs" — it omits this sampling mechanism entirely. A reviewer who notices this (and reviewers who do mutation-testing work will look for it) can reasonably reject on construct-validity grounds alone.

**C2. Single experimenter performed generation, mutation design, execution, *and* equivalent-mutant adjudication, with no blinding and no second annotator.**
Equivalence classification happened only for mutants that already showed `SURVIVED/SURVIVED` (e.g., E5's four exclusions out of 26 planned mutants, E4's one, E6's four, E10's one) — i.e., the researcher looked for justifications to exclude only *after* seeing which mutants embarrassed the mutation set, and only via code-level reasoning performed by the same person who wrote the AI prompts and the mutation plan. The paper's Internal Validity paragraph claims this is mitigated by "freezing mutation plans before execution and requiring code-level justification," but freezing the *mutation plan* does not address post-hoc, unblinded *equivalence judgment* — exactly where subjective bias enters mutation-testing studies. Name this explicitly rather than folding it into the plan-freezing sentence.

**C3. Two of the four related-work citations contain factual metadata errors that look like hallucinated bibliographic details.**
Verified against real, published sources:
- `zhao2026`: the bib lists authors as "Zhao, Jiachi; Zhou, Shuang; Cohen, Eric" in "Proceedings of ISSTA." The actual paper (real, published, directly on-topic) is **Junda Zhao, Shurui Zhou, Eldan Cohen**, *"Do Coverage and Mutation Scores of LLM-Generated Test Suites Correlate with Their Effectiveness? (Replicability Study)"*, **Proc. ACM Softw. Eng.** 3, ISSTA, Article ISSTA002 (2026), DOI `10.1145/3832093`. Three author names, the venue, and the subtitle are all wrong.
- `mutgen2026`: authors listed as "Wang, Guanchun; Xu, Qi." The real authors are **Guancheng Wang** and **Qinghua Xu** (IEEE TSE, vol. 52, no. 5, pp. 1657–1671, May 2026, DOI `10.1109/TSE.2026.3682975`).

These are exactly the errors that make a reviewer distrust an entire reference list. The underlying papers are real and well-chosen (good instinct in citation *selection*) — the metadata is simply wrong, and a five-minute fix. For a paper specifically about AI-generated content, reviewers will check this.

### Major

**M1. Contamination-control rigor was not uniform across the ten experiments, and the paper implies a single protocol throughout.**
From the underlying logs: E1–E2 relied on the AI test files not existing yet at baseline time (a real but *incidental* safety net, not a designed control); E3–E4 used qualified filters; **E5 had an actual contamination incident** — an unqualified `--filter CombinationsTests` matched 31 tests including the AI suite — that was caught and corrected; E6–E10 added automated per-mutant contamination flags. The paper's Methodology says only "Later experiments used fully qualified filters... to prevent accidental inclusion." This undersells both the real incident (which is actually *a point in the paper's favor*, showing the QA process works) and the fact that earlier experiments used a different, weaker mechanism. State this plainly.

**M2. No statistical treatment of the ten paired scores beyond a descriptive mean and win count.**
The paper is appropriately cautious ("These aggregates are descriptive, not population-level superiority claims"), but a caution with no actual quantification of uncertainty reads as hand-waving. Computed directly from the paper's own Table 2 — paired differences (AI − Human): +10.0, +14.8, −7.2, −8.0, 0, +9.1, +8.7, +8.3, −7.7, +21.8.
- Paired *t*-test: t(9) = 1.53, p ≈ 0.16
- Wilcoxon signed-rank (n = 9 non-tied): W = 6, which does not clear the exact critical value (5) at α = 0.05 two-sided

**Neither test reaches significance.** This is *evidence for* the paper's own caution, not against it — but it should be reported, not left implicit.

**M3. The AI generation process included an iterative compile/test-fix loop, and this is under-described.**
"Once passing, each AI suite was frozen" is the only hint that AI-authored tests were not first-shot output — they were repeatedly corrected against compiler and test-framework failures (confirmed in the underlying records, e.g., Experiment #10's floating-point comparison helper being revised after initial assertion failures). This loop used *only* compiler/test-framework signals, not human tests or mutation results, so it does not violate the leakage protocol — but reviewers will ask how many iterations occurred and whether iterating toward "green" biases the suite toward easy-to-assert paths. State this explicitly rather than leaving it to be inferred from one clause.

**M4. Equivalent-mutant exclusion rates vary widely (0%–19% of planned mutants) with no reported inter-rater check.**
E5 excluded 5/26 (19%), E6 excluded 4/26 (15%), E4 excluded 1/26 (4%), E3 and E9 excluded 0%. Not wrong on its own, but undiscussed. Report the per-experiment rate and address why it varies.

**M5. Related Work is thin (4 citations, one paragraph) for a paper whose contribution rests on positioning against a specific empirical literature.**
The two most relevant *conceptual* anchors — Inozemtseva & Holmes (ICSE 2014), the foundational paper showing coverage is a poor predictor of suite effectiveness for human-written tests, and Papadakis et al.'s mutation-testing survey (2019) — are missing entirely. Both are real, verifiable, and directly on point.

### Minor

- E6-M11's classification (an automated log-heuristic initially flagged it `INVALID`; a manual read of the logs reclassified it `KILLED-CRASH`) is disclosed in the underlying artifacts but not mentioned in the paper. Harmless, but worth a one-line footnote on the automated classifier's known limitation with crash logs.
- Figure 1 (grouped bars, all 10 experiments) and Figure 3 (paired differences, same 10 experiments) show the same underlying data from two angles. Figure 3 earns its place — it makes the win/loss pattern and magnitude immediately legible in a way Figure 1 doesn't — but consider whether a page-limited venue needs both.
- Confirm the `[10pt,conference]` IEEEtran template matches the actual target venue before submission.

---

## Pass 2 — Audit of Every Scientific Claim

### Numeric claims: fully verified

| Claim | Verified? |
|---|---|
| Table 2, all 20 mutation-score cells (E1–E10, Human/AI) | ✅ Exact match to `experiment-N-mutation-results.md` / `.jsonl` |
| "AI higher in six, Human in three, one tie" | ✅ E1,E2,E6,E7,E8,E10 = AI; E3,E4,E9 = Human; E5 = tie |
| Unweighted means: AI 93.8%, Human 88.8% | ✅ Recomputed independently: 93.81% / 88.83% |
| E3/E4/E9 "identical coverage" claims (99.03%; 82.39/78.85/73.08%; 100%) | ✅ All three metrics match exactly between suites in each case |
| E6: AI coverage higher, 2 unique kills via `Sequence.partitioned` | ✅ Matches mutation-results notes verbatim |
| E7: 98.0% vs 64.0% line coverage, 2 AI-only print-validation kills | ✅ Matches baselines and mutation results |
| E8: 95.8% vs 81.82% line coverage, 2 AI-only kills | ✅ Matches baselines and mutation results |
| E10: 97.06% vs 88.24% line coverage, 5 AI-only kills | ✅ Matches Experiment #10 summary |
| E5: both suites, 21/21 valid mutants, 100%/100% | ✅ Matches, with legitimate per-mutant equivalence justifications |
| Suite-size counterexamples (E4: 41 vs 10; E5: 27 vs 4; E9: 27 vs 10) | ✅ Matches test-method counts in baselines |

**No number in the paper needed correcting.** The remaining audit work is about claim *strength*, not claim *accuracy*.

### Claims needing a more defensible formulation

**P2-1.** *"AI-generated tests can complement mature human test suites"* (Abstract, Conclusion). Defensible as written — "can complement" is appropriately modal. Keep.

**P2-2.** *"high or even complete code coverage does not imply equivalent fault detection"* (Abstract). Defensible — directly demonstrated by E3/E4/E9. This is the paper's single most important claim and deserves to be flagged as a property of *this sample*, stated once explicitly near this sentence, not only in Threats to Validity.

**P2-3.** *"AI achieved the higher mutation score in six experiments... Aggregate win counts should not be interpreted as a replacement argument"* (RQ1 discussion). Directionally fine, but as shown in M2 above, the 6-3-1 split and the +4.98pp mean **are not statistically distinguishable from no difference** at conventional thresholds. Recommended reformulation:

> "AI-generated suites achieved a numerically higher mean mutation score across this sample (93.8% vs. 88.8%), but a paired comparison of the ten scores does not reach conventional statistical significance (Wilcoxon signed-rank, n=9 non-tied pairs, W=6, p≈.05 two-sided uncorrected; paired t-test, t(9)=1.53, p≈.16). Given the small, repository-clustered, heterogeneous sample, we treat the win count and mean as descriptive rather than as evidence of a population-level effect."

**P2-4.** *"Coverage measures execution rather than assertion quality"* (Construct Validity). Correct and important — the paper's best sentence. No change needed, but this distinction should also appear the *first* time mutation score is introduced as the outcome variable, not only six pages later in Threats to Validity.

**P2-5.** RQ4: *"larger generated suites do not necessarily produce stronger mutation effectiveness... no causal conclusion is warranted."* Defensible and correctly hedged already — a model sentence for the rest of the paper to match.

**P2-6.** The Results section computes and reports the aggregate mean/win-count *before* disclosing that the ten experiments are not independent samples (clustered within five repositories, produced by one experimenter). Move that caveat up to sit next to the first appearance of the aggregate numbers, not only in the Conclusion Validity paragraph several sections later.

**P2-7.** *"Related work has also examined whether coverage and mutation scores of LLM-generated suites correlate with effectiveness [zhao2026]"* — once the citation metadata is fixed, this sentence should also reflect what that paper actually found: the coverage/mutation/bug-detection relationship for LLM-generated suites is *context-dependent* (holds when the code-under-test is bug-free, breaks down when it's already buggy), and suite size is *not* a dominant confounder for LLM suites (unlike for human suites in Inozemtseva & Holmes). This is a substantive point of contrast for the paper's own RQ2 and RQ4, not just a passing citation.

---

## Pass 3 — Research Narrative

The paper follows Problem → RQs → Methodology → Experiments → Results → Discussion → Threats → Conclusion, and each RQ gets an explicit, separately labeled answer. That structural discipline is good and should be preserved.

Where the narrative needs tightening:

1. **The coverage / test-quantity / assertion-quantity / mutation-score / real-fault-detection distinction is the paper's real contribution, but it's introduced in one passing sentence.** Given how central this distinction is (and the explicit instruction that higher coverage must never be implied to mean better tests), it should be stated as a numbered taxonomy early in the Introduction, with each RQ answer explicitly naming which of these constructs it addresses. Note also that mutation score itself is *also* not real-fault detection — it's a proxy for it, validated only against synthetic seeded faults, and the paper should say so once explicitly at first use, not only in Threats to Validity.

2. **RQ2's "identical coverage, different fault detection" finding is the strongest result in the paper and is under-sold**, appearing as a subsection deep in Results rather than being foregrounded as the headline finding it is. It is genuinely the most reviewer-convincing part of this paper — three independent components at three different coverage levels, all showing coverage saying "equal" while mutation testing says "not equal." Consider naming the effect size explicitly in the Introduction's contribution list (up to 8–9 percentage points of mutation-score gap despite literally 100.00% coverage on all three metrics, for both suites, in E9).

3. **RQ3's "behavioral gap" account is good but is pattern-matching across ten small case studies, not a tested hypothesis.** That's fine for an exploratory study, but the paper should say explicitly that RQ3 is answered *qualitatively/thematically*, not statistically, so the reader doesn't hold it to the same evidentiary bar as RQ1.

---

## Pass 4 — Writing

The prose is already unusually clean for a conference draft — terse, appropriately hedged, low on filler. Few genuinely "AI-sounding" or marketing phrases were found. Specific fixes:

- Abstract: *"**More importantly**, several experiments achieved identical coverage..."* → drop "More importantly" (subjective signposting); let the fact carry its own weight.
- Methodology: *"Mutants represented observable defects such as..."* → *"Mutants modeled realistic defect classes: branch inversions, comparison-operator errors, off-by-one boundaries, wrong return values, omitted guards, sign errors, and special-case handling."*
- Conclusion Validity: *"Reported means and win counts are descriptive."* — good, keep, but pair it with the actual statistical-test result (Pass 2, P2-3) rather than a bare assertion.
- Several sentences pack 2–3 distinct claims with no connective tissue (e.g., the single dense sentence covering both AI-only and human-only kill patterns in RQ3). Split into one sentence per pattern.
- Terminology consistency: "mutation effectiveness," "mutation score," and "fault detection" are used somewhat interchangeably. Reserve "mutation score" for the measured metric, and use "fault-detection capability" / "mutation effectiveness" only with the proxy caveat attached.

---

## Pass 5 — Tables and Figures

- **Table 1 (Subjects):** self-contained and accurate. Add an LOC/executable-lines column — the design process used size criteria ("100–400 LOC" style sizing) that the reader never sees; a reviewer sizing up "is this a toy or a real component" will want it. *(Added in the revised manuscript — see below.)*
- **Table 2 (Results):** accurate, fully re-verified. Add a valid-mutant-count column — four experiments show "100%," but of *different* mutant-set sizes (21–24) and different equivalence-exclusion rates, and that context currently isn't visible next to the percentages.
- **Figure 1 vs. Figure 3:** two views of one dataset (see Pass 1, Minor). Recommend keeping both if space allows: Figure 1 is what readers expect first (raw scores); Figure 3 communicates the RQ1 answer (mixed, no consistent winner, one large outlier) more directly.
- **Figure 2:** earns its place — isolates exactly the three cases carrying the paper's central claim, and the title is already self-explanatory. No change.
- **Missing table (now added):** a per-experiment test-method / assertion-count table (Human vs. AI). This directly resolves `TODO[AUDIT-RESULTS-4]` and materially strengthens RQ4 — currently RQ4 is argued with three cherry-picked comparisons (E4, E5, E9) in prose; a full table lets the reader verify the "larger ≠ better" claim across all ten, not just three.

---

## Pass 6 — Publication Readiness

### 1. Reviewer Verdict

**Weak Reject / Borderline**, trending to **Weak Accept** if the Required Changes below are made.

The underlying empirical work is careful, and the numbers check out completely under independent re-verification — that is rare and valuable. But as currently written, the paper (a) hides a real selection-bias mechanism in candidate selection, (b) asserts a headline comparative finding (6-3-1, mean gap) without the statistical framing needed to know whether it's noise, (c) has two citations with wrong author names, and (d) under-describes its own AI-generation and equivalence-adjudication procedures for reproducibility. All four are fixable without new experiments. None is a fatal flaw in the underlying study design — they are disclosure and framing gaps. A revision addressing them would likely clear a mutation-testing-literate program committee.

### 2. Top 5 Rejection Risks

1. Undisclosed selection criterion favoring "comparison potential" in candidate choice — a mutation-testing-literate reviewer will ask how the ten components were chosen and whether that choice explains the results, and the paper has no answer on the page.
2. No statistical qualification of the central 6-3-1 / 93.8-vs-88.8 comparison — its absence invites a "descriptive stats masquerading as a finding" critique.
3. Incorrect author names in two citations (`zhao2026`, `mutgen2026`) — trivially checkable, and one wrong citation makes reviewers distrust the rest of the reference list.
4. Single-annotator, unblinded, post-hoc equivalent-mutant classification with no inter-rater check — a known soft spot that experienced mutation-testing reviewers probe specifically.
5. Missing generation-process detail (model/version, prompt, iteration count, sampling settings — five unresolved `TODO[AUDIT-MODEL-*]` markers) — for a paper about AI-generated tests, not being able to say which AI, what prompt, or how many fix-iterations is a reproducibility gap serious enough to justify a desk reject at some venues.

### 3. Required Changes (prioritized)

1. Resolve all `TODO[AUDIT-MODEL-*]` markers — exact model/version, Cursor version, prompt/runbook version, sampling settings if available, generation timestamps. **[AUTHOR ACTION REQUIRED]**
2. Fix `zhao2026` and `mutgen2026` citation metadata. *(Done in the revised bibliography.)*
3. Disclose the candidate-selection criteria explicitly, including "comparison potential," as a named threat to construct/external validity.
4. Add the paired statistical test (t-test + Wilcoxon) with caveats to Results/Conclusion Validity.
5. State the equivalence-classification process explicitly (single researcher, post-hoc, no second annotator) in Internal Validity.
6. Add the full per-experiment test/assertion-count table.
7. Describe the iterative AI generation/fix loop explicitly in the Methodology.
8. Expand Related Work with the two foundational citations (Inozemtseva & Holmes 2014; Papadakis et al. 2019) plus a genuine systematic pass. **[AUTHOR ACTION REQUIRED for the full systematic review]**
9. Add artifact-repository URL. **[AUTHOR ACTION REQUIRED]**
10. Verify author/affiliation block before submission (currently placeholder). **[AUTHOR ACTION REQUIRED]**

### 4. Section-by-Section Review

| Section | Works | Weak | Change |
|---|---|---|---|
| Abstract | Numbers verified accurate; appropriately hedged conclusion | "More importantly" filler; unresolved recomputation TODO | Tighten language; state that recomputation was done |
| Introduction | Clear problem statement; contributions map to results | Coverage/mutation/assertion distinction introduced too briefly | Elevate to explicit taxonomy paragraph |
| Related Work | Citations real and on-topic once corrected | Only 4 citations, 1 paragraph; missing two most relevant foundational papers | Expand with Inozemtseva & Holmes 2014, Papadakis et al. 2019; fix names; still needs full systematic pass |
| Methodology | Verified accurate against artifacts for all 10 experiments; principled leakage controls | Presents a single uniform protocol when rigor actually evolved experiment-to-experiment; omits generation-loop and equivalence-adjudication detail | Add methodology-evolution paragraph, generation-loop detail, adjudication-process detail |
| Results | All numbers re-verified exact | No uncertainty quantification; test/assertion counts scattered in prose, not tabulated | Add stats sentence; add full count table |
| Discussion | RQ-by-RQ structure is good discipline | RQ3 not marked as qualitative-only; mutation score vs. real fault detection conflated in places | Label RQ3 explicitly as thematic; add proxy caveat at first use of "mutation score" |
| Threats to Validity | Already better than average — separates internal/construct/external/conclusion/reproducibility explicitly | Missing selection-bias-in-candidate-choice and single-annotator-adjudication threats | Add both explicitly |
| Conclusion | Appropriately narrow ("supports a complementary view," not a replacement claim) | None significant | Minor tightening only |
| Appendix (Audit Checklist) | Good practice — shows the authors already know what to check | Several items still literally unresolved (SHAs, model version, bibliography) | Resolve before submission |

---

## Deliverables Produced Alongside This Report

Two additional files were written next to the originals (nothing was overwritten):

- **`references_revised.bib`** — corrected author/venue/DOI metadata for `yuan2023`, `mutgen2026`, and `zhao2026`; adds two verified foundational citations, `inozemtseva2014` and `papadakis2019survey`.
- **`paper_revised.tex`** — incorporates every fix resolvable from existing evidence:
  - The paired statistical test (t-test + Wilcoxon), reported with caveats
  - A full per-experiment test/assertion-count table (resolves `TODO[AUDIT-RESULTS-4]`)
  - A completed LOC / executable-lines column in the Subjects table (previously missing for E5, E6, E9, E10 — filled in from the underlying baseline artifacts)
  - Explicit selection-bias and single-annotator disclosures in Threats to Validity
  - The methodology-evolution paragraph (contamination controls) and the AI generation-loop description
  - Every unresolved item marked `[AUTHOR ACTION REQUIRED]` rather than guessed (model/version, prompts, artifact URL, author names, full systematic related-work pass)

Structural integrity of the revised LaTeX was checked by hand (no compiler was available in this environment): brace balance, `\begin`/`\end` environment matching, every `\cite` key resolving in the new bibliography, and every `\ref` having a matching `\label` — all clean.
