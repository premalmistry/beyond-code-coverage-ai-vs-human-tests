// Experiment #9 — AI-generated tests for SaturatingArithmetic.swift
// Generated from production source only. Do not edit after freeze.

import IntegerUtilities
import XCTest

final class AIGeneratedSaturatingArithmeticTests: XCTestCase {

  // MARK: - addingWithSaturation

  func testAddSignedNoOverflow() {
    XCTAssertEqual(Int8(40).addingWithSaturation(20), 60)
    XCTAssertEqual(Int8(-40).addingWithSaturation(-20), -60)
    XCTAssertEqual(Int8(-10).addingWithSaturation(25), 15)
  }

  func testAddSignedSaturatesAtMax() {
    XCTAssertEqual(Int8.max.addingWithSaturation(1), Int8.max)
    XCTAssertEqual(Int8(100).addingWithSaturation(100), Int8.max)
    XCTAssertEqual(Int8.max.addingWithSaturation(Int8.max), Int8.max)
  }

  func testAddSignedSaturatesAtMin() {
    XCTAssertEqual(Int8.min.addingWithSaturation(-1), Int8.min)
    XCTAssertEqual(Int8(-100).addingWithSaturation(-100), Int8.min)
    XCTAssertEqual(Int8.min.addingWithSaturation(Int8.min), Int8.min)
  }

  func testAddUnsignedSaturatesAtMax() {
    XCTAssertEqual(UInt8.max.addingWithSaturation(1), UInt8.max)
    XCTAssertEqual(UInt8(200).addingWithSaturation(100), UInt8.max)
  }

  func testAddUnsignedNoOverflow() {
    XCTAssertEqual(UInt8(10).addingWithSaturation(20), 30)
    XCTAssertEqual(UInt8(0).addingWithSaturation(0), 0)
  }

  // MARK: - subtractingWithSaturation

  func testSubSignedNoOverflow() {
    XCTAssertEqual(Int8(50).subtractingWithSaturation(20), 30)
    XCTAssertEqual(Int8(-10).subtractingWithSaturation(-30), 20)
  }

  func testSubSignedSaturatesAtMin() {
    XCTAssertEqual(Int8.min.subtractingWithSaturation(1), Int8.min)
    XCTAssertEqual(Int8(-100).subtractingWithSaturation(100), Int8.min)
  }

  func testSubSignedSaturatesAtMax() {
    XCTAssertEqual(Int8.max.subtractingWithSaturation(-1), Int8.max)
    XCTAssertEqual(Int8(100).subtractingWithSaturation(-100), Int8.max)
  }

  func testSubUnsignedSaturatesAtZero() {
    XCTAssertEqual(UInt8(5).subtractingWithSaturation(10), 0)
    XCTAssertEqual(UInt8.min.subtractingWithSaturation(1), 0)
    XCTAssertEqual(UInt8(0).subtractingWithSaturation(UInt8.max), 0)
  }

  func testSubUnsignedNoOverflow() {
    XCTAssertEqual(UInt8(50).subtractingWithSaturation(20), 30)
  }

  // MARK: - negatedWithSaturation

  func testNegSignedNormal() {
    XCTAssertEqual(Int8(42).negatedWithSaturation(), -42)
    XCTAssertEqual(Int8(-42).negatedWithSaturation(), 42)
    XCTAssertEqual(Int8(0).negatedWithSaturation(), 0)
  }

  func testNegSignedMinSaturatesToMax() {
    XCTAssertEqual(Int8.min.negatedWithSaturation(), Int8.max)
  }

  func testNegUnsignedAlwaysZero() {
    XCTAssertEqual(UInt8(0).negatedWithSaturation(), 0)
    XCTAssertEqual(UInt8(1).negatedWithSaturation(), 0)
    XCTAssertEqual(UInt8.max.negatedWithSaturation(), 0)
  }

  // MARK: - multipliedWithSaturation

  func testMulSignedNoOverflow() {
    XCTAssertEqual(Int8(7).multipliedWithSaturation(by: 8), 56)
    XCTAssertEqual(Int8(-7).multipliedWithSaturation(by: 8), -56)
    XCTAssertEqual(Int8(-7).multipliedWithSaturation(by: -8), 56)
  }

  func testMulSignedSaturatesPositive() {
    XCTAssertEqual(Int8(16).multipliedWithSaturation(by: 16), Int8.max)
    XCTAssertEqual(Int8(-16).multipliedWithSaturation(by: -16), Int8.max)
  }

  func testMulSignedSaturatesNegative() {
    XCTAssertEqual(Int8(16).multipliedWithSaturation(by: -16), Int8.min)
    XCTAssertEqual(Int8(-16).multipliedWithSaturation(by: 16), Int8.min)
    XCTAssertEqual(Int8.min.multipliedWithSaturation(by: 2), Int8.min)
  }

  func testMulUnsignedSaturatesAtMax() {
    XCTAssertEqual(UInt8(20).multipliedWithSaturation(by: 20), UInt8.max)
    XCTAssertEqual(UInt8.max.multipliedWithSaturation(by: 2), UInt8.max)
  }

  func testMulUnsignedNoOverflow() {
    XCTAssertEqual(UInt8(6).multipliedWithSaturation(by: 7), 42)
    XCTAssertEqual(UInt8(0).multipliedWithSaturation(by: 255), 0)
  }

  // MARK: - shiftedWithSaturation

  func testShiftLeftNoOverflow() {
    XCTAssertEqual(Int8(3).shiftedWithSaturation(leftBy: 2), 12)
    XCTAssertEqual(UInt8(3).shiftedWithSaturation(leftBy: 2), 12)
  }

  func testShiftLeftSaturatesSigned() {
    XCTAssertEqual(Int8(64).shiftedWithSaturation(leftBy: 1), Int8.max)
    XCTAssertEqual(Int8(-64).shiftedWithSaturation(leftBy: 1), Int8.min)
    XCTAssertEqual(Int8(1).shiftedWithSaturation(leftBy: 20), Int8.max)
  }

  func testShiftLeftSaturatesUnsigned() {
    XCTAssertEqual(UInt8(128).shiftedWithSaturation(leftBy: 1), UInt8.max)
    XCTAssertEqual(UInt8(1).shiftedWithSaturation(leftBy: 20), UInt8.max)
  }

  func testShiftByZeroIdentity() {
    XCTAssertEqual(Int8(42).shiftedWithSaturation(leftBy: 0), 42)
    XCTAssertEqual(UInt8(99).shiftedWithSaturation(leftBy: 0), 99)
  }

  func testShiftZeroStaysZeroEvenForLargeCount() {
    XCTAssertEqual(Int8(0).shiftedWithSaturation(leftBy: 100), 0)
    XCTAssertEqual(UInt8(0).shiftedWithSaturation(leftBy: 100), 0)
  }

  func testShiftNegativeCountRightShifts() {
    // Negative leftBy delegates to right shift (with saturation of count).
    XCTAssertEqual(Int8(16).shiftedWithSaturation(leftBy: -1), 8)
    XCTAssertEqual(Int8(16).shiftedWithSaturation(leftBy: -2), 4)
  }

  func testShiftGenericCountClamping() {
    XCTAssertEqual(Int8(1).shiftedWithSaturation(leftBy: Int16(3)), 8)
  }

  // MARK: - Cross-checks vs wider clamping oracle (spot)

  func testAddMatchesClampingOracleSpotChecks() {
    let pairs: [(Int8, Int8)] = [
      (127, 1), (-128, -1), (60, 70), (-60, -70), (0, 0), (127, -128)
    ]
    for (a, b) in pairs {
      let expected = Int8(clamping: Int16(a) + Int16(b))
      XCTAssertEqual(a.addingWithSaturation(b), expected, "\(a)+\(b)")
    }
  }

  func testMulMatchesClampingOracleSpotChecks() {
    let pairs: [(Int8, Int8)] = [
      (16, 16), (-16, -16), (16, -16), (-16, 16), (7, 9), (-128, -1)
    ]
    for (a, b) in pairs {
      let expected = Int8(clamping: Int16(a) * Int16(b))
      XCTAssertEqual(a.multipliedWithSaturation(by: b), expected, "\(a)*\(b)")
    }
  }
}
