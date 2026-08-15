//===----------------------------------------------------------------------===//
// Experiment #6 — AI-generated tests for Partition.swift
// Generated from production source only. Do not edit after freeze.
//===----------------------------------------------------------------------===//

import Algorithms
import XCTest

/// Minimal mutable, non-bidirectional collection so `MutableCollection.partition`
/// (half-stable) is selected instead of the Bidirectional overload.
private struct ForwardBox<Element>: MutableCollection {
  var storage: [Element]

  var startIndex: Int { storage.startIndex }
  var endIndex: Int { storage.endIndex }
  func index(after i: Int) -> Int { storage.index(after: i) }

  subscript(position: Int) -> Element {
    get { storage[position] }
    set { storage[position] = newValue }
  }
}

final class AIGeneratedPartitionTests: XCTestCase {

  // MARK: - stablePartition

  func testStablePartitionEmpty() {
    var a: [Int] = []
    let p = a.stablePartition { $0 > 0 }
    XCTAssertEqual(p, a.endIndex)
    XCTAssertEqual(a, [])
  }

  func testStablePartitionSingleElementFalse() {
    var a = [7]
    let p = a.stablePartition { $0 % 2 == 0 }
    XCTAssertEqual(p, a.endIndex)
    XCTAssertEqual(a, [7])
  }

  func testStablePartitionSingleElementTrue() {
    var a = [8]
    let p = a.stablePartition { $0 % 2 == 0 }
    XCTAssertEqual(p, a.startIndex)
    XCTAssertEqual(a, [8])
  }

  func testStablePartitionPreservesRelativeOrder() {
    var a = [1, 2, 3, 4, 5, 6]
    let p = a.stablePartition { $0 % 2 == 0 }
    XCTAssertEqual(Array(a[..<p]), [1, 3, 5])
    XCTAssertEqual(Array(a[p...]), [2, 4, 6])
  }

  func testStablePartitionAllFalse() {
    var a = [1, 3, 5]
    let p = a.stablePartition { $0 % 2 == 0 }
    XCTAssertEqual(p, a.endIndex)
    XCTAssertEqual(a, [1, 3, 5])
  }

  func testStablePartitionAllTrue() {
    var a = [2, 4, 6]
    let p = a.stablePartition { $0 % 2 == 0 }
    XCTAssertEqual(p, a.startIndex)
    XCTAssertEqual(a, [2, 4, 6])
  }

  func testStablePartitionSubrangeOnlyTouchesInterior() {
    var a = [0, 1, 2, 3, 4, 5, 6, 7]
    let sub = 2..<6
    let p = a.stablePartition(subrange: sub, by: { $0 % 2 == 0 })
    XCTAssertEqual(Array(a[..<2]), [0, 1])
    XCTAssertEqual(Array(a[6...]), [6, 7])
    XCTAssertEqual(Array(a[sub.lowerBound..<p]), [3, 5])
    XCTAssertEqual(Array(a[p..<sub.upperBound]), [2, 4])
  }

  func testStablePartitionEmptySubrange() {
    var a = [1, 2, 3]
    let p = a.stablePartition(subrange: 1..<1, by: { $0 > 0 })
    XCTAssertEqual(p, 1)
    XCTAssertEqual(a, [1, 2, 3])
  }

  // MARK: - partition (bidirectional / Array)

  func testBidirectionalPartitionPivotAndMembership() {
    var a = [9, 1, 8, 2, 7, 3]
    let p = a.partition(by: { $0 >= 5 })
    XCTAssertTrue(a[..<p].allSatisfy { $0 < 5 })
    XCTAssertTrue(a[p...].allSatisfy { $0 >= 5 })
  }

  func testBidirectionalPartitionSubrangePreservesOutside() {
    var a = [0, 1, 2, 3, 4, 5]
    let outsidePrefix = Array(a[..<1])
    let outsideSuffix = Array(a[5...])
    let p = a.partition(subrange: 1..<5, by: { $0 % 2 == 0 })
    XCTAssertEqual(Array(a[..<1]), outsidePrefix)
    XCTAssertEqual(Array(a[5...]), outsideSuffix)
    XCTAssertTrue(a[1..<p].allSatisfy { $0 % 2 != 0 })
    XCTAssertTrue(a[p..<5].allSatisfy { $0 % 2 == 0 })
  }

  func testBidirectionalPartitionNoMatchesReturnsUpperBound() {
    var a = [1, 3, 5]
    let p = a.partition(subrange: a.startIndex..<a.endIndex, by: { $0 % 2 == 0 })
    XCTAssertEqual(p, a.endIndex)
  }

  func testBidirectionalPartitionAllMatchReturnsLowerBound() {
    var a = [2, 4, 6]
    let p = a.partition(by: { $0 % 2 == 0 })
    XCTAssertEqual(p, a.startIndex)
  }

  // MARK: - partition (MutableCollection half-stable)

  func testMutableHalfStablePartitionPreservesFirstPartitionOrder() {
    var box = ForwardBox(storage: [1, 2, 3, 4, 5, 6])
    let p = box.partition(subrange: box.startIndex..<box.endIndex) { $0 % 2 == 0 }
    XCTAssertEqual(Array(box.storage[..<p]), [1, 3, 5])
    XCTAssertEqual(Set(box.storage[p...]), Set([2, 4, 6]))
  }

  func testMutableHalfStablePartitionEmptyPredicate() {
    var box = ForwardBox(storage: [1, 3, 5])
    let p = box.partition(subrange: 0..<3) { $0 % 2 == 0 }
    XCTAssertEqual(p, 3)
    XCTAssertEqual(box.storage, [1, 3, 5])
  }

  func testMutableHalfStablePartitionSubrange() {
    var box = ForwardBox(storage: [10, 1, 2, 3, 4, 20])
    let p = box.partition(subrange: 1..<5) { $0 % 2 == 0 }
    XCTAssertEqual(box.storage[0], 10)
    XCTAssertEqual(box.storage[5], 20)
    XCTAssertEqual(Array(box.storage[1..<p]), [1, 3])
    XCTAssertEqual(Set(box.storage[p..<5]), Set([2, 4]))
  }

  // MARK: - partitioningIndex

  func testPartitioningIndexEmpty() {
    let a: [Int] = []
    XCTAssertEqual(a.partitioningIndex { $0 > 0 }, a.endIndex)
  }

  func testPartitioningIndexAllFalse() {
    let a = [1, 2, 3]
    XCTAssertEqual(a.partitioningIndex { $0 > 10 }, a.endIndex)
  }

  func testPartitioningIndexAllTrue() {
    let a = [5, 6, 7]
    XCTAssertEqual(a.partitioningIndex { $0 >= 5 }, a.startIndex)
  }

  func testPartitioningIndexFindsFirstTrue() {
    let a = [1, 3, 5, 7, 9]
    let i = a.partitioningIndex { $0 >= 5 }
    XCTAssertEqual(i, 2)
    XCTAssertEqual(a[i], 5)
  }

  func testPartitioningIndexAfterStablePartition() {
    var a = [4, 1, 5, 2, 6, 3]
    let p = a.stablePartition { $0 % 2 == 0 }
    XCTAssertEqual(a.partitioningIndex { $0 % 2 == 0 }, p)
  }

  // MARK: - partitioned (Collection)

  func testPartitionedCollectionEmpty() {
    let a: [Int] = []
    let (f, t) = a.partitioned { $0 > 0 }
    XCTAssertEqual(f, [])
    XCTAssertEqual(t, [])
  }

  func testPartitionedCollectionSplitsPreservingOrder() {
    let a = [1, 2, 3, 4, 5, 6]
    let (odds, evens) = a.partitioned { $0 % 2 == 0 }
    XCTAssertEqual(odds, [1, 3, 5])
    XCTAssertEqual(evens, [2, 4, 6])
  }

  func testPartitionedCollectionAllFalse() {
    let a = [1, 3, 5]
    let (f, t) = a.partitioned { $0 % 2 == 0 }
    XCTAssertEqual(f, [1, 3, 5])
    XCTAssertEqual(t, [])
  }

  func testPartitionedCollectionAllTrue() {
    let a = [2, 4, 6]
    let (f, t) = a.partitioned { $0 % 2 == 0 }
    XCTAssertEqual(f, [])
    XCTAssertEqual(t, [2, 4, 6])
  }

  func testPartitionedCollectionStringsByLength() {
    let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    let (longNames, shortNames) = cast.partitioned { $0.count < 5 }
    XCTAssertEqual(longNames, ["Vivien", "Marlon"])
    XCTAssertEqual(shortNames, ["Kim", "Karl"])
  }

  // MARK: - partitioned (Sequence overload)

  func testPartitionedSequenceOverloadViaAnySequence() {
    let seq = AnySequence([1, 2, 3, 4])
    let (f, t) = seq.partitioned { $0 > 2 }
    XCTAssertEqual(f, [1, 2])
    XCTAssertEqual(t, [3, 4])
  }

  func testPartitionedSequenceEmpty() {
    let seq = AnySequence([Int]())
    let (f, t) = seq.partitioned { $0 > 0 }
    XCTAssertEqual(f, [])
    XCTAssertEqual(t, [])
  }

  // MARK: - Cross-API consistency

  func testStablePartitionPivotMatchesPartitioningIndex() {
    for n in 0...8 {
      for modulus in 1...4 {
        var a = Array(0..<n)
        let pred = { $0 % modulus == 0 }
        let p = a.stablePartition(by: pred)
        XCTAssertEqual(a.partitioningIndex(where: pred), p)
        XCTAssertEqual(Array(a[..<p]), Array(0..<n).filter { !pred($0) })
        XCTAssertEqual(Array(a[p...]), Array(0..<n).filter(pred))
      }
    }
  }

  func testPartitionedMatchesStablePartitionContents() {
    let base = [9, 8, 7, 6, 5, 4, 3, 2, 1]
    let pred = { $0 < 5 }
    let (f, t) = base.partitioned(by: pred)
    var copy = base
    let p = copy.stablePartition(by: pred)
    XCTAssertEqual(f, Array(copy[..<p]))
    XCTAssertEqual(t, Array(copy[p...]))
  }
}
