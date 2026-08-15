# Experiment #8 — Human Baseline (`Digits.swift`)

**Component:** `Sources/Parsing/ParserPrinters/Digits.swift`  
**Repo SHA:** `7160b25d39e4a38258a7fe71591fbe182b026d69`  
**Baseline date (UTC):** `2026-08-13T15:01:54Z`  
**Swift:** Apple Swift 6.3.3  

**Production SHA-256:**
```
551333cb817917cdce03362e1949e848cd7245b9d8c1a91257407e3c531157ce  Sources/Parsing/ParserPrinters/Digits.swift
```

---

## Frozen human suite + contamination

**Filter:**

```bash
swift test --filter ParsingTests.DigitsTests
```

| Check | Result |
|---|---|
| PASS | **2 tests, 0 failures** |
| `AIGenerated*` executed? | **NO — CLEAN** |

### Inventory

1. `-[ParsingTests.DigitsTests testDigits]`
2. `-[ParsingTests.DigitsTests testZeroMinimum]`

**Methods:** 2 · **Assertion sites:** 13

---

## Coverage

| Metric | Value |
|---|---|
| LOC | **190** |
| Executable lines | **143** |
| Line | **81.82%** (117 / 143) |
| Region | **78.26%** (36 / 46) |
| Function | **73.33%** (11 / 15) |

### Uncovered (observation only)

- Integer **overflow** error path in `parse`
- Some unused Identity/UTF8View init overloads
- Partial print negative / edge arms

Do **not** expand the frozen filter.

---

## Integrity

Production SHA unchanged; Human PASS; contamination CLEAN. Proceed to Stage 3.
