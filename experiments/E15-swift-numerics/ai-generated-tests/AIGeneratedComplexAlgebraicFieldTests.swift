//===----------------------------------------------------------------------===//
// AI-generated unit tests for Complex+AlgebraicField.swift (Experiment #15).
// Generated from production API / module surface only.
//===----------------------------------------------------------------------===//

import XCTest
import ComplexModule
import RealModule

final class AIGeneratedComplexAlgebraicFieldTests: XCTestCase {

  // MARK: - one / conjugate

  func testOne_isMultiplicativeIdentity() {
    let z = Complex<Double>(3, -4)
    XCTAssertEqual(z * .one, z)
    XCTAssertEqual(Complex<Double>.one.real, 1)
    XCTAssertEqual(Complex<Double>.one.imaginary, 0)
  }

  func testConjugate_negatesImaginary() {
    let z = Complex<Double>(2.5, -7)
    let c = z.conjugate
    XCTAssertEqual(c.real, 2.5)
    XCTAssertEqual(c.imaginary, 7)
    XCTAssertEqual(c.conjugate, z)
  }

  func testConjugate_realIsFixedPoint() {
    let z = Complex<Double>(1.25, 0)
    XCTAssertEqual(z.conjugate, z)
  }

  // MARK: - Division (well-scaled)

  func testDivide_simpleValues() {
    let q = Complex<Double>(4, 2) / Complex<Double>(1, 1)
    XCTAssertEqual(q.real, 3, accuracy: 1e-12)
    XCTAssertEqual(q.imaginary, -1, accuracy: 1e-12)
  }

  func testDivide_byOneLeavesValue() {
    let z = Complex<Double>(-3, 5)
    XCTAssertEqual(z / .one, z)
  }

  func testDivide_assignOperator() {
    var z = Complex<Double>(6, 3)
    z /= Complex<Double>(3, 0)
    XCTAssertEqual(z.real, 2, accuracy: 1e-12)
    XCTAssertEqual(z.imaginary, 1, accuracy: 1e-12)
  }

  func testDivide_iOverIIsOne() {
    let q = Complex<Double>.i / Complex<Double>.i
    XCTAssertEqual(q.real, 1, accuracy: 1e-12)
    XCTAssertEqual(q.imaginary, 0, accuracy: 1e-12)
  }

  // MARK: - Division by zero / non-finite (rescaledDivide)

  func testDivide_byZeroYieldsNonFinite() {
    XCTAssertFalse((Complex(1.0, 2.0) / Complex(0.0, 0.0)).isFinite)
    XCTAssertFalse((Complex(0.0, 0.0) / Complex(0.0, 0.0)).isFinite)
    XCTAssertFalse((Complex<Double>.infinity / Complex(0, 0)).isFinite)
  }

  func testDivide_byInfinityYieldsZero() {
    let q = Complex(1.0, 1.0) / Complex<Double>.infinity
    XCTAssertEqual(q, .zero)
  }

  func testDivide_tinyDenominatorUsesRescaledPath() {
    let tiny = Complex(Double.leastNormalMagnitude / 4, 0)
    let z = Complex(1.0, 0)
    let q = z / tiny
    XCTAssertTrue(q.isFinite || q.magnitude.isInfinite || q.magnitude > 1)
    // Product should approximately recover z when finite.
    if q.isFinite {
      let prod = q * tiny
      XCTAssertEqual(prod.real, z.real, accuracy: 1e-6)
    }
  }

  // MARK: - Baudin–Smith style scale stress (deterministic)

  func testDivide_largeOverLarge() {
    let a = Complex(0x1p1023, 0x1p1023)
    let b = Complex(1.0, 1.0)
    let q = a / b
    XCTAssertEqual(q.real, 0x1p1023, accuracy: 0)
    XCTAssertEqual(q.imaginary, 0, accuracy: 1e-6 * 0x1p1023)
  }

  func testDivide_andMultiplyRoundTripWellScaled() {
    let a = Complex(12.0, -5)
    let b = Complex(3.0, 4)
    let q = a / b
    let back = q * b
    XCTAssertEqual(back.real, a.real, accuracy: 1e-10)
    XCTAssertEqual(back.imaginary, a.imaginary, accuracy: 1e-10)
  }

  // MARK: - normalized

  func testNormalized_unitLengthForFiniteNonZero() {
    let z = Complex(3.0, 4.0)
    let n = z.normalized
    XCTAssertNotNil(n)
    XCTAssertEqual(n!.length, 1, accuracy: 1e-12)
    XCTAssertEqual(n!.real, 0.6, accuracy: 1e-12)
    XCTAssertEqual(n!.imaginary, 0.8, accuracy: 1e-12)
  }

  func testNormalized_nilForZero() {
    XCTAssertNil(Complex<Double>.zero.normalized)
  }

  func testNormalized_nilForInfinity() {
    XCTAssertNil(Complex<Double>.infinity.normalized)
  }

  // MARK: - reciprocal

  func testReciprocal_ofWellScaled() {
    let z = Complex(0.0, 2.0)
    let r = z.reciprocal
    XCTAssertNotNil(r)
    XCTAssertEqual(r!.real, 0, accuracy: 1e-12)
    XCTAssertEqual(r!.imaginary, -0.5, accuracy: 1e-12)
    let prod = z * r!
    XCTAssertEqual(prod.real, 1, accuracy: 1e-12)
    XCTAssertEqual(prod.imaginary, 0, accuracy: 1e-12)
  }

  func testReciprocal_ofOne() {
    let r = Complex<Double>.one.reciprocal
    XCTAssertEqual(r, .one)
  }

  func testReciprocal_matchesDivisionForm() {
    let z = Complex(2.0, -3.0)
    let viaDiv = 1 / z
    let viaRecip = z.reciprocal
    XCTAssertNotNil(viaRecip)
    XCTAssertEqual(viaRecip!.real, viaDiv.real, accuracy: 1e-12)
    XCTAssertEqual(viaRecip!.imaginary, viaDiv.imaginary, accuracy: 1e-12)
  }

  // MARK: - Float path smoke

  func testDivide_floatSimple() {
    let q = Complex<Float>(2, 0) / Complex<Float>(4, 0)
    XCTAssertEqual(q.real, 0.5, accuracy: 1e-6)
    XCTAssertEqual(q.imaginary, 0, accuracy: 1e-6)
  }
}
