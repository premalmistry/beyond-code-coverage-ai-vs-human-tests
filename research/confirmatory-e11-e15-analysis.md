# Confirmatory Analysis: Experiments #11–#15

**Scope:** Confirmatory phase only. Experiments #1–#10 are **not** recomputed here; exploratory conclusions are taken from the existing scholarly paper (`paper/paper_revised.md`).  
**Sources:** `research/experiment-{11..15}-summary.md` and supporting baseline/mutation-result artifacts in each repository. Experiment artifacts were **not** modified.  
**Dataset:** `research/confirmatory-e11-e15.csv`

---

## Dataset verification notes

All counts and percentages below were checked against each experiment’s summary and, where needed, mutation-results files:

| Exp | Valid | Human killed / MS | AI killed / MS | Human-only | AI-only | Shared survivors | Equiv/invalid |
|---:|---:|---|---|---:|---:|---:|---:|
| 11 | 24 | 10 / 41.7% | 22 / 91.7% | 1 | 13 | 1 | 0 |
| 12 | 22 | 20 / 90.9% | 21 / 95.5% | 0 | 1 | 1 | 2 |
| 13 | 23 | 21 / 91.3% | 23 / 100% | 0 | 2 | 0 | 1 |
| 14 | 22 | 15 / 68.2% | 16 / 72.7% | 2 | 3 | 4 | 0 |
| 15 | 24 | 13 / 54.2% | 16 / 66.7% | 5 | 8 | 3 | 0 |

Paired differences (AI − Human, percentage points): **+50.0, +4.6, +8.7, +4.5, +12.5**.

Means/medians below use exact kill ratios `(killed/valid)`, then report percentages to one decimal place.

---

## A. Overall results (E11–E15)

| Outcome | Count |
|---|---:|
| AI wins (higher mutation score) | **5 / 5** |
| Human wins | **0 / 5** |
| Ties | **0 / 5** |

| Statistic | Human | AI |
|---|---:|---:|
| Mean mutation score | **69.2%** | **85.3%** |
| Median mutation score | **68.2%** | **91.7%** |

| Paired difference (AI − Human) | Value |
|---|---:|
| Mean | **+16.1 pp** |
| Median | **+8.7 pp** |

**Descriptive reading:** On the five neutrally selected confirmatory components, AI achieved the higher mutation score in every experiment. The confirmatory mean gap (+16.1 pp) is larger than the exploratory paper’s reported mean gap (~+5.0 pp on E1–E10), but the samples are not interchangeable: confirmatory selection was deliberately comparison-neutral, mutant sets differ, and *n* = 5 remains small. This section does **not** claim statistical significance.

Contamination was **CLEAN** and integrity **PASS** in all five experiments.

---

## B. Central paper finding: coverage alone is insufficient

Paper claim under test (from exploratory E1–E10):  
**“Code coverage alone is insufficient to infer mutation effectiveness.”**

### Evidence in E11–E15

1. **Identical line coverage, different mutation score (E13)**  
   Both suites: **92.95%** line coverage.  
   Mutation scores: Human **91.3%** vs AI **100%** (Δ **+8.7 pp**).  
   Region coverage even favored Human (89.04% vs 80.82%), yet AI killed two additional `underestimatedCount` mutants.  
   → Direct confirmatory replication of coverage/MS dissociation under line-coverage parity.

2. **Higher coverage, lower mutation score (E15)**  
   Human line coverage **71.19%** > AI **44.92%**, but Human MS **54.2%** < AI **66.7%**.  
   → Strong dissociation: the suite with substantially *more* line coverage was the weaker mutant killer. (Region/function coverage favored AI; line coverage alone would mis-rank the suites.)

3. **Large coverage gap, small mutation-score gap (E14)**  
   Line coverage: Human 47.62% vs AI 79.76% (Δ **+32.1 pp** for AI).  
   Mutation score: 68.2% vs 72.7% (Δ only **+4.5 pp**).  
   → Coverage difference far exceeds mutation-score difference; coverage magnitude is a poor proxy for relative fault detection.

4. **Moderate coverage gap, small MS gap (E12)**  
   Line: 83.62% vs 93.10%; MS: 90.9% vs 95.5% (Δ **+4.6 pp**). Both suites strong; coverage and MS move together but the MS gap is small.

5. **Large coverage gap aligned with large MS gap (E11)**  
   Line: 57.78% vs 97.78%; MS: 41.7% vs 91.7% (Δ **+50.0 pp**). Here coverage and MS move in the same direction; this does **not** contradict the insufficiency claim — insufficiency means coverage is not a reliable *proxy*, not that coverage and MS never correlate.

**Verdict for §B:** E11–E15 **support and refine** the central claim. The confirmatory phase adds (a) a fresh identical-line-coverage / unequal-MS case (E13), (b) an inverse ranking under higher Human line coverage (E15), and (c) a large-coverage / small-MS case (E14).

---

## C. Complementary behavior

Across E11–E15:

| Partition | Total count (sum of per-experiment counts) |
|---|---:|
| Human-only kills | **8** (1+0+0+2+5) |
| AI-only kills | **27** (13+1+2+3+8) |
| Shared survivors | **9** (1+1+0+4+3) |

Experiments with **both** Human-only and AI-only kills: **E11, E14, E15** (3/5).  
Experiments with AI-only only (no Human-only): **E12, E13**.  
No confirmatory experiment had Human-only kills without AI-only kills.

### Concrete defect patterns

**AI-only (typical themes)**  
- **Untested API surface / constructors:** Record `rawValue` / DiffTool literals / `.ksdiff` formatting (E11).  
- **Capacity boundary polarity:** `>=` → `>` on exact-fit append (E12-M06).  
- **Count/estimate properties:** `underestimatedCount` (E13-M03, M20).  
- **Print / OptionalOneOf print paths** Human never exercises (E14-M13–M15).  
- **Identity / special-case APIs** absent from thin Human filters: `one`, `/=`, `normalized`, `reciprocal` branches (E15-M01, M02, M05, M18–M21); nonfinite divisor return (E15-M11).

**Human-only (typical themes)**  
- **Assertion precision inside covered paths:** exact DiffTool default string path-order (E11-M14).  
- **Parse try-order / aggregated error payloads** (E14-M01, M21).  
- **Scale-sensitive numerical path** Human Baudin–Smith stresses and AI mostly misses: Priest / tiny-magnitude `rescaledDivide` (E15-M13–M17).

**Shared survivors (not automatically equivalent)**  
- Async DiffTool ignore (E11-M22); exact-fit OutputSpan capacity (E12-M14); OneOf print/restore / error-order mutants (E14); reciprocal nil-clause and untested `_relaxed*` ops (E15-M22–M24).

**Verdict for §C:** Complementary detection **replicates**. AI more often uniquely kills unexercised surface area; Human uniquely kills narrower semantic/ordering/scale-sensitive faults. Confirmatory phase is AI-heavier on unique kills (27 vs 8), consistent with several thin Human filters under neutral selection (especially E11, E14, E15).

---

## D. Selection-bias concern

Exploratory E1–E10 (per paper §4.1 / Threats): later components were partly chosen for behavioral diversity and likelihood of distinguishing suites — informative, but **not** comparison-neutral.

Confirmatory E11–E15 strengthen evidence **with respect to component-selection bias** because:

1. **Pre-declared eligibility criteria** (direct Human tests, deterministic, focused, mutation-capable, no network, not previously studied, isolated).  
2. **Alphabetical ordering** of all eligible production paths.  
3. **First eligible component selected** — no skipping for interestingness, predicted winner, coverage, or paper fit.  
4. **Component frozen before** AI generation outcomes, coverage comparison, mutation design, and score observation.  
5. **Results accepted regardless** of Human/AI win, tie, boringness, or consistency with E1–E10 / paper hypothesis (including thin Human suites such as E14).

This does **not** eliminate all selection bias. Remaining threats include: repository choice, eligibility-criterion design, Human-filter narrowing (e.g., excluding non-deterministic tests), mutant-design judgment, single LLM/agent, Swift-only scope, and clustering within the same five ecosystems as the exploratory phase.

---

## E. Compare against exploratory findings (E1–E10 paper baseline)

Do **not** recompute E1–E10. Exploratory baseline (from `paper_revised.md`):

- AI higher MS in **6/10**, Human **3/10**, tie **1/10**  
- Mean MS ≈ **AI 93.8%**, **Human 88.8%** (Δ ≈ **+5.0 pp**); not statistically significant  
- Strongest claim: **identical/complete coverage can coexist with different MS** (E3, E4, E9)  
- Complementary Human-only vs AI-only kills  
- Suite size not a reliable causal predictor  
- External-validity caveat: non-neutral selection for later exploratory components  

| Exploratory finding | Confirmatory (E11–E15) status |
|---|---|
| Coverage insufficient to infer mutation effectiveness | **Replicated** (E13 identical line / unequal MS; E15 higher Human line / lower MS; E14 large cov Δ / small MS Δ) |
| Suites can be complementary (Human-only + AI-only kills) | **Replicated** (clear in E11, E14, E15; AI-only present in all five) |
| AI often competitive / frequently higher MS | **Replicated and strengthened directionally** (5/5 AI wins; larger mean Δ) |
| Human can win on mutation score (E3, E4, E9) | **Not replicated** in this confirmatory sample (0 Human wins) |
| Aggregate AI−Human gap modest (~5 pp) and non-significant | **Partially not replicated descriptively** (confirmatory mean Δ +16.1 pp) — **do not** treat as a pooled claim without separating phases |
| Exact MS tie under near-complete coverage (E5) | **Not observed** in E11–E15 |
| AI unique kills on uncovered / special paths | **Replicated** (E11 Record/DiffTool; E13 count; E14 print; E15 normalized/reciprocal/`one`) |
| Human unique kills as narrow oracles inside covered paths | **Replicated** (E11 string-order; E14 parse-order/errors; E15 numerical scale path) |
| Exploratory selection-bias threat | **Addressed (not erased)** by neutral rule in confirmatory phase |

### Overall answer to the research question

**Did E11–E15 strengthen or weaken the conclusions from E1–E10?**

- **Strengthen:** the central coverage≠mutation claim; complementary suite behavior; the practical value of evaluating AI suites with mutation testing rather than coverage alone; reduced component-selection-bias concern for the confirmatory subsample.  
- **Refine / qualify:** directional AI advantage looks **stronger** under neutral selection in this *n*=5 sample (5/5 wins; larger mean gap), so the paper should **not** over-claim exploratory “mixed 6–3–1 / non-significant” as the confirmatory pattern.  
- **Weaken (narrowly):** the exploratory observation that Human sometimes wins is **not** reproduced in E11–E15; any paper language implying frequent Human-over-AI mutation wins must be scoped to the exploratory phase or to specific oracle styles (exact strings, parse-order, scale-stress numerics), not to confirmatory aggregate win counts.

Keep phases separate: **Exploratory = E1–E10**, **Confirmatory = E11–E15**.
