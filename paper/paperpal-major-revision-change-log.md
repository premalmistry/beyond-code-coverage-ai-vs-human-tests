# Paperpal Major-Revision Change Log

This log records the changes made in the **final substantive revision pass**,
which addressed a Paperpal "major revision" review received after the
adversarial-review repair cycle (`paper/conference-review-audit.md`,
`paper/reviewer-repair-change-log.md`). No new experiments, tests, or mutants
were run to produce this revision. All changes are framing, sensitivity
analysis on already-frozen results, presentation, and compression of
repeated explanations.

## Title

**Evaluation.** The prior title, "Beyond Code Coverage: An Empirical
Comparison of AI-Generated and Human-Written Unit Tests Using Mutation
Testing," still invites an "AI ability vs. Human ability" reading that the
study does not support (§1 states the actual estimand).

**Three candidates considered:**

1. **Beyond Code Coverage: Comparing AI-Generated Tests with Existing Human
   Test Filters Using Mutation Analysis** — closely mirrors the user's
   suggested framing; explicitly names "existing Human test filters" rather
   than "human-written tests," removing the ability-comparison connotation
   while remaining readable.
2. Beyond Code Coverage: A Paired Mutation-Analysis Study of AI-Generated and
   Existing Human Test Suites in Swift — more explicit about the paired
   design and Swift scope, but longer and less punchy; "Swift" in the title
   may undersell the generalizable methodological contribution.
3. Coverage Parity, Mutation Divergence: A Paired Study of AI-Generated and
   Existing Human-Filter Test Suites — leads with the central finding
   rather than the method, which is more attention-grabbing but buries the
   "Beyond Code Coverage" framing that ties this paper to its motivating
   claim and to how it will likely be searched for/cited.

**Decision: Candidate 1.** It most accurately describes the actual
comparison (existing filters vs. freshly generated suites, not "human
tests" in general), remains close to the paper's established "Beyond Code
Coverage" framing, and is the most readable of the three. Applied to both
`paper/paper_revised.md` (H1 title) and `paper/paper_revised.tex`
(`\title{}`).

**Status: RESOLVED.**

## Concern-by-concern log

| Concern (Paperpal) | Change made | Section | Status |
|---|---|---|---|
| Comparison asymmetry (Human filter vs. fresh AI suite) not stated until Threats | Asymmetry and study estimand now stated explicitly in Abstract (first two sentences) and Introduction (new "What this study does and does not estimate" paragraph) | Abstract, §1 | RESOLVED |
| E11's mutation-score gap and its look-ahead exposure not quantified against the rest of the follow-up phase | New sensitivity analysis excluding E11 (`research/e11-sensitivity-analysis.md`), added to §5.5 and Conclusion: direction unchanged (4/4 AI-higher), magnitude roughly halves (+16.1pp → +7.58pp mean; +16.52pp → +7.70pp pooled) | §5.5, §8, `research/e11-sensitivity-analysis.md` | MITIGATED (quantified, not eliminated — E13 still has residual exposure) |
| RQ2's evidentiary base not checked against the look-ahead audit; risk that Paperpal's (or any reviewer's) characterization of exposure is assumed rather than verified | Exact look-ahead percentages re-verified per experiment (E3 3/28=10.7%, E4 0/26, E9 0/26, E13 2/23=8.7%, E14 0/22, E15 0/24) and stated in §5.1, §5.6, and RQ2 discussion; explicit statement that E13's entire gap and E3's entire human-only-kill set are attributable to flagged mutants | §5.1, §5.6, §6 (RQ2) | MITIGATED |
| Mutation-selection look-ahead explanation repeated at full length in multiple sections, making the paper read like an audit report | Full explanation retained once in §7.3 (canonical); §4.4's explanation trimmed to a two-sentence summary with a forward reference; "Selection Bias, Revisited" (§6) trimmed to remove restated detail already in §7.1/Table 7 | §4.4, §6, §7.3 | RESOLVED |
| Threats to Validity organized as an undifferentiated list, unclear which RQ each threat affects | New compact impact table (Table 7: Threat / Primarily affects / Consequence) added at the top of §7, with an interpretive paragraph stating RQ1 is most vulnerable to effort/freshness and look-ahead, RQ2 is narrower and E11-independent, RQ3 is descriptive | §7 (Table 7) | RESOLVED |
| Reported means/medians/win-counts could be read as population-level estimates | Explicit descriptive-statistics-only philosophy statement added to the start of §5 and to §7.7 | §5, §7.7 | RESOLVED |
| Novelty claim ("coverage does not imply effectiveness") not distinguished from prior literature that already establishes this | Contributions (§1.1) rewritten around a 7-part combination (paired design, leakage controls, mutation-beyond-coverage instrument, 10+5 phase structure, look-ahead self-audit + sensitivity analysis, concrete misleading-ranking cases); explicit statement that the general coverage-limitation claim is not itself the contribution; "first study" language avoided except the qualified "to our knowledge... has not combined these elements" | §1.1 | RESOLVED |
| Related Work did not clearly state what Lops et al., Vathana et al., and Zhao et al. individually contribute vs. what this paper adds | Restructured into three explicit "What we add" paragraphs, one per study, using only already-cited material | §3 | RESOLVED |
| Union/complementarity analysis risked being read as the paper's headline finding rather than supporting evidence | Abstract, Contributions, and Conclusion keep the union result secondary to the coverage/mutation-dissociation finding; RQ3 discussion and §5.7 explicitly note unique kills may partly reflect suite-size/freshness rather than a stable behavioral distinction | Abstract, §1.1, §6 (RQ3), §8 | MITIGATED (framing improved; underlying suite-size confound is not resolvable from this data) |
| Manuscript increasingly defensive/repetitive across pre-declared-vs-preregistered, Human-filter-vs-AI-suite, and no-AI-superiority statements | Compression pass: Introduction's phase-overview paragraph trimmed of restated asymmetry/pre-registration detail (now cross-references §4.6 and the new Introduction estimand paragraph); §7.1/§7.2 trimmed of detail now carried by Table 7 | §1, §4, §7 | MITIGATED (some necessary repetition remains by design, e.g., phase separation reminders in §5/§6) |
| Abstract too long / led with 5/5 win count | Rewritten to ~228 words (target 180–220, close); leads with the Human-filter/AI-suite asymmetry, states the coverage/mutation finding as the main result, does not mention "5/5" at all | Abstract | RESOLVED |
| Central coverage claim occasionally stated more broadly than the evidence ("insufficient to infer...") | Standardized to "insufficient on their own to *determine relative* mutation-based test effectiveness" throughout Abstract, Contributions, RQ2, Conclusion; E15's line-vs-region/function distinction restated precisely everywhere E15 appears | Abstract, §1.1, §6, §8 | RESOLVED |
| Formatting artifacts: Δ and MS defined implicitly / more than once | Δ now defined exactly once, in the Table 4 caption (first use); MS defined exactly once, in the §4.4 equation; Table 7's caption cross-references both instead of redefining | Table 4, §4.4, Table 7 | RESOLVED |
| Bibliography not internally re-checked in this pass | Internal (no-web-search) citation audit performed; three load-bearing citations (Vathana et al. 2026, Lops et al. 2025, Zhao et al. 2026) flagged for external re-verification before submission; no citation altered from memory | `paper/citation-verification-todo.md` | UNRESOLVED (external verification explicitly deferred to a human before submission, by design) |
| Human/AI equal-effort construct validity | Restated precisely as the study's estimand in §1; §7.2 retained as the full explanation | §1, §7.2 | UNRESOLVED BY DESIGN (this is a scope limitation of the study design itself, not a fixable presentation issue; it is now stated on page 1 rather than only in Threats) |

## Notes on what remains genuinely open

- **Mutation-selection look-ahead** (E2, E11 most heavily; smaller, quantified
  traces in E3, E6, E7, E13) is disclosed, quantified, and now
  sensitivity-tested (E11 sensitivity analysis), but it is not eliminated:
  the underlying mutation plans were not redesigned or re-run, per the hard
  rule against modifying frozen artifacts. **MITIGATED, not RESOLVED.**
- **Human/AI equal-effort construct validity** is a designed-in scope
  limitation, not a bug: the study deliberately compares existing filters to
  freshly generated suites because that is the realistic deployment
  scenario (using an LLM to generate tests for an existing, imperfectly
  tested codebase), not because equal-effort data was unavailable. It is
  now stated as the estimand on page 1. **UNRESOLVED BY DESIGN.**
- **Citation verification** (Vathana et al. 2026 in particular) requires a
  human to check the primary source before submission; this pass could not
  perform that check under the "no web search" constraint. **UNRESOLVED,
  explicitly deferred.**
