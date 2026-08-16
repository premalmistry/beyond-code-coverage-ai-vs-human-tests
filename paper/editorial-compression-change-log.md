# Editorial Compression Change Log

**Scope:** `paper/paper_revised.md` and `paper/paper_revised.tex`. This log documents a conservative editorial compression pass applied per `paper/editorial-compression-plan.md`, plus the explicit removal of all revision-process meta-narrative (the front-matter "Note on this revision" and related language) and the hard rules given directly for this pass (protect RQ2, keep the E11 sensitivity analysis in full, keep the mutation-selection look-ahead disclosure prominent, preserve every experimental result, citation, and limitation).

---

## 1. Word Count

| | `paper_revised.md` |
|---|---:|
| **Before** (measured by `editorial-compression-plan.md`, §1, via `wc -w` on the manuscript immediately prior to this edit) | **≈13,957 words** |
| **After** (current, `wc -w paper/paper_revised.md`) | **12,894 words** |
| **Words removed** | **≈1,063 words** |
| **Percentage reduction** | **≈7.6%** |

For reference, `paper_revised.tex` is currently 12,275 words; the two files were edited in lockstep and are semantically synchronized (see §7 below), but the compression plan's word-count audit was scoped to the Markdown file only, so no separately documented "before" figure exists for the LaTeX file.

**Why the achieved reduction (≈7.6%) is smaller than the plan's estimated range (≈10–11%, ≈12,450–12,600 words):** the compression plan's per-section savings estimates assumed several passages classified "SHORTEN" would be cut to bare cross-references. Two hard requirements given directly for this pass took priority over those specific estimates and pulled the other way:

- **RQ2 protection.** The plan's §6 RQ1 estimate (~60 words) was achieved, but RQ2 was explicitly excluded from compression and, in addition, was made more precise — it now states exactly which of its six evidence-base experiments (E4, E9, E14, E15) carry zero mutation-selection look-ahead exposure and which (E3, E13) do not, rather than a single aggregate caveat. This added words rather than removing them.
- **Look-ahead prominence.** The plan recommended shortening the look-ahead restatements in §5.1, §5.6, and §6 to bare pointers. Per the hard rule that look-ahead remain "impossible to miss," these were instead kept as short but fully explicit, per-experiment statements (exact fractions and percentages for E3, E4, E9, E13, E14, E15 individually), which cost more words than the plan's bare-pointer recommendation but was necessary to keep the disclosure unambiguous at each point it matters.
- **E11 sensitivity analysis.** Kept in full in §5.5, as required, including its own paragraph in §6 RQ1 and a one-line summary in §8 — this is scientific content, not narrative, and was never a candidate for reduction.

Net effect: the manuscript is meaningfully shorter and less repetitive than before this pass, but the reduction is real rather than the plan's more aggressive upper estimate, because scientific-transparency requirements were prioritized over maximizing word savings wherever the two conflicted.

---

## 2. Sections Shortened

- Front matter: the "Note on this revision" blockquote removed entirely (not merely shortened, per explicit instruction), along with the title's parenthetical revision framing.
- §3 Related Work: citation-verification TODO parenthetical removed; closing paragraph trimmed.
- §4.2 (Existing Human Test Filter): per-experiment contamination cross-check narrative condensed to a single sentence.
- §4.3 (Independent AI Test Generation): asymmetry restatement shortened with a cross-reference to §7.2.
- §4.8 (Follow-Up Suite Freezing/Mutation/Integrity): E15 rebuild-fix sentence trimmed.
- §5.0 (Exploratory Results): "earlier version of this analysis... following adversarial review" revision-history clause removed, methodological reasoning kept.
- §5.1 / §5.5 / §5.6 (Results): repeated full numeric restatements of the look-ahead audit condensed to short, still-exact, per-experiment cross-references pointing to §7.3 as the canonical account.
- §6 Discussion (RQ1, Selection Bias Revisited): shortened per the plan; RQ2 explicitly excluded from compression per hard rule.
- §7.1 (Component Selection): "internally-committed-but-not-externally-pre-registered" simplified to "pre-declared (not externally pre-registered)."
- §7.5 (Construct Validity): shortened to remove duplication with §7.8, replaced with a cross-reference.
- §8 Conclusion: limitations paragraph lightly trimmed, cross-references added in place of repeated explanation.
- Figure captions: Figures 2, 3, and 6 trimmed to remove interpretive text already stated in the surrounding Results prose.
- Appendix A.1 (item 6) and A.2 (items 11, 18, 19): shortened / rephrased to remove revision-process meta-narrative while keeping the underlying verification claim.

## 3. Material Moved to Artifact Repository

| Manuscript material | Moved to | Manuscript now retains |
|---|---|---|
| Appendix A.3, Repair-Cycle Audit (was ~8 itemized checklist entries auditing the paper's own editing process) | `paper/reviewer-repair-change-log.md` | One pointer sentence |
| Appendix A.4, items covering pure editorial/production verification (title wording, citation formatting, Δ/MS definitional consistency, "no new experiment was run" checks) | `paper/paperpal-major-revision-change-log.md` | One pointer sentence; items 29–31 (E11 sensitivity-analysis verification and per-experiment look-ahead re-verification) are retained in full in the manuscript because they are scientifically substantive, not editorial |
| §3 citation-verification TODO ("flagged for external re-verification... see `paper/citation-verification-todo.md`") | Removed from the manuscript; the underlying tracking file is unchanged and untouched | Nothing — this was an internal workflow note, not scientific content |

---

## 4. Confirmation No Experimental Result Changed

Verified by three independent checks, all passing:

1. **Table-row diff.** Every data row in Tables 1–7 (`grep -E '^\| E[0-9]+'` in the Markdown, `grep -E '^E[0-9]+ &'` in the LaTeX) was compared against the pre-edit manuscript; all mutation scores, coverage percentages, test/assertion counts, and Δ values are byte-identical to before this edit.
2. **Full numeric-token extraction.** Every percentage-formatted number (`[0-9]+\.[0-9]+%`) and every fraction (`[0-9]+/[0-9]+`) in the current `paper_revised.md` and `paper_revised.tex` was extracted and compared as a multiset. The two files' percentage multisets are identical to each other (as they must be, being synchronized formats), and every value traces to Tables 1–7 or the pooled/union/sensitivity analyses in `research/pooled-mutation-analysis.md`, `research/union-mutation-analysis.md`, and `research/e11-sensitivity-analysis.md` — no value was altered, dropped, or introduced.
3. **Word-level prose diff.** Every prose passage that was shortened or reworded was reviewed with a word-level diff against its pre-edit form to confirm that only surrounding explanatory text changed, never the number itself.

No mutation score, coverage value, count, percentage, p-value-equivalent statistic, or win count differs from the pre-edit manuscript.

## 5. Confirmation No Citation Changed

The References list (Markdown) and `.bib`-driven bibliography (LaTeX) were left untouched in this pass except for the removal of the internal citation-verification TODO parenthetical in §3, which was a workflow note about re-checking a citation, not the citation itself. All eight references, their metadata, and their in-text citation keys are unchanged.

## 6. Confirmation No New Experiment, Test, or Mutant Was Introduced

All content added or retained during this pass (the E11 sensitivity analysis, the per-experiment look-ahead exposure statements, and Table 7's threat-impact summary) is a re-aggregation or re-statement of results already computed and stored in existing, pre-existing research artifacts (`research/e11-sensitivity-analysis.md`, `research/mutation-lookahead-audit.md`/`.csv`, `research/pooled-mutation-analysis.md`, `research/union-mutation-analysis.md`). No file under `research/` was created, modified, or re-run as part of this editorial pass; only manuscript prose in `paper/` was edited.
