# CICT 2026 Draft — Integrity Check

**Draft files:** `paper/cict-2026-draft.md`, `paper/cict-2026-draft.tex`  
**Frozen source of truth:** `paper/paper_submission_candidate_v1.md`, `paper/paper_submission_candidate_v1.tex`  
**Plan followed:** `paper/cict-2026-condensation-plan.md`  
**Bibliography:** `paper/references_revised.bib` (LaTeX `\bibliography{references_revised}`; no metadata changes)

**Check date:** 2026-08-16  
**Scope:** First CICT draft integrity only. No reviewer simulation. No new experiments/analyses.

---

## Summary

| Check | Result |
|---|---|
| Approximate body word count | **PASS** (~3,300–3,450 prose words excl. abstract/refs/table cells; within 3,200–3,600 target) |
| Tables included | **PASS** (3: A subjects, B MS E1–E15, C RQ2 dissociation) |
| Figures included | **PASS** (0) |
| Every result number vs frozen | **PASS** (see §Number audit) |
| Human-filter / AI-suite asymmetry present | **PASS** |
| E11 sensitivity present | **PASS** (+16.1 → +7.58 pp; 4/4; pooled +16.52 → +7.70) |
| 29/369 look-ahead disclosure present | **PASS** (Methods + Threats; 7.9%; E2 & E11) |
| E3/E4/E9/E13/E14/E15 preserved | **PASS** |
| E15 line-vs-region/function distinction correct | **PASS** |
| No AI-superiority claim | **PASS** |
| Mutation ≠ real faults limitation | **PASS** |
| Frozen source files unchanged | **PASS** (drafts are new files only) |

**Overall: PASS** — scientific story of RQ2-centered coverage insufficiency survived condensation.

---

## Structure Compliance

| Required | Present |
|---|---|
| Abstract | Yes (~165 words) |
| I. Introduction | Yes |
| II. Related Work | Yes (compressed; citations from frozen set only) |
| III. Methodology | Yes (incl. look-ahead in Methods) |
| IV. Results | Yes (RQ2 centerpiece; no separate Discussion) |
| V. Threats to Validity | Yes (all 7 required threats) |
| VI. Conclusion | Yes |
| References | Yes (same 10 keys as frozen Related Work set) |

---

## Number Audit (Draft ↔ Frozen)

All values below appear in `cict-2026-draft.md` / `.tex` and match `paper_submission_candidate_v1.md`.

### Table B — Mutation scores

| Exp. | Valid | Human MS | AI MS | Higher | Match |
|---|---:|---:|---:|---|---|
| E1 | 20 | 85.0% | 95.0% | AI | PASS |
| E2 | 27 | 70.4% | 85.2% | AI | PASS |
| E3 | 28 | 92.9% | 85.7% | Human | PASS |
| E4 | 25 | 96.0% | 88.0% | Human | PASS |
| E5 | 21 | 100.0% | 100.0% | Tie | PASS |
| E6 | 22 | 90.9% | 100.0% | AI | PASS |
| E7 | 23 | 91.3% | 100.0% | AI | PASS |
| E8 | 24 | 91.7% | 100.0% | AI | PASS |
| E9 | 26 | 96.2% | 88.5% | Human | PASS |
| E10 | 23 | 73.9% | 95.7% | AI | PASS |
| E11 | 24 | 41.7% | 91.7% | AI | PASS |
| E12 | 22 | 90.9% | 95.5% | AI | PASS |
| E13 | 23 | 91.3% | 100.0% | AI | PASS |
| E14 | 22 | 68.2% | 72.7% | AI | PASS |
| E15 | 24 | 54.2% | 66.7% | AI | PASS |

### Aggregates / sensitivity / look-ahead

| Quantity | Draft value | Frozen source | Match |
|---|---|---|---|
| Exploratory win split | 6 AI / 3 Human / 1 tie | §5.0 | PASS |
| Exploratory mean MS | AI 93.8%, Human 88.8% | §5.0 | PASS |
| Exploratory median paired Δ | +8.5 (range −8.0…+21.8) | §5.0 | PASS |
| Exploratory pooled | 93.31% / 88.70% (+4.60); 239 mutants | §5.0 | PASS |
| Follow-up win | 5/5 AI | §5.5 | PASS |
| Follow-up means | AI 85.3%, Human 69.2%; Δ +16.1; median +8.7; range +4.5…+50.0 | §5.5 | PASS |
| Follow-up pooled | 85.22% / 68.70% (+16.52); 115 mutants | §5.5 | PASS |
| E11 flags | 12/24 (50.0%); gap +50.0 pp | §5.5 / §7.3 | PASS |
| E11 sensitivity | 4/4; mean +7.58 pp; pooled +7.70 pp | §5.5 | PASS |
| Look-ahead audit | 29/369 (7.9%); E2 & E11 concentration | Abstract / §4.4 / §7.3 | PASS |

### Table C — Coverage / RQ2

| Exp. | Coverage / MS details in draft | Match |
|---|---|---|
| E3 | Line 99.03%; MS 92.9% vs 85.7%; look-ahead 3/28 conditioned | PASS |
| E4 | L/R/F 82.39%/78.85%/73.08%; MS 96.0% vs 88.0%; 0 flags | PASS |
| E9 | 100% L/R/F; MS 96.2% vs 88.5%; 0 flags | PASS |
| E13 | Line 92.95%; MS 91.3% vs 100.0%; 2/23 entire gap conditioned | PASS |
| E14 | Line AI 79.76% vs Human 47.62% (~32 pp); MS 68.2% vs 72.7%; 0 flags | PASS |
| E15 | Line Human 71.19% vs AI 44.92%; MS 54.2% vs 66.7%; region AI 78.12% vs 40.62%; function AI 66.67% vs 25.00%; 0 flags | PASS |
| E5 | Coverage 99.21%/96.00%/94.74%; both MS 100%; 21 mutants | PASS |
| Union | > max in 1/10 exploratory, 3/5 follow-up; not called synergy | PASS |

**E15 interpretation check:** Draft states Human has higher *line* coverage but lower MS; AI has higher *region* and *function* coverage; does **not** claim Human had higher overall structural coverage. **PASS**

---

## Framing / Limitation Checks

| Requirement | Evidence in draft | Result |
|---|---|---|
| Not framed as “AI beats Human” | Abstract leads with coverage problem; Results state 5/5 is descriptive / not superiority; Conclusion explicitly denies general AI superiority | PASS |
| Human-filter vs fresh AI-suite asymmetry | Abstract, Intro estimand, Methods §B, Threats | PASS |
| Look-ahead in Methodology (not only Threats) | Methods “Look-ahead disclosure” subsection with 29/369 | PASS |
| RQ2 primary / most Results space | Dedicated RQ2 subsection + Table C; narrow claim paragraph | PASS |
| Internally pre-declared, not externally pre-registered | Methods §D | PASS |
| Mutation ≠ real faults | Threats + Conclusion | PASS |
| Artifact pointer | Intro + Methods references to GitHub repo | PASS |
| No new citations | Only keys from `references_revised.bib` / frozen Related Work | PASS |
| No new experiments/analyses/mutants/tests | Condensation of frozen results only | PASS |

---

## Markdown ↔ LaTeX Sync

| Item | Status |
|---|---|
| Same section structure | PASS |
| Same Tables A/B/C content and numbers | PASS |
| Same scientific claims and caveats | PASS |
| LaTeX uses `\bibliography{references_revised}` | PASS |
| 0 figures in both | PASS |

---

## Frozen Files Unchanged

| File | Status |
|---|---|
| `paper/paper_submission_candidate_v1.md` | Not modified in this step |
| `paper/paper_submission_candidate_v1.tex` | Not modified in this step |
| `paper/references_revised.bib` | Not modified in this step |

New files only: `cict-2026-draft.md`, `cict-2026-draft.tex`, `cict-2026-draft-integrity-check.md`.

---

## Notes / Residual Risks (not failures)

1. **Page fit:** First draft targets ~3.3k body words + 3 tables + refs. Table C is wide (`table*` in LaTeX); first IEEE compile may need minor caption/column tightening to stay ≤6 pages—numbers must not change.
2. **Word-count method:** Body prose estimate excludes markdown table rows and the References list; includes section headings and in-text percentages. Exact `wc` may differ by ±100 depending on whether table cells are counted.
3. **Abstract:** Intentionally omits the frozen manuscript’s union sentence and “5 of 15” union phrasing to save space and avoid an AI-win lead; union remains as ≤2 sentences in Results, matching the plan.

---

## STOP

Integrity check complete. Frozen manuscript untouched. No reviewer simulation performed.
