//===----------------------------------------------------------------------===//
// AI-generated unit tests for OneOfBuilder.swift (Experiment #14).
// Generated from production API / module surface only.
//===----------------------------------------------------------------------===//

import Parsing
import XCTest

final class AIGeneratedOneOfBuilderTests: XCTestCase {

  // MARK: - Multi-alternative OneOf (buildPartialBlock / OneOf2)

  func testOneOf_firstAlternativeSucceeds() throws {
    let parser = OneOf {
      "cat".map { "animal" }
      "car".map { "vehicle" }
    }
    var input = "cat"[...]
    XCTAssertEqual(try parser.parse(&input), "animal")
    XCTAssertEqual(input, "")
  }

  func testOneOf_secondAlternativeSucceedsAfterFirstFails() throws {
    let parser = OneOf {
      "cat".map { "animal" }
      "car".map { "vehicle" }
    }
    var input = "car"[...]
    XCTAssertEqual(try parser.parse(&input), "vehicle")
    XCTAssertTrue(input.isEmpty)
  }

  func testOneOf_threeAlternativesUsesNestedOneOf2() throws {
    let parser = OneOf {
      "a".map { 1 }
      "b".map { 2 }
      "c".map { 3 }
    }
    XCTAssertEqual(try parser.parse("a"), 1)
    XCTAssertEqual(try parser.parse("b"), 2)
    XCTAssertEqual(try parser.parse("c"), 3)
  }

  func testOneOf_allAlternativesFail() {
    let parser = OneOf {
      "x".map { 1 }
      "y".map { 2 }
    }
    XCTAssertThrowsError(try parser.parse("z"))
  }

  func testOneOf_restoresInputWhenFallingThrough() throws {
    let parser = OneOf {
      "ab".map { "first" }
      "a".map { "second" }
    }
    var input = "a"[...]
    XCTAssertEqual(try parser.parse(&input), "second")
    XCTAssertEqual(input, "")
  }

  // MARK: - buildArray (for-in)

  func testBuildArray_dynamicCases() throws {
    enum Color: String, CaseIterable {
      case red, green, blue
    }
    let parser = OneOf {
      for color in Color.allCases {
        color.rawValue.map { color }
      }
    }
    XCTAssertEqual(try parser.parse("red"), .red)
    XCTAssertEqual(try parser.parse("green"), .green)
    XCTAssertEqual(try parser.parse("blue"), .blue)
    XCTAssertThrowsError(try parser.parse("yellow"))
  }

  // MARK: - buildIf / OptionalOneOf

  func testBuildIf_omittedBranchWhenFalse() {
    let includeAdmin = false
    let parser = OneOf {
      if includeAdmin {
        "admin".map { "admin" }
      }
      "guest".map { "guest" }
    }
    XCTAssertEqual(try? parser.parse("guest"), "guest")
    XCTAssertThrowsError(try parser.parse("admin"))
  }

  func testBuildIf_includedBranchWhenTrue() throws {
    let includeAdmin = true
    let parser = OneOf {
      if includeAdmin {
        "admin".map { "admin" }
      }
      "guest".map { "guest" }
    }
    XCTAssertEqual(try parser.parse("admin"), "admin")
    XCTAssertEqual(try parser.parse("guest"), "guest")
  }

  func testOptionalOneOf_falseBranchSkipped() {
    let onlyOptionalFalse = false
    let p = OneOf {
      if onlyOptionalFalse {
        "never".map { 1 }
      }
      "ok".map { 0 }
    }
    XCTAssertEqual(try? p.parse("ok"), 0)
    XCTAssertThrowsError(try p.parse("never"))
  }

  // MARK: - buildEither (if-else)

  func testBuildEither_trueBranch() throws {
    let useLegacy = true
    let parser = OneOf {
      if useLegacy {
        "legacy".map { "L" }
      } else {
        "modern".map { "M" }
      }
    }
    XCTAssertEqual(try parser.parse("legacy"), "L")
    XCTAssertThrowsError(try parser.parse("modern"))
  }

  func testBuildEither_falseBranch() throws {
    let useLegacy = false
    let parser = OneOf {
      if useLegacy {
        "legacy".map { "L" }
      } else {
        "modern".map { "M" }
      }
    }
    XCTAssertEqual(try parser.parse("modern"), "M")
    XCTAssertThrowsError(try parser.parse("legacy"))
  }

  // MARK: - Empty OneOf / Fail

  func testEmptyOneOf_fails() {
    let parser = OneOf(input: Substring.self, output: Int.self) {}
    XCTAssertThrowsError(try parser.parse("anything"))
  }

  // MARK: - Printing (OneOf2 / OptionalOneOf)

  func testOneOf_printPrefersLaterAlternative() throws {
    let parser = OneOf {
      "one".map { 1 }
      "two".map { 2 }
    }
    XCTAssertEqual(try parser.print(2), "two")
    XCTAssertEqual(try parser.print(1), "one")
  }

  func testOneOf_printThreeAlternatives() throws {
    let parser = OneOf {
      "a".map { 1 }
      "b".map { 2 }
      "c".map { 3 }
    }
    XCTAssertEqual(try parser.print(3), "c")
    XCTAssertEqual(try parser.print(1), "a")
  }

  func testBuildIf_printWhenPresent() throws {
    let include = true
    let parser = OneOf {
      if include {
        "yes".map { true }
      }
      "no".map { false }
    }
    XCTAssertEqual(try parser.print(true), "yes")
    XCTAssertEqual(try parser.print(false), "no")
  }

  func testBuildIf_printWhenAbsentUsesRemaining() throws {
    let include = false
    let parser = OneOf {
      if include {
        "yes".map { true }
      }
      "no".map { false }
    }
    XCTAssertEqual(try parser.print(false), "no")
    XCTAssertThrowsError(try parser.print(true))
  }

  // MARK: - Single-parser OneOf

  func testOneOf_singleParser() throws {
    let parser = OneOf {
      "42".map { 42 }
    }
    XCTAssertEqual(try parser.parse("42"), 42)
  }

  func testOneOf_consumesOnlyMatchedPrefix() throws {
    let parser = OneOf {
      "hi".map { "greeting" }
      "hello".map { "greeting2" }
    }
    var input = "hi there"[...]
    XCTAssertEqual(try parser.parse(&input), "greeting")
    XCTAssertEqual(input, " there")
  }
}
