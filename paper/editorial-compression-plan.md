# Editorial Compression Audit — `paper_revised.md`

**Audit type:** Conservative editorial compression only. No changes were made to `paper_revised.md` or `paper_revised.tex`. This document contains analysis and recommendations only.

**Scope constraints honored in this audit:**
- No experiments, numbers, results, or citations are questioned or altered.
- No limitation is recommended for outright removal. Every limitation currently stated is recommended to remain stated at least once in the main paper.
- Recommendations prefer SHORTEN over REMOVE, and MOVE TO APPENDIX over deleting.
- "REMOVE AS DUPLICATE" is used only for prose that restates, verbatim or near-verbatim, a point already fully and adequately made elsewhere in the same document (e.g., duplicated interpretive clauses in figure captions), never for a limitation's only occurrence.

---

## 1. Current Word Count

Measured with `wc -w` on `paper/paper_revised.md` (492 lines):

| Basis | Word count |
|---|---:|
| **Whole file, as-is** (title through Appendix A, including tables and markdown emphasis markers) | **≈13,957 words** |
| Whole file, **excluding markdown table rows** (i.e., prose, headers, figure captions, references, and appendix checklist only) | ≈13,084 words |

For reference, per-section breakdown (raw `wc -w`, includes table rows where present):

| Section | Approx. words |
|---|---:|
| Title + Abstract + revision note | 408 |
| §1 Introduction | 928 |
| §2 Research Questions | 119 |
| §3 Related Work | 786 |
| §4 Methodology | 2,329 |
| §5 Results | 3,617 |
| §6 Discussion | 1,319 |
| §7 Threats to Validity | 2,147 |
| §8 Conclusion | 681 |
| References | 353 |
| Appendix A (Audit Checklist) | 1,270 |
| **Total** | **13,957** |

This is a long but not unusually long empirical SE paper body; the length is driven less by any single bloated section and more by **the same handful of caveats being fully re-explained, with numbers re-quoted, in 4–8 different places each** (§6 of this report itemizes these).

---

## 2. Estimated Word Count After Recommended Trimming

| | Words |
|---|---:|
| Current (raw) | ~13,957 |
| Estimated removable via SHORTEN / MOVE / REMOVE-AS-DUPLICATE (conservative) | ~1,350–1,550 |
| **Estimated word count after trimming** | **~12,450–12,600** |

This is an **~10–11% reduction**, achieved almost entirely by (a) collapsing repeated full explanations into a single canonical statement plus short cross-references, (b) moving revision-process/audit-checklist material that is already independently duplicated in existing repository files (`paper/*-change-log.md`) further out of the main narrative, and (c) trimming interpretive duplication in figure captions. **No table, no numeric result, no citation, and no limitation's sole occurrence is touched.**

See §7 below for the itemized breakdown behind this estimate.

---

## 3. Section-by-Section Recommendations

### Front matter / Revision note (line 7)

> "**Note on this revision:** this version is the final substantive revision before submission preparation, addressing an additional major-revision review (Paperpal) received after the adversarial-review repair pass... Three changes are worth flagging up front: (1)... (2)... (3)... Full resolution status per concern is in `paper/paperpal-major-revision-change-log.md`."

~210 words of production/revision-history narration in the manuscript's very first visible content.

- **Classification: SHORTEN.**
- This is meta-information about the paper's own editing history, not about the study. A reader evaluating the science does not need the itemized list of "three changes worth flagging" — that list is already the subject of §6 (Discussion), §7.3 (look-ahead), and §1 (Introduction) individually. Reduce to 2–3 sentences: what changed in kind (framing, sensitivity analysis, compression), that no new data was collected, and a single pointer to the change-log file for full resolution status.
- Suggested compressed version (~45 words): *"This version responds to an additional major-revision review (Paperpal), following the adversarial-review repair pass. No new experiments, tests, or mutants were run; changes are limited to framing, a new sensitivity analysis on already-frozen E11–E15 results (§5.5), and compression of repeated explanations. Full resolution status: `paper/paperpal-major-revision-change-log.md`."*
- Estimated savings: **~150 words**.

### Abstract (line 13)

- **Classification: KEEP**, essentially as-is. This is the one place a full, dense statement of the asymmetry, the look-ahead exposure (29/369), and the "not a blind instrument" caveat is *required* — abstracts are read standalone and must be self-contained. Do not shorten the substantive content. Minor tightening only if the authors want it (e.g., "concentrated in two experiments" could drop to "(mainly E2, E11)" to save ~4 words), but this is optional and not counted in the savings estimate.

### §1 Introduction (lines 19–48)

- Paragraph at line 23 ("What this study does and does not estimate") — **KEEP**. This is the canonical *first* statement of the estimand and is appropriately placed per the paper's own stated design goal (line 7: "the Human-filter-vs-AI-suite comparison and its limits are now stated in the Abstract and Introduction, not only in Threats to Validity"). Do not shorten below its current level of precision; this paragraph is doing real epistemic work (defining what RQ1–RQ4 can and cannot answer).
- Paragraph at line 34 (two-phase framing, pre-declared/pre-registered) — **KEEP**, but see §6.4 below re: cross-references to §4.6 rather than re-arguing the distinction here. Currently it already mostly just names the rule and points to §4.6, which is the right pattern — no change needed here specifically.
- §1.1 Contributions list (lines 40–47) — **KEEP** as a list; it is compact and functions as a roadmap. Item 6 (line 45) restates the look-ahead-audit finding with the artifact filename; this is fine at first mention.

### §2 Research Questions (lines 52–62) — **KEEP**, no changes. This section is already minimal (119 words) and serves a distinct organizing function; further compression would reduce clarity for no material savings.

### §3 Related Work (lines 66–82)

- Overall **KEEP** — this is comparative positioning against three specific papers and is not repetitive internally.
- Line 76, parenthetical: *"(This citation is flagged for external re-verification before submission; see `paper/citation-verification-todo.md`.)"* — **MOVE TO ARTIFACT REPOSITORY** (or resolve before submission). This is an internal production TODO, not a scientific limitation or a disclosure the reader needs in the main text; a `citation-verification-todo.md` file already exists for exactly this purpose. Leaving an unresolved "flagged for external re-verification" note inside the camera-ready-track manuscript reads as an editorial oversight rather than a disclosed limitation. Recommend resolving the citation check before submission and removing this parenthetical from the main text (or, if unresolved at submission time, moving the flag to acknowledgments/footnote rather than inline in Related Work). Estimated savings if moved: **~20 words**.
- Line 82 (closing paragraph, look-ahead + neutral-selection framing) — **SHORTEN slightly**. The clause "we treat this as an open methodological gap this paper discloses and measures, not one it fully resolves" duplicates the framing already given in the Introduction and restated in §7.3. Trim to a single clause pointing to §7.3. Estimated savings: **~15 words**.

### §4 Methodology (lines 86–172)

- §4.1–§4.2 (Subjects, Human filter) — **KEEP** the core description; this is load-bearing methodology.
  - Line 111, the contamination-control-evolution paragraph, and line 115, the per-experiment cross-check paragraph ("E9 and E10 report an explicit 'contamination CLEAN' check; E6, E7, and E8 report a 'Contamination check (Runbook v2)' step..."): **SHORTEN line 115.** Line 115 is essentially an audit-trail cross-check (confirming line 111's narrative against raw records) rather than a methods description; it duplicates, at the sentence level, what line 111 already states in prose form. Compress line 115 to one sentence ("This description was cross-checked against per-experiment raw baseline records with no discrepancies found") and move the itemized per-experiment detail to the artifact repository / Appendix (it is exactly the kind of item already handled by Appendix A checklist items 8, 14 — arguably a near-duplicate of those). **Classification: MOVE TO APPENDIX or ARTIFACT REPOSITORY.** Estimated savings: **~70 words**.
  - Line 113 (E11 `SnapshotsTraitTests` exclusion; E15 `testPolar` exclusion) — **KEEP**. This is a genuine, load-bearing disclosure about filter-selection judgment calls, and it is *also* stated in §7.2 (line 368) and §4.8 (line 170) and §A.2 item 14. This is one of the concepts in §6 below; the *canonical* full statement should live in §7.2 (Threats to Validity), with §4.2 and §4.8 giving only the brief factual note needed for methodological completeness at first mention. See §6.7.
- §4.3 (AI generation, lines 117–123) — mostly **KEEP** (this is where the generation protocol itself belongs), but line 121's second half ("A plausible alternative reading of most AI-favoring results in this paper is therefore 'a larger, fresher, iteratively self-corrected suite outperforms a smaller, older, unmodified filter'... We do not attempt to separate freshness, size, and iteration-count effects...") is a **near-verbatim restatement** of §7.2 (line 368: "A plausible, and in our view under-examined, alternative explanation for most AI-favoring mutation-score gaps in this paper is therefore... We do not attempt to disentangle freshness, iteration count, and suite size..."). **Classification: SHORTEN (cross-reference §7.2).** Keep the factual observation ("AI suites were also larger... in nine of ten... and all five...") since it is methodologically relevant here, but replace the interpretive sentence with "(see §7.2 for the full asymmetry threat and its implications)." Estimated savings: **~55 words**.
- §4.4 (Mutation Design, lines 125–133) — **KEEP** the core description; line 129's look-ahead paragraph is the *first* mention and appropriately brief (already says "the canonical explanation and audit results for this threat" is in §7.3 — this is exactly the right pattern and should be used as the template for other repeat-offenders elsewhere).
- §4.6 (Neutral-Selection rationale, lines 139–153) — **KEEP in full.** This is the canonical methodological explanation of the pre-declared-not-pre-registered distinction and the eligibility rule; it should not be shortened, and other sections should cross-reference it rather than re-explain it (see §6.4).
- §4.7 (Subjects table) — **KEEP**, compact.
- §4.8 (Suite freezing/mutation/integrity for follow-up, lines 168–172) — **KEEP** the E15 rebuild-fix disclosure (line 170); this is a genuine integrity-relevant implementation detail (inlining causing stale-binary risk) and must remain at least in summary form. Consider **SHORTENING** the sentence slightly, since the full procedural blow-by-blow ("the mutation runner was corrected mid-campaign to force a clean rebuild of the test target before each suite invocation, and the full campaign was re-run under that fix before any result was reported") could be trimmed to "a mid-campaign tooling fix (forced clean rebuild) was applied and the full campaign re-run before any result was reported (`research/experiment-15-mutation-results.md`)" — same disclosure, ~20 fewer words. Estimated savings: **~20 words**.

### §5 Results (lines 176–306)

This is the largest section (3,617 words) and has the most internal repetition, mostly numeric restatement of the look-ahead audit rather than new results.

- §5.0 (lines 178–216) — **KEEP** the descriptive statistics themselves (mean/median/pooled/range) — these are results and must stay in full with exact numbers.
  - Line 199 ("We do not report a paired t-test... An earlier version of this analysis did, and found neither test statistically significant; on reflection, and following adversarial review, we consider that framing misleading rather than merely inconclusive...") — **SHORTEN.** The clause "An earlier version of this analysis did... on reflection, and following adversarial review" is revision-history narration (what a prior draft did), not a methodological finding about the current study. The methodological reasoning that follows ("the ten experiments are not independent random draws... clustered within five repositories... heterogeneous, manually constructed mutant sets... designed and adjudicated by the same two-person team") is genuine and load-bearing and should stay. Recommend cutting the "earlier version... adversarial review" clause (a `paper/reviewer-repair-change-log.md` already exists for this history) and stating the reasoning directly: "We do not report inferential significance tests here: the ten experiments are not independent random draws from a population of components..." **Classification: SHORTEN + MOVE revision-history clause to artifact repository (already covered by change-log).** Estimated savings: **~35 words**.
- §5.1 (lines 218–224) — **KEEP** the coverage/mutation-score results themselves (line 220) in full; this is core RQ2 evidence.
  - Line 222 (look-ahead exposure for E3/E4/E9) restates the audit's exact figures (0/26, 0/26, 3/28, 10.7%) that are *also* given in §7.3, §5.6, §6 (RQ2), and Appendix item 30. **Classification: SHORTEN.** This is the first of five near-identical numeric restatements of the same look-ahead figures for the same experiment set (see concept map in §6.2 below). Recommend keeping the qualitative pointer ("E3's gap is not blind to suite content; E4 and E9 are the cleaner, zero-exposure instances — full figures in §7.3") and dropping the repeated percentages, since §7.3 is the designated canonical location per the paper's own line 129 ("the canonical explanation and audit results for this threat"). Estimated savings: **~50 words**.
- §5.2–§5.4b — **KEEP** in full. These report distinct, non-duplicated results (coverage-gap cases, the E5 counterexample, suite-size analysis, union-effectiveness). No compression recommended.
- §5.5 (lines 244–276) — **KEEP** the core follow-up results and the sensitivity analysis (line 262) in full — this is a Result and its canonical location (see §6.3 below); do not shorten the sensitivity-analysis paragraph itself.
  - Line 246's look-ahead restatement (E11 12/24, 50.0%; E13 2/23, 8.7%) is the second of the five near-identical restatements — **SHORTEN**, same treatment as line 222: keep the qualitative flag, drop repeated percentages already in §7.3. Estimated savings: **~30 words**.
- §5.6 (lines 278–288) — **KEEP** the coverage/mutation dissociation findings (E13, E15, E14) in full; these are central RQ2 evidence and appropriately detailed.
  - Within the E13 paragraph (line 282), the clause "2 of E13's 23 valid mutants (8.7%) are flagged in `research/mutation-lookahead-audit.md` as suite-content-aware (E13-M03, E13-M20, both HIGH risk...)" is the third restatement of figures also in §7.3 and Appendix item 30. **SHORTEN**: keep "E13's entire 8.7-point gap is attributable to two suite-content-aware mutants (full audit in §7.3)" and drop the mutant-ID-level detail here (the IDs belong in the artifact repository / mutation-lookahead-audit.md, which already contains them). Estimated savings: **~35 words**.
- §5.7 — **KEEP** in full; distinct union-effectiveness results, no repetition found.

### §6 Discussion (lines 310–340)

- **RQ1** (lines 312–316) — Line 316 restates the AI-effort/freshness asymmetry, the look-ahead caveat, and the E11-exclusion sensitivity result in near-full form, each of which has its canonical home elsewhere (§7.2, §7.3, §5.5 respectively). **Classification: SHORTEN.** This paragraph's *job* is synthesis across phases (comparing 6-3-1 to 5-0-0), which is valuable and should stay; the repeated mechanics of *why* those numbers are qualified should be compressed to short parenthetical pointers. Estimated savings: **~60 words**.
- **RQ2** (lines 318–328) — This is explicitly, and correctly, framed by the paper itself as "the central, cross-phase finding" (line 328) and as "least affected by the limitations discussed under RQ1" (line 320). **KEEP the core argument in full** — do not shorten the load-bearing claim about which experiments carry RQ2's evidentiary weight (E3/E4/E9/E13/E14/E15) or the exact per-experiment exposure figures at line 326, since this paragraph is itself functioning as a second, necessary "canonical" statement (cross-phase synthesis, distinct from §7.3's per-experiment audit). No compression recommended here beyond what is captured in §7.3 already being the fuller source — this paragraph should *stay* essentially as-is because it is synthesis, not raw repetition.
- **RQ3** (lines 330–332) — **KEEP**, distinct synthesis content, appropriately brief already.
- **RQ4** (lines 334–336) — **KEEP**, brief, no repetition.
- **Selection Bias, Revisited** (lines 338–340) — **SHORTEN.** This short paragraph re-explains that the neutral rule "reduces but does not eliminate" component-selection bias and that it does not address look-ahead or effort asymmetry — all three points are already made in §4.6, §7.1, and §7.3 respectively. Recommend compressing to 2 sentences: state that both patterns recur under the neutral rule (the one new synthesis point), then a single sentence pointing to §7.1/§7.3 for the residual-bias account, dropping the re-derivation. Estimated savings: **~40 words**.

### §7 Threats to Validity (lines 344–400)

This section is the **designated canonical home** for essentially every repeated concept in this paper (by the paper's own design — see line 346, "the subsections below give the full account of each threat once, and later sections cross-reference this table rather than repeating it"). The audit finds that this design intent is **mostly, but not fully, honored** — several other sections (§5.1, §5.5, §5.6, §6) restate figures that this section's own stated design says should live only here. The fix is in those other sections (above), not in §7 itself.

- Table 7 (lines 350–358) — **KEEP in full.** This is exactly the kind of compact signpost table that should exist; it is not itself repetitive.
- §7.1–§7.4, §7.6, §7.9 — **KEEP in full.** These are the canonical, single-location explanations and should not be shortened; they are the *target* of cross-references from elsewhere, not the source of duplication.
- §7.3 (lines 370–376) — **KEEP in full, without exception.** This is explicitly labeled "the single most important limitation identified in this revision of the paper" (line 376) and is the canonical location for the look-ahead audit. All other mentions should point here (see §6.2 below).
- §7.5 (Construct Validity, lines 382–384) and §7.8 (Mutation vs. Real Faults, lines 394–396) — **partial overlap.** §7.5's second sentence ("Mutation score measures sensitivity to seeded, syntactic faults, not to the distribution of real historical defects; we do not equate a mutant kill with detection of a real bug anywhere in this paper") substantially duplicates §7.8's opening ("Every finding in this paper concerns mutation-based, not real-fault-based, effectiveness... We make no claim, anywhere in this paper, that a higher mutation score corresponds to catching more real bugs..."). **Classification: SHORTEN §7.5.** Recommend §7.5 keep only its coverage-vs-assertion-quality point (which is distinct and not repeated elsewhere) and cross-reference §7.8 for the mutation-vs-real-fault point: "Mutation score is a syntactic-fault proxy, not a real-defect measure (§7.8)." Estimated savings: **~25 words**.
- §7.7 (Conclusion Validity, lines 390–392) — **KEEP in full.** This is the canonical statement of the descriptive-statistics-only philosophy and should not be shortened; per the paper's own Appendix item 34, it is intended to be stated "once near the top of §5 and once in §7.7." The top-of-§5 instance (line 178) is brief and appropriate; no change needed to either.

### §8 Conclusion (lines 404–414)

- **KEEP the substance.** A conclusion section restating the paper's key numbers and central limitations is conventional and expected; this is not "repetition" in the pejorative sense — it is what a conclusion is for. No word-count reduction is recommended for the numerical restatement of both phases' results (lines 406–408) or the coverage/mutation dissociation claim (line 410).
- Line 412 (the two study-level limitations, effort/freshness and look-ahead) restates both in close-to-full form. **Classification: light SHORTEN only.** Recommend trimming the parenthetical elaboration slightly (e.g., "so the corresponding mutation-score gaps are conditional on manually constructed, suite-aware mutant sets, not unbiased estimates of general suite effectiveness (§7.3)" could compress to "so those gaps are conditional, not unbiased (§7.3)"), while keeping both limitations named explicitly, since a conclusion is exactly where a reader expects to find the "so what do I take away" limitations statement. Estimated savings: **~30 words** (conservative; this paragraph should mostly stay as written).
- Future work paragraph (line 414) — **KEEP**, compact and appropriately forward-looking; not restated elsewhere.

### References — **KEEP in full.** No changes; explicitly out of scope per task constraints.

### Appendix A. Audit Checklist (lines 442–492)

This is the section with the clearest, lowest-risk compression opportunity, because much of its content is **already independently captured** in existing repository files referenced by the manuscript itself (`paper/conference-review-audit.md`, `paper/reviewer-repair-change-log.md`, `paper/paperpal-major-revision-change-log.md`).

- **A.1 Exploratory phase checklist** (items 1–10, lines 446–455, ~291 words) — **KEEP, lightly shorten.** This is a genuine reproducibility/integrity checklist (contamination checks, fingerprint verification, bibliography corrections) with real scientific-integrity content, appropriately placed in an appendix. Recommend only minor tightening of item wording (e.g., item 6's long bibliography-correction sentence could drop the itemized paper-by-paper list, since those additions are already visible in §3 and the References list itself). Estimated savings: **~40 words**.
- **A.2 Follow-up phase checklist** (items 11–20, lines 457–468, ~348 words) — **KEEP, lightly shorten.** Same reasoning as A.1; this is the follow-up-phase analog and has comparable integrity value (e.g., item 19/20 confirm win counts are never pooled — a substantive, non-obvious verification worth keeping visible). Estimated savings: **~40 words**.
- **A.3 Repair-cycle audit** (items 21–28, lines 470–479, ~310 words) — **MOVE TO ARTIFACT REPOSITORY.** Every item here ("Verified that no exploratory-phase number was altered...", "Verified 'Human suite' has been replaced with...") is a **verification of the paper's own editing process**, not a verification of the scientific method or data. The manuscript explicitly states (line 476, 479) that this is "consistent with `paper/reviewer-repair-change-log.md`" — i.e., a more complete version of this exact audit trail already exists as a standalone file. Recommend replacing this subsection with a single pointer sentence: *"A full repair-cycle audit trail, including verification that no exploratory-phase number was altered and that no new significance test was introduced, is maintained in `paper/reviewer-repair-change-log.md`."* Estimated savings: **~270 words** (keeping ~40 words as the pointer sentence).
- **A.4 Paperpal major-revision audit** (items 29–38, lines 481–492, ~321 words) — **MOVE TO ARTIFACT REPOSITORY, with one exception.** Items 29–31 (E11 sensitivity analysis verification, per-experiment look-ahead re-verification, and the "does not claim unaffected" wording check) restate figures that are scientifically substantive (the sensitivity-analysis numbers) and worth a condensed retention; items 32, 36, 38 (title-consistency check, citation sanity check, "no new experiment was run" verification) are pure production/editorial verification, directly paralleling `paper/paperpal-major-revision-change-log.md`, which the manuscript already cites. Recommend: keep a 2–3 sentence condensed version of items 29–31 (the numbers), and replace items 32–38 with a single pointer to the change-log file. Estimated savings: **~230 words** (keeping ~90 words of condensed sensitivity/look-ahead verification).

**Net Appendix A savings: ~580 words**, achieved entirely by pointing to already-existing artifact-repository files rather than by deleting any unique verification content.

---

## 4. Material That MUST Remain in the Main Paper

The following must **not** be shortened, moved, or removed — they are either singly-stated limitations, the paper's designated canonical explanations, or content load-bearing for a standalone reading of the paper:

1. **Abstract in full** (line 13) — the only self-contained summary; must retain the asymmetry statement, the look-ahead figure (29/369), and the coverage-insufficiency conclusion.
2. **§1 line 23** ("What this study does and does not estimate") — the paper's own stated design goal is that this appear here, not only in §7.
3. **§4.6 in full** (lines 139–153) — the canonical pre-declared-vs-pre-registered explanation and the seven eligibility criteria; this is methodology, not repetition.
4. **§4.4's mutation-scoring formula and equivalence-adjudication description** (lines 125–133).
5. **All of §5's numeric results** — Tables 2–6, all percentages, all per-experiment findings (§5.1–§5.7). These are the paper's evidence and are explicitly out of scope for this audit.
6. **§5.5's E11 sensitivity analysis** (line 262) in full — this is itself a result, computed specifically for this revision, and is its own canonical location.
7. **§6 RQ2 discussion** (lines 318–328) — the paper's self-declared "central, cross-phase finding," including the six-experiment evidentiary-base statement and per-experiment exposure figures at line 326.
8. **§7.1–§7.8 core prose, each threat's full first (and only fully-elaborated) statement** — this section is the canonical home for every threat and must not be thinned; in particular §7.3 (look-ahead) is labeled "the single most important limitation" and must remain fully detailed.
9. **§7.9 Reproducibility** — required disclosure of artifacts, versions, and reproducibility scope.
10. **§8 Conclusion's limitation restatement** (line 412) — a conclusion is expected to restate, in condensed form, the limitations that qualify its claims; only light trimming is recommended, not removal.
11. **Every disclosure that currently appears only once** — verified in this audit: the E5 counterexample (§5.3), the E14 large-coverage/small-gap finding (§5.6), the equivalent-mutant exclusion-rate variance (§7.4), and the single-annotator adjudication limitation (§4.4, §7.4) each appear in essentially one place and must not be cut.
12. **All tables (1, 1b, 2–7) and all figures with their core (non-interpretive) captions.**
13. **References** — untouched per task constraints.

---

## 5. Material Safe to Move Out (or Compress Toward a Pointer)

1. **Appendix A.3 and A.4** (repair-cycle and Paperpal-revision audit checklists) → point to `paper/reviewer-repair-change-log.md` and `paper/paperpal-major-revision-change-log.md`, which already contain this content in fuller form.
2. **The front-matter "Note on this revision"** (line 7) → shorten to a 2–3 sentence pointer to `paper/paperpal-major-revision-change-log.md`.
3. **The Related Work citation-verification flag** (line 76 parenthetical) → resolve or move to `paper/citation-verification-todo.md` only (already exists); should not remain as an inline "TODO" in the main narrative.
4. **§4.2's per-experiment contamination cross-check itemization** (line 115) → condense in-text to one sentence; full per-experiment detail already belongs to (and substantially duplicates) Appendix A items 8 and 14 / underlying `research/experiment-N-*.md` files.
5. **§5.0 line 199's "an earlier version of this analysis did..." clause** → this revision-history detail is already covered by `paper/reviewer-repair-change-log.md`; state the current methodological reasoning directly instead of narrating the prior draft's choice.
6. **Mutant-ID-level detail in §5.6's E13 discussion** (e.g., "E13-M03, E13-M20, both HIGH risk") → this level of detail belongs in `research/mutation-lookahead-audit.md` (already the cited source); the main text needs only the count and the qualitative conclusion.
7. **Repeated numeric restatements of the look-ahead audit's top-line figures** (29/369, 7.9%; E2 7/27; E11 12/24) wherever they appear outside §7.3 and the Abstract — every other appearance (§5.1 line 222, §5.5 line 246, §6 line 326, Appendix item 30) can cite §7.3/Table 7 instead of re-quoting the percentages.

---

## 6. Repeated Concepts: Every Occurrence, Canonical Location, and Recommended Cross-Reference Wording

### 6.1 Human-filter vs. fresh-AI-suite asymmetry

**Occurrences:**
- Abstract, line 13 — full statement (required, KEEP).
- §1, line 23 — full statement (required by paper's own design goal, KEEP).
- §4, line 88 — brief naming convention statement (KEEP, it's short and functional).
- §4.3, line 121 — near-full restatement of the "plausible alternative reading" argument (SHORTEN).
- §5.5, line 260 (implicitly, via "should not be interpreted as evidence of universal AI superiority") — different angle, KEEP.
- §6 RQ1, line 316 — restates "AI-effort/freshness asymmetry" as one of several qualifiers (SHORTEN to pointer).
- §6 Selection Bias, line 340 — restates that the neutral rule "does not address... AI-generation effort asymmetry" (KEEP, this is a distinct point about what the rule does *not* cover — but trim the sentence).
- Table 7, line 353 — compact summary row (KEEP, this is the intended compact form).
- §7.2, lines 366–368 — **canonical, full explanation** (KEEP in full).
- §8, lines 408, 412 — conclusion-appropriate restatement (KEEP, light trim only).
- Appendix item 33 — verification that this is stated in §1 (KEEP, brief).

**Canonical location:** §7.2 (Human-Filter Selection and AI-Generation Effort Asymmetry).

**Recommended cross-reference wording elsewhere:** *"...an effort/freshness asymmetry between the two artifacts, not a matched-effort comparison (§7.2)."*

### 6.2 Mutation-selection look-ahead

**Occurrences (most-repeated concept in the paper):**
- Abstract, line 13 — top-line figure only (KEEP).
- §1.1 item 6, line 45 — names the audit + sensitivity analysis (KEEP, roadmap item).
- §3, line 82 — one sentence, appropriately brief (KEEP).
- §4.4, line 129 — first full mention, explicitly deferring detail to §7.3 (**KEEP as the model for how this should be done elsewhere**).
- §5.1, line 222 — full numeric restatement for E3/E4/E9 (SHORTEN).
- §5.5, lines 246, 262 — full numeric restatement for E11/E13, plus the sensitivity analysis (line 262 is itself a **result** and canonical for that computation; line 246's restatement can be shortened).
- §5.6, line 282 — full numeric restatement + mutant IDs for E13 (SHORTEN).
- §6 RQ1, line 316 — restatement (SHORTEN to pointer).
- §6 RQ2, lines 320, 326 — the six-experiment evidentiary-base statement with exact per-experiment figures (**KEEP** — this is cross-phase synthesis, the paper's stated central finding, distinct from raw repetition).
- Table 7, line 354 — compact summary row (KEEP).
- §7.3, lines 370–376 — **canonical, full explanation and quantification** (KEEP in full; explicitly self-identified as "the single most important limitation").
- §7.4, line 380 — brief cross-reference (KEEP, already appropriately brief).
- §7.7, line 392 — brief mention as one clustering factor (KEEP, brief).
- §8, lines 410, 412 — conclusion-appropriate restatement (KEEP, light trim).
- Appendix items 21, 30, 31 — verification entries (KEEP items 21/31 as brief; item 30's full per-experiment re-verification is useful but could be trimmed — see §3 Appendix recommendations).

**Canonical location:** §7.3 (Mutation-Selection Look-Ahead), with §6 RQ2 as a secondary, necessary cross-phase synthesis location (not true duplication — keep both).

**Recommended cross-reference wording elsewhere:** *"...conditional on suite-aware mutant selection in this experiment (full audit: §7.3)."* Drop repeated percentages/counts outside §7.3, the Abstract, and Table 4/7.

### 6.3 E11 sensitivity / limitations

**Occurrences:**
- §5.5, line 262 — **canonical**: the sensitivity analysis is computed and reported here for the first time (KEEP in full — this is a result).
- §6 RQ1, line 316 — restates the +7.58 pp vs. +16.1 pp comparison (SHORTEN to pointer, since the numbers are already in §5.5).
- §6 RQ2, lines 320, 326 — states that RQ2 "does not depend on E11" (**KEEP** — this is a distinct, important scoping claim about a different RQ, not a repeat of the §5.5 computation).
- §8, line 408 — conclusion restatement of direction (4/4) and magnitude (+7.58 pp) (KEEP, conclusions restate key results; no change recommended).
- Appendix item 29 — verification entry (KEEP, brief).

**Canonical location:** §5.5 (Neutral-Selection Follow-Up Results), "Sensitivity analysis excluding the highest-look-ahead experiment" paragraph.

**Recommended cross-reference wording elsewhere:** *"...as shown by the E11-exclusion sensitivity analysis (§5.5): direction unchanged, magnitude roughly halved."*

### 6.4 Pre-declared vs. pre-registered selection

**Occurrences:**
- Abstract, line 13 — brief, parenthetical (KEEP).
- §1, line 34 — names the distinction and points to §4.6 (KEEP — already the right pattern).
- §1.1 item 5, line 44 — roadmap item (KEEP, brief).
- §3, line 82 — brief (KEEP).
- §4, line 88 — naming convention (KEEP, brief).
- §4.6, lines 143 — **canonical, full explanation of internal-vs-external pre-registration** (KEEP in full).
- §4.7 caption, line 158 — brief (KEEP).
- §5.5, line 246 — brief, functional (KEEP).
- §6 Selection Bias, line 340 — restates "internally-committed-but-not-externally-pre-registered" (SHORTEN — this exact phrase is a near-quote of §4.6/§7.1; use a shorter pointer).
- §7.1, line 364 — restates the same phrase again (SHORTEN, same reasoning).
- §8, line 408 — brief, appropriate for conclusion (KEEP).
- Appendix items 19, 24 — verification entries (KEEP, brief).

**Canonical location:** §4.6 (Neutral-Selection Follow-Up Phase: Rationale and Component Selection).

**Recommended cross-reference wording elsewhere:** *"...the pre-declared (not externally pre-registered) rule (§4.6)."* — this exact short form already appears in several places and should simply be used consistently instead of the longer "internally-committed-but-not-externally-pre-registered" phrasing at lines 340 and 364.

### 6.5 "We do not claim AI superiority"

**Occurrences:**
- §5.5, line 260 — **first full statement**, appropriately placed immediately after the striking 5/5 win-count result (KEEP in full — readers need this caveat exactly where the eye-catching number appears).
- §6 RQ1, lines 314, 316 — restates for both phases (**KEEP** — this is the section's job, synthesizing across phases; not true duplication of §5.5, which is phase-specific).
- §8, line 412 — **canonical closing statement**: "We explicitly do not conclude that AI-generated tests are better than human-written tests" (KEEP in full — this is the paper's single most important takeaway sentence and belongs in the conclusion).

**Canonical location:** §8 Conclusion, line 412 (as the paper's definitive closing statement), with §5.5 as a necessary earlier instance (result-adjacent caveat) and §6 as cross-phase synthesis. **No changes recommended** — this concept is not over-repeated; it appears at the three structurally appropriate points (first result, synthesis, conclusion) and each instance does distinct work.

### 6.6 Mutation testing is not equivalent to real-world bugs

**Occurrences:**
- §1, lines 30–32 — defines "Real fault-detection capability" as one of four levels, and states mutation testing "measures sensitivity to synthetic, seeded faults, not to the defects that occur in practice" (KEEP — this is the foundational conceptual framework for the whole paper).
- §3, line 76 (Vathana et al. discussion) — contextual, comparative use, not a repeated disclosure (KEEP, distinct function).
- Table 7, line 358 — compact summary row (KEEP).
- §7.5, line 384 — restates the point (SHORTEN — overlaps with §7.8).
- §7.8, lines 394–396 — **canonical, full explanation**, its own dedicated subsection (KEEP in full).
- §8, line 414 — future-work framing (KEEP, distinct function — points forward rather than restating backward).

**Canonical location:** §7.8 (Mutation vs. Real Faults).

**Recommended cross-reference wording elsewhere (for §7.5):** *"Mutation score is a syntactic-fault proxy, not a real-defect measure (§7.8)."*

### 6.7 Neutral component-selection methodology

**Occurrences:**
- §1, line 34 — introduces the phase and its purpose (KEEP, brief).
- §1.1 items 4–5, lines 43–44 — roadmap (KEEP, brief).
- §3, line 82 — comparative positioning against related work (KEEP, distinct function).
- §4.6, lines 139–153 — **canonical, full methodological description** (KEEP in full).
- §4.7, lines 154–158 — subjects table and selection confirmation (KEEP, this is data, not repeated argument).
- §6 Selection Bias, lines 338–340 — re-derives "reduces but does not eliminate" (SHORTEN, see §3 recommendations above).
- §7.1, lines 362–364 — restates the rule's purpose before adding genuinely new content (the residual-discretion enumeration) (**partial KEEP**: the residual-discretion list is new and valuable; only the first 1–2 sentences re-explaining the rule's purpose should be trimmed to a pointer).

**Canonical location:** §4.6 (methodology) for the rule itself; §7.1 (Threats to Validity) for the residual-discretion/limitations analysis of that rule — these are legitimately two different canonical locations for two different aspects (what the rule is vs. what it doesn't fix), and should both remain, with only the redundant framing sentences trimmed.

---

## 7. Estimated Number of Words Removable Without Changing Scientific Meaning

| Item | Location | Estimated savings |
|---|---|---:|
| Front-matter revision note | line 7 | ~150 |
| Related Work citation-verification flag | line 76 | ~20 |
| Related Work closing-paragraph trim | line 82 | ~15 |
| §4.2 contamination cross-check itemization | line 115 | ~70 |
| §4.3 asymmetry restatement | line 121 | ~55 |
| §4.8 E15 rebuild-fix sentence trim | line 170 | ~20 |
| §5.0 "earlier version... adversarial review" clause | line 199 | ~35 |
| §5.1 look-ahead numeric restatement (E3/E4/E9) | line 222 | ~50 |
| §5.5 look-ahead numeric restatement (E11/E13) | line 246 | ~30 |
| §5.6 E13 mutant-ID-level detail | line 282 | ~35 |
| §6 RQ1 asymmetry/look-ahead restatement | line 316 | ~60 |
| §6 Selection Bias re-derivation | lines 338–340 | ~40 |
| §7.1 rule-purpose re-explanation (before residual-discretion list) | line 364 | ~20 |
| §7.5 real-fault overlap with §7.8 | line 384 | ~25 |
| §8 limitations-paragraph light trim | line 412 | ~30 |
| Figure caption interpretive-clause trims (Figs. 2, 3, 6) | lines 224, 230, 288 | ~50 |
| Appendix A.1 light trim | lines 446–455 | ~40 |
| Appendix A.2 light trim | lines 457–468 | ~40 |
| Appendix A.3 → pointer to `reviewer-repair-change-log.md` | lines 470–479 | ~270 |
| Appendix A.4 → condensed + pointer to `paperpal-major-revision-change-log.md` | lines 481–492 | ~230 |
| **Total estimated removable** | | **~1,285–1,485 words** |

Rounding for the headline figures used in §2 above: **~1,350–1,550 words removable (~10–11% of the manuscript)**, entirely through shortening repeated explanations to cross-references, moving process/audit narration to already-existing artifact-repository files, and trimming duplicated interpretive clauses in figure captions — with **zero** results, citations, numbers, or sole-occurrence limitations affected.

---

## Summary Table: Classification Counts

| Classification | Approx. instances identified |
|---|---:|
| KEEP | ~35 |
| SHORTEN | ~16 |
| MOVE TO APPENDIX | 1 (§4.2 line 115 detail) |
| MOVE TO ARTIFACT REPOSITORY | 3 (Appendix A.3, A.4, citation-verification flag) |
| REMOVE AS DUPLICATE | 3 (figure-caption interpretive clauses only) |

No limitation stated only once anywhere in the manuscript is recommended for removal, shortening below its current level of disclosure, or relocation out of the main paper.
