//===----------------------------------------------------------------------===//
//
// Experiment #4 — AI-generated OrderedSet insertion tests (frozen baseline).
// Authored from OrderedSet+Insertions.swift public APIs only; human tests not read.
//
//===----------------------------------------------------------------------===//

import XCTest
import OrderedCollections

/// Value-equal, identity-distinct element for `update` / `updateOr*` / equal `replace`.
private final class IdentityInt: Hashable {
  let value: Int
  init(_ value: Int) { self.value = value }
  static func == (lhs: IdentityInt, rhs: IdentityInt) -> Bool {
    lhs.value == rhs.value
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(value)
  }
}

/// AI-authored tests for `OrderedSet` insertion / update / replace APIs.
final class AIGeneratedOrderedSetInsertionsTests: XCTestCase {

  private func array<E: Hashable>(_ set: OrderedSet<E>) -> [E] {
    Array(set)
  }

  // MARK: - Empty / single / basics

  func testEmptyAppendInsertsAtZero() {
    var set = OrderedSet<Int>()
    XCTAssertTrue(set.isEmpty)
    let r = set.append(10)
    XCTAssertTrue(r.inserted)
    XCTAssertEqual(r.index, 0)
    XCTAssertEqual(array(set), [10])
    XCTAssertEqual(set.count, 1)
  }

  func testSingleElementDuplicateAppend() {
    var set: OrderedSet = [7]
    let r = set.append(7)
    XCTAssertFalse(r.inserted)
    XCTAssertEqual(r.index, 0)
    XCTAssertEqual(array(set), [7])
    XCTAssertEqual(set.count, 1)
  }

  // MARK: - append

  func testAppendPreservesOrderOfFirstOccurrence() {
    var set = OrderedSet<Int>()
    XCTAssertEqual(set.append(1).index, 0)
    XCTAssertEqual(set.append(2).index, 1)
    XCTAssertEqual(set.append(3).index, 2)
    XCTAssertEqual(array(set), [1, 2, 3])
  }

  func testAppendDuplicateReturnsExistingIndex() {
    var set: OrderedSet = [10, 20, 30]
    let r = set.append(20)
    XCTAssertFalse(r.inserted)
    XCTAssertEqual(r.index, 1)
    XCTAssertEqual(set[r.index], 20)
    XCTAssertEqual(array(set), [10, 20, 30])
  }

  func testAppendNewAfterDuplicatesStillAppendsAtEnd() {
    var set: OrderedSet = [1, 2]
    _ = set.append(1) // duplicate
    let r = set.append(3)
    XCTAssertTrue(r.inserted)
    XCTAssertEqual(r.index, 2)
    XCTAssertEqual(array(set), [1, 2, 3])
  }

  func testAppendManyUniqueDeterministicSequence() {
    var set = OrderedSet<Int>()
    for v in 0..<40 {
      let r = set.append(v)
      XCTAssertTrue(r.inserted)
      XCTAssertEqual(r.index, v)
      XCTAssertEqual(set[r.index], v)
    }
    XCTAssertEqual(array(set), Array(0..<40))
  }

  func testAppendInterleavedDuplicatesKeepFirstIndexes() {
    var set = OrderedSet<Int>()
    let seq = [0, 1, 0, 2, 1, 3, 2]
    var firstIndex: [Int: Int] = [:]
    for v in seq {
      let r = set.append(v)
      if let existing = firstIndex[v] {
        XCTAssertFalse(r.inserted)
        XCTAssertEqual(r.index, existing)
      } else {
        XCTAssertTrue(r.inserted)
        firstIndex[v] = r.index
      }
    }
    XCTAssertEqual(array(set), [0, 1, 2, 3])
  }

  // MARK: - append(contentsOf:)

  func testAppendContentsOfOntoEmpty() {
    var set = OrderedSet<Int>()
    set.append(contentsOf: [3, 1, 2, 1, 3, 4])
    XCTAssertEqual(array(set), [3, 1, 2, 4])
  }

  func testAppendContentsOfSkipsExistingPreservesOrder() {
    var set: OrderedSet = [10, 20]
    set.append(contentsOf: [20, 30, 10, 40])
    XCTAssertEqual(array(set), [10, 20, 30, 40])
  }

  func testAppendContentsOfEmptySequenceNoOp() {
    var set: OrderedSet = [1, 2]
    set.append(contentsOf: [])
    XCTAssertEqual(array(set), [1, 2])
  }

  func testAppendContentsOfAllDuplicatesNoGrowth() {
    var set: OrderedSet = [5, 6, 7]
    set.append(contentsOf: [7, 6, 5, 7])
    XCTAssertEqual(array(set), [5, 6, 7])
    XCTAssertEqual(set.count, 3)
  }

  // MARK: - insert(_:at:)

  func testInsertAtBeginning() {
    var set: OrderedSet = [2, 3]
    let r = set.insert(1, at: 0)
    XCTAssertTrue(r.inserted)
    XCTAssertEqual(r.index, 0)
    XCTAssertEqual(array(set), [1, 2, 3])
  }

  func testInsertAtMiddle() {
    var set: OrderedSet = [1, 3]
    let r = set.insert(2, at: 1)
    XCTAssertTrue(r.inserted)
    XCTAssertEqual(r.index, 1)
    XCTAssertEqual(array(set), [1, 2, 3])
  }

  func testInsertAtEnd() {
    var set: OrderedSet = [1, 2]
    let end = set.endIndex
    let r = set.insert(3, at: end)
    XCTAssertTrue(r.inserted)
    XCTAssertEqual(r.index, end)
    XCTAssertEqual(array(set), [1, 2, 3])
  }

  func testInsertIntoEmptyAtZero() {
    var set = OrderedSet<Int>()
    let r = set.insert(9, at: 0)
    XCTAssertTrue(r.inserted)
    XCTAssertEqual(r.index, 0)
    XCTAssertEqual(array(set), [9])
  }

  func testDuplicateInsertReturnsExistingIndexNotRequested() {
    var set: OrderedSet = [10, 20, 30]
    // Request insertion at 0, but 20 already lives at 1.
    let r = set.insert(20, at: 0)
    XCTAssertFalse(r.inserted)
    XCTAssertEqual(r.index, 1)
    XCTAssertEqual(array(set), [10, 20, 30])
  }

  func testInsertShiftsSucceedingElements() {
    var set: OrderedSet = [0, 1, 2, 3]
    _ = set.insert(99, at: 2)
    XCTAssertEqual(array(set), [0, 1, 99, 2, 3])
    XCTAssertEqual(set.firstIndex(of: 2), 3)
  }

  // MARK: - update(_:at:)

  func testUpdateReplacesIdentityKeepsValueAndOrder() {
    let a = IdentityInt(1)
    let b = IdentityInt(2)
    var set: OrderedSet = [a, b]
    let replacement = IdentityInt(1)
    XCTAssertFalse(a === replacement)
    let old = set.update(replacement, at: 0)
    XCTAssertTrue(old === a)
    XCTAssertTrue(set[0] === replacement)
    XCTAssertEqual(set.map(\.value), [1, 2])
  }

  func testUpdateMiddleElementIdentity() {
    let items = (0..<5).map { IdentityInt($0) }
    var set = OrderedSet(items)
    let neu = IdentityInt(3)
    let old = set.update(neu, at: 3)
    XCTAssertTrue(old === items[3])
    XCTAssertTrue(set[3] === neu)
    XCTAssertEqual(set.map(\.value), Array(0..<5))
  }

  // MARK: - updateOrAppend

  func testUpdateOrAppendInsertsWhenAbsent() {
    let a = IdentityInt(1)
    var set = OrderedSet<IdentityInt>()
    let old = set.updateOrAppend(a)
    XCTAssertNil(old)
    XCTAssertEqual(array(set).map(\.value), [1])
    XCTAssertTrue(set[0] === a)
  }

  func testUpdateOrAppendReplacesWhenPresent() {
    let a = IdentityInt(5)
    let b = IdentityInt(5)
    var set: OrderedSet = [a]
    let old = set.updateOrAppend(b)
    XCTAssertTrue(old === a)
    XCTAssertTrue(set[0] === b)
    XCTAssertEqual(set.count, 1)
  }

  func testUpdateOrAppendDoesNotMoveExistingMember() {
    let x = IdentityInt(1)
    let y = IdentityInt(2)
    let x2 = IdentityInt(1)
    var set: OrderedSet = [x, y]
    _ = set.updateOrAppend(x2)
    XCTAssertEqual(set.map(\.value), [1, 2])
    XCTAssertTrue(set[0] === x2)
    XCTAssertTrue(set[1] === y)
  }

  // MARK: - updateOrInsert

  func testUpdateOrInsertNewAtBeginning() {
    var set: OrderedSet = [2, 3]
    let r = set.updateOrInsert(1, at: 0)
    XCTAssertNil(r.originalMember)
    XCTAssertEqual(r.index, 0)
    XCTAssertEqual(array(set), [1, 2, 3])
  }

  func testUpdateOrInsertNewAtMiddle() {
    var set: OrderedSet = [1, 3]
    let r = set.updateOrInsert(2, at: 1)
    XCTAssertNil(r.originalMember)
    XCTAssertEqual(r.index, 1)
    XCTAssertEqual(array(set), [1, 2, 3])
  }

  func testUpdateOrInsertNewAtEnd() {
    var set: OrderedSet = [1, 2]
    let r = set.updateOrInsert(3, at: set.endIndex)
    XCTAssertNil(r.originalMember)
    XCTAssertEqual(r.index, 2)
    XCTAssertEqual(array(set), [1, 2, 3])
  }

  func testUpdateOrInsertExistingIgnoresRequestedIndex() {
    let a = IdentityInt(10)
    let b = IdentityInt(20)
    let a2 = IdentityInt(10)
    var set: OrderedSet = [a, b]
    let r = set.updateOrInsert(a2, at: 1) // request index 1, but 10 is at 0
    XCTAssertTrue(r.originalMember === a)
    XCTAssertEqual(r.index, 0)
    XCTAssertTrue(set[0] === a2)
    XCTAssertEqual(set.map(\.value), [10, 20])
  }

  // MARK: - replace(at:with:)

  func testReplaceWithNewElementKeepsSlotOrder() {
    // Doc example: [1,2,3].replace(at:1, with:4) → [1,4,3]
    var set: OrderedSet = [1, 2, 3]
    let old = set.replace(at: 1, with: 4)
    XCTAssertEqual(old, 2)
    XCTAssertEqual(array(set), [1, 4, 3])
  }

  func testReplaceAtBeginningWithNew() {
    var set: OrderedSet = [1, 2, 3]
    let old = set.replace(at: 0, with: 9)
    XCTAssertEqual(old, 1)
    XCTAssertEqual(array(set), [9, 2, 3])
  }

  func testReplaceAtEndWithNew() {
    var set: OrderedSet = [1, 2, 3]
    let old = set.replace(at: 2, with: 9)
    XCTAssertEqual(old, 3)
    XCTAssertEqual(array(set), [1, 2, 9])
  }

  func testReplaceEqualElementInPlaceIdentity() {
    let a = IdentityInt(1)
    let b = IdentityInt(2)
    let a2 = IdentityInt(1)
    var set: OrderedSet = [a, b]
    let old = set.replace(at: 0, with: a2)
    XCTAssertTrue(old === a)
    XCTAssertTrue(set[0] === a2)
    XCTAssertEqual(set.map(\.value), [1, 2])
  }

  func testReplaceMiddleThenContains() {
    var set: OrderedSet = [0, 1, 2, 3, 4]
    _ = set.replace(at: 2, with: 99)
    XCTAssertEqual(array(set), [0, 1, 99, 3, 4])
    XCTAssertFalse(set.contains(2))
    XCTAssertTrue(set.contains(99))
  }

  // MARK: - Capacity growth

  func testAppendCapacityGrowthKeepsMembershipAndOrder() {
    var set = OrderedSet<Int>()
    let n = 200
    for v in 0..<n {
      let r = set.append(v)
      XCTAssertTrue(r.inserted)
      XCTAssertEqual(r.index, v)
    }
    XCTAssertEqual(set.count, n)
    XCTAssertEqual(array(set), Array(0..<n))
    // Duplicates still resolve after growth.
    let d = set.append(n / 2)
    XCTAssertFalse(d.inserted)
    XCTAssertEqual(d.index, n / 2)
    XCTAssertEqual(set.count, n)
  }

  func testInsertDuringGrowthPreservesRelativeOrder() {
    var set = OrderedSet<Int>()
    for v in 0..<50 {
      _ = set.append(v)
    }
    // Insert new values at front repeatedly to force shifts + growth interplay.
    for v in 100..<120 {
      let r = set.insert(v, at: 0)
      XCTAssertTrue(r.inserted)
      XCTAssertEqual(r.index, 0)
      XCTAssertEqual(set[0], v)
    }
    XCTAssertEqual(set.count, 70)
    XCTAssertEqual(Array(set.suffix(50)), Array(0..<50))
  }

  func testUpdateOrInsertManyNewForcesTablePaths() {
    var set = OrderedSet<Int>()
    for i in 0..<80 {
      let r = set.updateOrInsert(i, at: set.endIndex)
      XCTAssertNil(r.originalMember)
      XCTAssertEqual(r.index, i)
    }
    XCTAssertEqual(array(set), Array(0..<80))
    let again = set.updateOrInsert(10, at: 0)
    XCTAssertEqual(again.originalMember, 10)
    XCTAssertEqual(again.index, 10)
    XCTAssertEqual(array(set), Array(0..<80))
  }

  // MARK: - Combined / edge scenarios

  func testMixedAppendInsertReplaceRoundTripState() {
    var set = OrderedSet<Int>()
    XCTAssertTrue(set.append(1).inserted)
    XCTAssertTrue(set.append(2).inserted)
    XCTAssertTrue(set.insert(0, at: 0).inserted)
    XCTAssertEqual(array(set), [0, 1, 2])
    XCTAssertEqual(set.replace(at: 1, with: 9), 1)
    XCTAssertEqual(array(set), [0, 9, 2])
    XCTAssertFalse(set.append(0).inserted)
    XCTAssertTrue(set.append(3).inserted)
    XCTAssertEqual(array(set), [0, 9, 2, 3])
  }

  func testOrderPreservationUnderDuplicateHeavyInput() {
    var set = OrderedSet<String>()
    set.append(contentsOf: ["a", "b", "a", "c", "b", "d", "a"])
    XCTAssertEqual(array(set), ["a", "b", "c", "d"])
    let ins = set.insert("b", at: 0)
    XCTAssertFalse(ins.inserted)
    XCTAssertEqual(ins.index, 1)
    XCTAssertEqual(array(set), ["a", "b", "c", "d"])
  }

  func testReplaceThenAppendDuplicateOfReplacedValue() {
    var set: OrderedSet = [1, 2, 3]
    _ = set.replace(at: 0, with: 8) // removes 1
    let r = set.append(1)
    XCTAssertTrue(r.inserted)
    XCTAssertEqual(r.index, 3)
    XCTAssertEqual(array(set), [8, 2, 3, 1])
  }

  func testCopyOnWriteAppendDoesNotMutateCopy() {
    var set: OrderedSet = [1, 2, 3]
    let copy = set
    XCTAssertTrue(set.append(4).inserted)
    XCTAssertEqual(array(set), [1, 2, 3, 4])
    XCTAssertEqual(array(copy), [1, 2, 3])
  }

  func testCopyOnWriteInsertDoesNotMutateCopy() {
    var set: OrderedSet = [1, 2, 3]
    let copy = set
    XCTAssertTrue(set.insert(0, at: 0).inserted)
    XCTAssertEqual(array(set), [0, 1, 2, 3])
    XCTAssertEqual(array(copy), [1, 2, 3])
  }

  func testUpdateOrAppendNilMeansInsertedAtEnd() {
    var set: OrderedSet = [IdentityInt(1), IdentityInt(2)]
    let neu = IdentityInt(3)
    XCTAssertNil(set.updateOrAppend(neu))
    XCTAssertEqual(set.count, 3)
    XCTAssertTrue(set[2] === neu)
  }

  func testInsertAllOffsetsOnSmallSet() {
    for offset in 0...3 {
      var set: OrderedSet = [0, 1, 2]
      let value = 100 + offset
      let r = set.insert(value, at: offset)
      XCTAssertTrue(r.inserted)
      XCTAssertEqual(r.index, offset)
      XCTAssertEqual(set[offset], value)
      XCTAssertEqual(set.count, 4)
      // Original relative order of 0,1,2 preserved around the insertion.
      XCTAssertEqual(set.filter { $0 < 100 }, [0, 1, 2])
    }
  }
}
