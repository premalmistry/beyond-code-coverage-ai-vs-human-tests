# Experiment #9 — Mutation Results (`SaturatingArithmetic.swift`)

**Component:** `Sources/IntegerUtilities/SaturatingArithmetic.swift`  
**Frozen set:** E9-M01–E9-M26 (**26**)  
**Repo SHA:** `899af71c0256d0ad181e3b7eb3453c1065d928a5`  
**Run date (UTC):** `2026-08-13T15:25:05Z`  

**AI SHA-256:** `93ebec4f106534683fae2d1824c8d16bf3d5668e10b3f3a196b08f74741253a0`  
**Production SHA-256 (restored):** `1da0a8a5b9f7d6f9a9421786d1817b35eed7dbe9dcf48190eaac5ef131498536`

## Integrity

| Check | Result |
|---|---|
| Production restored + SHA | ✓ |
| AI suite SHA frozen | ✓ |
| Human / AI filters | ✓ PASS after run |
| Suites unmodified post-results | ✓ |

## Results

| Mutation | Human | AI | Notes |
|---|---|---|---|
| E9-M01 | KILLED | KILLED | |
| E9-M02 | KILLED | KILLED | |
| E9-M03 | KILLED | KILLED | |
| E9-M04 | KILLED | KILLED | |
| E9-M05 | KILLED | KILLED | |
| E9-M06 | KILLED | KILLED | |
| E9-M07 | KILLED | KILLED | |
| E9-M08 | KILLED | KILLED | |
| E9-M09 | KILLED | KILLED | |
| E9-M10 | KILLED | KILLED | |
| E9-M11 | KILLED | KILLED | |
| E9-M12 | KILLED | KILLED | |
| E9-M13 | KILLED | KILLED | |
| E9-M14 | KILLED | KILLED | |
| E9-M15 | KILLED | KILLED | |
| E9-M16 | KILLED | KILLED | |
| E9-M17 | KILLED | KILLED | |
| E9-M18: `count <= bitWidth` | **KILLED** | **SURVIVED** | **Human-only** |
| E9-M19 | KILLED | KILLED | |
| E9-M20 | KILLED | KILLED | |
| E9-M21 | KILLED | KILLED | |
| E9-M22 | KILLED | KILLED | |
| E9-M23 | KILLED | KILLED | |
| E9-M24 | KILLED | KILLED | |
| E9-M25: `clamped = Self.max` | **KILLED** | **SURVIVED** | **Human-only** |
| E9-M26: `Int(truncatingIfNeeded:)` | **SURVIVED** | **SURVIVED** | Shared survivor (valid) |

No INVALID / INVALID-EQUIVALENT reclassifications.

### Survivor analysis

- **E9-M18:** Changes `count < Self.bitWidth` to `<=`. At `count == bitWidth` the large-shift path is skipped. Human exhaustive shift coverage kills; AI never asserts at exact `bitWidth`.
- **E9-M25:** Uses `Self.max` instead of `Self.max &- signbit` for shift saturation. Differs only for **signed** overflow to min. AI’s large-shift / saturate cases are non-negative; Human exhaustive signed shifts kill.
- **E9-M26:** `Int(clamping:)` → `Int(truncatingIfNeeded:)`. **Not equivalent:** e.g. `UInt.max` → clamp `Int.max` vs trunc `-1`. Neither suite calls the generic overload with a `Count` outside `Int`’s range (AI only uses `Int16(3)`). Retained as valid shared survivor.

## Scores

| Metric | Value |
|---|---|
| Total planned / valid | **26 / 26** |
| Human killed / survived | **25 / 1** |
| Human mutation score | **96.2%** (25/26) |
| AI killed / survived | **23 / 3** |
| AI mutation score | **88.5%** (23/26) |
| Human-only kills | **E9-M18, E9-M25** |
| AI-only kills | **none** |
| Both survived (valid) | **E9-M26** |
