# Mutation Results — Human vs AI URLRequest Suites

**Component:** `Sources/SnapshotTesting/Snapshotting/URLRequest.swift`  
**Mutation set:** M01–M20 from `research/experiment-plan.md` (no added mutants)  
**Repo SHA:** `59a99c458de4d2dee580529b61b4f78dca7b7fa6`  
**Date (UTC):** 2026-08-13  

## Integrity checks

- Production file restored after every mutant (`research/URLRequest.swift.ORIG`).
- Snapshot fixtures restored after every mutant (`git checkout -- Tests/SnapshotTestingTests/__Snapshots__/`).
- Ran with `SNAPSHOT_TESTING_RECORD=never` to avoid keeping fixture pollution.
- Suites frozen: human `testURLRequest` unchanged; AI SHA-256 `1eba2811acf4de49c78c9f6c2ce1bf60d345317877a780c363587fd2bce0d2b4` unchanged.
- Final post-run verify: both suites **PASS** on restored production.
- Raw logs: `research/mutation-logs/MXX-human.log`, `research/mutation-logs/MXX-ai.log`.
- Machine-readable rows: `research/mutation-results.jsonl`.

> Note: An initial campaign run without fixture restore polluted `__Snapshots__` via auto-record. Those results were discarded. The table below is from a full re-run with per-mutant fixture restore + `SNAPSHOT_TESTING_RECORD=never`.

## Commands used (per mutant)

```bash
cp research/mutants/MXX.swift Sources/SnapshotTesting/Snapshotting/URLRequest.swift
SNAPSHOT_TESTING_RECORD=never swift test --filter SnapshotTestingTests.testURLRequest
SNAPSHOT_TESTING_RECORD=never swift test --filter AIGeneratedURLRequestTests
cp research/URLRequest.swift.ORIG Sources/SnapshotTesting/Snapshotting/URLRequest.swift
git checkout -- Tests/SnapshotTestingTests/__Snapshots__/
```

Final verification:

```bash
cp research/URLRequest.swift.ORIG Sources/SnapshotTesting/Snapshotting/URLRequest.swift
git checkout -- Tests/SnapshotTestingTests/__Snapshots__/
SNAPSHOT_TESTING_RECORD=never swift test --filter SnapshotTestingTests.testURLRequest
SNAPSHOT_TESTING_RECORD=never swift test --filter AIGeneratedURLRequestTests
```

## Results table

| Mutation | Human | AI | Human failing tests | AI failing tests | Notes |
|---|---|---|---|---|---|
| M01: `raw(pretty: false)` → `pretty: true` (L23) | KILLED | KILLED | `testURLRequest` snapshots: post-with-json | `testRaw_prettyFalseDoesNotPrettyPrintJSON`, `testRaw_staticRawMatchesPrettyFalse` | |
| M02: `httpMethod ?? "GET"` → `?? "POST"` (L31) | SURVIVED | SURVIVED | — | — | Both survive: `httpMethod` reads as non-nil `"GET"` in these setups, so `??` default unused |
| M03: `?? "(null)"` → `?? ""` (L31) | SURVIVED | KILLED | — | `testRaw_nilURLRendersNullPlaceholder`, `testRaw_nilURLWithHeadersAndBody` | AI-only: nil-URL cases absent from human fixtures |
| M04: Remove `.sorted()` on raw headers (L35) | KILLED | KILLED | `testURLRequest` snapshots: get, get-with-query, post, post-with-json | `testRaw_headersAreSortedAlphabetically`, `testRaw_includesCookieHeaderInRawOutput` | |
| M05: `joined("\n")` → `joined("\n\n")` (L59) | KILLED | KILLED | `testURLRequest` snapshots: get, get-with-query, post, post-with-json, head | 11 AI failures (raw/pretty formatting) | |
| M06: `if pretty` → `if !pretty` (L39) | KILLED | KILLED | `testURLRequest` snapshots: post-with-json | 6 AI failures (pretty/raw JSON paths) | |
| M07: catch body always `[]` (L53–56) | KILLED | KILLED | `testURLRequest` snapshots: post, post-with-json | 6 AI failures (body-related raw tests) | |
| M08: `case "GET": break` → append `--request GET` (L85) | KILLED | KILLED | `testURLRequest` snapshots: get-curl, get-with-query-curl | 7 AI curl GET failures | |
| M09: `case "HEAD": --head` → `break` (L86) | KILLED | KILLED | `testURLRequest` snapshots: head-curl | `testCurl_HEADUsesHeadFlag` | |
| M10: `"--head"` → `"--request HEAD"` (L86) | KILLED | KILLED | `testURLRequest` snapshots: head-curl | `testCurl_HEADUsesHeadFlag` | |
| M11: `default: append(--request)` → `break` (L87) | KILLED | KILLED | `testURLRequest` snapshots: post-curl, post-with-json-curl | 9 AI non-GET/HEAD curl failures | |
| M12: `where field != "Cookie"` → `== "Cookie"` (L92) | KILLED | KILLED | `testURLRequest` snapshots: get-curl, get-with-query-curl, post-curl, post-with-json-curl, head-curl | 5 AI header/cookie curl failures | |
| M13: Remove `where field != "Cookie"` (L92) | KILLED | KILLED | `testURLRequest` snapshots: get-curl, get-with-query-curl, post-curl, head-curl | 4 AI cookie-duplication curl failures | |
| M14: Remove header `"` escaping (L93) | SURVIVED | KILLED | — | `testCurl_escapesDoubleQuotesInHeaderValues` | AI-only: human fixtures lack quoted non-Cookie header values |
| M15: Delete curl body `if let` block (L99–106) | KILLED | KILLED | `testURLRequest` snapshots: post-curl, post-with-json-curl | 5 AI `--data` failures | |
| M16: Swap curl body escape order (L102–103) | KILLED | KILLED | `testURLRequest` snapshots: post-with-json-curl | `testCurl_escapesQuotesInBody` | |
| M17: Delete curl cookie `if let` block (L109–112) | KILLED | KILLED | `testURLRequest` snapshots: get-curl, get-with-query-curl, post-curl, head-curl | 4 AI `--cookie` failures | |
| M18: `$0.name < $1.name` → `>` (L124) | KILLED | KILLED | `testURLRequest` snapshots: get-with-query, get-with-query-curl | 4 AI query-sorting failures | |
| M19: Skip assigning sorted query items (L125) | KILLED | KILLED | `testURLRequest` snapshots: get-with-query, get-with-query-curl | 4 AI query-sorting failures | |
| M20: curl `joined(" \\\n\t")` → `joined("\n")` (L117) | KILLED | KILLED | `testURLRequest` snapshots: get-curl, get-with-query-curl, post-curl, post-with-json-curl, head-curl | 17 AI curl formatting failures | |

## Scores

Mutation score = Killed / (Killed + Survived) × 100

| Metric | Value |
|---|---|
| Total mutations | 20 |
| Valid mutations | 20 |
| Invalid mutations | 0 |
| Human killed | 17 |
| Human survived | 3 |
| Human mutation score | **85.0%** (17/20) |
| AI killed | 19 |
| AI survived | 1 |
| AI mutation score | **95.0%** (19/20) |
| Mutations caught only by Human | 0 (—) |
| Mutations caught only by AI | 2 (M03, M14) |
| Mutations caught by both | 17 (M01, M04–M13, M15–M20) |
| Mutations missed by both | 1 (M02) |

## Stop line

Mutation campaign complete. Suites were not modified. No new tests or mutations added after seeing results.
