# Experiment #10 — Human Baseline (`Polar.swift`)

**Component:** `Sources/ComplexModule/Polar.swift`  
**Repo:** [apple/swift-numerics](https://github.com/apple/swift-numerics)  
**Repo SHA:** `899af71c0256d0ad181e3b7eb3453c1065d928a5`  
**Baseline date (UTC):** `2026-08-13T15:29:55Z`  
**Swift:** Apple Swift 6.3.3  

**Production SHA-256:**
```
d7c8056e0014a70367480efe161c64fb4bc525047a8681cf2fdba8be192e68d4  Sources/ComplexModule/Polar.swift
```

---

## Frozen human suite + contamination

**Filter:**

```bash
swift test --filter ComplexTests.ArithmeticTests/testPolar
```

| Check | Result |
|---|---|
| PASS | **1 test, 0 failures** |
| `AIGenerated*` executed? | **NO — CLEAN** (E9 saturating AI suite present in package but not selected) |

### Inventory

1. `-[ComplexTests.ArithmeticTests testPolar]`

**Methods:** 1 · **Assertion call sites (static in `testPolar` bodies):** **19** (`XCTAssert*` ×11 + `XCTFail` ×8)

---

## Coverage

| Metric | Value |
|---|---|
| LOC | **130** |
| Executable lines | **34** |
| Line | **88.24%** (30 / 34) |
| Region | **78.95%** (15 / 19) |
| Function | **80.00%** (8 / 10) |

### Uncovered (observation only — do not expand filter)

- `polar` property getter (never read as a tuple)
- Related missed regions on that path

---

## Integrity

Production SHA unchanged; Human PASS; contamination CLEAN. Proceed to Stage 3.
