//===----------------------------------------------------------------------===//
// Experiment #5 — AI-generated tests for Combinations.swift
// Generated from production source only. Do not edit after freeze.
//===----------------------------------------------------------------------===//

import Algorithms
import XCTest

final class AIGeneratedCombinationsTests: XCTestCase {

  // MARK: - Fixed k enumeration

  func testCombinationsOfCountZeroProducesSingleEmpty() {
    let empty: [Int] = []
    XCTAssertEqual(Array(empty.combinations(ofCount: 0)), [[]])

    let nums = [1, 2, 3]
    XCTAssertEqual(Array(nums.combinations(ofCount: 0)), [[]])
  }

  func testCombinationsOfCountOneYieldsSingletonsInOrder() {
    let letters = Array("WXYZ")
    let combos = Array(letters.combinations(ofCount: 1))
    XCTAssertEqual(combos, [["W"], ["X"], ["Y"], ["Z"]])
    XCTAssertEqual(combos.count, 4)
  }

  func testCombinationsOfCountTwoLexicographicOrder() {
    let base = [10, 20, 30, 40]
    let combos = Array(base.combinations(ofCount: 2))
    XCTAssertEqual(
      combos,
      [
        [10, 20], [10, 30], [10, 40],
        [20, 30], [20, 40],
        [30, 40],
      ])
  }

  func testCombinationsOfCountThreeAndFullSet() {
    let base = ["a", "b", "c", "d"]
    XCTAssertEqual(
      Array(base.combinations(ofCount: 3)),
      [
        ["a", "b", "c"],
        ["a", "b", "d"],
        ["a", "c", "d"],
        ["b", "c", "d"],
      ])
    XCTAssertEqual(Array(base.combinations(ofCount: 4)), [["a", "b", "c", "d"]])
  }

  func testCombinationsOfCountEqualToBaseCount() {
    let base = [7, 8]
    XCTAssertEqual(Array(base.combinations(ofCount: 2)), [[7, 8]])
    XCTAssertEqual(base.combinations(ofCount: 2).count, 1)
  }

  func testCombinationsOfCountExceedingBaseIsEmpty() {
    let base = [1, 2, 3]
    XCTAssertTrue(Array(base.combinations(ofCount: 4)).isEmpty)
    XCTAssertEqual(base.combinations(ofCount: 4).count, 0)
    XCTAssertTrue(Array([Int]().combinations(ofCount: 1)).isEmpty)
  }

  // MARK: - Count / underestimatedCount

  func testCountMatchesEnumeratedLengthForFixedK() {
    let base = Array(0..<6)
    for k in 0...6 {
      let seq = base.combinations(ofCount: k)
      let enumerated = Array(seq)
      XCTAssertEqual(seq.count, enumerated.count, "k=\(k)")
      XCTAssertEqual(seq.underestimatedCount, seq.count, "k=\(k)")
    }
  }

  func testCountBinomialValues() {
    // C(5,0)=1, C(5,1)=5, C(5,2)=10, C(5,3)=10, C(5,4)=5, C(5,5)=1
    let base = [1, 2, 3, 4, 5]
    XCTAssertEqual(base.combinations(ofCount: 0).count, 1)
    XCTAssertEqual(base.combinations(ofCount: 1).count, 5)
    XCTAssertEqual(base.combinations(ofCount: 2).count, 10)
    XCTAssertEqual(base.combinations(ofCount: 3).count, 10)
    XCTAssertEqual(base.combinations(ofCount: 4).count, 5)
    XCTAssertEqual(base.combinations(ofCount: 5).count, 1)
  }

  func testCountFullPowerSetViaClosedRange() {
    let base = [0, 1, 2, 3]
    // all sizes 0...4 → 2^4 = 16
    XCTAssertEqual(base.combinations(ofCount: 0...).count, 16)
    XCTAssertEqual(base.combinations(ofCount: 0...4).count, 16)
    XCTAssertEqual(Array(base.combinations(ofCount: 0...)).count, 16)
  }

  func testCountPartialRanges() {
    let base = Array("PQRS")
    // C(4,1)+C(4,2)=4+6=10
    XCTAssertEqual(base.combinations(ofCount: 1...2).count, 10)
    // C(4,2)+C(4,3)+C(4,4)=6+4+1=11
    XCTAssertEqual(base.combinations(ofCount: 2...4).count, 11)
    // ...2 → C(4,0)+C(4,1)+C(4,2)=1+4+6=11
    XCTAssertEqual(base.combinations(ofCount: ...2).count, 11)
    // 3... → C(4,3)+C(4,4)=4+1=5
    XCTAssertEqual(base.combinations(ofCount: 3...).count, 5)
  }

  func testCountWhenRangeExceedsBaseClamps() {
    let base = [9, 8, 7]
    // 2...10 clamps to 2..<4 → C(3,2)+C(3,3)=3+1=4
    XCTAssertEqual(base.combinations(ofCount: 2...10).count, 4)
    // 3...10 clamps to 3..<4 → C(3,3)=1
    XCTAssertEqual(base.combinations(ofCount: 3...10).count, 1)
    // entirely above n → empty
    XCTAssertEqual(base.combinations(ofCount: 4...10).count, 0)
    XCTAssertTrue(Array(base.combinations(ofCount: 4...10)).isEmpty)
  }

  func testCountUnderestimatedCountAlwaysAgree() {
    let base = Array(1...5)
    let ranges: [AnyRange] = [
      AnyRange(0...0),
      AnyRange(1...3),
      AnyRange(0...),
      AnyRange(...2),
      AnyRange(2...),
      AnyRange(5...20),
    ]
    for r in ranges {
      let seq = r.apply(base)
      XCTAssertEqual(seq.count, seq.underestimatedCount)
      XCTAssertEqual(seq.count, Array(seq).count)
    }
  }

  // MARK: - Range enumeration order

  func testRangeEnumerationSmallestKFirst() {
    let base = [1, 2, 3]
    let combos = Array(base.combinations(ofCount: 1...2))
    XCTAssertEqual(
      combos,
      [
        [1], [2], [3],
        [1, 2], [1, 3], [2, 3],
      ])
  }

  func testOpenEndedLowerBoundRange() {
    let base = Array("AB")
    XCTAssertEqual(
      Array(base.combinations(ofCount: 1...)).map { String($0) },
      ["A", "B", "AB"])
    XCTAssertEqual(
      Array(base.combinations(ofCount: 0...)).map { String($0) },
      ["", "A", "B", "AB"])
  }

  func testPartialThroughUpperBoundRange() {
    let base = [5, 6, 7]
    XCTAssertEqual(
      Array(base.combinations(ofCount: ...1)),
      [[], [5], [6], [7]])
  }

  func testExactClosedRangeMatchesFixedKUnion() {
    let base = [0, 1, 2, 3]
    let ranged = Array(base.combinations(ofCount: 2...3))
    let fixed =
      Array(base.combinations(ofCount: 2)) + Array(base.combinations(ofCount: 3))
    XCTAssertEqual(ranged, fixed)
  }

  // MARK: - Element / base edge cases

  func testSingleElementBase() {
    let base = [42]
    XCTAssertEqual(Array(base.combinations(ofCount: 0)), [[]])
    XCTAssertEqual(Array(base.combinations(ofCount: 1)), [[42]])
    XCTAssertTrue(Array(base.combinations(ofCount: 2)).isEmpty)
    XCTAssertEqual(Array(base.combinations(ofCount: 0...1)), [[], [42]])
  }

  func testDuplicateElementsPreserveIndexIdentity() {
    // Combinations are by index, so duplicate values still yield multiple combos.
    let base = [1, 1, 2]
    let combos = Array(base.combinations(ofCount: 2))
    XCTAssertEqual(combos.count, 3)
    XCTAssertEqual(combos, [[1, 1], [1, 2], [1, 2]])
  }

  func testStringBasePreservesCharacters() {
    let s = "cat"
    XCTAssertEqual(
      Array(s.combinations(ofCount: 2)).map { String($0) },
      ["ca", "ct", "at"])
  }

  func testEachCombinationLengthEqualsK() {
    let base = Array(0..<7)
    for k in 1...5 {
      for combo in base.combinations(ofCount: k) {
        XCTAssertEqual(combo.count, k)
      }
    }
  }

  func testCombinationsAreStrictlyIncreasingIndices() {
    let base = Array(0..<6)
    for combo in base.combinations(ofCount: 3) {
      XCTAssertEqual(combo, combo.sorted())
      XCTAssertEqual(Set(combo).count, combo.count)
    }
  }

  // MARK: - Iterator / repeated consumption

  func testFreshIteratorYieldsFullSequenceAgain() {
    let seq = [1, 2, 3, 4].combinations(ofCount: 2)
    let first = Array(seq)
    let second = Array(seq)
    XCTAssertEqual(first, second)
    XCTAssertEqual(first.count, 6)
  }

  func testManualIteratorExhaustion() {
    var it = [9, 8, 7].combinations(ofCount: 2).makeIterator()
    var seen: [[Int]] = []
    while let next = it.next() {
      seen.append(next)
    }
    XCTAssertEqual(seen, [[9, 8], [9, 7], [8, 7]])
    XCTAssertNil(it.next())
  }

  // MARK: - Lazy

  func testLazyCombinationsRemainLazySequence() {
    requireLazySequence([1, 2, 3].lazy.combinations(ofCount: 2))
    requireLazySequence([1, 2, 3].lazy.combinations(ofCount: 0...2))
    requireLazySequence([1, 2, 3].lazy.combinations(ofCount: 1...))
    requireLazySequence([1, 2, 3].lazy.combinations(ofCount: ...1))
  }

  func testLazyEnumerationMatchesEager() {
    let base = [4, 5, 6, 7]
    let eager = Array(base.combinations(ofCount: 2))
    let lazy = Array(base.lazy.combinations(ofCount: 2))
    XCTAssertEqual(eager, lazy)
  }

  // MARK: - Invariants across APIs

  func testEmptyRangeAfterClampProducesZeroCountAndEmptyArray() {
    let base = [1, 2]
    let seq = base.combinations(ofCount: 5...8)
    XCTAssertEqual(seq.count, 0)
    XCTAssertEqual(seq.underestimatedCount, 0)
    XCTAssertEqual(Array(seq), [])
  }

  func testZeroOnlyRange() {
    let base = [1, 2, 3, 4]
    let seq = base.combinations(ofCount: 0...0)
    XCTAssertEqual(seq.count, 1)
    XCTAssertEqual(Array(seq), [[]])
  }
}

/// Type-erased helper so one test can apply several range expression forms.
private struct AnyRange {
  private let _apply: ([Int]) -> CombinationsSequence<[Int]>

  init<R: RangeExpression>(_ range: R) where R.Bound == Int {
    _apply = { $0.combinations(ofCount: range) }
  }

  func apply(_ base: [Int]) -> CombinationsSequence<[Int]> {
    _apply(base)
  }
}
