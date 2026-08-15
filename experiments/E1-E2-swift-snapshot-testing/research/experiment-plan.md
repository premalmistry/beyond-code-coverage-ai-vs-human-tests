# Experiment Plan: AI-Generated vs Human-Written Unit Tests

**Repository:** [pointfreeco/swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing)  
**Pinned revision:** `59a99c458de4d2dee580529b61b4f78dca7b7fa6` (`main` as of clone, 2026-08-12)  
**Research question:** How effective are AI-generated unit tests compared with existing human-written tests?  
**Metrics:** code coverage, mutation score, number of mutations detected  
**Scope tonight:** analysis + plan + human baseline only (**no AI tests, no mutations applied**)

---

## 1. Project architecture (brief)

SwiftPM package with three products:

| Product | Role |
|---|---|
| `SnapshotTesting` | Core library: `assertSnapshot`, `Snapshotting`/`Diffing` strategies, configuration |
| `InlineSnapshotTesting` | Inline snapshots via swift-syntax rewriting |
| `SnapshotTestingCustomDump` | `.customDump` strategy bridging `CustomDump` |

**Layout**

- `Sources/SnapshotTesting/` — assert API, diff engine (`Diff.swift`), strategy modules under `Snapshotting/` (String, URLRequest, UI*, etc.), configuration
- `Sources/InlineSnapshotTesting/` — inline assert helpers (depends on swift-syntax)
- `Tests/SnapshotTestingTests/` — human XCTest/Swift Testing suite + `__Snapshots__` fixtures
- Platforms: iOS/macOS/tvOS/watchOS; CI also runs Linux via `swift test`

**Test style:** primarily *snapshot* tests (serialize value → compare to on-disk fixture). Many strategies need UIKit/AppKit; a smaller subset is Foundation-only and suitable for a weekend mutation experiment.

---

## 2. Experiment candidates

Criteria: meaningful logic, existing human tests, mostly platform-independent, SwiftPM-runnable, branch-rich for mutation testing, no UI/simulator image snapshots, independently testable.

| Candidate | Source LOC | Existing tests | Why suitable | Complexity |
|---|---:|---|---|---|
| **`Snapshotting/URLRequest.swift`** | 130 | `testURLRequest` (1 method, **10** `assertSnapshot`s; 11 on-disk fixtures under `__Snapshots__/…/testURLRequest.*`) | Foundation-only; `.raw` / `.curl` formatters with method/header/cookie/body/query branches; no UI; mutations change snapshot text → tests fail | **Medium** |
| **`Snapshotting/Any.swift`** (`snap` / `.dump`) | 241 | Several dump tests (`testAny`, `testRecursion`, `testAnySnapshotStringConvertible`, `testDeterministicDictionaryAndSetSnapshots`, `testMultipleSnapshots`, `testNamedAssertion`, …) | Large Mirror switch with pluralization, sorting, circular refs; platform-independent; well exercised by string snapshots | **Medium–High** |
| **`Diff.swift`** (`diff` / `chunk`) | 131 | No direct unit tests; used by `Diffing.lines` only on **mismatch** path | Pure algorithmic LCS-style diff + hunk chunking; many operators/branches | **High** (logic) / **Poor fit** for fair weekend compare* |
| **`Snapshotting/CaseIterable.swift`** | 55 | `testCaseIterable` (1 snapshot → CSV) | Small, SwiftPM-friendly, deterministic CSV mapping | **Low** |
| **`Snapshotting/String.swift`** (`Diffing.lines`) | 28 | Indirectly via any failing line-diff; equality guard `old != new` | Tiny surface; couples tightly to `Diff.swift` | **Low** |

\* **Diff caveat:** while snapshots match, `Diff.swift` is not executed. Mutating it often leaves existing *passing* human tests green, understating human effectiveness and biasing the experiment. Prefer a component whose happy-path output is asserted.

---

## 3. Selected component (recommendation)

**`Sources/SnapshotTesting/Snapshotting/URLRequest.swift`**

1. Meaningful, branchy formatting logic (HTTP method switch, header sort, Cookie exclusion, body escaping, query sorting, raw vs curl).
2. Dedicated human coverage (`testURLRequest`) with **10** string snapshot assertions — no simulator/UI images.
3. Runs under SwiftPM on macOS (`swift test --filter …`); Foundation-only (`#if !os(WASI)`).
4. Weekend-sized (~130 LOC) with ~15–20 clear, local mutants; production architecture unchanged.
5. Neutral for AI vs human: humans already cover common paths well; uncovered `pretty: true` JSON path and edge cases leave room without gaming either side.

---

## 4. Human baseline (selected component)

### Environment

| Item | Value |
|---|---|
| Host | macOS `darwin` arm64 |
| Swift | Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`) |
| Repo SHA | `59a99c458de4d2dee580529b61b4f78dca7b7fa6` |
| Baseline date (UTC) | 2026-08-13T00:35:57Z |

### Commands used (document exactly)

```bash
# Clone (done once for this workspace)
git clone --depth 1 https://github.com/pointfreeco/swift-snapshot-testing.git
cd swift-snapshot-testing
git rev-parse HEAD   # 59a99c458de4d2dee580529b61b4f78dca7b7fa6

# Run existing human URLRequest tests + instrument coverage
swift test --filter SnapshotTestingTests.testURLRequest --enable-code-coverage

# Coverage report for the selected file
PROF=".build/arm64-apple-macosx/debug/codecov/default.profdata"
BIN=".build/arm64-apple-macosx/debug/swift-snapshot-testingPackageTests.xctest/Contents/MacOS/swift-snapshot-testingPackageTests"

xcrun llvm-cov report "$BIN" -instr-profile="$PROF" \
  Sources/SnapshotTesting/Snapshotting/URLRequest.swift

xcrun llvm-cov show "$BIN" -instr-profile="$PROF" \
  Sources/SnapshotTesting/Snapshotting/URLRequest.swift
```

Artifacts saved:

- `research/baseline-urlrequest-coverage.txt`
- `research/baseline-urlrequest-coverage-detail.txt`

### Results

| Metric | Value |
|---|---|
| Production LOC (physical, `wc -l`) | **130** |
| Executable lines (`llvm-cov`) | **128** |
| Human test methods targeting component | **1** (`SnapshotTestingTests.testURLRequest`) |
| Human snapshot assertions in that method | **10** |
| On-disk fixtures named `testURLRequest.*` | **11** (includes unused leftover `post-json.txt`; method ends with a POST setup that does **not** call `assertSnapshot`) |
| Test result | **PASS** (1 test, 0 failures) |
| Line coverage (`URLRequest.swift`) | **85.16%** (109 / 128 lines) |
| Region coverage | **63.89%** (23 / 36 regions) |
| Function coverage | **53.33%** (8 / 15 functions) |

**Primary uncovered path:** `raw(pretty: true)` JSON pretty-print branch (lines ~40–48). Human tests only use `.raw` ⇒ `raw(pretty: false)`.

**Existing human tests were not modified.**

---

## 5. Proposed mutations (not applied)

Target file: `Sources/SnapshotTesting/Snapshotting/URLRequest.swift`  
Approx. **18** mutants. “Human test expected to catch?” = expectation that **current** `testURLRequest` snapshots fail if the mutant is live (Yes / Likely / No / Uncertain).

| # | Mutation | Source location | Expected behavior change | Human test expected to catch? |
|---|---|---|---|---|
| M01 | `Snapshotting.raw(pretty: false)` → `pretty: true` | L23 | `.raw` attempts JSON pretty-print for bodies | **Yes** for JSON body cases (`post-with-json`); others may stay similar |
| M02 | `httpMethod ?? "GET"` → `httpMethod ?? "POST"` | L31 | Default method label wrong when `httpMethod == nil` | **Likely** (GET fixtures often rely on nil ⇒ `"GET"`) |
| M03 | `?? "(null)"` → `?? ""` | L31 | Missing URL renders empty instead of `(null)` | **No** (no nil-URL fixture) |
| M04 | Remove `.sorted()` on header lines | L35 | Header order non-deterministic / unsorted | **Yes** (fixtures assume sorted headers) |
| M05 | `joined(separator: "\n")` → `"\n\n"` | L59 | Extra blank lines in raw output | **Yes** |
| M06 | `if pretty` → `if !pretty` | L39 | Non-pretty `.raw` takes pretty JSON path | **Yes** for JSON POST; form-encoded may error into catch (similar) |
| M07 | Drop `request.httpBody.map { … }` in `catch` → always `[]` | L53–56 | Raw snapshots omit bodies | **Yes** (`post`, `post-with-json`) |
| M08 | `case "GET": break` → append `"--request GET"` | L85 | curl GET gains `--request GET` | **Yes** (`get-curl`, `get-with-query-curl`) |
| M09 | `case "HEAD": … "--head"` → `break` | L86 | HEAD curl omits `--head` | **Yes** (`head-curl`) |
| M10 | `"--head"` → `"--request HEAD"` | L86 | Different HEAD encoding | **Yes** (`head-curl`) |
| M11 | `default: append("--request …")` → `break` | L87 | POST/PUT curl omit `--request` | **Yes** (`post-curl`, `post-with-json-curl`) |
| M12 | `where field != "Cookie"` → `where field == "Cookie"` | L92 | Only Cookie emitted as `--header`; other headers dropped | **Yes** |
| M13 | `where field != "Cookie"` → remove `where` clause | L92 | Cookie duplicated as `--header` and `--cookie` | **Yes** |
| M14 | Remove `\"` → `\\\"` header escaping | L93 | Quotes in header values unescaped | **Uncertain** (few quoted non-cookie headers in fixtures) |
| M15 | Delete body `if let httpBodyData` block | L99–106 | curl omits `--data` | **Yes** (POST curl fixtures) |
| M16 | Swap escape order / remove `\"` body escaping | L102–103 | Broken `--data` quoting | **Yes** (JSON/form bodies with quotes) |
| M17 | Delete cookie `if let cookie` block | L109–112 | curl omits `--cookie` | **Yes** (most curl fixtures include Cookie) |
| M18 | `$0.name < $1.name` → `$0.name > $1.name` | L124 | Query keys reverse-sorted | **Yes** (`get-with-query`, `*-curl`) |
| M19 | Skip assigning `components?.queryItems = sortedQueryItems` | L125 | Query order left unsorted | **Yes** when input order ≠ sorted (`get-with-query`) |
| M20 | `joined(separator: " \\\n\t")` → `"\n"` | L117 | curl formatting changes | **Yes** (all `*-curl` fixtures) |

**Out of scope for first round (optional later):** mutants only inside the uncovered `pretty: true` success path (e.g. drop `.sortedKeys`) — humans likely **miss** those until someone calls `raw(pretty: true)`.

**Mutation protocol (weekend, when executing):**

1. Work on a throwaway branch; never commit mutants to the experiment baseline branch.
2. Apply **one** mutant at a time; rebuild; run:
   ```bash
   swift test --filter SnapshotTestingTests.testURLRequest
   ```
3. **Killed** = ≥1 failure; **Survived** = all pass; **Invalid** = build failure / equivalent compile error → exclude from denominator.
4. Restore file before next mutant (`git checkout -- Sources/SnapshotTesting/Snapshotting/URLRequest.swift`).
5. Record results in `research/mutation-results-human.md` (to be created during execution).

---

## 6. Reproducibility constraints

- Do **not** modify production architecture or existing human tests.
- Pin SHA `59a99c458de4d2dee580529b61b4f78dca7b7fa6` (or record exact SHA if re-cloned).
- Prefer filtered test runs for speed; optionally confirm once with full `swift test` / `make test-swift`.
- Keep AI prompt, model, temperature, and generation date in `research/` when AI suite is produced.
- Same mutant list + same commands for human suite vs AI suite.

---

## 7. Next steps (not done tonight)

1. **Freeze baseline** — this document + coverage artifacts; optional tag `research/urlrequest-baseline`.
2. **Generate AI tests** for `URLRequest` strategies only (separate file, e.g. `Tests/SnapshotTestingTests/AIGeneratedURLRequestTests.swift`); do not edit `testURLRequest`.
3. **Measure AI suite:** run AI tests alone; `llvm-cov` on `URLRequest.swift`; record LOC coverage + assertion count.
4. **Run mutation campaign** (~18 mutants) against (a) human-only, (b) AI-only, (c) optional combined; compute mutation score = killed / (killed + survived).
5. **Write results** — tables for coverage Δ, killed/survived counts, qualitative notes (redundant tests, missed edges like `pretty: true`, nil URL).
6. **Keep experiment small** — one file, one weekend, no package redesign.

---

## 8. Weekend success criteria

- [ ] Human baseline numbers reproduced with documented commands  
- [ ] ≥15 valid mutants applied and scored against human tests  
- [ ] AI test suite generated once, frozen, scored on coverage + same mutants  
- [ ] Short results write-up comparing coverage %, mutation score, and # mutations detected  

**Stop line for tonight:** plan + baseline complete; **AI test generation not started.**
