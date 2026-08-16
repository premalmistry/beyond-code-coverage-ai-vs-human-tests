# CICT 2026 Layout Check

**Manuscript edited (layout only):** `paper/cict-2026-draft.tex`  
**PDF:** `paper/cict-2026-draft.pdf`  
**Frozen full manuscript:** not modified  
**Markdown draft:** not modified (layout fixes are LaTeX-only)

---

## What Changed (Layout Only)

| Table | Change | Scientific values |
|---|---|---|
| **Table I** (Study subjects) | Converted to `table*` (two-column span); used wrapping `p{4.4cm}` / `p{6.2cm}` for Repository / Component; `\tabcolsep=4pt`; `@{}` side padding | **Unchanged** — all 15 rows, phases, repos, component names identical |
| **Table II** (Mutation scores) | Kept single-column `table`; `\tabcolsep=3.5pt`; `@{}` side padding; removed stray space in column spec | **Unchanged** — all Valid / Human MS / AI MS / Higher values identical |
| **Table III** (RQ2 dissociation) | **No change** | Unchanged |

No prose rewritten. No captions rewritten except that Table I remains captioned “Study subjects.” No numerical values altered.

---

## Compile Results

| Item | Result |
|---|---|
| Compilation succeeded? | **Yes** (Tectonic exit 0) |
| Exact PDF page count | **5** |
| Within 6-page limit? | **Yes** (5 ≤ 6) |
| References within those pages? | **Yes** — “References” and [1]–[10] present in PDF |
| Remaining Overfull `\hbox` | **None** |
| Remaining Overfull `\vbox` | **None** |
| Tables readable? | **Yes** — Table I now full-width with wrap; Table II fits column; Table III unchanged (`\small`, no overfull) |
| Content beyond page 6? | **No** |
| Any scientific number changed? | **No** |

### Note on page count
Pre-fix PDF was **4** pages with two Overfull `\hbox` warnings. After making Table I a readable `table*`, the PDF is **5** pages (still within the CICT 6-page limit). No overfull box warnings remain.

---

## STOP

Layout fixes and compile check complete. No scientific content changed. Frozen manuscript untouched.
