// Experiment #10 — AI-generated tests for Polar.swift
// Generated from production source / Complex polar API only. Do not edit after freeze.

import ComplexModule
import RealModule
import XCTest

final class AIGeneratedPolarTests: XCTestCase {

  /// ULP tolerance for finite length/phase round-trips (matches documented
  /// polar accuracy expectations for libm-backed cos/sin/atan2/hypot).
  private let ulpsAllowed: Double = 16

  private func closeEnough<T: Real>(
    _ a: T, _ b: T, ulps allowed: T, relativeTo ref: T = 0
  ) -> Bool {
    if a == b { return true }
    if a.isNaN && b.isNaN { return true }
    // Include `ref` so near-zero residuals (e.g. cos(π/2)) are judged
    // relative to a meaningful magnitude, not only leastNormalMagnitude.
    let scale = max(a.magnitude, b.magnitude, ref.magnitude, T.leastNormalMagnitude).ulp
    return (a - b).magnitude <= allowed * scale
  }

  // MARK: - length / lengthSquared (well-scaled)

  func testLengthOf3_4_5Triangle() {
    let z = Complex(3.0, 4.0)
    XCTAssertEqual(z.lengthSquared, 25.0)
    XCTAssertEqual(z.length, 5.0)
  }

  func testLengthOfUnitAxes() {
    XCTAssertEqual(Complex(1.0, 0.0).length, 1.0)
    XCTAssertEqual(Complex(0.0, 1.0).length, 1.0)
    XCTAssertEqual(Complex(-1.0, 0.0).length, 1.0)
    XCTAssertEqual(Complex(0.0, -1.0).length, 1.0)
  }

  func testLengthOfZeroIsZero() {
    XCTAssertEqual(Complex<Double>.zero.length, .zero)
    XCTAssertEqual(Complex(0.0, -0.0).length, .zero)
  }

  func testLengthOfNonFiniteIsInfinity() {
    XCTAssertEqual(Complex<Double>.infinity.length, .infinity)
    XCTAssertEqual(Complex(Double.infinity, 1.0).length, .infinity)
    XCTAssertEqual(Complex(Double.nan, 0.0).length, .infinity)
  }

  func testLengthAvoidsSpuriousOverflowLikeDocs() {
    // Documented motivation: naive sqrt(x*x+y*y) overflows; length should not.
    let x: Float = 3.0e+20
    let y: Float = 4.0e+20
    let z = Complex(x, y)
    let naive = Float.sqrt(x * x + y * y)
    XCTAssertTrue(naive.isInfinite)
    XCTAssertEqual(z.length, 5.0e+20)
  }

  // MARK: - phase

  func testPhaseQuadrants() {
    XCTAssertTrue(closeEnough(Complex(1.0, 0.0).phase, 0.0, ulps: ulpsAllowed))
    XCTAssertTrue(closeEnough(Complex(0.0, 1.0).phase, Double.pi / 2, ulps: ulpsAllowed))
    XCTAssertTrue(closeEnough(Complex(-1.0, 0.0).phase, Double.pi, ulps: ulpsAllowed))
    XCTAssertTrue(closeEnough(Complex(0.0, -1.0).phase, -Double.pi / 2, ulps: ulpsAllowed))
  }

  func testPhaseOfZeroIsNaN() {
    XCTAssertTrue(Complex<Double>.zero.phase.isNaN)
    XCTAssertTrue(Complex(0.0, -0.0).phase.isNaN)
  }

  func testPhaseOfNonFiniteIsNaN() {
    XCTAssertTrue(Complex<Double>.infinity.phase.isNaN)
    XCTAssertTrue(Complex(Double.nan, 1.0).phase.isNaN)
  }

  // MARK: - polar property

  func testPolarTupleMatchesLengthAndPhase() {
    let z = Complex(3.0, 4.0)
    let p = z.polar
    XCTAssertEqual(p.length, z.length)
    XCTAssertEqual(p.phase, z.phase)
  }

  func testPolarSpecials() {
    let z0 = Complex<Double>.zero.polar
    XCTAssertEqual(z0.length, .zero)
    XCTAssertTrue(z0.phase.isNaN)

    let zInf = Complex<Double>.infinity.polar
    XCTAssertEqual(zInf.length, .infinity)
    XCTAssertTrue(zInf.phase.isNaN)
  }

  // MARK: - init(length:phase:) specials (exact)

  func testInitZeroLengthIgnoresPhase() {
    XCTAssertEqual(Complex(length: Double.zero, phase: .infinity), .zero)
    XCTAssertEqual(Complex(length: Double.zero, phase: -.infinity), .zero)
    XCTAssertEqual(Complex(length: Double.zero, phase: .nan), .zero)
    XCTAssertEqual(Complex(length: 0.0, phase: 1.23), .zero)
  }

  func testInitInfiniteLengthIgnoresPhase() {
    XCTAssertEqual(Complex(length: Double.infinity, phase: .infinity), .infinity)
    XCTAssertEqual(Complex(length: Double.infinity, phase: -.infinity), .infinity)
    XCTAssertEqual(Complex(length: Double.infinity, phase: .nan), .infinity)
    XCTAssertEqual(Complex(length: -Double.infinity, phase: .nan), .infinity)
  }

  func testInitNegativeLengthReflectsThroughOrigin() {
    let r = 2.0
    let theta = Double.pi / 6
    let z = Complex(length: r, phase: theta)
    let w = Complex(length: -r, phase: theta)
    XCTAssertEqual(w, -z)
  }

  // MARK: - init(length:phase:) finite round-trip (tolerance)

  func testInitFiniteRoundTripDeterministic() {
    let cases: [(Double, Double)] = [
      (1.0, 0.0),
      (1.0, .pi / 4),
      (2.5, -.pi / 3),
      (10.0, .pi),
      (0.5, -.pi / 2),
      (7.0, 2.0),
    ]
    for (r, theta) in cases {
      let z = Complex(length: r, phase: theta)
      XCTAssertTrue(
        closeEnough(z.length, r, ulps: ulpsAllowed),
        "length mismatch r=\(r) θ=\(theta) got \(z.length)"
      )
      XCTAssertTrue(
        closeEnough(z.phase, theta, ulps: ulpsAllowed),
        "phase mismatch r=\(r) θ=\(theta) got \(z.phase)"
      )
    }
  }

  func testInitProducesExpectedComponentsOnAxes() {
    let a = Complex(length: 5.0, phase: 0.0)
    XCTAssertTrue(closeEnough(a.real, 5.0, ulps: ulpsAllowed, relativeTo: 5.0))
    XCTAssertTrue(closeEnough(a.imaginary, 0.0, ulps: ulpsAllowed, relativeTo: 5.0))

    let b = Complex(length: 5.0, phase: Double.pi / 2)
    XCTAssertTrue(closeEnough(b.real, 0.0, ulps: ulpsAllowed, relativeTo: 5.0))
    XCTAssertTrue(closeEnough(b.imaginary, 5.0, ulps: ulpsAllowed, relativeTo: 5.0))
  }

  func testLengthSquaredMatchesForNormalProducts() {
    let r = 3.0
    let z = Complex(length: r, phase: 0.7)
    let rr = r * r
    XCTAssertTrue(rr.isNormal)
    XCTAssertTrue(closeEnough(z.lengthSquared, rr, ulps: ulpsAllowed))
  }

  // MARK: - Float smoke

  func testFloatLengthAndPhaseBasics() {
    let z = Complex<Float>(3, 4)
    XCTAssertEqual(z.lengthSquared, 25)
    XCTAssertEqual(z.length, 5)
    XCTAssertTrue(closeEnough(z.phase, Float.atan2(y: 4, x: 3), ulps: Float(ulpsAllowed)))
  }

  func testFloatInitSpecials() {
    XCTAssertEqual(Complex<Float>(length: 0, phase: .nan), .zero)
    XCTAssertEqual(Complex<Float>(length: .infinity, phase: .nan), .infinity)
  }
}
