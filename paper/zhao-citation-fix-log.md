# Zhao Citation Fix Log

**Date:** 2026-08-16  
**Scope:** Zhao, Zhou, and Cohen (2026) only. No other citations, experiments, methodology, or sections changed.

**Files updated**
- `paper/paper_revised.md`
- `paper/paper_revised.tex`
- `paper/references_revised.bib`

---

## Correction

Cite Zhao et al. (2026) conservatively as a **verifiable arXiv preprint**, not as a verified PACMSE/ISSTA publication.

| Field | Before | After |
|-------|--------|-------|
| Title | Unchanged | *Do Coverage and Mutation Scores of LLM-Generated Test Suites Correlate with Their Effectiveness? (Replicability Study)* |
| Authors | Unchanged | Junda Zhao, Shurui Zhou, Eldan Cohen |
| Year | Unchanged | 2026 |
| Venue | *PACMSE* 3(ISSTA), Article ISSTA002 | **arXiv preprint arXiv:2607.22880** |
| DOI | `10.1145/3832093` (unresolved / flagged) | **Not cited** |
| Link | arXiv URL + unresolved-DOI note | `https://arxiv.org/abs/2607.22880` |

---

## Removed from manuscript

- All **NEEDS MANUAL VERIFICATION** notes related to Zhao
- Unresolved DOI comments / author-reported DOI caveats
- Unverified PACMSE / ISSTA publication metadata (`volume`, `number`, `articleno`, publisher DOI)
- Parenthetical audit flag in the Related Work Zhao paragraph

---

## Preserved

- Substantive Related Work discussion of Zhao et al. (suite size as a comparatively weak confounder for LLM-generated suites; RQ4 consistency note)
- Cite key `zhao2026` (no other `\cite` / in-text year changes required)

---

## Sync

| Change | `.md` | `.tex` | `.bib` |
|--------|:-----:|:------:|:------:|
| Related Work: remove Zhao verification parenthetical | ✓ | ✓ | n/a |
| References: arXiv-only entry | ✓ | via bib | ✓ |
| No DOI `10.1145/3832093` | ✓ | via bib | ✓ |

**STOP** — Zhao citation fix complete. Citation verification finished pending Step 5.
