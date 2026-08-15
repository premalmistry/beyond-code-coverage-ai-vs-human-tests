# Experiment #6 — AI Baseline (`Partition.swift`)

**Component (primary):** `Sources/Algorithms/Partition.swift`  
**Repo SHA:** `5b7143f8e291dee0e14c118fd0212487f0b37af5`  
**Baseline date (UTC):** `2026-08-13T14:11:15Z`  
**Swift:** Apple Swift 6.3.3 (`swiftlang-6.3.3.1.3`), arm64 macOS  

**Isolation:** AI suite generated from production `Partition.swift` (+ Package/test target layout) only. Human `PartitionTests`, human coverage artifacts, and mutation plans were **not** used as generation inputs.

**Production SHA-256:**
```
bef59fabc5958af321b728fb4bac230ff875db3135d17b6e5bee0216a8be3644  Sources/Algorithms/Partition.swift
```

**AI test file (frozen) SHA-256:**
```
2ed75624b2a22bf13f7911512fa3e1cf0b19385415a4d06916e8d92078725c59  Tests/SwiftAlgorithmsTests/AIGeneratedPartitionTests.swift
```

---

## 1. Frozen AI suite

**File:** `Tests/SwiftAlgorithmsTests/AIGeneratedPartitionTests.swift`  
**Filter:**

```bash
swift test --filter AIGeneratedPartitionTests
```

| Metric | Value |
|---|---|
| AI test methods | **29** |
| AI assertion call sites (static) | **59** |
| Test result | **PASS** (29 tests, 0 failures) |

### Disjoint inventory check (Runbook v2)

| Check | Result |
|---|---|
| Human filter executes `AIGenerated*`? | **NO** (10 Human tests only) |
| AI filter executes Human `PartitionTests`? | **NO** (29 AI tests only) |
| Inventory overlap | **empty** |

Do **not** edit the AI file after freeze.

---

## 2. Coverage results

| Metric | Value |
|---|---|
| Executable lines | **216** |
| Line coverage | **95.83%** (207 / 216; 9 missed) |
| Region coverage | **96.20%** (76 / 79; 3 missed) |
| Function coverage | **90.91%** (10 / 11; 1 missed) |

Notable vs Human: AI exercises `Sequence.partitioned(by:)` (Human left at 0% because Array uses the Collection overload). Remaining misses are mainly throwing/`count`-mismatch precondition arms.

---

## 3. Integrity check (end of Stage 3)

| Check | Result |
|---|---|
| Production SHA unchanged | **PASS** |
| AI test SHA recorded | **PASS** |
| AI suite rerun | **PASS** (29 tests) |
| Human/AI inventories disjoint | **PASS** |

AI suite is frozen. Proceed to Stage 4 (mutation plan — no execution yet).
