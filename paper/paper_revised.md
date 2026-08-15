# Beyond Code Coverage: An Empirical Comparison of AI-Generated and Human-Written Unit Tests Using Mutation Testing

*[AUTHOR ACTION REQUIRED: Author(s) and affiliation to be added]*

> **Note on this revision:** everything below has been checked against the underlying experiment artifacts (coverage reports, mutation logs, JSONL results) for all ten experiments. Remaining `[AUTHOR ACTION REQUIRED]` markers cannot be resolved without additional information from the authors and are called out explicitly rather than guessed.

---

## Abstract

Large language models (LLMs) are increasingly used to generate unit tests, yet code coverage does not directly measure fault-detection capability. This paper presents a controlled empirical study comparing independently AI-generated unit tests with existing human-written tests across ten paired experiments drawn from five mature open-source Swift repositories. The studied components span serialization, reflection, data structures, algorithms, parser-printers, and numerical computation. To reduce information leakage, AI suites were generated from production code alone, without access to human tests, human coverage gaps, or mutation plans; each AI suite was frozen and fingerprinted before mutation design began. Human and AI suites were then executed against the same frozen mutant set. Across the ten experiments, the AI suite achieved the higher mutation score in six, the human suite in three, and one experiment tied; the unweighted mean mutation score was 93.8% for AI-generated tests and 88.8% for human-written tests. A paired comparison of the ten scores does not reach conventional statistical significance (Wilcoxon signed-rank test on the nine non-tied pairs, *W* = 6, *p* ≈ .05 two-sided; paired *t*-test, *t*(9) = 1.53, *p* ≈ .16), so we treat the win count and mean as descriptive rather than as evidence of a population-level effect. The more robust finding is structural: in three experiments the human and AI suites achieved identical coverage on every measured metric (including 100% in one case) yet differed in mutation score by 7–9 percentage points. This shows directly that coverage parity does not imply fault-detection parity, independent of which suite happens to win on average.

**Keywords:** large language models, unit testing, mutation testing, code coverage, Swift, software testing

---

## 1. Introduction

Unit testing remains a central mechanism for detecting regressions and documenting expected behavior. LLMs can now synthesize executable tests from production implementations, making automated test generation increasingly practical. Prior studies report promising coverage but also compilation failures, incorrect assertions, and weak fault detection (Yuan et al., 2024).

A test suite's quality can be described at several distinct levels, and this paper is organized around keeping them separate:

- **Code coverage** — whether a line, region, or function executes at least once.
- **Test and assertion quantity** — how many test methods and assertion call sites a suite contains.
- **Mutation score** — the fraction of seeded, syntactic code changes (mutants) that a suite detects.
- **Real fault-detection capability** — whether a suite catches actual, historically occurring defects.

Coverage answers only the first question. Mutation score is a stronger proxy for the fourth, but remains a proxy: it measures sensitivity to synthetic, seeded faults, not to the defects that occur in practice. We use mutation testing as an evaluation instrument, applied identically to both suites after they are frozen, rather than as feedback used during test generation.

### 1.1 Contributions

- A leakage-controlled paired methodology comparing human and independently AI-generated suites on the same production component and the same frozen mutant set.
- Ten experiments across five open-source Swift repositories and multiple behavioral domains.
- Direct evidence that coverage and mutation score can dissociate: in three experiments (§5.1) the two suites reached identical coverage on every reported metric — including 100% in one case — while differing in mutation score by 7–9 percentage points.

---

## 2. Research Questions

**RQ1:** How does the mutation score of independently AI-generated tests compare with existing human-written tests?

**RQ2:** When AI and human suites achieve similar or identical coverage, do they exhibit equivalent mutation-based fault detection?

**RQ3:** What behavioral gaps explain suite-specific mutant kills?

**RQ4:** How does suite size relate descriptively to mutation score?

---

## 3. Related Work

Coverage-based evaluation of test suites has long been questioned for human-written tests. Inozemtseva and Holmes found that, once test-suite size is controlled for, the correlation between coverage and mutation-based effectiveness is low to moderate for large Java programs, and argued coverage should not be used as a quality target (Inozemtseva & Holmes, 2014). Papadakis et al. survey the broader mutation-testing literature underpinning this line of work (Papadakis et al., 2019).

For LLM-generated tests specifically, Yuan et al. evaluated ChatGPT for unit-test generation and reported promising coverage alongside compilation and assertion-correctness failures (Yuan et al., 2024). MuTAP augments prompts with surviving mutants to improve LLM-generated tests (Moradi Dakhel et al., 2024), and MutGen applies mutation feedback iteratively during generation (Wang et al., 2026); both use mutation information as *generation feedback*. Our study differs by withholding mutation information from generation entirely and using mutation testing only for post-generation, comparative evaluation against an independently written human suite. Closest in spirit is Zhao et al.'s replication of Inozemtseva and Holmes for LLM-generated suites, which finds that coverage and mutation score correlate with real-bug detection only when the code under test can be assumed bug-free, and that suite size — the dominant confounder for human-written suites — is a comparatively weak confounder for LLM-generated suites (Zhao et al., 2026). Our RQ4 finding (§5.4) that larger AI suites do not consistently score higher is consistent with, though far smaller in scale than, that result.

> **TODO [AUTHOR ACTION REQUIRED]:** a full systematic search beyond these five anchor papers is still required before submission.

---

## 4. Methodology

### 4.1 Subjects

We selected focused components with existing human tests, deterministic SwiftPM execution, meaningful branch/boundary logic, and sufficient isolation for mutation analysis. Later components were additionally screened for behavioral diversity from earlier ones and for being likely to distinguish the two suites (Table 1); we discuss the implications of this selection criterion in §6.

**Table 1. Experimental subjects.** LOC is physical lines of the production file; executable lines are the denominator used for the coverage percentages reported in §5.

| Exp. | Repository | Component | LOC | Exec. lines |
|---|---|---|---:|---:|
| E1 | swift-snapshot-testing | URLRequest | 130 | 128 |
| E2 | swift-snapshot-testing | Any.swift | 241 | 139 |
| E3 | swift-collections | Heap | 390 | 309 |
| E4 | swift-collections | OrderedSet | 328 | 142 |
| E5 | swift-algorithms | Combinations | 311 | 126 |
| E6 | swift-algorithms | Partition | 389 | 216 |
| E7 | swift-parsing | Prefix | 191 | 100 |
| E8 | swift-parsing | Digits | 190 | 143 |
| E9 | swift-numerics | SaturatingArithmetic | 167 | 57 |
| E10 | swift-numerics | Polar | 130 | 34 |

### 4.2 Human Baseline

For each component, a focused human test filter was selected and frozen before AI generation. Line, region, and function coverage were recorded for this filter alone. Contamination-control rigor evolved across the ten experiments rather than being uniform throughout: for E1–E2, the AI suite did not yet exist when the human baseline was measured, so contamination was structurally impossible at that stage. From E3 onward we used explicit, qualified test filters to exclude AI-named tests, and one contamination incident occurred and was caught: an early E5 filter (`--filter CombinationsTests`) unintentionally matched the AI suite's class name; the contaminated run was discarded and archived separately, and the experiment was re-run with a fully qualified filter. From E6 onward, every mutant run additionally logged the exact executed test names and flagged any cross-suite match automatically. We report this evolution rather than presenting a single uniform protocol, since the later, stronger controls are what should be replicated in follow-up work.

> **TODO:** cross-reference this paragraph against the raw contamination logs for all ten experiments before submission.

### 4.3 Independent AI Test Generation

The AI could inspect the production implementation and the APIs needed for compilation, but not human tests, fixtures, human coverage reports, uncovered-path analyses, mutation plans, or mutation results. Generation was not one-shot: for each experiment, the AI-authored suite was iteratively corrected against *compiler errors and its own test failures* until it passed, then frozen and fingerprinted with SHA-256. This loop never consulted human tests, coverage, or mutation information, so it does not violate the leakage protocol, but it means the frozen suite reflects several rounds of self-correction rather than a single unedited generation pass; we note this because it is relevant to interpreting suite size and thoroughness (§5.4).

> **[AUTHOR ACTION REQUIRED]** Add exact model/version, Cursor version, prompt/runbook version per experiment, sampling/temperature settings if available, and generation timestamps. These are necessary for reproducibility and are currently missing.

### 4.4 Mutation Design and Execution

Mutation plans were defined only after both suites were frozen. Mutants represented realistic defect classes: branch inversions, comparison-operator errors, off-by-one boundaries, wrong return values, omitted guards, sign errors, and special-case handling. The same mutant was executed against both frozen suites, in randomized order per mutant, with production code restored and its checksum re-verified between mutants.

A mutant was classified as killed when a test failed; crash and timeout kills also counted as kills. A survivor was excluded from the denominator as equivalent only after an explicit code-level argument for why no test could distinguish the mutant from the original under the public API. This adjudication was performed by the same person who designed the AI prompts and the mutation plan, with no independent second annotator; we treat this as a limitation (§6) rather than a resolved methodological question. The fraction of planned mutants ultimately excluded as equivalent or non-compiling varied by component, from 0% (E3, E8, E9) to 19% (E5); we do not have a component-independent explanation for this variation and report it rather than smoothing over it.

$$MS = \frac{\text{killed}}{\text{killed}+\text{survived}}\times100$$

### 4.5 Integrity Controls

Production files were restored between mutants and their SHA-256 checksums re-verified, frozen suites were rerun after each mutation campaign to confirm they still passed against restored production code, and neither suite was edited after mutation outcomes were observed.

> **TODO [AUTHOR ACTION REQUIRED]:** add artifact repository URL.

---

## 5. Results

**Table 2. Mutation score by experiment and suite**, and valid-mutant denominator (planned mutants minus those excluded as non-compiling or equivalent after code-level justification). "Higher" marks the suite with the numerically larger score; see the discussion below the table for why this comparison should not be read as statistically conclusive.

| Exp. | Valid mutants | Human MS | AI MS | Higher |
|---|---:|---:|---:|---|
| E1 | 20 | 85.0% | 95.0% | AI |
| E2 | 27 | 70.4% | 85.2% | AI |
| E3 | 28 | 92.9% | 85.7% | Human |
| E4 | 25 | 96.0% | 88.0% | Human |
| E5 | 21 | 100.0% | 100.0% | Tie |
| E6 | 22 | 90.9% | 100.0% | AI |
| E7 | 23 | 91.3% | 100.0% | AI |
| E8 | 24 | 91.7% | 100.0% | AI |
| E9 | 26 | 96.2% | 88.5% | Human |
| E10 | 23 | 73.9% | 95.7% | AI |

AI achieved the higher mutation score in six experiments, human tests in three, and one tied. The unweighted mean mutation score was 93.8% for AI and 88.8% for human tests, a difference of 4.98 percentage points. We computed a paired *t*-test and a Wilcoxon signed-rank test directly on the ten (nine non-tied) score differences in Table 2: *t*(9) = 1.53, *p* ≈ .16; Wilcoxon *W* = 6, which does not clear the exact two-sided critical value of 5 at α = .05 for *n* = 9. Neither test reaches conventional significance. Given that the ten experiments are not independent draws — they are clustered within five repositories, use heterogeneous mutant sets of different sizes, and were all produced by the same experimenter — we report this test result as a caution against over-reading the win count, not as a substitute for a properly powered, pre-registered comparison.

> **[AUTHOR ACTION REQUIRED]:** verify this computation independently with a statistical package before submission; it was performed manually here.

**Table 3. Test-method and static-assertion-call-site counts per suite.** AI suites were larger in nine of ten experiments; §5.4 shows this did not translate into a consistently higher mutation score.

| Exp. | Human tests | Human assertions | AI tests | AI assertions |
|---|---:|---:|---:|---:|
| E1 | 1 | 10 | 44 | 56 |
| E2 | 6 | 14 | 51 | 101 |
| E3 | 32 | 245 | 50 | 167 |
| E4 | 10 | 73 | 41 | 139 |
| E5 | 4 | 28 | 27 | 62 |
| E6 | 10 | 39 | 29 | 59 |
| E7 | 13 | 27 | 25 | 42 |
| E8 | 2 | 13 | 25 | 37 |
| E9 | 10 | 10 | 27 | 58 |
| E10 | 1 | 19 | 18 | 49 |

![Figure 1: Mutation scores for human-written and AI-generated suites across all ten experiments. Bar height is the mutation score against each experiment's own valid-mutant denominator (Table 2); denominators differ across experiments and are not directly comparable in absolute mutant count.](figure1_mutation_scores.png)

### 5.1 Identical Coverage, Different Mutation Score

E3, E4, and E9 provide the clearest evidence for RQ2. In E3, both suites achieved 99.03% line coverage on the primary heap implementation, yet human tests scored 92.9% versus 85.7% for AI — a 7.2-point gap under identical coverage, driven by two human-only kills on tie-break/identity-sensitive mutants that AI's otherwise-equivalent line coverage did not encode assertions for. In E4, both suites achieved identical line (82.39%), region (78.85%), and function (73.08%) coverage, while human tests scored 96.0% versus 88.0% for AI, driven by two human-only kills on capacity/overflow-boundary mutants. In E9, both suites achieved 100% line, region, and function coverage — the strongest possible coverage parity — yet human tests scored 96.2% versus 88.5% for AI, driven by two human-only kills on shift-boundary and signed-overflow mutants. In all three cases the coverage tools report the suites as equivalent; the mutation results show they are not.

![Figure 2: Mutation-score divergence in E3, E4, and E9 despite identical primary coverage (all three reported metrics) within each experiment. The human suite scores higher in all three; the full results table shows this pattern does not hold across the full sample.](figure2_identical_coverage_divergence.png)

### 5.2 Coverage Gaps, Mutation Gaps

In E6, AI covered `Sequence.partitioned` behavior that the human suite's coverage left at 0%, and uniquely killed two polarity mutants confined to that overload. In E7, AI line coverage was 98.0% versus 64.0% for human tests, concentrated in the `print` path, and AI uniquely killed two printer-validation mutants there. E8 showed the same pattern (AI 95.8% versus human 81.82% line coverage; two AI-only kills, one on an exact-boundary print check and one on a negative-value print guard). In E10, AI achieved 97.06% line coverage versus 88.24% for human tests and killed five mutants — concentrated in non-finite length/phase handling — that the human suite's single randomized round-trip test missed.

![Figure 3: Paired mutation-score difference (AI minus Human) for all ten experiments. Positive values favor AI. The pattern is mixed rather than one-directional; the E10 outlier (+21.8 points) reflects a human suite consisting of a single randomized test method (Table 3).](figure3_paired_differences.png)

### 5.3 Equal Coverage Can Also Coincide with Equal Effectiveness

E5 is the counterexample to §5.1: human and AI suites achieved identical near-complete coverage (99.21%/96.00%/94.74%) and both killed all 21 valid mutants. Coverage parity is therefore not sufficient on its own to predict a mutation-score gap — it is possible for two suites to be equivalent on both axes at once. We report this alongside §5.1 precisely because the two results together, not either alone, are what support RQ2's answer: coverage parity is uninformative about whether a mutation-score gap exists, in either direction.

### 5.4 Suite Size

AI suites were larger in nine of ten experiments (Table 3), but larger size did not guarantee a higher mutation score. E4 used 41 AI tests versus 10 human tests, yet human tests scored higher. E5 used 27 AI tests versus 4 human tests, and both scored 100%. E9 used 27 AI tests versus 10 human tests, yet human tests again scored higher. Across all ten experiments, the suite with more tests also had the higher (or tied) mutation score in seven cases and the lower score in three (E3, E4, E9) — the same three experiments identified in §5.1.

---

## 6. Discussion

### RQ1

AI tests were often strong but not uniformly superior, and the aggregate difference is not statistically distinguishable from no difference at this sample size (§5). We do not interpret the 6-3-1 split as evidence that AI-generated tests are generally more or less effective than human-written tests; we interpret it as showing that neither suite dominated on this sample of ten components.

### RQ2

Similar or identical coverage did not guarantee equivalent mutation score. E3, E4, and E9 show that two suites can execute the same lines, regions, and functions while encoding different behavioral oracles over those same paths — coverage cannot see the difference, and mutation testing can. E5 shows the same coverage parity can also coincide with mutation-score parity, so coverage parity does not *determine* the direction or existence of a mutation-score gap; it simply does not rule one out.

### RQ3

AI-only kills clustered around paths the human suites' coverage did not reach at all: an untested `Sequence` overload (E6), `print`-path validation (E7, E8), and non-finite floating-point special cases (E10). Human-only kills, by contrast, occurred *inside* paths both suites already covered, and reflected narrower semantic expectations that coverage cannot express: tie-break identity (E3), capacity/overflow boundaries (E4), and signed-overflow shift semantics (E9). This is a thematic, qualitative pattern across ten case studies, not a statistically tested claim.

### RQ4

The suite with more test methods had the higher or tied mutation score in seven of ten experiments and the lower score in three. Because suite size was not controlled and the AI suites were also produced through an iterative self-correction loop (§4.3) rather than a single generation pass, we cannot separate the effect of raw test count from the effect of that iteration; no causal conclusion about suite size is warranted from this sample.

---

## 7. Threats to Validity

**Internal validity.** Mutation selection and equivalent-mutant classification involve researcher judgment. Mutation plans were frozen before execution, which limits post-hoc mutant selection, but equivalence adjudication happened only after observing which mutants survived both suites, and was performed by the same person who designed the AI prompts and mutation plans, with no independent second annotator. The equivalent/invalid exclusion rate varied from 0% to 19% of planned mutants across experiments; we report this rather than treat it as noise, since we cannot rule out that harder-to-kill components produced more permissive equivalence judgments.

**Construct validity.** Mutation score measures sensitivity to seeded, syntactic faults, not to the distribution of real historical defects. Coverage measures execution, not assertion quality; §5.1 demonstrates this gap directly rather than asserting it.

**External validity.** The study covers ten components from five Swift repositories. Component selection for later experiments explicitly favored components expected to distinguish the two suites, alongside more standard criteria (existing tests, appropriate size, mutation potential). This is a deliberate design choice for maximizing informativeness per experiment, but it means the sample is not representative of an unbiased population of tested components, and the frequency and magnitude of divergence reported here should not be extrapolated to arbitrary code. Results may also not generalize to other languages, systems, test levels, or LLMs.

**Conclusion validity.** The ten paired experiments are clustered within five repositories, use different mutant sets of different sizes (21–28 valid mutants), and were all produced by a single experimenter in a short time window. The win count and mean mutation score should be read as descriptive; the paired-difference test in §5 does not reach significance at conventional thresholds.

**Reproducibility.** Repository SHAs, fingerprints, filters, coverage artifacts, mutation plans, logs, and machine-readable results were retained for all ten experiments. Exact model/version, Cursor version, prompts, and generation/sampling configuration are not yet included and are required before submission (§4.3).

---

## 8. Conclusion

Across ten paired experiments on five open-source Swift repositories, independently AI-generated tests frequently broadened coverage into boundary, overload, printing, and special-value behavior that the existing human suites did not reach. AI-generated suites also achieved a numerically higher mean mutation score across this sample, but that difference is not statistically distinguishable from no difference given the sample's size and structure. The most robust finding is not the aggregate comparison but the demonstration, in three separate components, that identical or complete coverage can coexist with materially different mutation scores. This shows directly that coverage cannot be used as a proxy for mutation-based fault detection, independent of which suite currently wins on average. The evidence supports a narrow, complementary reading: on this sample, AI-generated tests tended to enumerate behaviors the human suites had not exercised, while human tests tended to encode narrower semantic invariants inside paths both suites already covered.

Future work should expand the sample with a pre-registered, comparison-neutral component-selection protocol; use an independent second annotator for equivalent-mutant classification; control for suite size and generation-iteration count; compare multiple LLMs and prompting strategies; and validate the observed patterns against real historical defects rather than seeded mutants alone.

---

## References

Inozemtseva, L., & Holmes, R. (2014). Coverage is not strongly correlated with test suite effectiveness. *Proceedings of the 36th International Conference on Software Engineering (ICSE)*, 435–445. https://doi.org/10.1145/2568225.2568271

Moradi Dakhel, A., Nikanjam, A., Majdinasab, V., Khomh, F., & Desmarais, M. C. (2024). Effective test generation using pre-trained large language models and mutation testing. *Information and Software Technology*, *171*, 107468. https://doi.org/10.1016/j.infsof.2024.107468

Papadakis, M., Kintis, M., Zhang, J., Jia, Y., Le Traon, Y., & Harman, M. (2019). Mutation testing advances: An analysis and survey. *Advances in Computers*, *112*, 275–378. https://doi.org/10.1016/bs.adcom.2018.03.015

Wang, G., Xu, Q., Briand, L., & Liu, K. (2026). Mutation-guided unit test generation with a large language model. *IEEE Transactions on Software Engineering*, *52*(5), 1657–1671. https://doi.org/10.1109/TSE.2026.3682975

Yuan, Z., Liu, M., Ding, S., Wang, K., Chen, Y., Peng, X., & Lou, Y. (2024). No more manual tests? Evaluating and improving ChatGPT for unit test generation. *Proceedings of the ACM on Software Engineering*, *1*(FSE), Article 76. https://doi.org/10.1145/3660783 (Originally released as arXiv:2305.04207, 2023.)

Zhao, J., Zhou, S., & Cohen, E. (2026). Do coverage and mutation scores of LLM-generated test suites correlate with their effectiveness? (Replicability study). *Proceedings of the ACM on Software Engineering*, *3*(ISSTA), Article ISSTA002. https://doi.org/10.1145/3832093

---

## Appendix A. Audit Checklist

1. All ten experiment summaries have been checked against raw coverage and mutation-result artifacts (done for this revision).
2. E1/E2 mutation and coverage artifacts verified against `research/mutation-results.md` and `research/experiment-2-mutation-results.md`.
3. Invalid/equivalent mutant exclusions re-audited per experiment; exclusion-rate variation is now reported explicitly (§7).
4. **[AUTHOR ACTION REQUIRED]** Add exact AI model/version, Cursor version, prompts, and settings.
5. Repository SHAs and SHA-256 fingerprints verified present and well-formed in underlying artifacts (40-hex-character SHA-1 repository revisions).
6. Bibliography metadata corrected for Yuan et al., Wang et al. (MutGen), and Zhao et al.; two foundational citations added (Inozemtseva & Holmes 2014; Papadakis et al. 2019). **[AUTHOR ACTION REQUIRED]:** full systematic related-work pass still needed.
7. Figure values verified against Tables 2/3 and the final aggregate computation in §5.
8. Human/AI test-filter disjointness verified for every scored experiment; contamination-control evolution across experiments is now described explicitly (§4.2) rather than presented as uniform.
