# Citation Verification TODO

This is an **internal consistency check only** — it does not use web search or
any external database. It flags entries in `paper/paper_revised.md` §References
whose metadata is internally plausible but not independently verified, or
where an internal inconsistency was found. No citation was "corrected" from
memory; where an issue is found, the entry is left as-is and flagged here for
a human to verify against the actual source before submission.

## Priority 1 — verify before submission (load-bearing in Related Work)

1. **Vathana et al. (2026)**, `arXiv:2606.08588`. This is the single most
   load-bearing citation in Related Work §3 — it is used to support a
   specific, quantitative claim ("69% vs. 17.2%, Fisher's exact *p* < .001")
   that is presented as reinforcing this paper's own findings "from opposite
   directions." A specific statistic attributed to a citation that has not
   been independently re-read against the actual PDF/HTML source is a higher
   risk than a qualitative claim. **Action:** locate and re-read the actual
   paper before submission; confirm the exact percentages, the statistical
   test, the dataset (BugsInPy), and the coverage-parity claim attributed to
   it. The arXiv identifier format (`2606.08588` → June 2026) is internally
   consistent with a 2026 publication year, but the paper's actual existence
   and content have not been re-verified in this pass.
2. **Lops et al. (2025)**, `arXiv:2511.20403` (AgoneTest). Also load-bearing:
   used to support the claim that LLM suites "can match or exceed human
   suites on both coverage and mutation-based defect detection" for the
   subset of generated tests that compile. **Action:** re-verify the exact
   framework name, author list, venue/preprint status, and the specific
   claim attributed to it (aggregated-across-projects vs. paired-per-component
   comparison).
3. **Zhao et al. (2026)**, *Proceedings of the ACM on Software Engineering*,
   3(ISSTA), **Article ISSTA002**, DOI `10.1145/3832093`. The article
   identifier "ISSTA002" is not in the same numeric-article format used by
   the paper's other PACMSE citations (e.g., Yuan et al.'s "Article 76").
   This internal inconsistency does not by itself indicate an error — PACMSE
   issues tied to different sister conferences may use different numbering
   conventions — but it is different enough from this paper's other PACMSE
   citation to warrant a direct check against the publisher's page.
   **Action:** verify the exact article number/ID and DOI resolve to the
   claimed paper before submission.

## Priority 2 — verify if time permits (supporting, not load-bearing)

4. **Ouédraogo et al. (2024)**, `arXiv:2407.00225`. Used to support a specific
   numeric claim ("216,300 generated tests across four LLMs and five
   prompting techniques"). **Action:** confirm this exact figure against the
   source rather than a paraphrase.
5. **Wang et al. (2026)** (MutGen), *IEEE Transactions on Software
   Engineering*, 52(5), 1657–1671, DOI `10.1109/TSE.2026.3682975`. Volume 52
   for IEEE TSE in 2026 is arithmetically plausible (TSE began in 1975;
   1975 + 51 ≈ 2026) but has not been checked against the actual table of
   contents. **Action:** confirm volume/issue/page range and DOI.
6. **Moradi Dakhel et al. (2024)** (MuTAP), *Information and Software
   Technology*, 171, 107468. No internal inconsistency found; flagged only
   because, like all entries here, it has not been independently re-read
   against the source in this pass.

## Priority 3 — low-risk, noted for completeness

7. **Duplicate article number "76" across two different venues.** Yuan et al.
   (2024), *PACMSE* 1(FSE), is listed as **Article 76**, and Yang et al.
   (2024), *ASE 2024 Proceedings*, is also listed as **Article 76**. Two
   different ACM-published venues independently numbering an article "76" in
   the same year is not inherently an error (ACM article numbers are
   typically sequential per volume/proceedings, not shared across venues),
   but the coincidence is worth a quick visual check against both papers'
   actual ACM Digital Library pages before submission.
8. **General note on preprint/published-status consistency.** Yuan et al. is
   the only reference with an explicit "originally released as arXiv:X,
   YEAR" annotation distinguishing preprint and published versions. Lops et
   al., Ouédraogo et al., and Vathana et al. are currently cited as arXiv
   preprints without a published-venue annotation. If any of these three has
   since appeared in a peer-reviewed venue, update the citation to the
   published version (or add the same "originally released as" annotation
   used for Yuan et al.) for consistency.

## What was checked and found clean

- No duplicate reference entries (same paper cited under two different keys).
- No internally inconsistent publication years for a single entry (e.g., a
  2019 in-text year with a 2024 reference-list year, or vice versa).
- DOI-suffix ordering is directionally consistent with publication years
  where multiple ACM DOIs are compared (e.g., Zhao et al. 2026's DOI suffix
  is numerically larger than Yang et al. 2024's, consistent with a later
  publication date), though this is only a weak internal-consistency signal,
  not verification.
- Venue-name formatting for *Proceedings of the ACM on Software Engineering*
  correctly varies the sister-conference designation per issue (1(FSE),
  3(ISSTA)), which is the actual convention for that journal, not a
  formatting error.
