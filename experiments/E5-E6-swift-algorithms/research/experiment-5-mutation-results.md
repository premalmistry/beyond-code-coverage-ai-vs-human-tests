# Experiment #5 — Mutation Results (`Combinations.swift`)

**Component:** `Sources/Algorithms/Combinations.swift`  
**Frozen set:** E5-M01–E5-M26 (**26**) from `research/experiment-5-mutation-plan.md`  
**Repo SHA:** `5b7143f8e291dee0e14c118fd0212487f0b37af5`  
**Run date (UTC):** `2026-08-13T14:00:00Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**AI suite SHA-256:** `e976602ed1a9a7546365a77dce298e130cee68d9645f8088bb7cdc8b52e529fa`  
**Production SHA-256 (restored):** `a47a9033683f9be178ebd992398c1bc7c4f269c2eb02c2ac34cc7d3bd4dc2263`

## Integrity (pre-run / post-run)

| Check | Result |
|---|---|
| Repo SHA | `5b7143f8…` ✓ |
| Production SHA-256 | matches baseline ✓ |
| AI test SHA-256 | matches freeze ✓ |
| Human `CombinationsTests.swift` | unmodified ✓ |

### Human filter correction (methodology)

An initial pass used `--filter CombinationsTests`, which also matched `AIGeneratedCombinationsTests` (31 tests). Those contaminated logs are archived under `research/mutation-logs-e5-contaminated-filter/` and `research/experiment-5-mutation-results.jsonl.contaminated-filter`.

**Authoritative results** use:

```bash
swift test --filter SwiftAlgorithmsTests.CombinationsTests   # Human: 4 tests
swift test --filter AIGeneratedCombinationsTests             # AI: 27 tests
```

## Protocol

- One mutant at a time via `research/run_e5_mutations.py`; restore from `research/Combinations.swift.ORIG` after each.
- Timeout: **30s** per suite run.
- Crash / precondition / signal abort ⇒ **KILLED-CRASH**; hang ⇒ **KILLED-TIMEOUT**.
- Suites not modified after freeze; mutation set not altered after observation.
- Logs: `research/mutation-logs-e5/`; mutants: `research/mutants-e5/`; machine rows: `research/experiment-5-mutation-results.jsonl`.

## Results table

| Mutation | Human | AI | Notes |
|---|---|---|---|
| E5-M01: `lowerBound < upperBound` → `<=` | SURVIVED | SURVIVED | → **INVALID-EQUIVALENT** (below) |
| E5-M02: clamp `0..<(upperBound-1)` | KILLED | KILLED | |
| E5-M03: else `nil` → `0..<0` | SURVIVED | SURVIVED | → **INVALID-EQUIVALENT** (below) |
| E5-M04: nil count → `1` | KILLED | KILLED-CRASH | Both killed |
| E5-M05: power-set range `0..<n` | KILLED-CRASH | KILLED-CRASH | |
| E5-M06: `1<<(n-1)` | KILLED | KILLED | |
| E5-M07: binomial base → `0` | KILLED | KILLED | |
| E5-M08: `case n...: return 1` | SURVIVED | SURVIVED | → **INVALID-EQUIVALENT** (below) |
| E5-M09: symmetry `k-1` | KILLED-CRASH | KILLED-CRASH | |
| E5-M10: `*` → `+` in binomial | KILLED-CRASH | KILLED-CRASH | |
| E5-M11: reduce `*` | KILLED-CRASH | KILLED-CRASH | |
| E5-M12: invert `isFinished` | KILLED-CRASH | KILLED-CRASH | |
| E5-M13: nil → `0..<1` | KILLED | KILLED | |
| E5-M14: `prefix(lowerBound+1)` | KILLED-CRASH | KILLED-CRASH | |
| E5-M15: advanceKRange `<=` | SURVIVED | SURVIVED | → **INVALID-EQUIVALENT** (below) |
| E5-M16: advance size `+2` | KILLED-CRASH | KILLED-CRASH | |
| E5-M17: rebuild `prefix(upperBound)` | KILLED-CRASH | KILLED-CRASH | |
| E5-M18: invert empty-index guard | KILLED-CRASH | KILLED-CRASH | |
| E5-M19: `formIndex(before:)` | KILLED | KILLED | → **INVALID** (compile error; below) |
| E5-M20: invert endIndex early-return | KILLED-CRASH | KILLED-CRASH | |
| E5-M21: `j > 0` | KILLED-CRASH | KILLED-CRASH | |
| E5-M22: copy prior index | KILLED | KILLED | |
| E5-M23: invert break | KILLED-CRASH | KILLED-CRASH | |
| E5-M24: invert `isFinished` guard in `next` | KILLED-CRASH | KILLED-CRASH | |
| E5-M25: remove `defer { advance() }` | KILLED-TIMEOUT | KILLED-TIMEOUT | |
| E5-M26: precondition `k > 0` | KILLED | KILLED | crash on `k == 0` |

## Equivalence / invalid assessments

### E5-M01 — INVALID-EQUIVALENT

**Observed:** SURVIVED / SURVIVED.

Changing `range.lowerBound < upperBound` to `<=` only affects the boundary `lowerBound == upperBound` (`upperBound = n + 1`). In that case the original stores `nil`; the mutant stores `range.clamped(to: 0..<upperBound)`, which is an **empty** range. Publicly: `count` is 0 either way (`guard let` vs empty `map`/`reduce`), and iteration is empty (`nil` → iterator `0..<0`; empty range → `isFinished`). No observable difference under the API.

### E5-M03 — INVALID-EQUIVALENT

**Observed:** SURVIVED / SURVIVED.

Replacing out-of-range `nil` with `0..<0` is the same sentinel the iterator already uses (`combinations.kRange ?? 0..<0`). Count and enumeration both empty.

### E5-M08 — INVALID-EQUIVALENT

**Observed:** SURVIVED / SURVIVED.

`case n...: return 0` in `binomial` handles `k > n`. After init clamping, mapped `k` values are in `0...n`, and `k == n` is handled by `case n, 0`. The mutated arm is unreachable for legal `CombinationsSequence` values constructed via the public APIs.

### E5-M15 — INVALID-EQUIVALENT

**Observed:** SURVIVED / SURVIVED.

Widening `advanceKRange`’s guard from `<` to `<=` only adds work when `kRange` is already empty (`lowerBound == upperBound`). `next()` returns `nil` via `isFinished` before further advances once the range is empty, so the new branch is not exercised. (If it were, constructing `(lowerBound+1)..<upperBound` with `lowerBound == upperBound` would trap — still unreachable here.)

### E5-M19 — INVALID (compile failure)

**Observed:** both suites fail the build (`formIndex(before:)` is not available — only `after:` on `Collection`).

Not a meaningful runtime mutant. Excluded from the score denominator.

## Scores

Mutation score = Killed / (Killed + Survived) × 100  
(`KILLED` + `KILLED-CRASH` + `KILLED-TIMEOUT` count as killed.)

| Metric | Value |
|---|---|
| Total planned mutations | **26** |
| Invalid / equivalent excluded | **5** (E5-M01, M03, M08, M15 equivalent; M19 compile) |
| Valid mutants | **21** |
| Human killed | **21** |
| Human survived | **0** |
| Human mutation score | **100.0%** (21/21) |
| AI killed | **21** |
| AI survived | **0** |
| AI mutation score | **100.0%** (21/21) |
| Both killed | **21** (all valid) |
| Human-only kills | **none** |
| AI-only kills | **none** |
| Both survived (valid) | **none** |
| Crash kills (either suite) | E5-M05, M09–M12, M14, M16–M18, M20–M21, M23–M24 (+ M04 AI; M26 precondition) |
| Timeout kills | **E5-M25** (both) |

## Bucket IDs

| Bucket | IDs |
|---|---|
| INVALID-EQUIVALENT | E5-M01, E5-M03, E5-M08, E5-M15 |
| INVALID (compile) | E5-M19 |
| Both killed (valid) | E5-M02, M04–M07, M09–M14, M16–M18, M20–M26 |
| Human-only / AI-only | — |
| Shared valid survivors | — |

## Notes

- Coverage was essentially identical (~99% line) and mutation effectiveness on the valid set was also identical (both 100%).
- Many kills are crash/timeout rather than precise assertion diffs — still valid kills per runbook.
- Contaminated first-pass results are preserved but **not** used for scoring.
