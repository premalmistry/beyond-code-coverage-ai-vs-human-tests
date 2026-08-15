//===----------------------------------------------------------------------===//
// AI-generated unit tests for AdjacentPairs.swift (Experiment #13).
// Generated from production API / module surface only.
//===----------------------------------------------------------------------===//

import Algorithms
import XCTest

final class AIGeneratedAdjacentPairsTests: XCTestCase {

  private func pairs<S: Sequence>(_ s: S) -> [(S.Element, S.Element)]
  where S.Element: Equatable {
    Array(s.adjacentPairs())
  }

  // MARK: - Sequence.adjacentPairs()

  func testSequence_emptyYieldsNoPairs() {
    let result = pairs((0..<0))
    XCTAssertEqual(result.count, 0)
  }

  func testSequence_singleElementYieldsNoPairs() {
    XCTAssertEqual(pairs([42]).count, 0)
  }

  func testSequence_twoElementsOnePair() {
    XCTAssertEqual(pairs([1, 2]).map { [$0.0, $0.1] }, [[1, 2]])
  }

  func testSequence_threeElementsTwoOverlappingPairs() {
    let result = pairs([10, 20, 30])
    XCTAssertEqual(result.count, 2)
    XCTAssertEqual(result[0].0, 10)
    XCTAssertEqual(result[0].1, 20)
    XCTAssertEqual(result[1].0, 20)
    XCTAssertEqual(result[1].1, 30)
  }

  func testSequence_stringCharacters() {
    let result = pairs(Array("abcd"))
    XCTAssertEqual(result.map { "\($0.0)\($0.1)" }, ["ab", "bc", "cd"])
  }

  func testSequence_underestimatedCount() {
    let base = [1, 2, 3, 4, 5]
    XCTAssertEqual(base.adjacentPairs().underestimatedCount, 4)
    XCTAssertEqual([1].adjacentPairs().underestimatedCount, 0)
    XCTAssertEqual([Int]().adjacentPairs().underestimatedCount, 0)
  }

  func testSequence_makeIteratorConsumesOverlapping() {
    var it = [7, 8, 9].adjacentPairs().makeIterator()
    XCTAssertEqual(it.next()?.0, 7)
    XCTAssertEqual(it.next()?.1, 9)
    XCTAssertNil(it.next())
  }

  // MARK: - Collection.adjacentPairs()

  func testCollection_emptyStartEqualsEnd() {
    let c = (0..<0).adjacentPairs()
    XCTAssertEqual(c.startIndex, c.endIndex)
    XCTAssertEqual(c.count, 0)
    XCTAssertTrue(c.isEmpty)
  }

  func testCollection_singleElementEmptyPairs() {
    let c = (0..<1).adjacentPairs()
    XCTAssertEqual(c.startIndex, c.endIndex)
    XCTAssertEqual(c.count, 0)
  }

  func testCollection_countIsBaseMinusOne() {
    XCTAssertEqual((0..<5).adjacentPairs().count, 4)
    XCTAssertEqual((0..<2).adjacentPairs().count, 1)
    XCTAssertEqual([10, 11, 12, 13].adjacentPairs().count, 3)
  }

  func testCollection_subscriptReturnsAdjacentElements() {
    let c = [100, 200, 300, 400].adjacentPairs()
    var i = c.startIndex
    XCTAssertEqual(c[i].0, 100)
    XCTAssertEqual(c[i].1, 200)
    i = c.index(after: i)
    XCTAssertEqual(c[i].0, 200)
    XCTAssertEqual(c[i].1, 300)
    i = c.index(after: i)
    XCTAssertEqual(c[i].0, 300)
    XCTAssertEqual(c[i].1, 400)
    i = c.index(after: i)
    XCTAssertEqual(i, c.endIndex)
  }

  func testCollection_indexAfterAdvancesByOnePair() {
    let c = (0..<4).adjacentPairs()
    let i0 = c.startIndex
    let i1 = c.index(after: i0)
    let i2 = c.index(after: i1)
    let i3 = c.index(after: i2)
    XCTAssertLessThan(i0, i1)
    XCTAssertLessThan(i1, i2)
    XCTAssertEqual(i3, c.endIndex)
    XCTAssertEqual(c.distance(from: i0, to: i2), 2)
  }

  func testCollection_indexBeforeRoundTrips() {
    let c = (0..<6).adjacentPairs()
    let mid = c.index(c.startIndex, offsetBy: 2)
    let back = c.index(before: mid)
    let forth = c.index(after: back)
    XCTAssertEqual(mid, forth)
    XCTAssertEqual(c[back].0, 1)
    XCTAssertEqual(c[back].1, 2)
  }

  func testCollection_indexBeforeEndIndex() {
    let c = (0..<4).adjacentPairs()
    let last = c.index(before: c.endIndex)
    XCTAssertEqual(c[last].0, 2)
    XCTAssertEqual(c[last].1, 3)
  }

  func testCollection_offsetByPositiveAndNegative() {
    let c = Array(0..<10).adjacentPairs()
    let i = c.index(c.startIndex, offsetBy: 3)
    XCTAssertEqual(c[i].0, 3)
    XCTAssertEqual(c[i].1, 4)
    let j = c.index(i, offsetBy: -2)
    XCTAssertEqual(c[j].0, 1)
    XCTAssertEqual(c[j].1, 2)
    XCTAssertEqual(c.index(c.startIndex, offsetBy: 0), c.startIndex)
  }

  func testCollection_offsetByLimitedBySucceeds() {
    let c = (0..<8).adjacentPairs()
    let limit = c.index(c.startIndex, offsetBy: 3)
    let reached = c.index(c.startIndex, offsetBy: 2, limitedBy: limit)
    XCTAssertEqual(reached, c.index(c.startIndex, offsetBy: 2))
  }

  func testCollection_offsetByLimitedByFailsPastLimit() {
    let c = (0..<8).adjacentPairs()
    let limit = c.index(c.startIndex, offsetBy: 2)
    let blocked = c.index(c.startIndex, offsetBy: 5, limitedBy: limit)
    XCTAssertNil(blocked)
  }

  func testCollection_offsetByLimitedByZeroDistance() {
    let c = (0..<5).adjacentPairs()
    let i = c.index(c.startIndex, offsetBy: 1)
    XCTAssertEqual(c.index(i, offsetBy: 0, limitedBy: c.endIndex), i)
  }

  func testCollection_offsetByLimitedBySameAsLimitReturnsNil() {
    let c = (0..<5).adjacentPairs()
    let i = c.index(c.startIndex, offsetBy: 1)
    XCTAssertNil(c.index(i, offsetBy: 1, limitedBy: i))
  }

  func testCollection_distanceMatchesCountAcrossFullRange() {
    let c = (0..<7).adjacentPairs()
    XCTAssertEqual(c.distance(from: c.startIndex, to: c.endIndex), c.count)
    XCTAssertEqual(c.distance(from: c.endIndex, to: c.startIndex), -c.count)
  }

  func testCollection_reversedPairsViaBidirectional() {
    let c = [1, 2, 3, 4].adjacentPairs()
    var idx = c.endIndex
    var collected: [(Int, Int)] = []
    while idx != c.startIndex {
      idx = c.index(before: idx)
      collected.append(c[idx])
    }
    XCTAssertEqual(collected.map(\.0), [3, 2, 1])
    XCTAssertEqual(collected.map(\.1), [4, 3, 2])
  }

  func testCollection_indexEqualityUsesFirstComponent() {
    let c = (0..<5).adjacentPairs()
    let a = c.startIndex
    let b = c.startIndex
    XCTAssertEqual(a, b)
    XCTAssertNotEqual(a, c.index(after: a))
  }

  func testCollection_formArrayEqualsZipShift() {
    let base = Array(0..<12)
    let got = Array(base.adjacentPairs())
    let expected = Array(zip(base, base.dropFirst()))
    XCTAssertEqual(got.count, expected.count)
    for (g, e) in zip(got, expected) {
      XCTAssertEqual(g.0, e.0)
      XCTAssertEqual(g.1, e.1)
    }
  }

  func testLazySequenceStillProducesPairs() {
    let result = Array((0..<5).lazy.adjacentPairs())
    XCTAssertEqual(result.map(\.0), [0, 1, 2, 3])
    XCTAssertEqual(result.map(\.1), [1, 2, 3, 4])
  }

  func testCollection_twoElementsSinglePairIndices() {
    let c = [9, 8].adjacentPairs()
    XCTAssertEqual(c.count, 1)
    XCTAssertEqual(c[c.startIndex].0, 9)
    XCTAssertEqual(c[c.startIndex].1, 8)
    XCTAssertEqual(c.index(after: c.startIndex), c.endIndex)
  }
}
