# Revision Change Log: Incorporating Confirmatory Experiments E11–E15

**Scope of this revision:** Adds the confirmatory phase (E11–E15) to `paper/paper_revised.md` and `paper/paper_revised.tex`, on top of the previously revised ten-experiment (E1–E10) manuscript. The exploratory phase is **not** re-analyzed, recomputed, or renumbered; every E1–E10 number, table, and figure carried over unchanged. Sources used: `research/confirmatory-e11-e15.csv`, `research/confirmatory-e11-e15-analysis.md`, `research/confirmatory-paper-update-plan.md`, and the underlying `research/experiment-{11..15}-*` artifacts.

---

## Sections changed

| Section (both `.md`/`.tex`) | Nature of change |
|---|---|
| Title-page note / preamble comment | Extended to describe the two-phase design and that E1–E10 numbers are unchanged. |
| Abstract | Rewritten to describe two phases: exploratory summary preserved verbatim in substance; confirmatory summary added (5/5, means, E13/E15 highlights). Headline kept as the coverage/mutation dissociation, not "AI wins." |
| §1 Introduction | Added one paragraph explaining the two-phase rationale (exploratory found the pattern; confirmatory tests whether it survives neutral selection). Original motivation paragraphs preserved unchanged. |
| §1.1 Contributions | Expanded from 3 to 5 bullets/items: added confirmatory protocol, confirmatory replication, and complementarity findings as separate items. Original 3 exploratory-phase claims preserved. |
| §2 Research Questions | RQ1–RQ3 unchanged in wording. RQ4 relabeled "(secondary, descriptive)" per the instruction to de-emphasize suite-size as a major RQ, without deleting it. Added a linking paragraph pointing to phase-specific result subsections. |
| §3 Related Work | Unchanged in substance; added one short paragraph at the end connecting the two-phase design to the literature (no rewrite of existing citations/claims). |
| §4 Methodology | Added an orienting paragraph. Relabeled existing subsections 4.1–4.5 as "(Exploratory Phase)" without changing their content. Added three new subsections: 4.6 (confirmatory rationale + the 6-step neutral selection rule), 4.7 (confirmatory subjects table), 4.8 (confirmatory suite freezing/mutation/integrity, including the E15 human-filter and `@_transparent`/`@inlinable` rebuild notes). |
| §5 Results | Added an orienting paragraph. Relabeled 5.0–5.4 as exploratory (captions now say "Exploratory phase (E1–E10)"); content and numbers unchanged. Added 5.5 (confirmatory results + Table 4 + Figures 4–5), 5.6 (confirmatory coverage–mutation dissociation: E13, E15, E14 in that order), 5.7 (confirmatory complementarity). |
| §6 Discussion | RQ1–RQ4 discussions rewritten to present exploratory and confirmatory evidence side by side, explicitly phase-labeled, with an explicit warning against pooling win counts (e.g., against "AI won 11 of 15"). Added a new "Selection Bias, Revisited" subsection connecting confirmatory results back to the exploratory phase's own stated future-work recommendation. |
| §7 Threats to Validity | Internal/Construct validity extended to cover both phases. External validity split into "component selection" (rewritten to describe the neutral rule and explicitly state bias is *reduced, not eliminated*, with an enumerated list of remaining discretion points) and "model and tooling" (new). Conclusion validity extended to address non-pooling of significance tests across phases. Reproducibility extended to describe confirmatory artifacts. |
| §8 Conclusion | Rewritten around the two-phase narrative: exploratory finding → confirmatory test → replication (E13) and extension (E15, E14) → the single cross-phase claim (coverage insufficiency) as primary, complementarity as secondary, explicit non-claim of AI superiority, updated future-work list. |
| Appendix A. Audit Checklist | Split into A.1 (exploratory, items 1–10, unchanged) and A.2 (confirmatory, items 11–20, new), each traceable to a specific artifact or cross-check performed during this revision. |
| References | Unchanged — no new citations added or removed in this revision. |

## Tables added

- **Table 1b** (`.md`) / `tab:subjects2` (`.tex`): confirmatory-phase subjects (E11–E15, repository, component).
- **Table 4** (`.md`) / `tab:confresults` (`.tex`): confirmatory mutation scores, valid-mutant counts, and AI−Human deltas per experiment.

Existing exploratory Table 1 (subjects), Table 2 (mutation scores), Table 3 (test/assertion counts) are unchanged in content; captions updated to say "Exploratory phase (E1–E10)" for clarity. No table combines E1–E10 and E11–E15 rows.

## Figures added/updated

- **Figure 4** (`figure4_confirmatory_mutation_scores.png`, new): confirmatory mutation scores by suite, analogous to Figure 1.
- **Figure 5** (`figure5_confirmatory_paired_differences.png`, new): confirmatory paired AI−Human differences, analogous to Figure 3.
- **Figure 6** (`figure6_confirmatory_coverage_dissociation.png`, new): three-panel line-coverage-vs-mutation-score comparison for E13, E15, E14.
- Figures 1–3 (exploratory) are unchanged; captions updated to say "Exploratory phase" for clarity.
- New figures were generated with `paper/figures/generate_confirmatory_figures.py` (added in this revision) directly from `research/confirmatory-e11-e15.csv` values, so they are reproducible and auditable against Table 4.

## Claims strengthened

- The central claim — "structural code coverage alone is insufficient to infer mutation-based fault-detection effectiveness" — is now supported by evidence from **both** phases (E3/E4/E9 exploratory, E13/E15/E14 confirmatory), and the paper now states this survived a neutral-selection test rather than resting solely on exploratory, non-neutrally-selected components.
- The complementary-detection finding (human-only vs. AI-only kills) is now supported by a second, independently selected sample (8 human-only / 27 AI-only / 9 shared survivors across E11–E15), in addition to the exploratory pattern.
- The external-validity threat around component selection is now partially *addressed* (not just *disclosed*) via the confirmatory protocol, and the paper documents this rather than merely flagging it as a limitation for future work.

## Claims weakened / qualified

- The exploratory phase's observation that human suites sometimes win on mutation score (E3, E4, E9) is explicitly noted as **not replicated** in the confirmatory sample (0/5 human wins). The paper is careful to scope any "human sometimes wins" language to the exploratory phase and specific oracle styles, not to a combined sample.
- The exploratory phase's descriptive win split (6-3-1, ~5 pp mean gap, non-significant) cannot be generalized to "AI usually wins by a small margin" — the confirmatory sample shows a larger, more consistent gap (5/5, +16.1 pp mean), and the paper explicitly refuses to average the two phases' win rates together, since doing so in either direction would overstate precision the study does not have.
- Both phases' RQ1 win counts are now explicitly labeled as *descriptive*, and the paper adds an explicit sentence warning against constructing a fifteen-experiment pooled win rate.

## Threats to Validity updated

- Component-selection-bias language changed from "future work should use a neutral protocol" (prior revision) to "we executed a neutral protocol in E11–E15; it reduces but does not eliminate the concern," with an enumerated list of remaining discretion points (eligibility-criteria design, repository choice inherited from exploratory phase, human-filter judgment calls, small confirmatory *n*).
- Added an explicit "model and tooling" external-validity paragraph (single LLM, single agent, single research team, both phases).
- Conclusion validity extended to explain why the two phases' scores were **not** pooled into one significance test (no pre-registered pooling rule; avoiding post-hoc researcher-degrees-of-freedom).
- Reproducibility extended to describe exactly what confirmatory artifacts exist and how the selection decision for each confirmatory component is independently auditable.

## Unresolved TODOs (carried into future work, not resolved by this revision)

- No independent second annotator for equivalent-mutant classification in either phase (still a single-annotator design).
- No pre-registered power analysis or formal significance test for the confirmatory phase (intentionally left as descriptive, per instructions).
- The confirmatory phase still reuses the same five repositories as the exploratory phase; it does not test generalization to new ecosystems, languages, or LLMs.
- The eligibility criteria used to define the confirmatory-phase "population" of components are themselves researcher-designed and not further validated (e.g., via an independent audit of the exclusion decisions beyond the candidate-selection records).
- No real-historical-defect validation was performed in either phase; both phases measure sensitivity to seeded mutants only.
- A fully systematic (e.g., PRISMA-style) related-work search remains future work (unchanged from the prior revision).

---

## Self-audit (performed against the manuscript after all edits above)

1. **Are exploratory and confirmatory phases clearly separated?** Yes — every results/discussion/threats paragraph is phase-labeled; §5 and Appendix A are split into exploratory and confirmatory subsections; no merged table or figure spans both phases.
2. **Did we accidentally imply E11–E15 were randomized?** No — §4.6/`sec:confselection` explicitly states the rule "does not make the sample random" and that it was "not describe[d]... as randomized"; checked via grep for "randomiz" — all other occurrences refer to mutant execution order or the excluded randomized human test, not component selection.
3. **Did we overstate 5/5 AI wins?** No — every mention of 5/5 is immediately qualified as descriptive, *n*=5, not a significance test, and not to be pooled with the exploratory 6-3-1 split; §6 RQ1 explicitly rejects the "AI won 11 of 15" framing.
4. **Is the main claim supported by BOTH phases?** Yes — §6 RQ2 and §8 Conclusion cite E3/E4/E9 (exploratory) and E13/E15/E14 (confirmatory) together as the basis for the central coverage-insufficiency claim.
5. **Are E13 and E15 described accurately?** Yes, checked against `research/confirmatory-e11-e15.csv` and `research/experiment-{13,15}-summary.md`: E13 line coverage 92.95%/92.95%, MS 91.3%/100.0%; E15 line coverage 71.19%/44.92% (human higher), MS 54.2%/66.7% (AI higher), and the paper correctly notes region/function coverage favored AI in E15 rather than generalizing "all coverage metrics failed."
6. **Are Human-only kills represented fairly?** Yes — §5.7/§6 RQ3 report the 8 human-only kills with concrete examples (E11 string order, E14 parse try-order/errors, E15 scale-sensitive rescaling) rather than omitting them in favor of the larger AI-only count.
7. **Did we equate mutation score with real bugs anywhere?** No — Construct Validity explicitly states "we do not equate a mutant kill with detection of a real bug anywhere in this paper," and no other passage uses "bug" or "fault" to describe a mutant kill without the "mutation-based" or "seeded" qualifier.
8. **Did we claim selection bias was eliminated rather than reduced?** No — verified by direct search; every occurrence uses "reduce/reduces," "not eliminate," or explicitly states "We do not claim this eliminates component-selection bias."
9. **Are all numbers consistent with `confirmatory-e11-e15.csv`?** Yes — Table 4, the 5/5 win count, mean scores (Human 69.2%/AI 85.3%), mean/median paired differences (+16.1/+8.7 pp), and the 8/27/9 kill-partition counts were cross-checked line-by-line against the CSV and `confirmatory-e11-e15-analysis.md` before writing.
10. **Are Markdown and LaTeX semantically synchronized?** Yes — verified programmatically (brace/environment balance, `\cite`/bibliography key parity, and `\label`/`\ref` completeness all checked with no mismatches) and by side-by-side section comparison; both documents carry the same section structure, the same new subsections (4.6–4.8, 5.5–5.7), the same Table 1b/Table 4 contents, and the same six-figure set with matching filenames and captions.
11. **Are tables and figures internally consistent?** Yes — Figure numbering was corrected during drafting so figures appear in ascending order in the text (4, 5, 6) and figure filenames were renamed to match (`figure5_confirmatory_paired_differences.png`, `figure6_confirmatory_coverage_dissociation.png`); the figure-generation script was updated to match the final filenames for future reproducibility.
12. **Are limitations prominent enough?** Yes — the confirmatory *n*=5, non-random repository selection, single-LLM/single-agent scope, and non-pooling rationale each appear in at least two places (Results caveats, Discussion RQ1, and Threats to Validity), not buried in a single footnote.

No issues requiring further fixes were found in this self-audit. No additional experiments were run, Experiment #16 was not created, and no frozen E1–E15 artifact was modified in the course of this revision.
