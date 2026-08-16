# CICT 2026 Condensation Plan

**Source of truth (frozen; do not modify):**
- `paper/paper_submission_candidate_v1.md`
- `paper/paper_submission_candidate_v1.tex`
- `paper/references_revised.bib`

**Target:** IEEE double-column, **≤ 6 pages** including figures, tables, and references.

**Scope of this document:** Analysis and planning only. Do not draft the CICT manuscript yet. Do not change results, citations, experiments, or analyses.

**Scientific framing (non-negotiable):**
- Central claim remains coverage insufficiency for relative mutation effectiveness (llvm-cov line/region/function).
- Paper must **not** read as “AI beats Human.”
- Preserve Human-filter vs fresh AI-suite asymmetry.
- Preserve mutation-selection look-ahead as a first-class limitation.

**Rough baseline:** frozen manuscript ≈ 12,900 words (Markdown body including tables/appendix). A typical IEEE 6-page double-column paper needs roughly **3,800–4,800 words of body prose** plus compact tables/refs; the CICT version requires cutting to ~**30–40%** of the frozen length, mostly by moving detail to the artifact repo and collapsing repetition—not by dropping the central science.

---

## Classification Summary (Items 1–16 + Extras)

| # | Item | Classification | Rationale |
|---|---|---|---|
| 1 | Problem / motivation | **MUST KEEP** | Establishes why coverage is an inadequate sole proxy; needed for any reader. |
| 2 | Research questions | **COMPRESS** | Keep RQ1–RQ2 as primary; fold RQ3 into one Results/Discussion sentence; demote RQ4 to a clause or drop as numbered RQ. |
| 3 | E1–E10 exploratory design | **COMPRESS** | Keep two-phase framing and subject list in a compact table; drop LOC/exec-line columns and long selection narrative. |
| 4 | E11–E15 neutral-selection follow-up | **MUST KEEP** (compressed) | Essential to show RQ2 is not an artifact of exploratory selection bias. |
| 5 | Human-filter / AI-suite methodology | **MUST KEEP** (compressed) | Core estimand; must be clear on page 1 and in Methods. |
| 6 | Leakage / contamination controls | **COMPRESS** | One short paragraph + artifact pointer; drop E1–E10 evolution chronology and E5 incident narrative. |
| 7 | Mutation methodology | **MUST KEEP** (compressed) | Freeze-before-mutation, MS formula, equivalence rule, look-ahead disclosure in brief. |
| 8 | Core E1–E15 results | **MUST KEEP** (compressed) | Combined results table with Human/AI MS and phase label. |
| 9 | E3/E4/E9 coverage-equal dissociation | **MUST KEEP** | Core RQ2 evidence; include look-ahead qualifiers (E4/E9 clean; E3 conditioned). |
| 10 | E13/E14/E15 follow-up evidence | **MUST KEEP** | Shows pattern under neutral selection; E15 inverse ranking is high-value. |
| 11 | E11 sensitivity analysis | **COMPRESS** | Keep headline numbers (+16.1 → +7.58 pp / 4/4); derivation → artifact. |
| 12 | Union mutation analysis | **COMPRESS** | Keep one summary sentence (union > max in 1/10 exploratory, 3/5 follow-up); drop Table 6 and per-experiment union prose. |
| 13 | Mutation-selection look-ahead audit | **MUST KEEP** (compressed) | Top-line 29/369 (7.9%), concentration in E2/E11; full audit table → artifact. |
| 14 | Threats to validity | **MUST KEEP** (compressed) | Dedicated short section listing required threats (see §10). |
| 15 | Related work | **COMPRESS** | ~½ column establishing four points; cite all necessary papers briefly. |
| 16 | Conclusion | **MUST KEEP** (compressed) | Restate central RQ2 claim + no AI-superiority claim + two limitations. |
| — | Numbered contributions list (§1.1) | **COMPRESS** | Fold 2–3 bullets into Intro; drop 7-item list. |
| — | Separate Discussion (§6) | **COMPRESS / MERGE** | Merge RQ answers into Results + short Discussion/Conclusion; avoid re-explaining Methods. |
| — | RQ3 behavioral-gap taxonomy | **COMPRESS** | One paragraph max; no universal-taxonomy claim. |
| — | RQ4 suite-size analysis | **REMOVE FROM 6-PAGE VERSION** (or 1 sentence) | Secondary; cite Zhao; details → artifact / full manuscript. |
| — | Integrity / reproducibility (§4.5, §7.9) | **MOVE TO ARTIFACT** (keep 1 sentence + URL) | SHA inventories, fingerprints, JSONL → repo. |
| — | Appendix A audit checklist | **REMOVE FROM 6-PAGE VERSION** | Entirely → artifact / full manuscript. |
| — | Table 7 threats-impact table | **REMOVE FROM 6-PAGE VERSION** | Replace with prose bullets in compact Threats. |
| — | Per-experiment kill narratives (E6–E8, E10) | **COMPRESS** | Optional one-sentence “coverage-gap cases exist”; not needed for central claim. |
| — | E5 counterexample | **COMPRESS** | Keep one sentence: coverage parity can also coincide with MS parity. |

---

## 1. Proposed 6-Page Structure

| Sec | Title | Role |
|---|---|---|
| — | Title, authors, abstract, keywords | Self-contained; asymmetry + RQ2 conclusion + look-ahead top-line |
| I | Introduction | Motivation; estimand (Human filter vs AI suite); two phases; 2–3 contribution bullets; RQs (RQ1–RQ2 primary) |
| II | Related Work | Coverage proxy; LLM unit-test empirics; mutation-as-evaluation vs mutation-as-feedback; what we add |
| III | Methodology | Subjects (one combined table); Human filter + AI generation; leakage (brief); mutation design + look-ahead disclosure; neutral-selection rule (brief) |
| IV | Results | Combined MS table; descriptive RQ1 summary + E11 sensitivity; RQ2 dissociation cases (E3/E4/E9, E13/E14/E15); optional 1-sentence union |
| V | Threats to Validity | Compact multi-threat paragraph or short bullets (required list) |
| VI | Conclusion | Central claim; no AI-superiority; limitations; artifact URL; future work (2 sentences) |
| — | References | All necessary citations (see Related Work plan) |

**Not in CICT version as separate sections:** full Discussion (§6), Reproducibility (§7.9), Appendix A, union tables, suite-size tables, six figures.

---

## 2. Approximate Page Budget (IEEE Double-Column)

Realistic IEEE 10pt double-column budgeting (tables and refs count toward the 6 pages):

| Block | Pages | Notes |
|---|---:|---|
| Title + authors + Abstract + keywords | 0.35 | Abstract ~150–180 words |
| I. Introduction | 0.70 | Estimand + phases + RQs; no long contribution list |
| II. Related Work | 0.45 | Dense citation paragraph(s), not three long case studies |
| III. Methodology | 1.20 | Includes **Table A** (subjects) + **brief** protocol |
| IV. Results | 1.90 | Includes **Table B** (all 15 MS) + **Table C** (RQ2 coverage–MS cases); optional tiny Fig. 1 |
| V. Threats to Validity | 0.55 | All required threats in compressed form |
| VI. Conclusion | 0.35 | Central claim + caveats + artifact link |
| References | 0.50 | ~10 entries; dense IEEEtran style |
| **Total** | **≈ 6.00** | Leave ~0.05–0.10 contingency by trimming Intro/Related Work if tables overflow |

**If over length:** drop optional figure first; then shorten Related Work; then cut RQ3/union sentence; never cut RQ2 cases, asymmetry, or look-ahead.

---

## 3. MUST KEEP Scientific Claims

These claims must appear (possibly compressed) in the 6-page paper:

1. **Central (RQ2):** Line, region, and function coverage (llvm-cov) are insufficient on their own to determine relative mutation-based test effectiveness across these case studies.
2. **Estimand:** Comparison is of **existing researcher-selected Human test filters** vs **freshly generated, implementation-aware, iteratively repaired AI suites**—not matched-effort human vs AI ability.
3. **Two phases:** Exploratory E1–E10 (later components partly chosen to distinguish suites) and neutral-selection follow-up E11–E15 (pre-declared eligibility + alphabetical first; not externally pre-registered).
4. **Exploratory RQ2 instances:** E3, E4, E9 — identical (or all-metric) coverage with different MS; E4 and E9 have **zero** look-ahead flags; E3 is conditioned.
5. **Follow-up RQ2 instances:** E13 identical line coverage / different MS (gap conditioned on 2 flagged mutants); E15 **inverse** line-coverage ranking with higher Human line coverage but lower Human MS (0 flagged); E14 large coverage gap / small MS gap (0 flagged).
6. **RQ2 does not depend on E11;** four zero-look-ahead experiments (E4, E9, E14, E15) suffice for the pattern.
7. **E5:** Coverage parity can also coincide with MS parity (coverage is uninformative, not predictive of a gap).
8. **Descriptive RQ1:** Exploratory mixed (6 AI / 3 Human / 1 tie); follow-up 5/5 AI-higher descriptively—**not** evidence of general AI superiority; phases not pooled.
9. **E11 sensitivity:** Excluding E11 leaves 4/4 direction but roughly halves mean Δ (+16.1 → +7.58 pp).
10. **Look-ahead:** 29/369 (7.9%) planned mutants suite-aware; concentrated in E2 and E11; affected gaps are conditional.
11. **Mutation ≠ real faults:** Findings are mutation-based; no claim about historical bug detection.
12. **Artifact availability:** Point to `https://github.com/premalmistry/beyond-code-coverage-ai-vs-human-tests`.

---

## 4. Material to Compress

| Frozen location | How to compress for CICT |
|---|---|
| Abstract | Keep asymmetry, two phases, RQ2 conclusion, look-ahead top-line; drop union sentence if needed for space. |
| §1 “What this study does and does not estimate” | Keep as **one tight paragraph** (not a full column). |
| §1.1 Contributions (7 items) | Collapse to **2–3 bullets** (paired design + isolation; mutation evaluation; exploratory + neutral follow-up + quantified look-ahead). |
| §2 RQs | State RQ1–RQ2 explicitly; RQ3 optional one-liner; RQ4 omit as numbered RQ. |
| §3 Related Work | Replace three long “What we add” case studies with **one paragraph** differentiating Lops / Vathana / Zhao / MuTAP–MutGen (see § Related Work below). |
| §4.1–§4.7 Methods | Single Methods section: combined subject table; 1 para Human filter; 1 para AI gen (Grok 4.5 / Cursor 3.15.19 / defaults / iterative repair); 1 para mutation + look-ahead; 1 short para neutral rule (eligibility + alphabetical first + freeze + accept). |
| §4.2 contamination evolution | “Qualified filters + post-E6 automated name logging; one caught/re-run incident; details in artifact.” |
| §5.0 / §5.5 numeric restatement | One combined results table + short means/medians; no long anti-significance essays—one sentence: descriptive only, not population inference. |
| §5.1 / §5.6 RQ2 narratives | Keep exact MS and coverage numbers for the six key experiments; cut mutant-ID prose except where needed for look-ahead (E13: gap = two suite-aware mutants). |
| §5.5 sensitivity | Keep the three headline numbers; drop derivation narrative. |
| §5.2 / §5.4 / §5.4b / §5.7 | Cover-gap cases and union → 1–2 sentences total. |
| §6 Discussion | Do **not** duplicate Methods/Threats; fold into Results closing + Conclusion. |
| §7 Threats | See §10 sketch; drop Table 7 and long subsections. |
| §8 Conclusion | 1 short paragraph central claim + 1 paragraph no-superiority + limitations + artifact. |

---

## 5. Material to Move to Artifacts

Point to the public repo rather than reproducing:

| Material | Artifact location (existing or to be linked) |
|---|---|
| Complete per-experiment mutation plans & mutant sources | `research/experiment-N-mutation-*.md` / mutant files |
| SHA / fingerprint details | Per-experiment baseline & integrity records |
| Exact executed-test inventories | Mutation run logs / JSONL |
| Contamination audit details & E5 incident archive | Experiment baselines; candidate-selection notes |
| Full look-ahead audit table (369 mutants) | `research/mutation-lookahead-audit.md` / `.csv` |
| Union-analysis details & formulas | `research/union-mutation-analysis.md` / `.csv` |
| Sensitivity-analysis derivation | `research/e11-sensitivity-analysis.md` |
| Pooled mutant-weighted computations | `research/pooled-mutation-analysis.md` |
| Neutral-selection eligible inventories | `research/experiment-{11..15}-candidate-selection.md` |
| Extended validity / full Threats prose | Frozen full manuscript §7 |
| Research audit checklists (Appendix A) | Frozen manuscript Appendix A + change-log files |
| Suite size / assertion tables (Tables 3 & 5) | Frozen manuscript / research baselines |
| LOC / executable-line subject detail | Frozen Table 1 |
| SciPy significance-test reproducibility record | Appendix A.1 item 10 (full manuscript only) |
| E15 `@_transparent` rebuild-fix narrative | `research/experiment-15-mutation-results.md` |

**CICT paper sentence (template):** “Full protocols, fingerprints, mutation plans, look-ahead audit, and sensitivity derivations are available at [repo URL].”

---

## 6. Material to Remove from the 6-Page Version

Remove from CICT (retain in frozen full manuscript / artifacts only):

- Entire **Appendix A** audit checklist
- **Table 7** threats-impact table
- **Tables 3 and 5** (test/assertion counts)—replace with one sentence: AI suites larger in 9/10 exploratory and 5/5 follow-up
- **Table 6** (union MS)—replace with one sentence of counts
- **Figures 1–5** (redundant with MS table); prefer table over bars
- Long **Discussion** restatements of Methods and look-ahead numbers already in Results/Threats
- **RQ4** as a full subsection; Zhao citation can cover the “size ≠ effectiveness” pointer
- Exploratory **union near-zero-gain** multi-paragraph analysis
- Per-mutant kill storytelling beyond the six RQ2 experiments (E6–E8, E10 detail)
- Revision-process / change-log / Paperpal language (already absent from candidate—keep it that way)
- Internal file-path verbosity in prose (cite repo once)

---

## 7. Tables: Keep / Combine / Remove

### Existing tables (frozen)

| Table | Content | Recommendation |
|---|---|---|
| Table 1 | E1–E10 subjects + LOC + exec lines | **COMBINE** into CICT Table A; drop LOC/exec columns |
| Table 1b | E11–E15 subjects | **COMBINE** into CICT Table A with Phase column |
| Table 2 | E1–E10 Human/AI MS | **COMBINE** into CICT Table B |
| Table 3 | E1–E10 suite sizes | **REMOVE** (1 sentence in text) |
| Table 4 | E11–E15 Human/AI MS + Δ | **COMBINE** into CICT Table B |
| Table 5 | E11–E15 suite sizes | **REMOVE** (same sentence as Table 3) |
| Table 6 | Follow-up union MS | **REMOVE** (1 sentence) |
| Table 7 | Threats impact | **REMOVE** (prose Threats) |

### Recommended CICT tables (minimum = 2; ideal = 3)

**Table A — Subjects (all 15).** Columns: Exp. | Phase | Repository | Component.  
(~15 rows; very compact; establishes exploratory vs follow-up.)

**Table B — Mutation scores (all 15).** Columns: Exp. | Phase | Valid | Human MS | AI MS | Higher.  
Optional: add Δ only for follow-up rows, or omit Δ and state means in text.  
This single table lets the reader see Human MS, AI MS, and phase separation without Figures 1/4/5.

**Table C — Coverage–mutation dissociation cases (RQ2).** Recommended columns:

| Exp. | Phase | Coverage relationship | Human MS | AI MS | Look-ahead |
|---|---|---|---:|---:|---|
| E3 | Expl. | Identical line (99.03%) | 92.9% | 85.7% | Conditioned (3/28) |
| E4 | Expl. | Identical L/R/F | 96.0% | 88.0% | 0 |
| E9 | Expl. | 100% L/R/F | 96.2% | 88.5% | 0 |
| E13 | Follow-up | Identical line (92.95%) | 91.3% | 100.0% | Conditioned (2/23; entire gap) |
| E14 | Follow-up | Large line gap (~32 pp AI higher) | 68.2% | 72.7% | 0 |
| E15 | Follow-up | Inverse: Human line higher, MS lower | 54.2% | 66.7% | 0 |

Table C is the **highest-value** visual for the central claim; prefer it over any figure.

**Total tables in CICT:** **3** (A+B+C). If forced to 2: merge A into a footnote/repo and keep B+C, or keep A+B and put C’s six rows as a compact text list (worse). Prefer keeping all three by shrinking Related Work.

---

## 8. Figures: Keep / Remove / Replace

| Figure | Content | Classification |
|---|---|---|
| Fig. 1 | E1–E10 MS bars | **REPLACE WITH TABLE/TEXT** (Table B) |
| Fig. 2 | E3/E4/E9 divergence bars | **REPLACE WITH TABLE/TEXT** (Table C) |
| Fig. 3 | E1–E10 paired Δ | **REMOVE** (mixed pattern is clear from Table B + one sentence) |
| Fig. 4 | E11–E15 MS bars | **REPLACE WITH TABLE/TEXT** (Table B) |
| Fig. 5 | E11–E15 paired Δ | **REMOVE** (Table B + sensitivity sentence) |
| Fig. 6 | Coverage vs MS for E13/E15/E14 | **KEEP (optional) or REPLACE WITH TABLE C** |

**Recommendation:** **0 figures** in the default plan (safest for page limit). Table C carries the RQ2 message more precisely than Fig. 6 (includes look-ahead column and E3/E4/E9).

**Optional exception:** If after drafting there is ≥0.35 page free, add a single small Fig. 6-style panel for E13/E15/E14 only—still secondary to Table C.

---

## 9. Proposed Compact Results Presentation (~1.5–2.0 pages)

**Order of content (do not lead with “AI wins”):**

1. **Setup sentence:** Descriptive statistics only; phases reported separately; not population inference.
2. **Table B** + 4–6 sentences:
   - Exploratory: 6 AI / 3 Human / 1 tie; mean MS AI 93.8% vs Human 88.8%; median paired Δ +8.5 pp (range −8.0 to +21.8); pooled +4.60 pp.
   - Follow-up: 5/5 AI-higher; mean Δ +16.1 pp; **not** universal superiority.
   - **E11 sensitivity (inline):** exclude E11 → 4/4, mean Δ +7.58 pp (roughly half).
3. **RQ2 block (largest Results share):**
   - Table C.
   - 1 paragraph on E3/E4/E9 (identical coverage ≠ identical MS; E4/E9 clean).
   - 1 paragraph on E13/E14/E15 (recurs under neutral selection; E15 inverse line ranking; E14 magnitude mismatch).
   - 1 sentence E5 counterexample.
   - 1–2 sentences: RQ2 base = E3/E4/E9/E13/E14/E15; independent of E11; four zero-look-ahead experiments.
4. **Optional closing (≤3 sentences):** AI often larger; size ≠ higher MS (E4/E9); union gain in 1/10 + 3/5 (complementary kills, not synergy)—details in artifact.

**Do not:** open Results with the +50 pp E11 gap; pool 11/15 wins; imply significance tests.

---

## 10. Proposed Compact Threats Section

**Target length:** ~0.5 page. Structure as a single subsection with short labeled bullets or tight paragraphs—not nine subsections.

**Must include (map to frozen §7):**

1. **Human/AI effort & freshness asymmetry (§7.2):** Fresh, iteratively repaired AI suite vs historically fixed, unrevised Human filter; AI larger in most experiments; AI-favoring Δ may reflect authoring circumstances, not “AI-ness.”
2. **Researcher-selected Human filters (§7.2 / §4.2):** Scores describe the selected filter (e.g., E11 `SnapshotsTraitTests` out of scope; E15 `testPolar` excluded for determinism), not every existing test.
3. **Mutation-selection look-ahead (§7.3):** Designer not blind to frozen suite content; 29/369 (7.9%) flagged; concentrated in E2/E11; affected gaps conditional; RQ2 pattern still supported by zero-exposure cases.
4. **Manually designed mutants / single annotator (§7.3–§7.4):** Heterogeneous mutant sets; equivalence adjudication by same person; exclusion rates 0–19%.
5. **Single LLM / tooling (§7.6):** Grok 4.5 via Cursor 3.15.19, default sampling; not generalized.
6. **Swift / five open-source repositories (§7.1):** No claim beyond this language/ecosystem/unit-test level; exploratory selection not representative; neutral rule reduces but does not eliminate discretion (small *n*=5, inherited repos, researcher-designed eligibility).
7. **Mutation ≠ real-fault evaluation (§7.8):** Syntactic seeded faults only; no historical-bug claim.

**Omit from CICT Threats (→ artifact/full paper):** long look-ahead prediction hit-rate narrative; full reproducibility subsection; Table 7; extended conclusion-validity essay (keep one phrase: “descriptive characterization, not inference”).

---

## 11. Estimated Target Word Count

| Component | Target |
|---|---|
| Abstract | 150–180 words |
| Body prose (Intro–Conclusion, excluding tables) | **3,200–3,600 words** |
| Table captions + short table notes | ~200–300 words |
| References (10 entries, IEEEtran) | ~0.45–0.55 page |
| **Effective total for fit** | Aim for **≈ 3,500 words body** + 3 compact tables + refs ≤ 6.0 pages |

**Cut from frozen ≈12.9k words:** remove ~9,000–9,500 words of detail/repetition/appendix—primarily by deletion from the conference version and pointers to artifacts, not by changing science.

**Related-work citation set (all may remain in bibliography; discuss briefly):**

| Citation | Role in CICT | Depth |
|---|---|---|
| Inozemtseva & Holmes 2014 | Coverage imperfect adequacy proxy | Brief |
| Papadakis et al. 2019 | Mutation-testing context | Cite only |
| Yuan et al. 2024 | LLM unit-test empirics | Brief |
| Yang et al. 2024 | LLM unit-test empirics | Cite / brief |
| Ouédraogo et al. 2026 | Large-scale prompting / coverage | Cite / brief |
| Moradi Dakhel et al. 2024 (MuTAP) | Mutation as *generation* feedback | One contrast clause |
| Wang et al. 2026 (MutGen) | Mutation as generation feedback | One contrast clause |
| Lops et al. 2025 | Closest LLM-vs-human (aggregate) | One sentence “what we add” |
| Vathana et al. 2026 | Coverage parity + real-bug gap (direction contrast) | One sentence |
| Zhao et al. 2026 | Coverage/mutation/size for LLM suites | Cite / optional RQ4 pointer |

Do **not** drop necessary citations; do drop *long* per-paper literature reviews.

---

## 12. Risks of Over-Compression

| Risk | How it would go wrong | Mitigation |
|---|---|---|
| **Sounds like “AI wins”** | Leading with 5/5 / +50 pp E11; burying asymmetry | Lead Results with Table B neutrally; put RQ2 Table C as the interpretive center; state “no general superiority” in Abstract + Conclusion |
| **Estimand collapse** | Readers think matched-effort human vs AI | Keep asymmetry paragraph in Intro **and** one Threats bullet |
| **Look-ahead becomes a footnote** | Reviewers reject as biased mutant selection undisclosed | Keep 29/369 + E2/E11 concentration in Methods **and** Threats; qualify E3/E13 in Table C |
| **Dropping E11–E15** | RQ2 looks cherry-picked from exploratory selection | Must keep neutral-selection phase and E13/E14/E15 |
| **Dropping E11 sensitivity** | Follow-up mean Δ looks overstated | Keep +16.1 → +7.58 / 4/4 inline |
| **Dropping E15 inverse case** | RQ2 looks only like “identical coverage, Human higher” | Keep E15 (and note line vs region/function) |
| **Treating E13 gap as blind** | Overclaim magnitude under neutral selection | State entire E13 gap = 2 flagged mutants |
| **Omitting Threats** | Desk-reject / major revision for missing validity | Protect §V page budget (~0.55) |
| **Too many tables/figures** | Overflow page 6; refs cut | Default: 3 tables, 0 figures |
| **Cutting Related Work too hard** | Appears unaware of Lops/Vathana/MuTAP | Keep minimum citation spine above |
| **Moving *central* numbers only to artifact** | Paper not self-contained | Tables B and C must contain the key MS/coverage numbers in-paper |

---

## Execution Notes (for the later drafting step — not now)

1. Draft from `paper_submission_candidate_v1.tex` structure into a new file (e.g., `paper/cict-2026-draft.tex`); **never** overwrite the frozen candidate.
2. Build Tables A–C with **byte-identical** numbers from frozen Tables 1/1b/2/4 and §5.1/§5.6.
3. After first compile, if >6 pages: drop optional figure → trim Related Work → trim union/RQ3 → never trim Table C or Threats bullets.
4. Cross-check Abstract, Intro estimand, Results RQ2, Threats look-ahead, and Conclusion for consistent “not AI superiority” framing.

---

## STOP

This file is the condensation plan only.  
**Do not** edit `paper_submission_candidate_v1.md` / `.tex`.  
**Do not** create the CICT manuscript in this step.
