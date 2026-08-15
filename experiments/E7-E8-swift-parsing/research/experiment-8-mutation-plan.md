# Experiment #8 — Mutation Plan (`Digits.swift`)

**Component:** `Sources/Parsing/ParserPrinters/Digits.swift`  
**Repo SHA:** `7160b25d39e4a38258a7fe71591fbe182b026d69`  
**Production SHA-256:** `551333cb817917cdce03362e1949e848cd7245b9d8c1a91257407e3c531157ce`  
**AI SHA-256:** `f5525799b968cb0c7b43c35874b0c9843fa602dad66644be26c47858f39e888d`  

**Suites:** Human `ParsingTests.DigitsTests` (2) · AI `AIGeneratedDigitsTests` (25)  

**Status:** Plan only — **no execution**

```bash
swift test --filter ParsingTests.DigitsTests
swift test --filter AIGeneratedDigitsTests
```
Timeout: 30s.

---

## Mutations E8-M01…E8-M24

| ID | Location | Original | Mutation | Expected defect | Risk |
|---|---|---|---|---|---|
| **E8-M01** | while max | `length < $0` | `length <= $0` | Consumes one past maximum | — |
| **E8-M02** | while max | `length < $0` | `length > $0` | Never enters / wrong max | — |
| **E8-M03** | multiply | `multipliedReportingOverflow(by: 10)` | `by: 2` | Wrong place values | — |
| **E8-M04** | multiply | `by: 10` | `by: 0` | Always zero accumulation | — |
| **E8-M05** | add | `addingReportingOverflow(n)` | `addingReportingOverflow(0)` | Ignores digits | — |
| **E8-M06** | overflow after * | `guard !overflow` | `guard overflow` | Inverts overflow fail | — |
| **E8-M07** | overflow after + | `guard !overflow` (add) | `guard overflow` | Inverts add overflow | — |
| **E8-M08** | length++ | `length += 1` | `length += 2` | Undercounts digits vs max/min | — |
| **E8-M09** | min guard | `length >= minimum` | `length > minimum` | Exact-min fails | — |
| **E8-M10** | min guard | `length >= minimum` | `length < minimum` | Success/fail invert | — |
| **E8-M11** | omit min guard | remove guard/throw | Accept under-min | — |
| **E8-M12** | omit `bytes.removeFirst()` | Input bytes not advanced before unapply | Wrong remainder | — |
| **E8-M13** | digit switch | ascii 0...9 | ascii 1...9 | Rejects `'0'` | — |
| **E8-M14** | digit value | `n - "0"` | `n - "0" + 1` | Off-by-one digit values | — |
| **E8-M15** | return | `return output` | `return length` | Wrong Int result | — |
| **E8-M16** | print zero noop | `minimum != 0 \|\| output != 0` | `minimum != 0 \|\| output == 0` | Wrong zero/min-0 print | — |
| **E8-M17** | print negative | `output >= 0` | `output > 0` | Rejects printing 0 when min>0 path… actually 0 with min>0 pads; `>0` fails zero print | — |
| **E8-M18** | print max | `count > maximum` | `count >= maximum` | Rejects exact-max digit count | — |
| **E8-M19** | print max | `count > maximum` | `count < maximum` | Invert max check | — |
| **E8-M20** | print pad | `minimum - count` | `minimum + count` | Wrong pad / crash risk | possible crash |
| **E8-M21** | print pad | prepend `"0"` | prepend `"1"` | Wrong padding digit | — |
| **E8-M22** | print | omit prepend to input | Print no-op on output path | — |
| **E8-M23** | omit unapply assign | skip `input = unapply(bytes)` | Input not updated | — |
| **E8-M24** | print negative guard | omit negative check | Allows negative print | AI kill likely |

---

## Frozen set

**E8-M01 … E8-M24** (24). File scope: `Digits.swift` only.

**Mutation set frozen.** Proceed to Stage 5.
