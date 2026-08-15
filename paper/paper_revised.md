# Beyond Code Coverage: An Empirical Comparison of AI-Generated and Human-Written Unit Tests Using Mutation Testing

**Premal Mistry**¹ · **Randhir Kumar**¹

¹ Independent Researcher

> **Note on this revision:** this version repairs the manuscript following an adversarial internal review (`paper/conference-review-audit.md`) conducted after the second experimental phase (E11–E15) was added. No new experiments, tests, or mutants were run to produce this revision; all changes are terminology corrections, added disclosures, and re-aggregations of already-frozen results (`research/mutation-lookahead-audit.md`, `research/union-mutation-analysis.md`, `research/pooled-mutation-analysis.md`). The most consequential change is an explicit, quantified disclosure of **mutation-selection look-ahead**: several mutation plans were drafted with knowledge of each frozen suite's specific content, and this is now reported as a first-class threat to validity (§7.3) rather than left undisclosed. The second phase is now termed a **neutral-selection follow-up phase** rather than "confirmatory," to avoid implying a stronger evidentiary standard (e.g., external pre-registration) than was actually used. A full list of changes and their resolution status is in `paper/reviewer-repair-change-log.md`.

---

## Abstract

Code coverage does not directly measure fault-detection capability, yet it remains a common proxy for evaluating LLM-generated tests. We present a two-phase controlled study comparing existing human-written test filters against independently generated AI test suites on paired production components from five open-source Swift repositories. An **exploratory phase** (E1–E10) selected components partly for their likely ability to distinguish the two suites; a **neutral-selection follow-up phase** (E11–E15) applied a pre-declared, not externally pre-registered, eligibility-and-alphabetical-order rule, frozen before any outcome was observed, to reduce that bias. In three exploratory and one follow-up experiment, the suites reached identical coverage on every measured metric yet differed in mutation score by 7–9 points; a further follow-up experiment shows the suite with *higher* line coverage achieving the *lower* mutation score. We conclude that line, region, and function coverage, as measured by llvm-cov, are insufficient on their own to infer mutation-based fault-detection effectiveness. AI suites scored numerically higher on average in both phases — not statistically distinguishable from no difference in the exploratory phase, and a small-sample, non-inferential advantage in the follow-up phase — and the two suites frequently killed different mutants: their union killed more mutants than either alone in 5 of 15 experiments. A key limitation, quantified here for the first time, is that some mutation plans were drafted with knowledge of each frozen suite's content, so mutation-score gaps are conditional on suite-aware mutant sets, not a blind instrument. AI suites were also fresher, iteratively self-corrected, and usually larger than the human filters — an effort asymmetry we do not resolve.

**Keywords:** large language models, unit testing, mutation testing, code coverage, Swift, software testing

---

## 1. Introduction

Unit testing remains a central mechanism for detecting regressions and documenting expected behavior. LLMs can now synthesize executable tests from production implementations, making automated test generation increasingly practical. Prior studies report promising coverage but also compilation failures, incorrect assertions, and weak fault detection (Yuan et al., 2024).

A test suite's quality can be described at several distinct levels, and this paper is organized around keeping them separate:

- **Code coverage** — whether a line, region, or function executes at least once.
- **Test and assertion quantity** — how many test methods and assertion call sites a suite contains.
- **Mutation score** — the fraction of seeded, syntactic code changes (mutants) that a suite detects.
- **Real fault-detection capability** — whether a suite catches actual, historically occurring defects.

Coverage answers only the first question. Mutation score is a stronger proxy for the fourth, but remains a proxy: it measures sensitivity to synthetic, seeded faults, not to the defects that occur in practice. Mutation testing is used here as an evaluation instrument, applied after both suites are frozen, rather than as feedback used during test generation — but, as we disclose fully in §4.4 and §7.3, the *design* of that instrument (which mutants to include) was not blind to the frozen suites' content in every experiment, and we quantify that exposure rather than assume it away.

This study is organized into two explicitly separated phases. The **exploratory phase** (E1–E10, §4.1–§5) established our initial observations: AI-generated suites were often but not uniformly stronger on mutation score, and — most importantly — three components showed that suites with *identical* coverage on every reported metric could still differ in mutation score by several percentage points. Because later exploratory components were partly selected for being likely to distinguish the two suites (§4.1), that sample alone cannot rule out component-selection bias as an explanation for the observed patterns. A **neutral-selection follow-up phase** (E11–E15, §4.6–§5) was designed specifically to address that concern: five additional components were selected by a pre-declared, comparison-neutral rule — fixed eligibility criteria, alphabetical sort, first eligible component, frozen before any result is observed — and the same leakage-controlled, freeze-before-mutate protocol was applied. This rule was pre-declared internally, before any E11 outcome was observed, but was not externally pre-registered (e.g., via a timestamped, third-party-verifiable commitment); we therefore treat it as a bias-reduction mechanism, not a formal preregistration, and use "neutral-selection follow-up" rather than "confirmatory" throughout to avoid overstating the evidentiary standard. We report whether the exploratory patterns recur under this neutral-selection rule, and we keep the two phases' results and win counts separate throughout rather than pooling them into a single combined statistic. Both phases compare an **existing, researcher-selected filter over human-written tests** against a **freshly generated, independently written AI suite** — not human ability against AI ability under matched effort; §4.2, §6, and §7.2 discuss this asymmetry explicitly.

### 1.1 Contributions

1. A leakage-controlled paired methodology comparing an existing human-written test filter and an independently generated AI suite on the same production component and the same frozen mutant set, applied consistently across fifteen experiments.
2. Ten exploratory experiments (E1–E10) across five open-source Swift repositories and multiple behavioral domains, including three components (E3, E4, E9) where identical coverage on every reported metric coincided with different mutation scores.
3. Five additional neutral-selection follow-up experiments (E11–E15) using a pre-declared, comparison-neutral component-selection protocol, designed to reduce (not eliminate) the component-selection-bias threat identified in the exploratory phase.
4. A recurrence, under neutral component selection, of the coverage/mutation-score dissociation pattern (E13: identical line coverage, 8.7-point mutation-score gap; E15: the higher-line-coverage suite scores *lower* on mutation; E14: a 32-point coverage gap coincides with only a 4.5-point mutation-score gap).
5. Evidence, in both phases, that human-written and independently generated AI suites frequently kill different mutants — the union of both suites killed more mutants than either alone in 5 of 15 experiments (`research/union-mutation-analysis.md`) — suggesting complementary testing value rather than substitutability, without claiming this is a universal taxonomy of human-vs-AI testing behavior.
6. A quantified audit of mutation-selection look-ahead (`research/mutation-lookahead-audit.md`): 29 of 369 planned mutants across the study (7.9%) carry explicit, suite-content-specific outcome predictions, concentrated almost entirely in two experiments (E2, E11), which we report as a conditioning factor on the mutation-score gaps rather than a discarded artifact.

---

## 2. Research Questions

**RQ1:** How does the mutation score of independently generated AI tests compare with an existing human-written test filter?

**RQ2:** When the human filter and AI suite achieve similar or identical coverage, do they exhibit equivalent mutation-based fault detection?

**RQ3:** What behavioral gaps explain suite-specific mutant kills?

**RQ4 (secondary, descriptive):** How does suite size relate descriptively to mutation score?

All four RQs are answered separately for the exploratory phase (E1–E10, §5.0–§5.4) and the neutral-selection follow-up phase (E11–E15, §5.5–§5.7) before being discussed jointly, with phase labels preserved, in §6. RQ4 is treated as secondary and descriptive throughout: suite size was never a controlled variable, and no causal claim about suite size is made in either phase.

---

## 3. Related Work

Coverage-based evaluation of test suites has long been questioned for human-written tests. Inozemtseva and Holmes found that, once test-suite size is controlled for, the correlation between coverage and mutation-based effectiveness is low to moderate for large Java programs, and argued coverage should not be used as a quality target (Inozemtseva & Holmes, 2014). Papadakis et al. survey the broader mutation-testing literature underpinning this line of work (Papadakis et al., 2019).

For LLM-generated tests specifically, Yuan et al. evaluated ChatGPT for unit-test generation and reported promising coverage alongside compilation and assertion-correctness failures (Yuan et al., 2024). Yang et al. benchmarked open-source LLMs for Java unit-test generation against GPT-4 and EvoSuite across 17 projects and multiple prompting strategies, likewise finding that prompt design and model choice strongly affect coverage and defect-detection outcomes (Yang et al., 2024). Ouédraogo et al. extended this line to a larger, leakage-aware benchmark (216,300 generated tests across four LLMs and five prompting techniques) and found LLM-generated suites can match or exceed EvoSuite's coverage under chain-of-thought-style prompting, though fault detection remained inconsistent and highly prompt-dependent (Ouédraogo et al., 2024). MuTAP augments prompts with surviving mutants to improve LLM-generated tests (Moradi Dakhel et al., 2024), and MutGen applies mutation feedback iteratively during generation (Wang et al., 2026); both use mutation information as *generation feedback*. Our study differs by withholding mutation information from generation entirely and using mutation testing only for post-generation, comparative evaluation against an independently written human suite.

Two very recent studies are closest in spirit and design to ours. Lops et al.'s AgoneTest framework directly compares LLM-generated and human-written Java test suites at the class level using coverage, mutation score, and test-smell metrics, and reports that, for the subset of generated tests that compile, LLM suites can match or exceed human suites on both coverage and mutation-based defect detection (Lops et al., 2025) — broadly consistent with our six-of-ten AI-favoring result, though their comparison is aggregated across many projects rather than paired per-component. Vathana et al. compare LLM-generated and human-written Python tests on real historical bugs from BugsInPy and report the inverse asymmetry to the coverage-parity cases we observe in §5.1: their two suites achieve statistically indistinguishable line and branch coverage, yet retrieval-augmented LLM tests detect four times as many real bugs as general-purpose human tests (69% vs. 17.2%, Fisher's exact *p* < .001) (Vathana et al., 2026). Read together with our E3/E4/E9 findings — where coverage parity coincides with a human-favoring mutation-score gap — these results reinforce the same structural point from opposite directions: coverage parity constrains neither the direction nor the magnitude of a fault-detection gap between human and AI-generated suites.

Closest in spirit for the coverage/mutation-score dissociation question specifically is Zhao et al.'s replication of Inozemtseva and Holmes for LLM-generated suites, which finds that coverage and mutation score correlate with real-bug detection only when the code under test can be assumed bug-free, and that suite size — the dominant confounder for human-written suites — is a comparatively weak confounder for LLM-generated suites (Zhao et al., 2026). Our RQ4 finding (§5.4) that larger AI suites do not consistently score higher is consistent with, though far smaller in scale than, that result.

This search covered ChatGPT/Codex-based generation (Yuan et al., 2024), open-source-LLM benchmarking against EvoSuite (Yang et al., 2024; Ouédraogo et al., 2024), mutation-feedback-guided generation (Moradi Dakhel et al., 2024; Wang et al., 2026), direct LLM-vs-human comparison on Java (Lops et al., 2025) and Python (Vathana et al., 2026), and coverage/mutation/real-defect correlation studies (Inozemtseva & Holmes, 2014; Papadakis et al., 2019; Zhao et al., 2026). It was conducted via targeted keyword search (`LLM unit test generation mutation testing`, `AI generated vs human unit tests fault detection`) rather than a formal systematic-review protocol (e.g., PRISMA-style database queries with inclusion/exclusion criteria); a fully systematic search remains an opportunity for a future version of this paper but is no longer limited to the original five anchor papers.

None of the studies above use a pre-declared, comparison-neutral component-selection rule of the kind we add in the neutral-selection follow-up phase (§4.6); component or benchmark selection in this literature is typically determined by existing benchmark suites (e.g., EvoSuite corpora, BugsInPy) rather than by a rule applied post hoc by the same researchers who designed the comparison. We are not aware of prior LLM-vs-human test-suite studies that add a second, neutrally selected follow-up phase specifically to probe their own component-selection bias, and we present this as a methodological addition rather than a claim of being first to study coverage/mutation dissociation. We are also not aware of prior studies in this space that quantify mutation-selection look-ahead exposure in their own manually designed mutant sets (§7.3); we treat this as an open methodological gap in the broader literature, not one this paper fully resolves.

---

## 4. Methodology

This section describes the exploratory phase (§4.1–§4.5, E1–E10) first, exactly as originally conducted and disclosed, and then the neutral-selection follow-up phase (§4.6–§4.8, E11–E15) that was added afterward using a different, pre-declared component-selection rule. The two phases share the same leakage-control, suite-freezing, fingerprinting, and mutation-execution protocol (§4.2–§4.5); they differ only in how the production component was chosen. Throughout this section we use **"existing Human test filter"** for the researcher-selected subset of an existing repository's tests that exercises a given component, and **"independently generated AI suite"** for the freshly written suite — not "Human suite" vs. "AI suite" as if the two were produced under matched effort or matched freshness (§4.2, §4.3, §7.2 discuss this asymmetry directly).

### 4.1 Subjects (Exploratory Phase)

We selected focused components with existing human tests, deterministic SwiftPM execution, meaningful branch/boundary logic, and sufficient isolation for mutation analysis. Later components were additionally screened for behavioral diversity from earlier ones and for being likely to distinguish the two suites (Table 1); we discuss the implications of this selection criterion in §7, and we describe the neutral-selection follow-up phase added specifically to address it in §4.6.

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

### 4.2 Existing Human Test Filter (Exploratory Phase)

For each component, a focused **existing Human test filter** — a researcher-selected subset of that repository's already-existing tests, not a newly written or expanded suite — was selected and frozen before AI generation. Line, region, and function coverage were recorded for this filter alone. Contamination-control rigor evolved across the ten experiments rather than being uniform throughout: for E1–E2, the AI suite did not yet exist when the human baseline was measured, so contamination was structurally impossible at that stage. From E3 onward we used explicit, qualified test filters to exclude AI-named tests, and one contamination incident occurred and was caught: an early E5 filter (`--filter CombinationsTests`) unintentionally matched the AI suite's class name; the contaminated run was discarded and archived separately, and the experiment was re-run with a fully qualified filter. From E6 onward, every mutant run additionally logged the exact executed test names and flagged any cross-suite match automatically. We report this evolution rather than presenting a single uniform protocol, since the later, stronger controls are what should be replicated in follow-up work.

Because this filter is a subset selected by us, not necessarily every existing test in the repository that happens to exercise the component, it can understate what the repository's own maintainers would consider "the tests for this component." Two concrete instances are worth naming here rather than only in the aggregate: in E11, a related Swift Testing suite (`SnapshotsTraitTests`) was identified during candidate selection and deliberately left out of the frozen filter's default scope (`research/experiment-11-candidate-selection.md`); and in E15, an existing randomized round-trip test (`testPolar`, unrelated to the E15 component but present in the same test file family) was excluded from the frozen filter to keep baseline execution deterministic (§4.8). Neither exclusion was made after observing mutation results, but both mean the reported Human mutation score is a property of the *selected filter*, not necessarily of every test that exists for the component.

This description was cross-checked against the raw per-experiment baseline records: E9 and E10 report an explicit "contamination CLEAN" check; E6, E7, and E8 report a "Contamination check (Runbook v2)" step with a CLEAN result; E3 and E4 use class- or method-qualified filters (e.g., `--filter HeapTests`, `--filter 'OrderedSetTests.test_append$|...'`) that structurally exclude the differently-named AI test classes; E1 and E2 predate AI-suite existence at baseline time, so contamination was not applicable. This is consistent with the evolution described above.

### 4.3 Independent AI Test Generation (Exploratory Phase)

The AI could inspect the production implementation and the APIs needed for compilation, but not human tests, fixtures, human coverage reports, uncovered-path analyses, mutation plans, or mutation results. Generation was not one-shot: for each experiment, the AI-authored suite was iteratively corrected against *compiler errors and its own test failures* until it passed, then frozen and fingerprinted with SHA-256. This loop never consulted human tests, coverage, or mutation information, so it does not violate the leakage protocol, but it means the frozen suite reflects several rounds of self-correction rather than a single unedited generation pass; we note this because it is relevant to interpreting suite size and thoroughness (§5.4).

This generation process is not symmetric with how the existing Human filter came to exist. The AI suite is written fresh against the *current* production implementation, with no limit on self-correction iterations, tokens, or wall-clock time recorded in this study; the existing Human tests were written historically, by the repositories' own maintainers, under unknown time and knowledge constraints, and were never expanded or corrected for this study. AI suites were also larger than the Human filter in nine of ten exploratory experiments and in all five follow-up experiments (Table 3, Table 5). A plausible alternative reading of most AI-favoring results in this paper is therefore "a larger, fresher, iteratively self-corrected suite outperforms a smaller, older, unmodified filter," rather than "AI-generated tests are intrinsically more effective than human-written tests." We do not attempt to separate freshness, size, and iteration-count effects from any effect specific to the generating agent in this study (§7.2), and this asymmetry should be kept in mind when reading every mutation-score comparison in §5 and §6.

All ten experiments used the Grok 4.5 model accessed through the Cursor AI coding agent (version 3.15.19), with default sampling/temperature settings (not explicitly modified from the vendor default). Generation was guided by a written experimental protocol ("runbook") governing candidate selection, contamination controls, freezing, and mutation design; this protocol was refined iteratively as contamination-control rigor increased across the study (§4.2), so the exact runbook text differed somewhat between the earlier and later experiments rather than being version-pinned per experiment. Per-experiment generation timestamps (UTC) are recorded in each experiment's `research/experiment-N-candidate.md` file in the project repository (§4.5) and range from 2026-08-13T00:43Z (E1) to 2026-08-13T15:30Z (E10).

### 4.4 Mutation Design and Execution (Exploratory Phase)

Mutation plans were defined only after both suites were frozen. Mutants represented realistic defect classes: branch inversions, comparison-operator errors, off-by-one boundaries, wrong return values, omitted guards, sign errors, and special-case handling. The same mutant was executed against both frozen suites, in randomized order per mutant, with production code restored and its checksum re-verified between mutants.

Freezing both suites before mutation design prevents *test-side* adaptation to known mutants, but it does not, by itself, make mutant *selection* blind to the suites being compared: the person drafting each mutation plan had access to both suites' frozen content and coverage output while choosing which mutants to include. We disclose this explicitly rather than assume freezing is sufficient. Several mutation plans record an explicit, suite-specific outcome prediction for individual mutants — e.g., "Human may not call `rawValue`," "no enum dumps in human filter" — written *before* that mutant was executed, but *after* both suites' content was known. `research/mutation-lookahead-audit.md` audits every mutation plan in the study and finds this pattern in 29 of 369 planned mutants (7.9%), concentrated almost entirely in two experiments (E2: 7/27, 25.9%; E11: 12/24, 50.0%), with smaller traces in E3, E6, E7, and E13, and no textual evidence of it in the other nine experiments. We treat mutation-score gaps in the affected experiments — most importantly E11, which also has the largest gap in the study — as **conditional on a manually constructed, suite-aware mutant set**, not as an unbiased estimate of general suite effectiveness; §7.3 develops this as a first-class threat to validity.

A mutant was classified as killed when a test failed; crash and timeout kills also counted as kills. A survivor was excluded from the denominator as equivalent only after an explicit code-level argument for why no test could distinguish the mutant from the original under the public API. This adjudication was performed by the same person who designed the AI prompts and the mutation plan, with no independent second annotator; we treat this as a limitation (§7) rather than a resolved methodological question. The fraction of planned mutants ultimately excluded as equivalent or non-compiling varied by component, from 0% (E3, E8, E9) to 19% (E5); we do not have a component-independent explanation for this variation and report it rather than smoothing over it.

$$MS = \frac{\text{killed}}{\text{killed}+\text{survived}}\times100$$

### 4.5 Integrity Controls (Exploratory Phase)

Production files were restored between mutants and their SHA-256 checksums re-verified, frozen suites were rerun after each mutation campaign to confirm they still passed against restored production code, and neither suite was edited after mutation outcomes were observed.

### 4.6 Neutral-Selection Follow-Up Phase: Rationale and Component Selection

The exploratory phase (§4.1) explicitly screened later components for being "likely to distinguish the two suites." That criterion is scientifically useful for maximizing the information content of each individual case study, but it also means the ten exploratory components are not a selection-neutral sample: we cannot rule out that the observed patterns partly reflect which components we chose to study rather than a property of human- and AI-written tests in general. We designed the neutral-selection follow-up phase specifically to address this threat, not to replace or reanalyze the exploratory phase.

For each follow-up experiment, we followed a **pre-declared neutral selection rule**, fixed in writing before applying it to any repository. This rule was pre-declared *internally* — written down and frozen by us before E11 outcomes were observed — but it was not externally pre-registered (e.g., time-stamped with a third-party registry before data collection, as in a formal preregistration). We therefore describe it throughout as a **bias-reduction mechanism**, not a preregistration, and avoid the term "pre-registered" for this reason.

1. Enumerate every production `.swift` file under the target repository's `Sources/` tree.
2. Apply seven fixed eligibility criteria: (a) the component has direct, existing human-written tests; (b) those tests are deterministic; (c) the component has focused, observable behavior; (d) the component can reasonably support meaningful mutation testing; (e) the component requires no network or external services; (f) the component was not already studied in any prior experiment in this repository (E1–E10 or an earlier neutral-selection follow-up experiment); (g) the component is reasonably isolated for a paired human-vs-AI comparison.
3. Sort the resulting eligible set alphabetically by production file path.
4. Select the **first** eligible component.
5. **Freeze** that component before AI generation, before coverage is compared, before mutations are designed, and before any outcome is observed.
6. **Accept the result regardless of outcome** — the component is not replaced because a result looks weak, strong, boring, tied, or inconsistent with the exploratory phase or with a predicted winner.

This rule is comparison-neutral in the sense that it does not consult predicted or observed suite performance when choosing a component, and it is fully auditable: every experiment's candidate-selection record (`research/experiment-N-candidate-selection.md`) lists the complete eligible-component inventory, the alphabetical ordering, and the exclusion reason for every non-selected file. It is important to state precisely what this rule does and does not address: it removes *researcher discretion in choosing which component to study* from the comparison, but it does not make the sample random, and it does not remove researcher discretion from adjacent decisions — the eligibility criteria themselves, the choice of five specific repositories (the same five studied in the exploratory phase), the framing of the existing Human test filter, and the mutation-design and equivalence judgments applied afterward, including the mutation-selection look-ahead documented in §4.4 and §7.3, which the neutral component-selection rule does **not** address (it constrains *which component* is studied, not *which mutants* are subsequently designed for it). We therefore describe this rule as reducing, not eliminating, component-selection bias, and we did not describe it, and do not describe it here, as randomized.

### 4.7 Neutral-Selection Follow-Up Phase: Subjects

Table 1b lists the five follow-up components. Each was the first alphabetically eligible production file in its repository after excluding files already studied in the corresponding exploratory experiments (e.g., E15 excludes `SaturatingArithmetic.swift` and `Polar.swift`, studied as E9 and E10). No follow-up component overlaps, or substantially overlaps in behavior, with any exploratory component in the same repository.

**Table 1b. Neutral-selection follow-up-phase subjects.** Selection: alphabetically first eligible production path under the pre-declared rule (§4.6).

| Exp. | Repository | Component |
|---|---|---|
| E11 | swift-snapshot-testing | SnapshotTestingConfiguration.swift |
| E12 | swift-collections | RigidArray+Append.swift |
| E13 | swift-algorithms | AdjacentPairs.swift |
| E14 | swift-parsing | OneOfBuilder.swift |
| E15 | swift-numerics | Complex+AlgebraicField.swift |

### 4.8 Neutral-Selection Follow-Up Phase: Suite Freezing, Mutation, and Integrity

The follow-up phase reused the exploratory phase's leakage-control, freezing, and mutation-execution protocol without modification: the AI suite was generated from the production implementation alone (§4.3), frozen and SHA-256-fingerprinted before mutation design, mutations were defined only after both suites were frozen (§4.4), the same frozen mutant set was executed against both suites, and production/AI-suite checksums were re-verified after the mutation campaign (§4.5). Two component-specific procedural notes are relevant to reproducibility: in E15, the existing Human test filter deliberately excluded a non-deterministic, RNG-based round-trip test (`testPolar`) present in the same test file, to keep the frozen baseline deterministic, consistent with the exploratory phase's deterministic-execution criterion (§4.1); and in E15, because several mutated APIs are marked `@_transparent`/`@inlinable` and are inlined into calling test binaries, the mutation runner was corrected mid-campaign to force a clean rebuild of the test target before each suite invocation, and the full campaign was re-run under that fix before any result was reported (see `research/experiment-15-mutation-results.md`). Separately, in E11, a related Swift Testing suite (`SnapshotsTraitTests`) that also exercises the studied production file was identified during candidate selection but left outside the frozen filter's scope (§4.2); its tests were never executed as part of either suite in E11.

All raw artifacts for both phases (candidate-selection notes, human/AI coverage reports, frozen production-file snapshots, mutation plans, mutant source files, and machine-readable mutation results) are publicly available at <https://github.com/premalmistry/beyond-code-coverage-ai-vs-human-tests>.

---

## 5. Results

This section reports the exploratory phase (§5.0–§5.4) and the neutral-selection follow-up phase (§5.5–§5.7) separately. §6 discusses both phases together while preserving this separation. Following the repair described in the note at the top of this document, this revision reports mutation scores using **descriptive statistics only** (mean, median, paired-difference range, and a mutant-weighted pooled score) rather than leading with inferential significance tests; §5.0 and §5.5 explain why.

### 5.0 Exploratory Results — E1–E10

**Table 2. Exploratory phase (E1–E10): mutation score by experiment and suite**, and valid-mutant denominator (planned mutants minus those excluded as non-compiling or equivalent after code-level justification). "Higher" marks the suite with the numerically larger score; see the discussion below the table for why this comparison should not be read as statistically conclusive.

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

AI achieved the higher mutation score in six experiments, human tests in three, and one tied. We report this descriptively rather than through a significance test: the experiment-weighted mean mutation score was 93.8% for AI and 88.8% for human tests (difference 4.98 percentage points); the median paired difference (AI minus Human) was **+8.5 points**, with individual differences ranging from **−8.0** (E4, human-favoring) to **+21.8** (E10, AI-favoring). The **mutant-weighted pooled score** — total kills across all 239 valid exploratory mutants, divided by 239, rather than an average of ten per-experiment percentages — was **88.70%** for human tests and **93.31%** for AI, a pooled difference of **+4.60** points (`research/pooled-mutation-analysis.md`), consistent with the experiment-weighted mean.

We do not report a paired *t*-test or Wilcoxon signed-rank test here as evidence for or against a difference. An earlier version of this analysis did, and found neither test statistically significant; on reflection, and following adversarial review, we consider that framing misleading rather than merely inconclusive: the ten experiments are not independent random draws from a population of components, they are clustered within five repositories, they use heterogeneous, manually constructed mutant sets of different sizes (§7.3 discusses look-ahead exposure in this mutant-construction process), and they were all designed and adjudicated by the same two-person team. A *p*-value computed on such a sample does not estimate a meaningful population parameter, so we report only descriptive statistics (mean, median, range, pooled score) and do not treat any win count in this section as statistically established. We do not introduce a replacement significance test (e.g., a binomial test on the win count) in its place.

**Table 3. Exploratory phase (E1–E10): test-method and static-assertion-call-site counts per suite.** AI suites were larger in nine of ten experiments; §5.4 shows this did not translate into a consistently higher mutation score.

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

![Figure 1: Exploratory phase (E1–E10) mutation scores for human-written and AI-generated suites. Bar height is the mutation score against each experiment's own valid-mutant denominator (Table 2); denominators differ across experiments and are not directly comparable in absolute mutant count.](figure1_mutation_scores.png)

### 5.1 Identical Coverage, Different Mutation Score (Exploratory)

E3, E4, and E9 provide the clearest evidence for RQ2. In E3, both suites achieved 99.03% line coverage on the primary heap implementation, yet human tests scored 92.9% versus 85.7% for AI — a 7.2-point gap under identical coverage, driven by two human-only kills on tie-break/identity-sensitive mutants that AI's otherwise-equivalent line coverage did not encode assertions for. In E4, both suites achieved identical line (82.39%), region (78.85%), and function (73.08%) coverage, while human tests scored 96.0% versus 88.0% for AI, driven by two human-only kills on capacity/overflow-boundary mutants. In E9, both suites achieved 100% line, region, and function coverage — the strongest possible coverage parity — yet human tests scored 96.2% versus 88.5% for AI, driven by two human-only kills on shift-boundary and signed-overflow mutants. In all three cases the coverage tools report the suites as equivalent; the mutation results show they are not.

![Figure 2: Exploratory phase — mutation-score divergence in E3, E4, and E9 despite identical primary coverage (all three reported metrics) within each experiment. The human suite scores higher in all three; the full results table shows this pattern does not hold across the full sample.](figure2_identical_coverage_divergence.png)

### 5.2 Coverage Gaps, Mutation Gaps (Exploratory)

In E6, AI covered `Sequence.partitioned` behavior that the human suite's coverage left at 0%, and uniquely killed two polarity mutants confined to that overload. In E7, AI line coverage was 98.0% versus 64.0% for human tests, concentrated in the `print` path, and AI uniquely killed two printer-validation mutants there. E8 showed the same pattern (AI 95.8% versus human 81.82% line coverage; two AI-only kills, one on an exact-boundary print check and one on a negative-value print guard). In E10, AI achieved 97.06% line coverage versus 88.24% for human tests and killed five mutants — concentrated in non-finite length/phase handling — that the human suite's single randomized round-trip test missed.

![Figure 3: Exploratory phase — paired mutation-score difference (AI minus Human) for all ten experiments. Positive values favor AI. The pattern is mixed rather than one-directional; the E10 outlier (+21.8 points) reflects a human suite consisting of a single randomized test method (Table 3).](figure3_paired_differences.png)

### 5.3 Equal Coverage Can Also Coincide with Equal Effectiveness (Exploratory)

E5 is the counterexample to §5.1: human and AI suites achieved identical near-complete coverage (99.21%/96.00%/94.74%) and both killed all 21 valid mutants. Coverage parity is therefore not sufficient on its own to predict a mutation-score gap — it is possible for two suites to be equivalent on both axes at once. We report this alongside §5.1 precisely because the two results together, not either alone, are what support RQ2's answer: coverage parity is uninformative about whether a mutation-score gap exists, in either direction.

### 5.4 Suite Size (Exploratory, RQ4)

AI suites were larger in nine of ten experiments (Table 3), but larger size did not guarantee a higher mutation score. E4 used 41 AI tests versus 10 human tests, yet human tests scored higher. E5 used 27 AI tests versus 4 human tests, and both scored 100%. E9 used 27 AI tests versus 10 human tests, yet human tests again scored higher. Across all ten experiments, the suite with more tests also had the higher (or tied) mutation score in seven cases and the lower score in three (E3, E4, E9) — the same three experiments identified in §5.1.

### 5.4b Exploratory Union Mutation Effectiveness

As in §5.7 for the follow-up phase, we compute MS(Human ∪ AI) for each exploratory experiment (`research/union-mutation-analysis.md`). The union gain over the better single suite is exactly zero in **nine of ten** exploratory experiments (E1, E3, E4, E5, E6, E7, E8, E9, E10), because in each of those cases all unique kills belonged to only one suite. Only **E2** shows a positive gain (Human 70.4%, AI 85.2%, union 88.9%, **+3.7** points), because it is the one exploratory experiment with unique kills on *both* sides (1 human-only, 5 AI-only). Pooling all 239 valid exploratory mutants, the union kills 230 (96.23% pooled union MS) against a pooled AI score of 93.31%, a **+2.92-point** pooled gain over the stronger single suite. We report the near-universal zero-gain result plainly: in this exploratory sample, combining both frozen suites would rarely have added mutant kills beyond what the stronger individual suite already achieved, and E2 is the exception rather than the rule.

### 5.5 Neutral-Selection Follow-Up Results — E11–E15

Table 4 reports mutation scores for the five follow-up experiments, selected by the pre-declared neutral rule of §4.6 and frozen before any result was observed. All underlying counts are cross-checked against `research/confirmatory-e11-e15.csv`, which was itself verified against each experiment's baseline, mutation-result, and summary artifacts. As noted in §4.4 and developed fully in §7.3, four of these five mutation plans (E11 most heavily, with smaller traces in E13) contain mutants with explicit, suite-content-aware outcome predictions; the E11 gap in particular should be read as conditional on that mutant set (§7.3).

**Table 4. Neutral-selection follow-up phase (E11–E15): mutation score by experiment and suite.** Component names are abbreviated; full paths are in Table 1b. "Δ" is AI minus Human, in percentage points.

| Exp. | Component | Valid mutants | Human MS | AI MS | Δ (pp) | Higher |
|---|---|---:|---:|---:|---:|---|
| E11 | SnapshotTestingConfiguration | 24 | 41.7% | 91.7% | +50.0 | AI |
| E12 | RigidArray+Append | 22 | 90.9% | 95.5% | +4.6 | AI |
| E13 | AdjacentPairs | 23 | 91.3% | 100.0% | +8.7 | AI |
| E14 | OneOfBuilder | 22 | 68.2% | 72.7% | +4.5 | AI |
| E15 | Complex+AlgebraicField | 24 | 54.2% | 66.7% | +12.5 | AI |

AI achieved the higher mutation score in **all five** follow-up experiments (5/5); Human did not achieve the higher score in any (0/5), and there were no ties. The experiment-weighted mean mutation score was **85.3%** for AI and **69.2%** for human tests (mean paired difference **+16.1** percentage points; median paired difference **+8.7** percentage points; range **+4.5** to **+50.0**). The **mutant-weighted pooled score** — total kills across all 115 valid follow-up mutants, divided by 115 — was **68.70%** for human tests and **85.22%** for AI, a pooled difference of **+16.52** points (`research/pooled-mutation-analysis.md`), again consistent with the experiment-weighted mean.

**These are descriptive results from five neutrally selected components and should not be interpreted as evidence of universal AI superiority.** With *n* = 5, heterogeneous manually constructed mutant sets, and the look-ahead exposure just noted, we do not compute or report a significance test for this phase, and we do not report the 5/5 win count as if it were a binomial test result. A 5/5 win count on a small, though neutrally selected, sample is consistent with both a genuine directional tendency and with sampling variability, and the follow-up and exploratory samples should not be pooled into a single win-rate (§6, RQ1). Contamination was CLEAN and integrity checks PASSED in all five follow-up experiments (production and AI-suite SHA-256 fingerprints restored and reverified; both frozen suites re-executed against restored production code after the mutation campaign).

**Table 5. Neutral-selection follow-up phase (E11–E15): test-method and static-assertion-call-site counts per suite.** As in the exploratory phase (Table 3), AI suites were larger in every follow-up experiment.

| Exp. | Human tests | Human assertions | AI tests | AI assertions |
|---|---:|---:|---:|---:|
| E11 | 9 | 28 | 24 | 42 |
| E12 | 8 | 21 | 28 | 77 |
| E13 | 12 | 14 | 25 | 63 |
| E14 | 2 | 10 | 18 | 36 |
| E15 | 2 | 7 | 19 | 41 |

![Figure 4: Neutral-selection follow-up phase (E11–E15) mutation scores for human-written and AI-generated suites. As in Figure 1, bar height is against each experiment's own valid-mutant denominator (Table 4); the AI suite scores higher in every follow-up experiment.](figure4_confirmatory_mutation_scores.png)

![Figure 5: Neutral-selection follow-up phase — paired mutation-score difference (AI minus Human) for E11–E15. All five differences are positive; magnitude ranges from +4.5 (E14) to +50.0 (E11) percentage points.](figure5_confirmatory_paired_differences.png)

### 5.6 Neutral-Selection Coverage–Mutation Dissociation

This subsection tests, under neutral component selection, the same question addressed by §5.1 and §5.3 in the exploratory phase: does coverage predict mutation score? We discuss E13, E15, and E14 in that order, because E13 most directly recurs the exploratory identical-coverage result, while E15 and E14 extend it in new directions.

**E13 (identical line coverage).** Both suites achieved exactly **92.95%** line coverage on `AdjacentPairs.swift` — the same identical-coverage pattern as exploratory E3, E4, and E9 (§5.1), now observed on a component selected by the neutral rule rather than for its likely ability to distinguish the suites. Under this identical line coverage, mutation score still diverged: Human **91.3%** (21/23) versus AI **100.0%** (23/23), an 8.7-point gap. Region coverage in this experiment actually favored the human suite (89.04% vs. 80.82%), yet AI killed two additional mutants concentrated in `underestimatedCount` — an API the frozen human filter exercises without asserting its return value. (The mutation plan's own framing of this mutant, discussed in §7.3, references `underestimatedCount` by name as a property the human filter does not assert, so this specific gap is not fully blind to suite content.) E13 is, together with E3/E4/E9, the strongest evidence in this paper for RQ2: identical or near-identical coverage on a metric coverage tools report as complete can still coexist with a real, code-level mutation-detection gap, and this pattern recurs under a component-selection rule that was not chosen for its likely ability to illustrate it.

**E15 (inverse line-coverage ranking).** On `Complex+AlgebraicField.swift`, the human suite achieved substantially *higher* line coverage than the AI suite (71.19% vs. 44.92%, a 26.3-point gap), yet the human suite achieved the *lower* mutation score (54.2% vs. 66.7%, a 12.5-point gap in AI's favor). This is not merely coverage/mutation-score dissociation in the sense of §5.1 (identical coverage, different score); it is a case where the direction of the coverage comparison and the direction of the mutation-score comparison disagree. We note precisely what does and does not generalize from this result: region coverage (78.12% AI vs. 40.62% human) and function coverage (66.67% AI vs. 25.00% human) both favored AI, consistent with its higher mutation score, so it is *line* coverage specifically — not "all coverage metrics" — that misranks the suites here. The human suite's higher line coverage came from a small number of scale-stress numerical test methods (Baudin–Smith division vectors) that execute many lines of a Priest-style rescaling algorithm without asserting most of its intermediate branches; the AI suite's lower line coverage came from more numerous, narrower tests that each execute fewer lines but assert more special-case behavior (`one`, `/=`, `normalized`, `reciprocal`). The lesson is about the insufficiency of a single structural-coverage metric as a standalone proxy for fault detection, not that structural coverage is uninformative in general.

**E14 (large coverage gap, small mutation-score gap).** On `OneOfBuilder.swift`, AI's line coverage exceeded human's by roughly 32 percentage points (79.76% vs. 47.62%), but the mutation-score gap was only 4.5 points (72.7% vs. 68.2%). A large coverage advantage did not translate into a proportionally large mutation-score advantage: the human suite, despite executing far fewer lines, still killed 15 of 22 valid mutants, including two mutants (parse try-order and aggregated parse-error payloads) that the larger-coverage AI suite did not kill. This shows that the *magnitude* of a coverage gap between two suites is not a reliable predictor of the magnitude of the resulting mutation-score gap, reinforcing from a different angle the structural point made throughout this section and §5.1.

![Figure 6: Neutral-selection follow-up phase — line coverage vs. mutation score, Human and AI, for E13, E15, and E14. E13 shows identical line coverage with an 8.7-point mutation-score gap; E15 shows the human suite with higher line coverage but lower mutation score; E14 shows a large line-coverage gap (~32 points) alongside a small mutation-score gap (4.5 points).](figure6_confirmatory_coverage_dissociation.png)

### 5.7 Neutral-Selection Complementarity and Union Mutation Effectiveness

Summed across the five follow-up experiments: **8** human-only mutant kills, **27** AI-only mutant kills, and **9** shared survivors (mutants neither frozen suite killed). Both human-only and AI-only kills occurred in the same experiment in three of five cases (E11, E14, E15); the remaining two (E12, E13) had AI-only kills but no human-only kills. As in the exploratory phase (§5.2, RQ3), AI-only kills concentrated in API surface the human filter's tests did not exercise at all — untested constructors and literal forms (E11), a capacity-boundary polarity check (E12), an `underestimatedCount` property (E13), print-path validation (E14), and special-case numerical APIs such as `one`, `normalized`, and `reciprocal` (E15). Human-only kills concentrated inside paths the AI suite did cover, but with narrower or more exact assertions: an exact default-string path order (E11), parser try-order and aggregated error payloads (E14), and a scale-sensitive numerical rescaling path exercised by Baudin–Smith-style stress inputs (E15). We present these as patterns observed in this five-experiment sample, not as a universal taxonomy of how human-written and AI-generated tests differ.

To move beyond raw unique-kill counts, we compute **MS(Human ∪ AI)** — the mutation score of the hypothetical union of both frozen suites' kills — for every follow-up experiment, and report its gain over the better-performing individual suite (`research/union-mutation-analysis.md`; formulas and full E1–E15 table therein). **Table 6** summarizes the follow-up phase.

**Table 6. Neutral-selection follow-up phase: union mutation effectiveness.** Gain = union MS − max(Human MS, AI MS).

| Exp. | Human MS | AI MS | Union MS | Gain (pp) |
|---|---:|---:|---:|---:|
| E11 | 41.7% | 91.7% | 95.8% | +4.1 |
| E12 | 90.9% | 95.5% | 95.5% | +0.0 |
| E13 | 91.3% | 100.0% | 100.0% | +0.0 |
| E14 | 68.2% | 72.7% | 81.8% | +9.1 |
| E15 | 54.2% | 66.7% | 87.5% | +20.8 |

Combining the two frozen suites would have killed additional mutants, beyond what the stronger individual suite killed alone, in **3 of these 5 experiments** (E11, E14, E15) — the same three experiments where §5.7's first paragraph found both human-only and AI-only kills. In the other two (E12, E13), the union gain is exactly zero, a direct consequence of the human filter having zero unique kills in those two experiments, not a computational artifact; we report this null result rather than omit it. We describe this as **additive detection value** or **complementary mutant detection**, not causal synergy — the two suites were never executed together or merged, and MS(Human ∪ AI) is a property of the two frozen artifacts considered jointly, not an outcome that was observed from a combined suite. At the phase level, pooling all 115 valid follow-up mutants, the union kills 106 (92.17% pooled union MS) against a pooled AI score of 85.22%, a **+6.95-point** pooled gain over the stronger single suite — larger than the equivalent exploratory-phase pooled gain of +2.92 points (`research/union-mutation-analysis.md`), though we do not treat this phase-level difference as established given the small number of experiments contributing non-zero gains in either phase.

---

## 6. Discussion

### RQ1

**Exploratory (E1–E10):** AI tests were often strong but not uniformly superior, and we do not treat the aggregate difference as statistically established at this sample size (§5.0 reports descriptive statistics only, not a significance test). We do not interpret the 6-3-1 split as evidence that AI-generated tests are generally more or less effective than human-written tests; we interpret it as showing that neither suite dominated on this sample of ten components.

**Neutral-selection follow-up (E11–E15):** Under the pre-declared neutral selection rule, AI achieved the higher mutation score in all five experiments (5/5), with a mean paired difference of +16.1 percentage points — a stronger and more consistent directional advantage than in the exploratory phase. We are explicit about what this does and does not show: it is a descriptive result on *n* = 5 neutrally selected components, not a statistically powered test, and part of this gap is conditional on mutation plans (especially E11's) that were not blind to suite content (§7.3). It should not be combined with the exploratory 6-3-1 split into a claim such as "AI won 11 of 15 experiments" — the two phases used different selection procedures and different mutant sets, and pooling their win counts would obscure exactly the comparison this paper is designed to make. The honest summary is: the follow-up sample showed a stronger and more consistent directional AI advantage than the exploratory sample, but this observation is qualified by small sample size, single-domain (Swift) and single-model scope in both phases, the AI-effort/freshness asymmetry (§4.3, §7.2), and mutation-selection look-ahead concentrated in one of the five follow-up experiments (§7.3) — none of which support a general claim that AI-generated tests are superior to human-written tests.

### RQ2

This is the paper's strongest and most consistent finding across both phases, and the one least affected by the limitations above, because it concerns *coverage's* relationship to mutation score rather than *which suite* scores higher. **Exploratory:** E3, E4, and E9 show that two suites can execute the same lines, regions, and functions while encoding different behavioral oracles over those same paths — coverage cannot see the difference, and mutation testing can. E5 shows the same coverage parity can also coincide with mutation-score parity, so coverage parity does not *determine* the direction or existence of a mutation-score gap; it simply does not rule one out. **Neutral-selection follow-up:** E13 recurs the identical-line-coverage / different-mutation-score pattern under neutral component selection, which was not true of any exploratory component; E15 goes further, showing an *inverse* ranking in which the suite with higher line coverage has the lower mutation score (while region and function coverage both favored the higher-mutation-score suite — it is line coverage specifically that misranks the suites, not every structural metric); and E14 shows that a large coverage gap can coincide with a small mutation-score gap. Because E13, E15, and E14 were not selected for their likely ability to illustrate this phenomenon — they were the first alphabetically eligible components in their repositories — their agreement with the exploratory E3/E4/E9 pattern is evidence that the coverage/mutation-score dissociation is not an artifact of exploratory component selection. We treat this as the central, cross-phase finding of the paper: **line, region, and function coverage, as measured by llvm-cov, are insufficient on their own to infer mutation-based fault-detection effectiveness.**

### RQ3

**Exploratory:** AI-only kills clustered around paths the human suites' coverage did not reach at all: an untested `Sequence` overload (E6), `print`-path validation (E7, E8), and non-finite floating-point special cases (E10). Human-only kills, by contrast, occurred *inside* paths both suites already covered, and reflected narrower semantic expectations that coverage cannot express: tie-break identity (E3), capacity/overflow boundaries (E4), and signed-overflow shift semantics (E9). The union of both suites killed more mutants than the stronger single suite in only 1 of these 10 experiments (E2, +3.7 pp; §5.4b). **Neutral-selection follow-up:** the same qualitative pattern recurs (§5.7) — AI-only kills on unexercised API surface, human-only kills on narrower assertions inside jointly covered paths — with a higher AI-only-to-human-only ratio (27:8) than the exploratory phase, plausibly reflecting that several neutrally selected human filters (E11, E14, E15) happened to be thin relative to the production surface; the union of both suites killed more mutants than the stronger single suite in 3 of these 5 experiments (E11, E14, E15; gains of +4.1 to +20.8 pp; §5.7). Across fifteen case studies total, this is a thematic, qualitative pattern, and a set of additive-detection-value figures, not a statistically tested claim; we do not present it as a universal taxonomy of human-vs-AI testing behavior or as evidence of causal synergy between the two suites — it describes what we observed on these fifteen specific components and their frozen, never-merged test artifacts.

### RQ4 (secondary, descriptive)

The suite with more test methods had the higher or tied mutation score in seven of ten exploratory experiments and the lower score in three; AI suites were also larger in every follow-up experiment, which achieved the higher mutation score in all five, but follow-up suite sizes were not varied independently of which component was selected. Because suite size was not controlled in either phase and the AI suites were also produced through an iterative self-correction loop (§4.3) rather than a single generation pass, we cannot separate the effect of raw test count from the effect of that iteration, or from the effect of the AI suites simply being fresher and more recently repaired than the historically written human filters (§4.3, §7.2), in either phase; no causal conclusion about suite size or generation effort is warranted from this sample.

### Selection Bias, Revisited

The exploratory phase's Threats to Validity (§7) originally flagged component-selection bias as a limitation and recommended a comparison-neutral component-selection protocol as future work — a recommendation we now state used a pre-declared, but not externally pre-registered, rule (§4.6, §7.1). The neutral-selection follow-up phase executed that protocol (§4.6) rather than leaving it as a recommendation. The results in §5.5–§5.7 show that the central exploratory finding (RQ2) recurs under this rule, and that the RQ1 win-count pattern shifts toward a stronger, more consistent AI advantage under neutral selection — a result we report as observed, not as one we predicted or preferred, and one that is partly conditional on the mutation-selection look-ahead disclosed in §7.3. We reiterate that this protocol reduces, but does not eliminate, component-selection bias (§4.6, §7.1), and that it addresses only *component* selection, not the separate threats of mutation-selection look-ahead (§7.3) or AI-generation effort asymmetry (§7.2).

---

## 7. Threats to Validity

This section is organized as distinct, named subsections rather than the traditional internal/construct/external grouping alone, because several of the most important threats in this study (mutation-selection look-ahead, AI-generation effort asymmetry, Human-filter selection) are specific methodological concerns that a generic validity taxonomy tends to bury.

### 7.1 Component Selection

The study covers fifteen components from the same five Swift repositories, in two phases with different selection procedures. In the exploratory phase (E1–E10), component selection for later experiments explicitly favored components expected to distinguish the two suites, alongside more standard criteria (existing tests, appropriate size, mutation potential); this is a deliberate design choice for maximizing informativeness per experiment, but it means that sample is not representative of an unbiased population of tested components. The neutral-selection follow-up phase (E11–E15) was added specifically to address this: it used a rule, pre-declared internally but not externally pre-registered (§4.6), that enumerates eligible components, sorts them alphabetically, and selects the first eligible one, frozen before any outcome is observed. This reduces the concern that we chose components because we expected or preferred a particular result, and the fact that §5.6's dissociation pattern and §5.5's AI-favoring pattern both recur under this rule is evidence against the exploratory pattern being purely an artifact of exploratory component choice. **We do not claim this eliminates component-selection bias.** Several sources of researcher discretion remain even under the neutral rule: the seven eligibility criteria themselves were researcher-designed; the choice to study these same five repositories (rather than a random sample of open-source Swift projects) was inherited from the exploratory phase and not re-randomized; the existing Human test filter for each follow-up component still required a judgment call about which existing tests count as "the" filter (e.g., excluding a randomized test in E15, and excluding a related Swift Testing suite in E11; §4.2); and the follow-up sample size (five) is small. Results from either phase may also not generalize to other languages, systems, test levels, or LLMs.

### 7.2 Human-Filter Selection and AI-Generation Effort Asymmetry

This study does not compare human *ability* against AI *ability* under matched effort. It compares an **existing, researcher-selected filter over already-written human tests** against a **freshly generated, iteratively self-corrected AI suite** (§4.2, §4.3). These are not symmetric artifacts: the AI suite was written against the current implementation, with as many self-correction iterations as needed to compile and pass, and with no historical constraint on the generating agent's knowledge or the time available to it; the human filter was written at an unknown point in each repository's history, by unknown contributors, under unknown constraints, and was never expanded, corrected, or otherwise touched for this study beyond selecting which existing tests to include. AI suites were also larger than the human filter in nine of ten exploratory experiments and all five follow-up experiments (Table 3, Table 5). A plausible, and in our view under-examined, alternative explanation for most AI-favoring mutation-score gaps in this paper is therefore: *a larger, fresher, iteratively self-corrected test suite outperforms a smaller, historically fixed one that was never revised* — a property of authoring circumstances, not necessarily of the AI-vs-human origin of the tests. We do not attempt to disentangle freshness, iteration count, and suite size from generating-agent identity in this study, and no claim in this paper should be read as isolating "AI-ness" from these confounded factors. Two component-specific instances of filter-selection judgment are worth naming directly here rather than leaving implicit: in E11, a related existing test suite (`SnapshotsTraitTests`) that also exercises the studied production file exists in the repository but sits outside the frozen filter's scope, so E11's Human mutation score describes the selected filter, not necessarily every relevant existing test in the repository; and in E15, an existing randomized test (`testPolar`) was deliberately excluded from the frozen filter to preserve deterministic execution, a methodologically necessary but nonzero exclusion. Neither instance is unique to those two experiments in kind — every experiment's Human filter reflects a similar selection judgment — but these two are the most concretely documented in the underlying artifacts.

### 7.3 Mutation-Selection Look-Ahead

Mutation plans in this study were, by protocol, drafted only *after* both suites were frozen (§4.4, §4.8) — a step designed to prevent post-hoc *test* adaptation to known mutants. This freezing order does **not**, however, make mutant *selection* blind to the suites being evaluated: the person designing each mutation plan had full access to both suites' frozen content, coverage reports, and (in the exploratory phase) prior-experiment patterns while choosing which mutants to include and while drafting per-mutant outcome predictions. We disclose this explicitly and quantify it, rather than treat suite freezing as sufficient to guarantee an unbiased mutant sample.

`research/mutation-lookahead-audit.md` audits all 369 planned mutants across E1–E15 and finds that **29 (7.9%)** carry an explicit, suite-content-specific outcome prediction or rationale — e.g., a plan predicting "Human survives, AI kills" for a given mutant with a written rationale naming a specific gap in the frozen Human filter's coverage (such as "Human may not call `rawValue`" or "no enum dumps in human filter"). This exposure is **highly concentrated, not uniform**: two experiments, **E2 (7/27 mutants, 25.9%)** and especially **E11 (12/24 mutants, 50.0%)**, account for 19 of the 29 flagged mutants study-wide; smaller traces appear in E3, E6, E7, and E13; and eight experiments (E1, E4, E5, E9, E10, E12, E14, E15) show no textual evidence of suite-content-aware mutant selection at all. In most of the flagged cases where a differential prediction was made (15 of 29), the predicted asymmetry matched the observed result exactly — the clearest, most verifiable form of look-ahead — though several flagged predictions (e.g., E7-M24, E11-M05, E11-M22) were *not* realized, showing the designer's suite-specific knowledge did not translate into perfectly reliable foresight in either direction.

The practical consequence is that **mutation-score gaps in the affected experiments should be read as conditional on a manually constructed, suite-aware mutant set, not as unbiased estimates of general suite effectiveness.** E11 is the most important case: it has both the highest concentration of flagged mutants (50%) and the largest mutation-score gap in the entire study (+50.0 percentage points), and half of its mutant set was explicitly selected and predicted using itemized knowledge of the frozen Human filter's uncovered behavior (documented independently in `research/experiment-11-human-baseline.md`). We therefore weight E11's gap accordingly relative to experiments such as E9, E10, E14, and E15, where no such textual evidence exists. We do **not** claim this look-ahead was designed "to favor AI" as a general matter — the audit finds wrong-direction predictions as well as right-direction ones, and eleven of fifteen experiments show no evidence of it at all — but we also do not minimize it: it is a first-class, quantified threat to validity, not a footnote, and it is the single most important limitation identified in this revision of the paper.

### 7.4 Equivalent-Mutant Adjudication

Mutation selection and equivalent-mutant classification involve researcher judgment, in both phases. Mutation plans were frozen before execution, which limits post-hoc mutant selection but does not address the look-ahead threat in §7.3; equivalence adjudication happened only after observing which mutants survived both suites, and was performed by the same person who designed the AI prompts and mutation plans, with no independent second annotator. The equivalent/invalid exclusion rate varied from 0% to 19% of planned mutants across the exploratory experiments; the follow-up phase's exclusion rate was low and comparable (0 for E11, E14, E15; 2 of 24 planned mutants for E12; 1 of 24 for E13). We report this rather than treat it as noise, since we cannot rule out that harder-to-kill components produced more permissive equivalence judgments in either phase.

### 7.5 Construct Validity

Mutation score measures sensitivity to seeded, syntactic faults, not to the distribution of real historical defects; we do not equate a mutant kill with detection of a real bug anywhere in this paper. Coverage measures execution, not assertion quality; §5.1 and §5.6 demonstrate this gap directly, in both phases, rather than asserting it.

### 7.6 Model and Tooling

Both phases used a single LLM (Grok 4.5) accessed through a single coding agent (Cursor) with default sampling settings, and both phases were designed, executed, and adjudicated by the same small research team. Findings should not be generalized to other models, prompting strategies, or agent tooling without further study.

### 7.7 Conclusion Validity and Statistical Treatment

The exploratory ten paired experiments are clustered within five repositories, use different, manually constructed mutant sets of different sizes (21–28 valid mutants), and were all produced by a single experimenter in a short time window; the follow-up five experiments share these same characteristics (mutant sets of 22–24 valid mutants) and add a second source of non-independence, since all five were selected by the same fixed rule applied to the same five repositories, plus the look-ahead exposure documented in §7.3. Because of this clustering, heterogeneous mutant-set construction, and (in several experiments) non-blind mutant selection, we report §5.0 and §5.5 using **descriptive statistics only** — experiment-weighted mean, median, paired-difference range, and mutant-weighted pooled score (`research/pooled-mutation-analysis.md`) — and do not compute or report a paired *t*-test, Wilcoxon signed-rank test, or binomial test on either phase's win count as evidence of a population-level effect. We did not pool the two phases' scores into a single statistic of any kind, because doing so would require a pooling rule we did not specify in advance of seeing either phase's results; reporting a post-hoc pooled statistic here would risk exactly the kind of researcher-degrees-of-freedom problem this paper's methodology is designed to avoid.

### 7.8 Mutation vs. Real Faults

Every finding in this paper concerns mutation-based, not real-fault-based, effectiveness. Mutants are syntactic proxies for defects, selected by a human designer (§7.3) rather than sampled from a historical defect distribution. We make no claim, anywhere in this paper, that a higher mutation score corresponds to catching more real bugs in production; validating the observed patterns against real historical defects (e.g., via a BugsInPy-style corpus) remains future work (§8).

### 7.9 Reproducibility

Repository SHAs, fingerprints, filters, coverage artifacts, mutation plans, logs, and machine-readable results were retained for all fifteen experiments and are published at the artifact repository (§4.5, §4.8). For the neutral-selection follow-up phase specifically, this includes each experiment's candidate-selection record (full eligible-component inventory, eligibility rationale, alphabetical ordering, and the frozen selection), human and AI baseline coverage reports, AI-suite SHA-256 fingerprint, frozen mutation plan, machine-readable mutation results (JSONL), and a final experiment summary — so the selection decision for each component is independently auditable against the written eligibility criteria, not merely asserted. Model (Grok 4.5), agent version (Cursor 3.15.19), and sampling configuration (vendor defaults) are reported in §4.3 for both phases; the exact prompt/runbook text evolved across the exploratory study (§4.2) and is not version-pinned per experiment, which remains a minor limitation for exact replication of the earliest experiments specifically. The mutation-selection look-ahead audit (§7.3), union mutation-effectiveness analysis (§5.4b, §5.7), and pooled mutant-weighted scores (§5.0, §5.5) reported in this revision are all re-aggregations of these same already-frozen artifacts and are independently reproducible from `research/mutation-lookahead-audit.csv`, `research/union-mutation-analysis.csv`, and the per-experiment `research/experiment-N-mutation-results.md` files without running any new experiment, test, or mutant.

---

## 8. Conclusion

This study proceeded in two phases. The exploratory phase (E1–E10, ten paired experiments across five open-source Swift repositories) identified a dissociation between structural code coverage and mutation-based fault-detection effectiveness: in three components (E3, E4, E9), human and AI suites reached identical coverage on every measured metric — including 100% in one case — yet differed in mutation score by several percentage points. That phase also found that AI-generated suites frequently broadened coverage into boundary, overload, printing, and special-value behavior the existing human filters did not reach, while achieving a numerically higher mean mutation score that we do not treat as statistically established at that sample size.

Because later exploratory components were partly selected for their likely ability to distinguish the two suites, we added a neutral-selection follow-up phase (E11–E15, five additional experiments) that selected components using a pre-declared (not externally pre-registered), comparison-neutral rule — fixed eligibility criteria, alphabetical ordering, first eligible component, frozen before any outcome was observed — specifically to test whether the exploratory pattern would recur under neutral selection. It did: E13 recurs an identical-line-coverage / different-mutation-score result, and E15 shows an inverse case in which the suite with substantially *higher* line coverage achieves the *lower* mutation score (while its region and function coverage did not). The follow-up phase also showed a stronger and more consistent AI-favoring win count (5/5, mean paired difference +16.1 percentage points) than the exploratory phase's mixed 6-3-1 split; we report this difference between phases descriptively and do not pool it into a single fifteen-experiment win rate, and we do not treat it as evidence of general AI superiority.

Our main conclusion is narrow and structural: **across these case studies, line, region, and function coverage, as measured by llvm-cov, were not sufficient on their own to determine relative mutation effectiveness.** This held in the exploratory phase and recurred under neutral component selection in the follow-up phase. Our secondary conclusion is: **existing Human test filters and independently generated AI suites often killed different mutants, and their union sometimes improved mutation coverage** — the union of both frozen suites killed more mutants than the stronger single suite in 1 of 10 exploratory experiments and 3 of 5 follow-up experiments (§5.4b, §5.7), evidence of additive detection value rather than substitutability, though not of causal synergy between the two suites.

We explicitly do **not** conclude that AI-generated tests are better than human-written tests. Beyond the small sample sizes and single-language, single-model scope already noted, two study-level limitations condition every mutation-score comparison in this paper and should be read alongside any of its numbers: first, mutation plans in a subset of experiments — most heavily E2 and E11 — were drafted with explicit knowledge of each frozen suite's content, so the corresponding mutation-score gaps are conditional on manually constructed, suite-aware mutant sets, not unbiased estimates of general suite effectiveness (§7.3); second, the AI suites compared here were freshly generated against the current implementation and iteratively self-corrected, while the existing Human filters were historically written and never revised for this study, an effort and freshness asymmetry we do not resolve (§7.2). Neither limitation invalidates the coverage/mutation-score dissociation finding, which does not depend on which suite scores higher; both limit the strength of any claim about which suite scores higher.

Future work should expand the follow-up sample beyond five components, ideally across additional languages and repositories; use an independent second annotator for equivalent-mutant classification; design mutation plans with a documented blind procedure that does not expose the designer to either suite's content; control for suite size and generation-iteration count; compare multiple LLMs and prompting strategies under the same neutral-selection protocol; and validate the observed coverage/mutation-score dissociation and complementary-kill patterns against real historical defects rather than seeded mutants alone.

---

## References

Inozemtseva, L., & Holmes, R. (2014). Coverage is not strongly correlated with test suite effectiveness. *Proceedings of the 36th International Conference on Software Engineering (ICSE)*, 435–445. https://doi.org/10.1145/2568225.2568271

Lops, A., Narducci, F., Ragone, A., Trizio, M., & Bartolini, C. (2025). LLMs for automated unit test generation and assessment in Java: The AgoneTest framework. *arXiv preprint arXiv:2511.20403*. https://arxiv.org/abs/2511.20403

Moradi Dakhel, A., Nikanjam, A., Majdinasab, V., Khomh, F., & Desmarais, M. C. (2024). Effective test generation using pre-trained large language models and mutation testing. *Information and Software Technology*, *171*, 107468. https://doi.org/10.1016/j.infsof.2024.107468

Ouédraogo, W. C., Kaboré, A. K., Li, Y., Tian, H., Koyuncu, A., Klein, J., Lo, D., & Bissyandé, T. F. (2024). Prompt engineering in LLMs for automated unit test generation: A large-scale study. *arXiv preprint arXiv:2407.00225*. https://arxiv.org/abs/2407.00225

Papadakis, M., Kintis, M., Zhang, J., Jia, Y., Le Traon, Y., & Harman, M. (2019). Mutation testing advances: An analysis and survey. *Advances in Computers*, *112*, 275–378. https://doi.org/10.1016/bs.adcom.2018.03.015

Vathana, P., Bhatt, P., Patel, R., & Eisty, N. U. (2026). LLM vs. human unit tests: Fault detection on real Python bugs. *arXiv preprint arXiv:2606.08588*. https://arxiv.org/abs/2606.08588

Wang, G., Xu, Q., Briand, L., & Liu, K. (2026). Mutation-guided unit test generation with a large language model. *IEEE Transactions on Software Engineering*, *52*(5), 1657–1671. https://doi.org/10.1109/TSE.2026.3682975

Yang, L., Yang, C., Gao, S., Wang, W., Wang, B., Zhu, Q., Chu, X., Zhou, J., Liang, G., Wang, Q., & Chen, J. (2024). On the evaluation of large language models in unit test generation. *Proceedings of the 39th IEEE/ACM International Conference on Automated Software Engineering (ASE)*, Article 76. https://doi.org/10.1145/3691620.3695529

Yuan, Z., Liu, M., Ding, S., Wang, K., Chen, Y., Peng, X., & Lou, Y. (2024). No more manual tests? Evaluating and improving ChatGPT for unit test generation. *Proceedings of the ACM on Software Engineering*, *1*(FSE), Article 76. https://doi.org/10.1145/3660783 (Originally released as arXiv:2305.04207, 2023.)

Zhao, J., Zhou, S., & Cohen, E. (2026). Do coverage and mutation scores of LLM-generated test suites correlate with their effectiveness? (Replicability study). *Proceedings of the ACM on Software Engineering*, *3*(ISSTA), Article ISSTA002. https://doi.org/10.1145/3832093

---

## Appendix A. Audit Checklist

### A.1 Exploratory phase (E1–E10)

1. All ten experiment summaries have been checked against raw coverage and mutation-result artifacts.
2. E1/E2 mutation and coverage artifacts verified against `research/mutation-results.md` and `research/experiment-2-mutation-results.md`.
3. Invalid/equivalent mutant exclusions re-audited per experiment; exclusion-rate variation is now reported explicitly (§7.4).
4. AI model (Grok 4.5), agent (Cursor 3.15.19), and sampling settings (vendor defaults) added (§4.3); exact per-experiment runbook text not version-pinned (noted as a minor reproducibility limitation, §7.9).
5. Repository SHAs and SHA-256 fingerprints verified present and well-formed in underlying artifacts (40-hex-character SHA-1 repository revisions).
6. Bibliography metadata corrected for Yuan et al., Wang et al. (MutGen), and Zhao et al.; two foundational citations added (Inozemtseva & Holmes 2014; Papadakis et al. 2019); four additional related-work papers added following a targeted (non-systematic) search (Yang et al. 2024; Ouédraogo et al. 2024; Lops et al. 2025; Vathana et al. 2026). A fully systematic (e.g., PRISMA-style) search remains a future opportunity, not a blocking gap.
7. Figure values verified against Tables 2/3 and the final aggregate computation in §5.0.
8. Human/AI test-filter disjointness verified for every scored experiment; contamination-control evolution across experiments is now described explicitly (§4.2) rather than presented as uniform, and cross-checked against per-experiment baseline records (§4.2).
9. Artifact repository published and linked (§4.5): https://github.com/premalmistry/beyond-code-coverage-ai-vs-human-tests
10. A paired *t*-test and Wilcoxon signed-rank test were computed on the exploratory scores and independently re-verified with SciPy 1.13.1 (mean(AI) = 93.81%, mean(Human) = 88.83%, *t*(9) = 1.5338, *p* = .1595; Wilcoxon *W* = 6.0, *p* = .0547 on the nine non-tied pairs); following the adversarial repair review, these are **not** reported in the main text (§5.0, §7.7) and are retained here only as a reproducibility record, not as evidence for any claim in this paper.

### A.2 Neutral-selection follow-up phase (E11–E15)

11. All five follow-up experiment summaries, baseline reports, and mutation-results files (`research/experiment-{11..15}-*.md`, `.jsonl`) checked against `research/confirmatory-e11-e15.csv`; every value in Table 4 and §5.5–§5.7 traced to a specific source artifact. (This CSV retains its original filename from when the phase was still called "confirmatory"; its contents are unchanged and unaffected by the terminology repair.)
12. Each follow-up candidate-selection record (`research/experiment-{11..15}-candidate-selection.md`) verified to contain a complete eligible-component inventory, alphabetical ordering, and an explicit exclusion reason for every non-selected file; the selected component confirmed to be the first alphabetically eligible entry in each case.
13. Follow-up production and AI-suite SHA-256 fingerprints verified present, well-formed, and (where re-checked) matching between baseline measurement and final mutation-campaign restoration.
14. Follow-up contamination checks (Human filter executing zero AI-named tests, and vice versa) verified CLEAN for all five experiments; the E15 mutation-runner correction for `@_transparent`/`@inlinable` client inlining (§4.8) verified to have been applied before any follow-up mutation result was finalized.
15. Follow-up equivalent/invalid mutant exclusions re-audited (0 for E11, E14, E15; 2/24 for E12; 1/24 for E13); no follow-up survivor was excluded as equivalent without a code-level justification recorded in the corresponding `research/experiment-N-mutation-results.md`.
16. Figures 4–6 verified against Table 4 and against `research/confirmatory-e11-e15.csv`; Figure 6's three panels (E13, E15, E14) verified against the coverage and mutation-score values quoted in §5.6.
17. Follow-up win count (5/5), mean scores (Human 69.2%, AI 85.3%), and mean/median paired differences (+16.1 pp / +8.7 pp) independently recomputed from the per-experiment kill counts in Table 4 and confirmed to match `research/confirmatory-e11-e15-analysis.md`.
18. Verified that no exploratory-phase (E1–E10) number was altered in producing this revision; the exploratory tables and figures in §5.0 report the same underlying counts as the prior revision, relabeled for phase clarity and re-summarized with descriptive statistics only (§7.7).
19. Verified that no section in this revision states or implies that the follow-up components were selected randomly, and that all "selection bias" language distinguishes *reduced* from *eliminated* (§4.6, §7.1, §8).
20. Verified that the exploratory (6-3-1) and follow-up (5-0-0) win counts are never summed into a combined fifteen-experiment win rate anywhere in this document.

### A.3 Repair-cycle audit (this revision)

21. Mutation-selection look-ahead quantified for all 369 planned mutants across E1–E15 (`research/mutation-lookahead-audit.csv`, `research/mutation-lookahead-audit.md`); 29 flagged (7.9%), concentrated in E2 (7/27) and E11 (12/24); disclosed as a first-class Threats to Validity subsection (§7.3), not a footnote.
22. Union mutation effectiveness (MS(Human ∪ AI)) computed for all fifteen experiments (`research/union-mutation-analysis.csv`, `research/union-mutation-analysis.md`); zero-gain (null) results reported explicitly for 9 of 10 exploratory and 2 of 5 follow-up experiments, not hidden.
23. Mutant-weighted pooled scores computed separately for each phase (`research/pooled-mutation-analysis.md`); phases not combined into one pooled statistic.
24. Verified the paper no longer describes the neutral-selection rule as "pre-registered"; §4.6, §4.9 (intro), and §7.1 all state it was pre-declared internally but not externally pre-registered.
25. Verified "Human suite" has been replaced with "existing Human test filter" (or equivalent) in every methodologically load-bearing sentence; residual uses of "Human suite" as informal shorthand in figure captions and table headers were left as-is where space-constrained, consistent with `paper/reviewer-repair-change-log.md`.
26. Verified the central coverage claim is stated as "line, region, and function coverage, as measured by llvm-cov, are insufficient on their own to infer mutation-based test effectiveness" (or an equivalent formulation) in the Abstract, Contributions, RQ2 discussion, and Conclusion, and that E15's region/function coverage (which favored AI) is distinguished from its line coverage (which did not) everywhere E15 is discussed.
27. Verified the paired *t*-test and Wilcoxon signed-rank test were removed from the main narrative (§5.0) and are not used as the basis of any claim; retained only in Appendix A.1 (#10) as a reproducibility record. No new significance test (including a binomial test on the 5/5 win count) was introduced in their place.
28. This full audit, and the change log in `paper/reviewer-repair-change-log.md`, were produced without running any new experiment, test, or mutant; all figures in this revision are re-aggregations of E1–E15 artifacts that existed before this repair cycle began.
