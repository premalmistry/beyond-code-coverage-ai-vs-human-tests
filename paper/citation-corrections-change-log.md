# Citation Corrections Change Log

**Date:** 2026-08-16  
**Source:** `paper/citation-verification-final.md` (Step 1 audit)  
**Scope:** Citation metadata and Related Work claim fixes only. No experimental results, methods, tables, figures, or research artifacts were changed.

**Files updated**
- `paper/paper_revised.md`
- `paper/paper_revised.tex`
- `paper/references_revised.bib` (TeX bibliography source; kept in sync with the manuscript)

---

## 1. Lops et al. / AgoneTest (2025)

**Status in audit:** CORRECTION NEEDED  
**What changed**
- Reference updated from arXiv-only (`arXiv:2511.20403`) to the peer-reviewed ASE 2025 publication:
  - Venue: *Proceedings of the 40th IEEE/ACM International Conference on Automated Software Engineering (ASE)*
  - Pages: 2401–2413
  - DOI: `10.1109/ase63991.2025.00198`
  - Note retained: originally released as arXiv:2511.20403, 2025
- BibTeX entry `lops2025agonetest` changed from `@article` (arXiv) to `@inproceedings` (ASE 2025)

**What did not change**
- Related Work interpretation of AgoneTest (compiling-subset LLM vs human coverage/mutation comparison; aggregate vs paired design) — left intact because the audit verified those claims

**Why:** Audit confirmed a published ASE 2025 version; arXiv-only citation was incomplete.

---

## 2. Ouédraogo et al. (EMSE 2026)

**Status in audit:** CORRECTION NEEDED  
**What changed**

### Bibliography
- Updated from arXiv-only 2024 preprint to peer-reviewed:
  - *Empirical Software Engineering*, 31(4), Article 103, 2026
  - DOI: `10.1007/s10664-026-10840-4`
  - Note: originally released as arXiv:2407.00225, 2024
- Cite key renamed `ouedraogo2024` → `ouedraogo2026` in `.tex` / `.bib`; in-text years updated to 2026 in `.md`

### Related Work (§3) — claim corrections
**Removed (incorrect):**
1. That LLM-generated suites can match or exceed EvoSuite’s coverage under chain-of-thought-style prompting  
2. Any attribution of fault-detection findings to this study  

**Replaced with verified content:**
- Scope preserved: 216,300 tests; four LLMs; five prompting techniques; compilability / hallucination-driven failures; structural coverage; test smells; prompting effects
- Accurate coverage result: EvoSuite outperformed all evaluated LLMs on coverage; reasoning-based prompting improved LLM performance relative to weaker prompts
- Explicit note that the study did not assess fault detection

### Introduction (§1.1)
- Split the joint Yang/Ouédraogo parenthetical so Ouédraogo is no longer cited for “defect detection”
- Yang remains the support for prompt-/model-dependent coverage and defect detection
- Ouédraogo now supports large-scale prompting effects on compilability, structural coverage, and test smells

**Why:** Audit found the published EMSE version and verified that Finding 20 reports EvoSuite outperforming all LLMs on coverage, and that the paper’s limitations state it did not assess fault detection.

---

## 3. Zhao et al. (2026)

**Status in audit:** NEEDS MANUAL VERIFICATION  
**What changed**
- Added verified arXiv identifier `2607.22880` as the primary resolvable link in the References entry / BibTeX `url` + `eprint`
- Did **not** invent or “fix” the DOI: author/PACMSE-listed DOI `10.1145/3832093` is retained only as an author-reported value with an explicit **NEEDS MANUAL VERIFICATION** note
- Related Work paragraph for Zhao: added a short flag that the publisher DOI was not independently resolved during the citation audit (points to `paper/citation-verification-final.md`)
- Substantive claim about suite size as a weak confounder for LLM suites — unchanged (audit verified)

**What did not change**
- Venue metadata as listed (*PACMSE* 3(ISSTA), Article ISSTA002, 2026) — left as author/PACMSE-sourced, not re-asserted as independently DOI-verified
- No experimental or RQ4 interpretation edits

**Why:** Audit could not resolve the ACM DOI landing page (HTTP 404); user instruction was to mark for manual verification and not invent/fix the DOI.

---

## Sync check

| Change | `.md` | `.tex` | `.bib` |
|--------|:-----:|:------:|:------:|
| Lops → ASE 2025 | ✓ | ✓ (via bib) | ✓ |
| Ouédraogo → EMSE 2026 + claim rewrite | ✓ | ✓ | ✓ |
| Intro: stop attributing defect detection to Ouédraogo | ✓ | ✓ | n/a |
| Zhao: arXiv + DOI manual-verification flag | ✓ | ✓ | ✓ |

---

## Out of scope (not touched)

- Experimental results, methodology, tables, figures
- Vathana et al. and other PASS citations (aside from year string sync for Ouédraogo in appendix checklist item 6)
- Research artifacts under `research/` / `experiments/`

**STOP** — Step 2 complete. Awaiting Step 3.
