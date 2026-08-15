# Beyond Code Coverage: AI-Generated vs. Human-Written Unit Tests

Research artifacts for an empirical study comparing independently AI-generated
unit tests against existing human-written unit tests, using **mutation
testing** (not just code coverage) as the fault-detection metric.

**Authors:** Premal Mistry (Primary), Randhir Kumar (Co-author) — Independent Researchers

The full paper (original submission, peer-review report, and revised
manuscript) is in [`paper/`](paper/). The raw per-experiment evidence
(candidate selection notes, baselines, coverage reports, mutation plans,
mutant source files, and mutation results) is in [`experiments/`](experiments/).

## Paper

| File | Description |
|---|---|
| [`paper/paper.tex`](paper/paper.tex) | Original manuscript submitted for review |
| [`paper/Peer_Review_Report.md`](paper/Peer_Review_Report.md) | Six-pass critical peer review (novelty, claim audit, narrative, writing, figures/tables, publication readiness) |
| [`paper/paper_revised.tex`](paper/paper_revised.tex) / [`paper/paper_revised.md`](paper/paper_revised.md) | Revised manuscript incorporating the review, verified against the raw artifacts below |
| [`paper/references.bib`](paper/references.bib) / [`paper/references_revised.bib`](paper/references_revised.bib) | Bibliography (original / corrected & expanded) |
| [`paper/figures/`](paper/figures/) | Figures used in the revised manuscript |

## Methodology (summary)

Ten paired experiments (E1–E10) were run across five mature open-source Swift
repositories. For each experiment:

1. A production component was selected and its human-authored test filter and scope were frozen.
2. Human test suite coverage was measured as a baseline.
3. An AI agent (Cursor, using Grok 4.5) generated a test suite for the **same**
   production component **from the production code alone** — without access to
   the human tests, human coverage gaps, or the mutation plan — to reduce
   information leakage. The AI suite was frozen and fingerprinted (SHA-256)
   once complete.
4. A mutation plan (a frozen set of mutants) was designed against the
   production component.
5. Both the human suite and the AI suite were executed against the same
   frozen mutant set, and mutation scores were computed and cross-checked.

Swift toolchain: Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS.
Agent: Cursor 3.15.19, Grok 4.5, default sampling settings.

See `paper/paper_revised.md` (Methodology section) for the full protocol,
including how contamination controls evolved across experiments, and the
Threats to Validity section for known limitations.

## Experiments

| # | Upstream repo | Pinned commit | Component under test | Domain |
|---|---|---|---|---|
| E1 | [pointfreeco/swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing) | `59a99c458de4d2dee580529b61b4f78dca7b7fa6` | `Sources/SnapshotTesting/Snapshotting/URLRequest.swift` | Serialization / snapshot formatting |
| E2 | [pointfreeco/swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing) | `59a99c458de4d2dee580529b61b4f78dca7b7fa6` | `Sources/SnapshotTesting/Snapshotting/Any.swift` | Reflection-based snapshotting |
| E3 | [apple/swift-collections](https://github.com/apple/swift-collections) | `f3e778f17a438371c5b8c170f15c0d997bb417ee` | `Sources/HeapModule/Heap+UnsafeHandle.swift` | Data structures (heap) |
| E4 | [apple/swift-collections](https://github.com/apple/swift-collections) | `f3e778f17a438371c5b8c170f15c0d997bb417ee` | `Sources/OrderedCollections/OrderedSet/OrderedSet+Insertions.swift` | Data structures (ordered set) |
| E5 | [apple/swift-algorithms](https://github.com/apple/swift-algorithms) | `5b7143f8e291dee0e14c118fd0212487f0b37af5` | `Sources/Algorithms/Combinations.swift` | Algorithms (combinatorics) |
| E6 | [apple/swift-algorithms](https://github.com/apple/swift-algorithms) | `5b7143f8e291dee0e14c118fd0212487f0b37af5` | `Sources/Algorithms/Partition.swift` | Algorithms (partitioning) |
| E7 | [pointfreeco/swift-parsing](https://github.com/pointfreeco/swift-parsing) | `7160b25d39e4a38258a7fe71591fbe182b026d69` | `Sources/Parsing/ParserPrinters/Prefix.swift` | Parser-printers |
| E8 | [pointfreeco/swift-parsing](https://github.com/pointfreeco/swift-parsing) | `7160b25d39e4a38258a7fe71591fbe182b026d69` | `Sources/Parsing/ParserPrinters/Digits.swift` | Parser-printers (numeric) |
| E9 | [apple/swift-numerics](https://github.com/apple/swift-numerics) | `899af71c0256d0ad181e3b7eb3453c1065d928a5` | `Sources/IntegerUtilities/SaturatingArithmetic.swift` | Numerical computation (integer) |
| E10 | [apple/swift-numerics](https://github.com/apple/swift-numerics) | `899af71c0256d0ad181e3b7eb3453c1065d928a5` | `Sources/ComplexModule/Polar.swift` | Numerical computation (floating-point) |

Full quantitative results (coverage, mutation scores, statistical tests, and
the identical-coverage/divergent-mutation-score cases) are in the paper —
see `paper/paper_revised.md`, Section "Results".

Each `experiments/E*/` directory contains:

- `research/` — candidate selection notes, human/AI coverage reports,
  the frozen production-file snapshot (`*.ORIG`), the mutation plan, the
  mutant source files (`mutants-eN/`), and the mutation results
  (`experiment-N-mutation-results.md` / `.jsonl`).
- `ai-generated-tests/` — the frozen AI-generated test suite source file(s).

**Not included in this repo:** the raw `swift build`/`swift test` console logs
generated while running each mutant (hundreds of MB of build noise per
experiment). The structured, analyzed results in `research/*-mutation-results.md`
and `.jsonl` are derived from those logs. The upstream repositories themselves
are also not vendored here — clone them at the pinned commits above to
reproduce the exact baselines.

## License note

The AI-generated test files and mutant source files in `experiments/*/ai-generated-tests/`
and `experiments/*/research/mutants-e*/` are derivative works of the
corresponding upstream repository and are provided here for research
reproducibility, under the same license as that upstream project:

- `swift-snapshot-testing`, `swift-parsing` — MIT License (Point-Free, Inc.)
- `swift-collections`, `swift-algorithms`, `swift-numerics` — Apache License 2.0 (Apple Inc.)

This repository's own content (paper, analysis, research notes) is
© the authors; no license is granted for reuse beyond viewing unless
otherwise stated.
