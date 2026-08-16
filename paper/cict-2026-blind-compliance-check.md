# CICT 2026 Blind Compliance Check

**Blinded submission source:** `paper/cict-2026-submission.tex`  
**Blinded PDF:** `paper/cict-2026-submission.pdf`  
**Author-identified draft (unchanged):** `paper/cict-2026-draft.tex`  
**Frozen full manuscript:** not modified

**Purpose:** Double-blind CICT 2026 review submission. Camera-ready should restore authors/affiliation and the public artifact URL from `cict-2026-draft.tex` after acceptance.

---

## Compliance Summary

| Check | Result |
|---|---|
| Exact page count | **5** |
| Author names absent | **PASS** |
| Identifying artifact URL absent | **PASS** |
| Abstract ≤250 words | **PASS** (~144–165 words depending on counting method; well under 250) |
| Keywords ≥3 | **PASS** (5 keywords) |
| IEEE double-column 10pt | **PASS** (`\documentclass[10pt,conference,a4paper]{IEEEtran}`) |
| A4 | **PASS** (`a4paper`; PDF MediaBox 210×297 mm) |
| References within page limit | **PASS** (References [1]–[10] on page 5; total 5 ≤ 6) |
| Overfull boxes | **0** (no Overfull `\hbox` / `\vbox`) |
| Tables readable | **PASS** (same layout as approved draft; 3 tables) |
| Suggested CICT track | **Track 5 — Cloud Computing, Software Systems and Emerging ICT Technologies (Software Engineering and DevOps)** |

**Overall review-readiness (blinding + format): PASS**

---

## Blinding Changes Made (Submission File Only)

1. **Authors / affiliation removed** from the review manuscript and replaced with:
   - `Anonymous Author(s)`
   - `Affiliation withheld for double-blind review`
2. **Identifying GitHub URL removed.** The line that previously pointed to `https://github.com/premalmistry/beyond-code-coverage-ai-vs-human-tests` was replaced with neutral wording:
   > An anonymized artifact repository containing experiment scripts, mutation plans, frozen test inventories, and analysis records will be made available to reviewers / is provided as supplementary material.
3. **Paper size option:** added `a4paper` to `\documentclass` for CICT A4 compliance.
4. **No scientific prose, results, tables, references, or numbers were rewritten.**

`paper/cict-2026-draft.tex` retains the real authors and public artifact URL for camera-ready restoration.

---

## Identity Scan Report

### Found in unblinded `cict-2026-draft.tex` (and removed/neutralized in submission)

| Finding | Location in draft | Action in `cict-2026-submission.tex` |
|---|---|---|
| Premal Mistry, Randhir Kumar | `\author{...}` | Replaced with Anonymous Author(s) |
| Independent Researcher | `\author{...}` affiliation | Replaced with “Affiliation withheld…” |
| `https://github.com/premalmistry/beyond-code-coverage-ai-vs-human-tests` | Introduction artifacts sentence | Replaced with anonymized supplementary-material wording |

### Searched in blinded PDF — all absent (PASS)

- Premal / Mistry / Randhir / Kumar  
- Independent Researcher  
- premalmistry  
- github.com/premalmistry  
- beyond-code-coverage-ai-vs-human-tests  

### Present but **not** author-identifying (no change needed)

| Item | Why OK |
|---|---|
| “Human test filter” / “Human MS” | Methodological term for the existing-test condition, not an author name |
| Generic phrases “artifact repository” | No username or URL |
| Citations to third-party authors (e.g., Wang, Yang) | Standard bibliography; not self-identifying |
| No Acknowledgments section | Nothing to anonymize |

### Residual notes (informational)

- A LaTeX source comment points to `cict-2026-draft.tex` for camera-ready restore; **comments do not appear in the PDF**.
- For CMT, upload **`cict-2026-submission.pdf`** (not the author-identified draft PDF).
- If supplementary artifacts are uploaded separately in CMT, strip identifying paths/usernames from those packages as well.

---

## Compile Verification

| Item | Result |
|---|---|
| Compiler | Tectonic (exit 0) |
| PDF | `paper/cict-2026-submission.pdf` |
| Pages | **5** |
| Overfull `\hbox` | **0** |
| Overfull `\vbox` | **0** |
| References [1]–[10] | Present |
| Anonymous author block on page 1 | Present |

---

## Suggested Track

**Track 5:** Cloud Computing, Software Systems and Emerging ICT Technologies — **Software Engineering and DevOps**.

---

## Safe Deadline Reminder (from organizer materials; not verified against CMT live UI)

Treat **30 August 2026** as the full-paper deadline unless Microsoft CMT shows a different authoritative date.

---

## STOP

Blinded submission version and compliance check complete. No rewrite of scientific content. Author-identified draft preserved for camera-ready.
