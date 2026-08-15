# Experiment #7 — Mutation Plan (`Prefix.swift`)

**Component:** `Sources/Parsing/ParserPrinters/Prefix.swift`  
**Repo SHA:** `7160b25d39e4a38258a7fe71591fbe182b026d69`  
**Production SHA-256:** `da91af08f8fcf2116542fd1d423d1e1322312a15ba135de83a4085358f4159e6`  
**AI SHA-256:** `a0fc2c7ab3db3346e39497e73f9804098a92ae8a41ef37188975364005255b03`  

**Suites (frozen):**  
- Human: `ParsingTests.PrefixTests` (13)  
- AI: `AIGeneratedPrefixTests` (25)  

**Status:** Plan only — **no execution yet**

| Label | Meaning |
|---|---|
| Both kill | Both suites fail/crash |
| AI kill | AI likely; Human may miss |
| Possibly survives | Possible equivalent / weak |

```bash
swift test --filter ParsingTests.PrefixTests
swift test --filter AIGeneratedPrefixTests
```
Timeout: 30s.

---

## Proposed mutations (E7-M01…E7-M24)

| ID | Location | Original | Mutation | Expected defect | H pred | AI pred | Risk |
|---|---|---|---|---|---|---|---|
| **E7-M01** | parse L102 | `maximum.map(input.prefix) ?? input` | always `input` (ignore max) | Consumes past maximum | Both kill | Both kill | — |
| **E7-M02** | parse L103 | apply `prefix(while:)` when predicate | skip predicate (`prefix` unchanged) | Consumes past predicate stop | Both kill | Both kill | — |
| **E7-M03** | parse L105 | `removeFirst(count)` | `removeFirst(0)` | Input not consumed | Both kill | Both kill | — |
| **E7-M04** | parse L105 | `removeFirst(count)` | `removeFirst(max(0, count - 1))` | Off-by-one remainder | Both kill | Both kill | — |
| **E7-M05** | parse L106 | `count >= minimum` | `count > minimum` | Exact-min succeeds wrongly fails | Both kill | Both kill | — |
| **E7-M06** | parse L106 | `count >= minimum` | `count < minimum` | Success/failure inverted | Both kill | Both kill | — |
| **E7-M07** | parse L116 | `return prefix` | `return input` | Returns remainder not prefix | Both kill | Both kill | — |
| **E7-M08** | parse | removeFirst then guard | **swap:** guard before removeFirst using same count | On failure input unrestored / wrong | Both kill | Both kill | — |
| **E7-M09** | parse L102 | `maximum.map(input.prefix) ?? input` | `input.prefix(minimum)` always | Wrong length selection | Both kill | Both kill | — |
| **E7-M10** | while-init L94 | `minimum = 0` | `minimum = 1` | Empty while-match fails | Both kill | Both kill | — |
| **E7-M11** | print L124 | `count >= minimum` | `count > minimum` | Exact-min print fails | Both kill | Both kill | — |
| **E7-M12** | print L124 | `count >= minimum` | `count < minimum` | Min check inverted | Both kill | Both kill | — |
| **E7-M13** | print L139 | `count <= maximum` | `count < maximum` | Exact-max print fails | Both kill | Both kill | — |
| **E7-M14** | print L139 | `count <= maximum` | `count > maximum` | Max check inverted | Both kill | Both kill | — |
| **E7-M15** | print L154 | `output.allSatisfy(predicate)` | `!output.allSatisfy(predicate)` | Predicate polarity inverted | Both kill | Both kill | — |
| **E7-M16** | print L168 | `count != maximum` | `count == maximum` | Next-element check when max hit | Both kill | Both kill | — |
| **E7-M17** | print L169 | `!= true` | `== true` | Next-element round-trip polarity | Both kill | Both kill | — |
| **E7-M18** | print L185 | `input.prepend(contentsOf: output)` | omit prepend | Print does not write | Both kill | Both kill | — |
| **E7-M19** | print | omit entire `if let maximum` block | skip max validation | Accepts too-long print | AI kill | Both kill | Human may miss |
| **E7-M20** | print | omit `allSatisfy` guard (keep next-elem) | skip element predicate | Prints invalid elements | Both kill | Both kill | — |
| **E7-M21** | parse L103 | always `prefix.prefix(while: { _ in true })` | ignore real predicate | Consumes max regardless of pred | Both kill | Both kill | — |
| **E7-M22** | parse | `guard count >= minimum else { throw }; return prefix` | always `return prefix` (no min check) | Accepts under-min | Both kill | Both kill | — |
| **E7-M23** | while-init L95 | `maximum = nil` | `maximum = 0` | While-prefix never consumes | Both kill | Both kill | — |
| **E7-M24** | print L168–183 | omit next-element `if count != maximum` block | skip upstream check | Allows matching next elem | Possibly survives | Both kill | Human has dedicated test |

---

## Frozen set

**E7-M01 … E7-M24** (24 mutants). All in `Prefix.swift`. No suite edits after results.

**Mutation set frozen.** Proceed to Stage 5.
