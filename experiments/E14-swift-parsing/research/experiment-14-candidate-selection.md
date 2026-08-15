# Experiment #14 — Candidate Selection (CONFIRMATORY)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Repository:** [pointfreeco/swift-parsing](https://github.com/pointfreeco/swift-parsing)  
**Pinned SHA:** `7160b25d39e4a38258a7fe71591fbe182b026d69` (same pin as Experiments #7 and #8)  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Date (UTC):** `2026-08-15T17:04:48Z`

**This document only selects the component.** No AI tests, no mutations beyond recording this selection.

---

## Context

Experiments #1–#10 were **exploratory**. Experiments #11–#15 are **confirmatory**.

Confirmatory protocol is **identical** to Experiments #11–#13. Do **not** modify methodology based on those outcomes.

Previously studied in this repository (must not be reused):

| Experiment | Component |
|---|---|
| E7 | `Sources/Parsing/ParserPrinters/Prefix.swift` |
| E8 | `Sources/Parsing/ParserPrinters/Digits.swift` |

---

## Eligibility criteria (pre-declared)

A production file is **eligible** only if **all** hold:

1. Has **direct** existing human-written tests.
2. Has **deterministic** tests.
3. Has **focused, observable** behavior.
4. Can **reasonably support meaningful mutation testing**.
5. Does **not** require network / external services.
6. Was **not** studied in Experiments #1–#13.
7. Is **reasonably isolated** enough for Human-vs-AI comparison.

---

## Neutral selection rule (pre-declared — identical to #11–#13)

1. Enumerate every production `.swift` file under `Sources/`.
2. Apply eligibility criteria; record objective exclusions.
3. Sort the **eligible** set **alphabetically by production file path**.
4. Select the **first** eligible path.
5. **Do not** skip for predicted coverage, suite strength, outcome, tie risk, or interestingness.

## Full inventory (95 production files, alphabetical) and eligibility

| Production file path | LOC | Eligible? | Objective reason if excluded |
|---|---:|:---:|---|
| `Sources/Parsing/Builders/OneOfBuilder.swift` | 253 | **YES** | Direct `OneOfBuilderTests`; deterministic; focused builder/parser logic; not studied; isolated. |
| `Sources/Parsing/Builders/ParserBuilder.swift` | 294 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/Conversion.swift` | 28 | **No** | (#4) Insufficient local surface (28 LOC). |
| `Sources/Parsing/Conversions/AnyConversion.swift` | 160 | **No** | (#1) No dedicated direct human-written test suite for this file. |
| `Sources/Parsing/Conversions/BinaryFloatingPoint.swift` | 62 | **No** | (#1) No dedicated direct human-written test suite for this file. |
| `Sources/Parsing/Conversions/ConversionMap.swift` | 54 | **No** | (#1) No dedicated direct human-written test suite for this file. |
| `Sources/Parsing/Conversions/Conversions.swift` | 6 | **No** | (#4) Insufficient local surface (6 LOC). |
| `Sources/Parsing/Conversions/Data.swift` | 55 | **No** | (#1) No dedicated direct human-written test suite for this file. |
| `Sources/Parsing/Conversions/Enum.swift` | 82 | **No** | (#1) No dedicated direct human-written test suite for this file. |
| `Sources/Parsing/Conversions/FixedWidthInteger.swift` | 54 | **No** | (#1) No dedicated direct human-written test suite for this file. |
| `Sources/Parsing/Conversions/Identity.swift` | 20 | **No** | (#4) Insufficient local surface (20 LOC). |
| `Sources/Parsing/Conversions/JSON.swift` | 82 | **No** | (#1) No dedicated direct human-written test suite for this file. |
| `Sources/Parsing/Conversions/LosslessStringConvertible.swift` | 66 | **No** | (#1) No dedicated direct human-written test suite for this file. |
| `Sources/Parsing/Conversions/Memberwise.swift` | 173 | **No** | (#1) No dedicated direct human-written test suite for this file. |
| `Sources/Parsing/Conversions/ParseableFormatStyleConversion.swift` | 65 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/Conversions/RawRepresentable.swift` | 104 | **No** | (#1) No dedicated direct human-written test suite for this file. |
| `Sources/Parsing/Conversions/String.swift` | 84 | **No** | (#1) No dedicated direct human-written test suite for this file. |
| `Sources/Parsing/Conversions/Substring.swift` | 89 | **No** | (#1) No dedicated direct human-written test suite for this file. |
| `Sources/Parsing/Conversions/UTF8View.swift` | 37 | **No** | (#1) No dedicated direct human-written test suite for this file. |
| `Sources/Parsing/ConvertingError.swift` | 10 | **No** | (#4) Insufficient local surface (10 LOC). |
| `Sources/Parsing/CountingRange.swift` | 24 | **No** | (#4) Insufficient local surface (24 LOC). |
| `Sources/Parsing/EmptyInitializable.swift` | 3 | **No** | (#4) Insufficient local surface (3 LOC). |
| `Sources/Parsing/Internal/AnyEquatable.swift` | 19 | **No** | (#3/#4) Internal/deprecation surface; not a focused MUT component. |
| `Sources/Parsing/Internal/Deprecations.swift` | 889 | **No** | (#3/#4) Internal/deprecation surface; not a focused MUT component. |
| `Sources/Parsing/Parser.swift` | 249 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinter.swift` | 55 | **No** | (#1) No dedicated direct human-written test suite for this file. |
| `Sources/Parsing/ParserPrinters/Always.swift` | 83 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/AnyParserPrinter.swift` | 68 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Backtracking.swift` | 31 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Bool.swift` | 56 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/CaseIterableRawRepresentable.swift` | 161 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/CharacterSet.swift` | 59 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Conditional.swift` | 65 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Consumed.swift` | 33 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Digits.swift` | 190 | **No** | (#6) Studied in Experiments #7/#8. |
| `Sources/Parsing/ParserPrinters/End.swift` | 53 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Fail.swift` | 91 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Filter.swift` | 81 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/First.swift` | 47 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Float.swift` | 143 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/From.swift` | 57 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Int.swift` | 125 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Lazy.swift` | 68 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Literal.swift` | 59 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Many.swift` | 913 | **No** | (#7) Too large (913 LOC) / not reasonably isolated for focused MUT. |
| `Sources/Parsing/ParserPrinters/Map.swift` | 158 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Newline.swift` | 1 | **No** | (#4) Insufficient local surface (1 LOC). |
| `Sources/Parsing/ParserPrinters/Not.swift` | 59 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/OneOf.swift` | 183 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/OneOfMany.swift` | 68 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Optional.swift` | 52 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Optionally.swift` | 61 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Parse.swift` | 238 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/ParseableFormatStyle.swift` | 36 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Peek.swift` | 60 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Pipe.swift` | 118 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Prefix.swift` | 191 | **No** | (#6) Studied in Experiments #7/#8. |
| `Sources/Parsing/ParserPrinters/PrefixThrough.swift` | 110 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/PrefixUpTo.swift` | 116 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Printing.swift` | 122 | **No** | (#1) No dedicated direct human-written test suite for this file. |
| `Sources/Parsing/ParserPrinters/Pullback.swift` | 64 | **No** | (#1) No dedicated direct human-written test suite for this file. |
| `Sources/Parsing/ParserPrinters/ReplaceError.swift` | 87 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Rest.swift` | 76 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Skip.swift` | 26 | **No** | (#4) Insufficient local surface (26 LOC). |
| `Sources/Parsing/ParserPrinters/StartsWith.swift` | 115 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/UUID.swift` | 112 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParserPrinters/Whitespace.swift` | 190 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/Parsers/AnyParser.swift` | 63 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/Parsers/CompactMap.swift` | 87 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/Parsers/FlatMap.swift` | 60 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/Parsers/Parsers.swift` | 6 | **No** | (#4) Insufficient local surface (6 LOC). |
| `Sources/Parsing/Parsers/Stream.swift` | 56 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/ParsingError.swift` | 510 | **No*** | Not selected — appears after first eligible under alphabetical rule; may independently satisfy criteria. |
| `Sources/Parsing/PrependableCollection.swift` | 175 | **No** | (#1) No dedicated direct human-written test suite for this file. |
| `Sources/Parsing/PrintingError.swift` | 140 | **No** | (#1) No dedicated direct human-written test suite for this file. |
| `Sources/swift-parsing-benchmark/Arithmetic.swift` | 124 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |
| `Sources/swift-parsing-benchmark/BinaryData.swift` | 199 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |
| `Sources/swift-parsing-benchmark/Bool.swift` | 50 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |
| `Sources/swift-parsing-benchmark/CSV.swift` | 117 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |
| `Sources/swift-parsing-benchmark/Color.swift` | 51 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |
| `Sources/swift-parsing-benchmark/Common/Benchmarking.swift` | 46 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |
| `Sources/swift-parsing-benchmark/Common/ParsingError.swift` | 1 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |
| `Sources/swift-parsing-benchmark/Date.swift` | 109 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |
| `Sources/swift-parsing-benchmark/HTTP.swift` | 135 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |
| `Sources/swift-parsing-benchmark/JSON.swift` | 310 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |
| `Sources/swift-parsing-benchmark/Numerics.swift` | 172 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |
| `Sources/swift-parsing-benchmark/PrefixUpTo.swift` | 49 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |
| `Sources/swift-parsing-benchmark/Race.swift` | 207 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |
| `Sources/swift-parsing-benchmark/ReadmeExample.swift` | 133 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |
| `Sources/swift-parsing-benchmark/Samples/CSVSample.swift` | 1002 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |
| `Sources/swift-parsing-benchmark/Samples/XCTestLogsSample.swift` | 5143 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |
| `Sources/swift-parsing-benchmark/StringAbstractions.swift` | 52 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |
| `Sources/swift-parsing-benchmark/UUID.swift` | 23 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |
| `Sources/swift-parsing-benchmark/XCTestLogs.swift` | 143 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |
| `Sources/swift-parsing-benchmark/main.swift` | 23 | **No** | (#1/#7) Benchmark target — not unit-test MUT surface for this protocol. |

### Notes on `No*` rows

`No*` = not selected once the first alphabetical **YES** is frozen.

### Eligible set (alphabetical)

1. **`Sources/Parsing/Builders/OneOfBuilder.swift`** *(selected)*

---

## Selection

**Selected component (first eligible alphabetically):**  
`Sources/Parsing/Builders/OneOfBuilder.swift`

**Selection rule applied:** sort eligible paths alphabetically → take index 0.

**No skipping:** not rejected for suite thinness, builder “interestingness,” predicted Human/AI outcome, or mutation-surface preference.

### Why eligible

- (#1) Direct `OneOfBuilderTests` (`testBuildArray`, `testBuildIf`).
- (#2) Deterministic parse/error assertions.
- (#3) Focused `@OneOfBuilder` construction + nested `OneOf2` / `OptionalOneOf` parse/print.
- (#4) 253 LOC with try-order, optional wrapping, and print fallback branching.
- (#5) No network/external services.
- (#6) Not studied in E1–#13 (distinct from Prefix/Digits).
- (#7) Single isolated production file.

### Intended frozen Human filter (Stage 2)

```bash
swift test --filter 'ParsingTests.OneOfBuilderTests'
```

(Unqualified `OneOfBuilderTests` would also match `AIGeneratedOneOfBuilderTests`; Stage 2 freezes the qualified filter.)

Smoke: **2 tests, 0 failures**.

### Production fingerprint

| File | SHA-256 |
|---|---|
| `Sources/Parsing/Builders/OneOfBuilder.swift` | `af44508de74348ae4be49bbff0548538eb36793d38ff956eb0424dfb9699a55e` |

## FREEZE

**Component is FROZEN.** Do not replace after observing experimental results.
