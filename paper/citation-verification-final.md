# Citation Verification Final Audit

**Manuscript audited:** `paper/paper_revised.md` (References + Related Work §3)  
**Audit date:** 2026-08-16  
**Method:** External checks against arXiv abs/HTML, publisher/DOI pages, ACM DL, IEEE Computer Society CSDL, ScienceDirect/Elsevier, and author replication packages. No manuscript text was rewritten.

**Status legend**

| Status | Meaning |
|--------|---------|
| PASS | Metadata and attributed Related Work claims verified against primary sources |
| CORRECTION NEEDED | At least one concrete error found (metadata and/or attributed claim) |
| NEEDS MANUAL VERIFICATION | Could not confirm confidently without further publisher-side check |

---

## Summary table

| Citation | Metadata verified | Claim verified | Status | Required correction |
|----------|-------------------|----------------|--------|---------------------|
| Inozemtseva & Holmes (2014) | Yes — authors, title, year, ICSE 2014, pages 435–445, DOI `10.1145/2568225.2568271`; peer-reviewed published | Yes — size-controlled coverage↔effectiveness is low–moderate for large Java programs; coverage should not be a quality target | PASS | None |
| Lops et al. (2025) AgoneTest | Partial — authors/order, title, arXiv:`2511.20403` match; **also peer-reviewed ASE 2025** (IEEE DOI `10.1109/ase63991.2025.00198`); manuscript cites arXiv only | Yes — for compiling tests, LLM suites can match/exceed human on coverage and defect detection; uses coverage, mutation score, test smells; comparison is dataset/project-aggregated | CORRECTION NEEDED | Prefer published ASE 2025 citation (or “originally arXiv:2511.20403” annotation as used for Yuan). Do not leave as arXiv-only if submitting after ASE 2025 appearance. |
| Moradi Dakhel et al. (2024) MuTAP | Yes — authors/order, title, *IST* 171:107468, DOI `10.1016/j.infsof.2024.107468`; peer-reviewed published (also arXiv:`2308.16557`) | Yes — augments prompts with surviving mutants (mutation as generation feedback) | PASS | Optional: add arXiv ID for consistency with other dual preprint/published refs |
| Ouédraogo et al. (2024) | Partial — authors/order, title, arXiv:`2407.00225`, and **216,300 / four LLMs / five prompts** match; **now peer-reviewed *Empirical Software Engineering* 31(4), 2026**, DOI `10.1007/s10664-026-10840-4` (manuscript still arXiv-only, year 2024) | **No** — Related Work overstates coverage vs EvoSuite and invents a fault-detection finding | CORRECTION NEEDED | (1) Cite EMSE 2026 (or annotate “originally arXiv:2407.00225, 2024”). (2) **Remove/replace** “can match or exceed EvoSuite’s coverage under chain-of-thought-style prompting” — paper Finding 20: *EvoSuite outperforms all LLMs* on coverage (e.g. GPT-3.5 CoT median line ~75% vs EvoSuite ~94%). (3) **Remove** “fault detection remained inconsistent…” — limitations state explicitly: *“Our study does not assess fault detection.”* Keep only verified scope: compilability/hallucination, coverage, smells, prompt effects. |
| Papadakis et al. (2019) | Yes — authors/order, title, *Advances in Computers* 112:275–378, DOI `10.1016/bs.adcom.2018.03.015`; peer-reviewed book chapter | Yes — survey/analysis of mutation-testing advances (supporting citation only) | PASS | None |
| Vathana et al. (2026) | Yes — authors/order, title, year, arXiv:`2606.08588`; **preprint only** (no peer-reviewed venue found) | Yes — BugsInPy 29 bugs; RAG LLM 69% vs human 17.2%; Fisher’s exact *p*<.001; line/branch coverage statistically indistinguishable (84.8% vs 88.5%, 75.2% vs 82.1%; Mann–Whitney n.s.) | PASS | Optional: keep preprint status explicit; re-check venue before camera-ready if accepted later |
| Wang et al. (2026) MutGen | Yes — authors/order, title, *IEEE TSE* 52(5):1657–1671 (May 2026), DOI `10.1109/TSE.2026.3682975`; peer-reviewed published (also arXiv:`2506.02954`) | Yes — MutGen feeds mutation feedback into prompts; iterative generation targets surviving mutants | PASS | Optional: add arXiv ID |
| Yang et al. (2024) | Yes — authors/order, title, ASE 2024, DOI `10.1145/3691620.3695529`; peer-reviewed; ACM article numbering **Article 76** consistent with ACM DL; page range **1607–1619** also reported (Computer.org / researchr) | Yes — 17 Java projects; open-source LLMs vs GPT-4 and EvoSuite; prompt design / model choice affect coverage and defect detection | PASS | Optional: add pages 1607–1619 alongside Article 76 for dual ACM/IEEE pagination |
| Yuan et al. (2024) | Yes — authors/order, title, *PACMSE* 1(FSE) Article 76, DOI `10.1145/3660783`; peer-reviewed; originally arXiv:`2305.04207` (2023) | Yes — promising coverage for passing tests alongside compilation and assertion-correctness failures | PASS | None |
| Zhao et al. (2026) | Partial — authors/order, title, *PACMSE* 3(ISSTA) Article ISSTA002, year 2026, and arXiv:`2607.22880` match author HTML/replication bibtex; claimed DOI `10.1145/3832093` appears in those sources, but **doi.org / ACM DL returned HTTP 404** during this audit | Yes — replicates Inozemtseva & Holmes for LLM suites; suite size is a comparatively weak confounder for LLM-generated suites | NEEDS MANUAL VERIFICATION | Confirm DOI/`ISSTA002` resolves on ACM DL / Crossref before submission; if DOI is live, status can become PASS with no content change. Optionally add arXiv:`2607.22880`. |

---

## Priority papers (detail)

### Lops et al. 2025 (AgoneTest)

| Field | Manuscript | Verified |
|-------|------------|----------|
| Authors | Lops, Narducci, Ragone, Trizio, Bartolini | Match |
| Title | LLMs for automated unit test generation… AgoneTest | Match (title case differs only) |
| Year | 2025 | Match |
| Venue in MS | arXiv preprint only | Incomplete — also **ASE 2025** research paper |
| arXiv | 2511.20403 | Match |
| Status | Cited as preprint | **Peer-reviewed published (ASE 2025)** + arXiv |

**Related Work claims:** Match abstract/results on compiling subset, coverage + defect detection / mutation score, human comparison. Aggregation vs paired-component contrast in MS is interpretive, not a false factual attribution.

### Vathana et al. 2026

| Field | Manuscript | Verified |
|-------|------------|----------|
| Authors | Vathana, Bhatt, Patel, Eisty | Match |
| Title | LLM vs. Human Unit Tests: Fault Detection on Real Python Bugs | Match |
| Year / arXiv | 2026 / 2606.08588 | Match |
| Status | Preprint | **Preprint only** (no venue found) |

**Related Work claims:** 69% vs 17.2%, Fisher’s exact *p*<.001, BugsInPy, coverage parity / statistically indistinguishable — **all verified** in abstract and results (incl. Mann–Whitney *p*=0.28 / 0.17 for line/branch).

### Wang et al. 2026 (MutGen)

| Field | Manuscript | Verified |
|-------|------------|----------|
| Authors | Wang, Xu, Briand, Liu | Match |
| Title | Mutation-guided unit test generation with a large language model | Match |
| Venue | *IEEE TSE* 52(5), 1657–1671 | Match (IEEE CSDL / researchr) |
| DOI | 10.1109/TSE.2026.3682975 | Match |
| Status | Peer-reviewed published | Confirmed |

**Related Work claim:** mutation feedback + iterative generation — verified.

### Zhao et al. 2026

| Field | Manuscript | Verified |
|-------|------------|----------|
| Authors | Zhao, Zhou, Cohen (Eldan) | Match |
| Title | Do coverage and mutation scores… (Replicability Study) | Match |
| Venue | *PACMSE* 3(ISSTA), Article ISSTA002 | Match on arXiv HTML + GitHub bibtex |
| DOI | 10.1145/3832093 | Present in those sources; **live DOI resolution failed (404)** |
| arXiv | Not listed in MS | Exists: **2607.22880** |
| Status | Treated as published PACMSE/ISSTA | Accepted/published per PACMSE HTML; confirm ACM landing |

**Related Work claim:** suite size weaker confounder for LLM suites — verified in abstract (“little evidence that test suite size is a dominant confounder”).

### Yang et al. 2024

| Field | Manuscript | Verified |
|-------|------------|----------|
| Authors | Yang et al. (11 authors) | Match |
| Title | On the evaluation of large language models in unit test generation | Match |
| Venue | ASE 2024 | Match |
| Locator | Article 76 | ACM DL consistent; also pages **1607–1619** |
| DOI | 10.1145/3691620.3695529 | Match |
| Status | Peer-reviewed published | Confirmed |

**Related Work claims:** 17 projects; prompt/model effects on coverage and defect detection — verified (Defects4J 17 projects; RQ4 defect detection).

### Ouédraogo et al. 2024 → EMSE 2026

| Field | Manuscript | Verified |
|-------|------------|----------|
| Authors | Ouédraogo et al. (8) | Match |
| Title | Prompt engineering in LLMs… large-scale study | Match |
| Numeric scope | 216,300 tests; 4 LLMs; 5 techniques | Match |
| Venue in MS | arXiv 2024 only | Incomplete — **EMSE 31(4), 2026** |
| Status | Cited as preprint | **Peer-reviewed published** |

**Related Work claims:**

| Claim in MS | Verdict |
|-------------|---------|
| 216,300 / four LLMs / five prompting techniques | PASS |
| LLM suites can match or exceed EvoSuite coverage under CoT-style prompting | **FALSE** — Finding 20: EvoSuite outperforms all LLMs; CoT narrows but does not close the gap |
| Fault detection remained inconsistent and highly prompt-dependent | **FALSE** — paper: “Our study does not assess fault detection.” |

---

## Counts

| Metric | Count |
|--------|------:|
| Citations checked | **10** |
| PASS | **7** |
| CORRECTION NEEDED | **2** |
| NEEDS MANUAL VERIFICATION | **1** |

**PASS:** Inozemtseva & Holmes (2014); Moradi Dakhel et al. (2024); Papadakis et al. (2019); Vathana et al. (2026); Wang et al. (2026); Yang et al. (2024); Yuan et al. (2024)

**CORRECTION NEEDED:** Lops et al. (2025); Ouédraogo et al. (2024/EMSE 2026)

**NEEDS MANUAL VERIFICATION:** Zhao et al. (2026) — DOI landing page

---

Audit complete. Manuscript not rewritten (per task instructions).
