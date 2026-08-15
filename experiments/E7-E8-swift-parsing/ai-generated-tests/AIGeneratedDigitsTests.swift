// Experiment #8 — AI-generated tests for Digits.swift
// Generated from production source only. Do not edit after freeze.

import Parsing
import XCTest

final class AIGeneratedDigitsTests: XCTestCase {

  // MARK: - Fixed length parse

  func testParseExactFourDigits() throws {
    var input = "20220131"[...].utf8
    XCTAssertEqual(2022, try Digits(4).parse(&input))
    XCTAssertEqual("0131", String(Substring(input)))
  }

  func testParseExactTwoDigitsThenRemainder() throws {
    var input = "09abc"[...].utf8
    XCTAssertEqual(9, try Digits(2).parse(&input))
    XCTAssertEqual("abc", String(Substring(input)))
  }

  func testParseExactFailsWhenTooFewDigits() {
    var input = "12"[...].utf8
    XCTAssertThrowsError(try Digits(4).parse(&input))
  }

  func testParseExactStopsAtNonDigit() {
    var input = "12x34"[...].utf8
    XCTAssertThrowsError(try Digits(4).parse(&input))
  }

  // MARK: - Range lengths

  func testParseAtLeastSucceedsWithEnough() throws {
    var input = "98765rest"[...].utf8
    XCTAssertEqual(98765, try Digits(3...).parse(&input))
    XCTAssertEqual("rest", String(Substring(input)))
  }

  func testParseAtLeastFailsWhenShort() {
    var input = "12"[...].utf8
    XCTAssertThrowsError(try Digits(3...).parse(&input))
  }

  func testParseClosedRangeCapsAtMaximum() throws {
    var input = "123456"[...].utf8
    XCTAssertEqual(1234, try Digits(2...4).parse(&input))
    XCTAssertEqual("56", String(Substring(input)))
  }

  func testParseDefaultDigitsRequiresAtLeastOne() {
    var input = "abc"[...].utf8
    XCTAssertThrowsError(try Digits().parse(&input))
  }

  func testParseDefaultDigitsConsumesRun() throws {
    var input = "42xyz"[...].utf8
    XCTAssertEqual(42, try Digits().parse(&input))
    XCTAssertEqual("xyz", String(Substring(input)))
  }

  // MARK: - Zero minimum

  func testParseZeroMinimumOnNonDigitLeavesInputAndReturnsZero() throws {
    var utf8 = "."[...].utf8
    XCTAssertEqual(0, try Digits(0...).parse(&utf8))
    XCTAssertEqual(".", String(Substring(utf8)))
  }

  func testParseZeroMinimumConsumesDigitRun() throws {
    var input = "007"[...].utf8
    XCTAssertEqual(7, try Digits(0...).parse(&input))
    XCTAssertEqual("", String(Substring(input)))
  }

  func testParseLeadingZerosAccumulateValue() throws {
    var input = "00042"[...].utf8
    XCTAssertEqual(42, try Digits(5).parse(&input))
    XCTAssertEqual("", String(Substring(input)))
  }

  // MARK: - Overflow

  func testParseOverflowThrows() {
    // Int.max is 19 digits on 64-bit; append another digit to force overflow
    let huge = String(repeating: "9", count: 40)
    var input = huge[...].utf8
    XCTAssertThrowsError(try Digits().parse(&input))
  }

  // MARK: - Substring convenience

  func testParseSubstringOverload() throws {
    var input = "3141pi"[...]
    XCTAssertEqual(3141, try Digits().parse(&input))
    XCTAssertEqual("pi", input)
  }

  func testParseSubstringFixedLength() throws {
    var input = "2024-01"[...]
    XCTAssertEqual(2024, try Digits(4).parse(&input))
    XCTAssertEqual("-01", input)
  }

  // MARK: - Print

  func testPrintZeroWithDefault() throws {
    XCTAssertEqual("0", try Digits().print(0))
  }

  func testPrintZeroWithPositiveMinimumPads() throws {
    XCTAssertEqual("000", try Digits(3).print(0))
  }

  func testPrintPadsToMinimum() throws {
    XCTAssertEqual("007", try Digits(3).print(7))
  }

  func testPrintExactNoPadWhenWideEnough() throws {
    XCTAssertEqual("42", try Digits(2).print(42))
  }

  func testPrintFailsWhenExceedsMaximum() {
    XCTAssertThrowsError(try Digits(2).print(100) as Substring)
  }

  func testPrintFailsOnNegative() {
    XCTAssertThrowsError(try Digits().print(-1) as Substring)
  }

  func testPrintZeroMinimumAndZeroIsNoOp() throws {
    // guard minimum != 0 || output != 0 else { return }
    var input = "tail"[...]
    try Digits(0...).print(0, into: &input)
    XCTAssertEqual("tail", input)
  }

  func testPrintIntoPrepends() throws {
    var input = "xyz"[...]
    try Digits(2).print(7, into: &input)
    XCTAssertEqual("07xyz", input)
  }

  // MARK: - Round trip

  func testRoundTripFixedLength() throws {
    var input = "2024rest"[...]
    let value = try Digits(4).parse(&input)
    XCTAssertEqual(2024, value)
    XCTAssertEqual("rest", input)
    try Digits(4).print(value, into: &input)
    XCTAssertEqual("2024rest", input)
  }

  func testEmptyInputFailsPositiveMinimum() {
    var input = ""[...].utf8
    XCTAssertThrowsError(try Digits(1).parse(&input))
  }
}
