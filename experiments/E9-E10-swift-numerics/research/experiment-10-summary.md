# Experiment #10 — Summary

**Repository:** [apple/swift-numerics](https://github.com/apple/swift-numerics)  
**Pinned SHA:** `899af71c0256d0ad181e3b7eb3453c1065d928a5`  
**Component:** `Sources/ComplexModule/Polar.swift`  
**Swift:** Apple Swift 6.3.3  
**Date (UTC):** `2026-08-13`

**Production SHA-256:** `d7c8056e0014a70367480efe161c64fb4bc525047a8681cf2fdba8be192e68d4`  
**AI suite SHA-256:** `b8eb9d8ca821b9bd0e74d30509135ea852c8b3b8397a57a5cc53995739bbf7fe`  

**Human filter:** `swift test --filter ComplexTests.ArithmeticTests/testPolar`  
**AI filter:** `swift test --filter ComplexTests.AIGeneratedPolarTests`  

**Diversity vs E9:** E9 was fixed-width **integer saturating** arithmetic. E10 is **complex polar geometry** (Euclidean length, phase, polar init) with floating-point specials and documented ulp tolerances.

---

## Compact results

| Metric | Human | AI |
|---|---:|---:|
| Test methods | 1 | 18 |
| Assertions (static) | 19 | 49 |
| Line coverage | 88.24% | 97.06% |
| Region coverage | 78.95% | 94.74% |
| Function coverage | 80.00% | 90.00% |
| Valid mutants | 23 | 23 |
| Mutants killed | 17 | 22 |
| Mutation score | **73.9%** | **95.7%** |
| Unique kills | 0 | **5** |

**Planned mutants:** 24 · **Excluded equivalent:** E10-M20 (1) · **Valid:** 23

---

## Observed findings (this experiment only)

1. **Coverage:** AI higher on line/region/function (includes `.polar` and stronger special-value paths).
2. **Mutation score:** AI **95.7%** vs Human **73.9%**.
3. **Human-only kills:** none.
4. **AI-only kills:** **E10-M06, E10-M10, E10-M12, E10-M14, E10-M24** (non-finite length/phase policy + `polar` tuple).
5. **Shared valid survivor:** **E10-M21** (omitted illegal-phase precondition).
6. Human suite is a single RNG-based polar round-trip test; AI uses deterministic inputs + exact specials + 16-ulp finite checks.
7. Do **not** generalize beyond this Polar component.

---

## Methodology (Runbook v2)

Production scope frozen; qualified Human method filter; inventory recorded; zero `AIGenerated*` under Human filter. AI from production API only; inventories disjoint; mutations frozen pre-execution; identical mutants vs both suites; suites not edited after results.  

**Extra integrity controls (documented):** `swift package clean` per mutant suite (inlinable Polar); Human kill requires 3 consecutive failures (RNG flake protection). E10-M20 reclassified equivalent via `Complex.==` non-finite identity.

---

## Artifacts

| Artifact | Path |
|---|---|
| Candidate | `research/experiment-10-candidate.md` |
| Human / AI baselines | `research/experiment-10-human-baseline.md`, `…-ai-baseline.md` |
| Coverage | `research/experiment-10-*-coverage*.txt` |
| Mutation plan / results | `research/experiment-10-mutation-plan.md`, `…-results.md`, `…-results.jsonl` |
| Logs / mutants / runner / ORIG | `research/mutation-logs-e10/`, `research/mutants-e10/`, `research/run_e10_mutations.py`, `research/Polar.swift.ORIG` |
| AI tests | `Tests/ComplexTests/AIGeneratedPolarTests.swift` |

---

## Final integrity

| Check | Result |
|---|---|
| Production restored + SHA-256 | **PASS** |
| AI SHA-256 | **PASS** |
| Human PASS (1) / AI PASS (18) | **PASS** |
| Human filter excludes `AIGenerated*` | **CLEAN** |
| Inventories disjoint | **PASS** |

Experiment #10 complete. **Stop** — no further experiments in this series.
