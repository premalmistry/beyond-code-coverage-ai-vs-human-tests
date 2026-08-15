# Experiment #15 — Human Baseline (`Complex+AlgebraicField.swift`)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/ComplexModule/Complex+AlgebraicField.swift`  
**Repo SHA:** `899af71c0256d0ad181e3b7eb3453c1065d928a5`  
**Baseline date (UTC):** `2026-08-15T17:39:27Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  
**Production SHA-256:** `9f984d0229c4851537e5367bb944a7bd8073d35ea0e94084a201724baaca6f5b`

Human tests and production were **not** modified. No AI tests yet. No mutations yet.

---

## 1. Frozen human suite + contamination guard

**Filter (frozen):**

```bash
swift test --filter 'ComplexTests.ArithmeticTests/testBaudinSmith|ComplexTests.ArithmeticTests/testDivisionByZero'
```

Excludes non-deterministic `testPolar` (RNG) and long `testFloat16DivisionSemiExhaustive`.

| Check | Result |
|---|---|
| Executed | `testBaudinSmith`, `testDivisionByZero` only |
| Any `AIGenerated*` test case? | **No** |
| Contamination | **CLEAN** |

### Human executed-test inventory

```
-[ComplexTests.ArithmeticTests testBaudinSmith]
-[ComplexTests.ArithmeticTests testDivisionByZero]
```

**2** XCTest methods. Assertion sites (`XCTAssert*` / `XCTFail` in those methods): **7**.

---

## 2. Results

| Metric | Value |
|---|---|
| Production LOC | **182** |
| Executable lines | **118** |
| Human test methods | **2** |
| Human assertion call sites | **7** |
| Test result | **PASS** |
| Line coverage | **71.19%** (84 / 118) |
| Region coverage | **40.62%** (13 / 32) |
| Function coverage | **25.00%** (3 / 12) |

Uncovered (docs only): `one`, `/=`, `normalized`, `reciprocal`, `_relaxedAdd`/`_relaxedMul`.

---

## 3. Freeze confirmation

- Production SHA verified vs ORIG  
- Human filter **FROZEN**
