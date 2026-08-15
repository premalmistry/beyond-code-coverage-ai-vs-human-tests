# Experiment #14 — Mutation Plan (FROZEN)

**Study phase:** CONFIRMATORY  
**Selection method:** PRE-DECLARED NEUTRAL RULE  
**Component:** `Sources/Parsing/Builders/OneOfBuilder.swift`  
**Repo SHA:** `7160b25d39e4a38258a7fe71591fbe182b026d69`  
**Production SHA-256:** `af44508de74348ae4be49bbff0548538eb36793d38ff956eb0424dfb9699a55e`  
**AI suite SHA-256:** `f8749111c158c88eb1083e7053653a2da9e91e5ba118114f007269881f6b232d`  
**Plan date (UTC):** `2026-08-15T17:08:00Z`

Both suites frozen. Plan defined **after** suite freeze and **before** execution.

Mutants: `research/mutants-e14/E14-MXX.swift` (**22** — quality over padding).

---

## Frozen mutant set (summary)

| ID | Theme | Risk |
|---|---|---|
| E14-M01 | OneOf2.parse try-order swap | |
| E14-M02 | OneOf2.parse skip input restore | |
| E14-M03 | OneOf2.parse only p0 | |
| E14-M04 | OneOf2.parse only p1 | |
| E14-M05 | buildExpression → fatalError | crash |
| E14-M06 | OptionalOneOf.parse invert nil guard | |
| E14-M07 | OptionalOneOf.parse always fail | |
| E14-M08 | OptionalOneOf.parse force-unwrap | crash |
| E14-M09 | buildEither first→second | |
| E14-M10 | buildEither second→first | |
| E14-M11 | OneOf2.print try-order swap | |
| E14-M12 | OneOf2.print skip restore | |
| E14-M13 | OneOf2.print only p1 | |
| E14-M14 | OptionalOneOf.print invert nil | |
| E14-M15 | OptionalOneOf.print always fail | |
| E14-M16 | buildPartialBlock → OneOf2(next,next) | |
| E14-M17 | buildPartialBlock swap args | |
| E14-M18 | buildArray → empty | |
| E14-M19 | buildIf always nil | |
| E14-M20 | OptionalOneOf.init always nil | |
| E14-M21 | parse error list drops e0 | possible weak/equiv |
| E14-M22 | print error list order swap | possible weak/equiv |

---

## Execution protocol

```text
Human filter: ParsingTests.OneOfBuilderTests
AI filter:    AIGeneratedOneOfBuilderTests
Timeout:      90s per suite
Order:        Human then AI per mutant; restore ORIG; verify SHA
```

## FREEZE

Do not alter mutants after seeing outcomes.
