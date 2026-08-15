//===----------------------------------------------------------------------===//
// AI-generated unit tests for RigidArray+Append.swift (Experiment #12).
// Generated from production API / module surface only.
//===----------------------------------------------------------------------===//

import XCTest
#if COLLECTIONS_SINGLE_MODULE
import Collections
#else
import _CollectionsTestSupport
import ContainersPreview
import BasicContainers
#endif

#if compiler(>=6.2)

/// Sequence without contiguous storage (forces `_append(prefixOf:)` path).
private struct NonContiguousInts: Sequence {
  let values: [Int]
  struct Iterator: IteratorProtocol {
    var inner: IndexingIterator<[Int]>
    mutating func next() -> Int? { inner.next() }
  }
  func makeIterator() -> Iterator {
    Iterator(inner: values.makeIterator())
  }
}

@available(SwiftStdlib 6.2, *)
final class AIGeneratedRigidArrayAppendTests: CollectionTestCase {

  private func contents(_ array: borrowing RigidArray<Int>) -> [Int] {
    var result: [Int] = []
    array.span.withUnsafeBufferPointer { buffer in
      result = Array(buffer)
    }
    return result
  }

  // MARK: - append(_:)

  func testAppend_singleElementsUntilFull() {
    var a = RigidArray<Int>(capacity: 4)
    expectEqual(a.count, 0)
    expectEqual(a.freeCapacity, 4)
    expectFalse(a.isFull)

    a.append(10)
    expectEqual(contents(a), [10])
    expectEqual(a.count, 1)
    expectEqual(a.freeCapacity, 3)

    a.append(20)
    a.append(30)
    a.append(40)
    expectEqual(contents(a), [10, 20, 30, 40])
    expectTrue(a.isFull)
    expectEqual(a.freeCapacity, 0)
  }

  func testAppend_intoZeroCapacityIsImpossibleWithoutTrap() {
    var a = RigidArray<Int>(capacity: 1)
    a.append(1)
    expectTrue(a.isFull)
    expectEqual(contents(a), [1])
  }

  func testAppend_preservesExistingPrefix() {
    var a = RigidArray<Int>(capacity: 5, copying: [1, 2])
    a.append(3)
    expectEqual(contents(a), [1, 2, 3])
    expectEqual(a.count, 3)
    expectEqual(a.capacity, 5)
  }

  // MARK: - pushLast(_:)

  func testPushLast_returnsNilWhileSpaceRemains() {
    var a = RigidArray<Int>(capacity: 3)
    expectNil(a.pushLast(1))
    expectNil(a.pushLast(2))
    expectNil(a.pushLast(3))
    expectEqual(contents(a), [1, 2, 3])
    expectTrue(a.isFull)
  }

  func testPushLast_returnsItemWhenFull() {
    var a = RigidArray<Int>(capacity: 2)
    expectNil(a.pushLast(7))
    expectNil(a.pushLast(8))
    let rejected = a.pushLast(9)
    expectEqual(rejected, 9)
    expectEqual(contents(a), [7, 8])
    expectEqual(a.count, 2)
  }

  func testPushLast_zeroCapacityAlwaysRejects() {
    var a = RigidArray<Int>(capacity: 0)
    expectTrue(a.isFull)
    let rejected = a.pushLast(42)
    expectEqual(rejected, 42)
    expectEqual(a.count, 0)
  }

  func testPushLast_emptyThenFill() {
    var a = RigidArray<Int>(capacity: 1)
    expectNil(a.pushLast(100))
    expectEqual(a.pushLast(101), 101)
    expectEqual(contents(a), [100])
  }

  // MARK: - append(addingCount:initializingWith:)

  func testAppendAddingCount_fullInitialization() {
    var a = RigidArray<Int>(capacity: 6, copying: [1, 2])
    a.append(addingCount: 3) { span in
      expectEqual(span.freeCapacity, 3)
      span.append(3)
      span.append(4)
      span.append(5)
    }
    expectEqual(contents(a), [1, 2, 3, 4, 5])
    expectEqual(a.count, 5)
    expectEqual(a.freeCapacity, 1)
  }

  func testAppendAddingCount_partialInitializationKeepsWrittenItems() {
    var a = RigidArray<Int>(capacity: 8, copying: [10])
    a.append(addingCount: 4) { span in
      expectEqual(span.freeCapacity, 4)
      span.append(11)
      span.append(12)
      // leave 2 slots of the reserved span uninitialized
    }
    expectEqual(contents(a), [10, 11, 12])
    expectEqual(a.count, 3)
  }

  func testAppendAddingCount_zeroIsNoOp() {
    var a = RigidArray<Int>(capacity: 4, copying: [1, 2])
    a.append(addingCount: 0) { span in
      expectEqual(span.freeCapacity, 0)
    }
    expectEqual(contents(a), [1, 2])
  }

  func testAppendAddingCount_fillsToCapacity() {
    var a = RigidArray<Int>(capacity: 4)
    a.append(addingCount: 4) { span in
      for i in 0..<4 { span.append(i) }
    }
    expectTrue(a.isFull)
    expectEqual(contents(a), [0, 1, 2, 3])
  }

  // MARK: - append(moving: UnsafeMutableBufferPointer)

  func testAppendMoving_unsafeMutableBufferPointer() {
    var a = RigidArray<Int>(capacity: 5, copying: [1])
    let buffer = UnsafeMutableBufferPointer<Int>.allocate(capacity: 3)
    _ = buffer.initialize(fromContentsOf: [2, 3, 4])
    a.append(moving: buffer)
    buffer.deallocate()
    expectEqual(contents(a), [1, 2, 3, 4])
    expectEqual(a.count, 4)
  }

  func testAppendMoving_emptyUnsafeBufferIsNoOp() {
    var a = RigidArray<Int>(capacity: 3, copying: [9])
    let buffer = UnsafeMutableBufferPointer<Int>.allocate(capacity: 0)
    a.append(moving: buffer)
    buffer.deallocate()
    expectEqual(contents(a), [9])
  }

  // MARK: - append(moving: OutputSpan) / RigidArray

  func testAppendMoving_outputSpanViaEdit() {
    var a = RigidArray<Int>(capacity: 6, copying: [1, 2])
    var source = RigidArray<Int>(capacity: 4, copying: [3, 4, 5])
    source.edit { span in
      a.append(moving: &span)
    }
    expectEqual(contents(a), [1, 2, 3, 4, 5])
    expectEqual(source.count, 0)
    expectEqual(source.capacity, 4)
  }

  func testAppendMoving_inoutRigidArray() {
    var a = RigidArray<Int>(capacity: 5, copying: [10])
    var b = RigidArray<Int>(capacity: 3, copying: [20, 30])
    a.append(moving: &b)
    expectEqual(contents(a), [10, 20, 30])
    expectEqual(b.count, 0)
    expectEqual(b.capacity, 3)
  }

  func testAppendMoving_emptySourceRigidArray() {
    var a = RigidArray<Int>(capacity: 4, copying: [1])
    var b = RigidArray<Int>(capacity: 2)
    a.append(moving: &b)
    expectEqual(contents(a), [1])
    expectEqual(b.count, 0)
  }

  // MARK: - append(copying: Span / buffers / Sequence)

  func testAppendCopying_span() {
    var a = RigidArray<Int>(capacity: 6, copying: [1])
    let b = RigidArray<Int>(capacity: 4, copying: [2, 3, 4])
    a.append(copying: b.span)
    expectEqual(contents(a), [1, 2, 3, 4])
    expectEqual(contents(b), [2, 3, 4]) // source unchanged
  }

  func testAppendCopying_unsafeBufferPointer() {
    var a = RigidArray<Int>(capacity: 5)
    let values = [7, 8, 9]
    values.withUnsafeBufferPointer { buffer in
      a.append(copying: buffer)
    }
    expectEqual(contents(a), [7, 8, 9])
  }

  func testAppendCopying_unsafeMutableBufferPointer() {
    var a = RigidArray<Int>(capacity: 4, copying: [0])
    var storage = [1, 2]
    storage.withUnsafeMutableBufferPointer { buffer in
      a.append(copying: buffer)
    }
    expectEqual(contents(a), [0, 1, 2])
  }

  func testAppendCopying_arraySequenceContiguous() {
    var a = RigidArray<Int>(capacity: 5, copying: [1, 2])
    a.append(copying: [3, 4, 5])
    expectTrue(a.isFull)
    expectEqual(contents(a), [1, 2, 3, 4, 5])
  }

  func testAppendCopying_nonContiguousSequence() {
    var a = RigidArray<Int>(capacity: 5, copying: [1])
    a.append(copying: NonContiguousInts(values: [2, 3, 4]))
    expectEqual(contents(a), [1, 2, 3, 4])
    expectEqual(a.freeCapacity, 1)
  }

  func testAppendCopying_emptySequenceIsNoOp() {
    var a = RigidArray<Int>(capacity: 3, copying: [1, 2])
    a.append(copying: [Int]())
    expectEqual(contents(a), [1, 2])
  }

  func testAppendCopying_emptyNonContiguousSequence() {
    var a = RigidArray<Int>(capacity: 2, copying: [9])
    a.append(copying: NonContiguousInts(values: []))
    expectEqual(contents(a), [9])
  }

  // MARK: - Combined / boundary behaviors

  func testAppend_mixPushLastAndAppend() {
    var a = RigidArray<Int>(capacity: 4)
    a.append(1)
    expectNil(a.pushLast(2))
    a.append(3)
    expectNil(a.pushLast(4))
    expectEqual(a.pushLast(5), 5)
    expectEqual(contents(a), [1, 2, 3, 4])
  }

  func testAppend_afterPartialFillCopyingSpanToFull() {
    var a = RigidArray<Int>(capacity: 4)
    a.append(10)
    let extra = RigidArray<Int>(capacity: 3, copying: [20, 30, 40])
    a.append(copying: extra.span)
    expectTrue(a.isFull)
    expectEqual(contents(a), [10, 20, 30, 40])
  }

  func testAppendAddingCount_thenPushLastRejects() {
    var a = RigidArray<Int>(capacity: 3)
    a.append(addingCount: 3) { span in
      span.append(1)
      span.append(2)
      span.append(3)
    }
    expectEqual(a.pushLast(99), 99)
    expectEqual(contents(a), [1, 2, 3])
  }

  func testAppendMoving_thenCopyingOntoRemainder() {
    var a = RigidArray<Int>(capacity: 5)
    var moved = RigidArray<Int>(capacity: 2, copying: [1, 2])
    a.append(moving: &moved)
    a.append(copying: [3, 4])
    expectEqual(contents(a), [1, 2, 3, 4])
    expectEqual(a.freeCapacity, 1)
    expectEqual(moved.count, 0)
  }

  func testAppend_capacityOne() {
    var a = RigidArray<Int>(capacity: 1)
    expectNil(a.pushLast(42))
    expectTrue(a.isFull)
    expectEqual(contents(a), [42])
    expectEqual(a.pushLast(43), 43)
  }
}

#endif
