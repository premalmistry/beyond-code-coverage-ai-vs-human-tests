// Experiment #7 — AI-generated tests for Prefix.swift
// Generated from production source only. Do not edit after freeze.

import Parsing
import XCTest

final class AIGeneratedPrefixTests: XCTestCase {

  // MARK: - Fixed-length parse

  func testParseExactLengthConsumesAndReturnsPrefix() throws {
    var input = "abcdef"[...]
    let out = try Prefix(3).parse(&input)
    XCTAssertEqual(out, "abc")
    XCTAssertEqual(input, "def")
  }

  func testParseExactLengthEntireInput() throws {
    var input = "xy"[...]
    let out = try Prefix(2).parse(&input)
    XCTAssertEqual(out, "xy")
    XCTAssertEqual(input, "")
  }

  func testParseExactLengthFailsWhenTooShort() {
    var input = "ab"[...]
    XCTAssertThrowsError(try Prefix(3).parse(&input))
    // On failure after consuming attempted prefix, remainder is empty for short input
    XCTAssertEqual(input, "")
  }

  func testParseZeroMinimumAllowsEmpty() throws {
    var input = "hello"[...]
    let out = try Prefix(0).parse(&input)
    XCTAssertEqual(out, "")
    XCTAssertEqual(input, "hello")
  }

  // MARK: - Range length

  func testParseClosedRangeTakesAtMostMaximum() throws {
    var input = "12345xyz"[...]
    let out = try Prefix(2...4).parse(&input)
    XCTAssertEqual(out, "1234")
    XCTAssertEqual(input, "5xyz")
  }

  func testParsePartialRangeFromRequiresMinimum() throws {
    var input = "ab"[...]
    XCTAssertThrowsError(try Prefix(3...).parse(&input))
  }

  func testParsePartialRangeFromSucceedsWithEnough() throws {
    var input = "abcdef"[...]
    let out = try Prefix(3...).parse(&input)
    XCTAssertEqual(out, "abcdef")
    XCTAssertEqual(input, "")
  }

  func testParsePartialRangeThroughCapsAtMaximum() throws {
    var input = "abcdefgh"[...]
    let out = try Prefix(...3).parse(&input)
    XCTAssertEqual(out, "abc")
    XCTAssertEqual(input, "defgh")
  }

  // MARK: - Predicate while

  func testParseWhileDigitsStopsAtNonDigit() throws {
    var input = "123abc"[...]
    let out = try Prefix(while: { $0.isNumber }).parse(&input)
    XCTAssertEqual(out, "123")
    XCTAssertEqual(input, "abc")
  }

  func testParseWhileWithMinimumFailsWhenPredicateStopsEarly() {
    var input = "12ab"[...]
    XCTAssertThrowsError(try Prefix(3...) { $0.isNumber }.parse(&input))
  }

  func testParseWhileWithMinimumSucceeds() throws {
    var input = "9876rest"[...]
    let out = try Prefix(2...5) { $0.isNumber }.parse(&input)
    XCTAssertEqual(out, "9876")
    XCTAssertEqual(input, "rest")
  }

  func testParseWhileAlwaysTrueConsumesAllWhenNoMax() throws {
    var input = "zzzz"[...]
    let out = try Prefix(while: { _ in true }).parse(&input)
    XCTAssertEqual(out, "zzzz")
    XCTAssertEqual(input, "")
  }

  func testParseWhileNeverTrueReturnsEmptyWhenMinZero() throws {
    var input = "abc"[...]
    let out = try Prefix(while: { _ in false }).parse(&input)
    XCTAssertEqual(out, "")
    XCTAssertEqual(input, "abc")
  }

  func testParseWhileNeverTrueFailsWhenMinPositive() {
    var input = "abc"[...]
    XCTAssertThrowsError(try Prefix(1...) { _ in false }.parse(&input))
    XCTAssertEqual(input, "abc")
  }

  // MARK: - Empty input

  func testParseEmptyInputFailsPositiveMinimum() {
    var input = ""[...]
    XCTAssertThrowsError(try Prefix(1).parse(&input))
    XCTAssertEqual(input, "")
  }

  func testParseEmptyInputSucceedsZeroMinimum() throws {
    var input = ""[...]
    let out = try Prefix(0...).parse(&input)
    XCTAssertEqual(out, "")
    XCTAssertEqual(input, "")
  }

  // MARK: - Print (ParserPrinter)

  func testPrintPrependsOutputToInput() throws {
    var input = " World"[...]
    try Prefix(5).print("Hello"[...], into: &input)
    XCTAssertEqual(input, "Hello World")
  }

  func testPrintFailsWhenOutputShorterThanMinimum() {
    var input = ""[...]
    XCTAssertThrowsError(try Prefix(3).print("ab"[...], into: &input))
    XCTAssertEqual(input, "")
  }

  func testPrintFailsWhenOutputLongerThanMaximum() {
    var input = ""[...]
    XCTAssertThrowsError(try Prefix(...2).print("abcd"[...], into: &input))
  }

  func testPrintFailsWhenPredicateNotSatisfied() {
    var input = ""[...]
    XCTAssertThrowsError(
      try Prefix(while: { $0.isNumber }).print("12a3"[...], into: &input)
    )
  }

  func testPrintSucceedsWhenAllElementsSatisfyPredicate() throws {
    var input = "!"[...]
    try Prefix(while: { $0.isNumber }).print("42"[...], into: &input)
    XCTAssertEqual(input, "42!")
  }

  func testPrintFailsWhenNextInputElementWouldAlsoMatchPredicateWithoutMax() {
    var input = "9more"[...]
    XCTAssertThrowsError(
      try Prefix(while: { $0.isNumber }).print("12"[...], into: &input)
    )
  }

  func testPrintWithExactMaximumAllowsMatchingNextElement() throws {
    // When count == maximum, next-element predicate check is skipped.
    var input = "9tail"[...]
    try Prefix(2) { $0.isNumber }.print("12"[...], into: &input)
    XCTAssertEqual(input, "129tail")
  }

  func testPrintExactLengthRoundTrip() throws {
    let parser: Prefix<Substring> = Prefix(4)
    var input = "WXYZ____"[...]
    let out = try parser.parse(&input)
    XCTAssertEqual(out, "WXYZ")
    try parser.print(out, into: &input)
    XCTAssertEqual(input, "WXYZ____")
  }

  // MARK: - UTF8View input

  func testParseUTF8ViewPrefix() throws {
    var input = "hello"[...].utf8
    let out = try Prefix(2).parse(&input)
    XCTAssertEqual(Substring(out), "he")
    XCTAssertEqual(Substring(input), "llo")
  }
}
