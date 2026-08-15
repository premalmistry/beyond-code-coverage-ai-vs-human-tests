# Paper Update Plan — Incorporating Confirmatory Experiments #11–#15

**Purpose:** Recommend edits to the *existing* scholarly paper (`paper/paper_revised.md` / `.tex`) after confirmatory analysis.  
**Do not rewrite the paper in this step.**  
**Keep phases explicit:** Exploratory = E1–E10; Confirmatory = E11–E15. Do **not** silently pool win counts or means across phases.

**Inputs:**  
- `research/confirmatory-e11-e15.csv`  
- `research/confirmatory-e11-e15-analysis.md`  
- Existing paper conclusions for E1–E10 (unchanged recomputation)

---

## 1. Abstract

**Change:** Extend from “ten paired experiments” to a two-phase design: ten exploratory + five confirmatory.

**Add (concise):**  
- Confirmatory components were selected with a **pre-declared neutral rule** (eligible → alphabetical → first).  
- On E11–E15, AI had the higher mutation score in **all five**; mean MS Human **69.2%**, AI **85.3%** (mean paired Δ **+16.1 pp**).  
- Confirmatory evidence **supports** the claim that coverage alone is insufficient (cite E13 identical line coverage / unequal MS; E15 higher Human line coverage / lower MS).  
- State that exploratory and confirmatory results are reported **separately**.

**Avoid:** A single blended “15 experiments, AI wins X” sentence without phase labels.

---

## 2. Contributions

**Update bullet list to include:**

1. Two-phase empirical design: exploratory (E1–E10) + confirmatory (E11–E15).  
2. Pre-declared neutral component-selection protocol reducing (not eliminating) selection bias.  
3. Confirmatory replication of coverage/MS dissociation under neutral selection.  
4. Confirmatory replication of complementary Human-only / AI-only kill patterns.

**Keep** leakage-controlled paired methodology and exploratory identical-coverage cases (E3/E4/E9) as foundational contributions.

---

## 3. Methodology

**Add a new subsection (suggested §4.x): Confirmatory phase protocol**

Document identically for E11–E15:

- Eligibility criteria (7 rules)  
- Alphabetical sort; select first eligible  
- Freeze component before AI generation / mutation  
- Same leakage controls, suite freeze + SHA-256, mutant freeze-before-run  
- Accept results regardless of outcome  
- Note Human-filter deterministic narrowing where used (e.g., E15 excluded RNG `testPolar`)  
- Note E15 measurement fix: force-rebuild clients for `@_transparent` / `@inlinable` APIs

**Clarify subjects table:** five repositories appear in both phases, but **components do not overlap** with prior experiments in the same repo.

**Do not** rewrite exploratory selection history; instead contrast it with confirmatory neutrality (paper already flags exploratory selection threat).

---

## 4. Results

**Restructure into two result blocks:**

### 4.A Exploratory results (E1–E10) — keep essentially as-is
Win counts, means, identical-coverage cases, suite-size discussion.

### 4.B Confirmatory results (E11–E15) — new

Include a table analogous to exploratory Table 2:

| Exp | Repo / component | Valid | Human MS | AI MS | Δ | Higher |
|---|---|---:|---:|---:|---:|---|
| E11 | SnapshotTestingConfiguration | 24 | 41.7% | 91.7% | +50.0 | AI |
| E12 | RigidArray+Append | 22 | 90.9% | 95.5% | +4.6 | AI |
| E13 | AdjacentPairs | 23 | 91.3% | 100% | +8.7 | AI |
| E14 | OneOfBuilder | 22 | 68.2% | 72.7% | +4.5 | AI |
| E15 | Complex+AlgebraicField | 24 | 54.2% | 66.7% | +12.5 | AI |

Summary stats: AI **5/5**; mean Human **69.2%**; mean AI **85.3%**; mean Δ **+16.1 pp**; median Δ **+8.7 pp**.

**New coverage-dissociation subsection (confirmatory):**

- E13: identical line coverage, unequal MS  
- E15: Human higher line coverage, lower MS  
- E14: large coverage Δ, small MS Δ  

**Complementarity subsection:** Human-only vs AI-only counts and example mutants (see analysis §C).

**Optional:** small *n*=5 descriptive test only if clearly labeled underpowered / exploratory; do **not** treat as primary confirmatory claim.

---

## 5. Discussion

Map RQs to **both phases**, with explicit phase labels.

| RQ | Recommended discussion update |
|---|---|
| RQ1 | Exploratory: mixed 6–3–1, non-significant ~5 pp gap. Confirmatory: AI 5/5, larger descriptive gap. Interpret as **phase-specific**; do not claim general AI superiority. |
| RQ2 | State confirmatory **replication** of insufficiency (E13, E15, E14). Keep E3/E4/E9 as exploratory anchors. |
| RQ3 | Confirmatory complementarity replicates; note AI-only volume higher under several thin Human filters produced by neutral selection. |
| RQ4 | Optionally note confirmatory AI suites remain larger; still no causal suite-size claim. |

**Selection bias:** Move from “future work should use neutral selection” (exploratory conclusion) to “we executed that protocol in E11–E15; results below.”

---

## 6. Threats to Validity

**Update External validity:**  
- Exploratory selection bias partially mitigated by confirmatory phase.  
- Remaining: same five ecosystems, eligibility design, Human filter choices, single LLM (Grok 4.5 / Cursor), Swift-only, mutant author = experiment author, small confirmatory *n*.

**Update Conclusion validity:**  
- Do not pool E1–E15 for a single significance test without a pre-registered pooling rule.  
- Confirmatory 5/5 win count is descriptive.

**Internal validity:** retain equivalence-adjudication single-annotator threat; note confirmatory equiv exclusions were few (E12:2, E13:1, others 0).

---

## 7. Conclusion

**Rewrite to two-phase conclusion:**

1. Exploratory E1–E10 established coverage/MS dissociation and mixed win pattern.  
2. Confirmatory E11–E15, under neutral selection, **supported** the coverage-insufficiency and complementarity findings.  
3. Confirmatory aggregate favored AI more strongly than exploratory; this **refines** rather than replaces the exploratory RQ1 reading.  
4. Most robust cross-phase claim remains: **coverage is not a sufficient proxy for mutation-based fault detection.**  
5. Future work: more confirmatory components, second annotator, multiple LLMs, real-fault validation — **not** “add neutral selection” as if undone.

---

## 8. Tables

| Table | Action |
|---|---|
| Exploratory MS table (current Table 2) | Keep; caption “Exploratory phase (E1–E10)” |
| New confirmatory MS table | Add (E11–E15) |
| Test/assertion counts | Add confirmatory companion or extend with a Phase column |
| Optional coverage table | E11–E15 line/region/function Human vs AI |
| Optional kill-partition table | Human-only / AI-only / shared survivors per confirmatory exp |

Do **not** replace exploratory tables with a merged 15-row table without a Phase column.

---

## 9. Figures

| Figure | Action |
|---|---|
| Fig 1 (MS bars E1–E10) | Keep; label Exploratory |
| Fig 2 (identical-coverage divergence) | Keep exploratory E3/E4/E9; **add** confirmatory panel or new figure for E13 (+ E15 inverse coverage ranking) |
| Fig 3 (paired Δ E1–E10) | Keep; add confirmatory paired-Δ figure or dual-panel |
| New | Optional schematic of neutral selection rule (eligibility → sort → first) |

---

## Explicit non-goals for the next paper edit

- Do **not** re-analyze or rewrite E1–E10 results.  
- Do **not** silently combine phases into one win-rate.  
- Do **not** claim confirmatory selection eliminates all bias.  
- Do **not** run Experiment #16 as part of the paper update.

---

## Suggested edit order

1. Methodology confirmatory subsection + threats update  
2. Results §4.B + tables/figures  
3. Discussion RQ mapping  
4. Abstract + contributions + conclusion  

**STOP** — await explicit instruction before rewriting `paper_revised.md` / `.tex`.
