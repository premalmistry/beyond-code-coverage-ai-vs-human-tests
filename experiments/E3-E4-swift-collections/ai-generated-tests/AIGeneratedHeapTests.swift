//===----------------------------------------------------------------------===//
//
// Experiment #3 — AI-generated Heap tests (frozen baseline).
// Authored from production HeapModule APIs only; human HeapTests were not read.
//
//===----------------------------------------------------------------------===//

import XCTest
import HeapModule

/// AI-authored unit tests for `Heap` / min-max heap behavior.
///
/// Exercises public operations that drive `Heap+UnsafeHandle` algorithms
/// (`bubbleUp`, `trickleDownMin`/`Max`, descendant selection, `heapify`) and
/// package-visible min-level classification via `Heap._isMinLevel(offset:)`.
final class AIGeneratedHeapTests: XCTestCase {

  // MARK: - Helpers

  /// Sorted multiset of remaining heap contents via repeated `popMin`.
  private func drainAscending(_ heap: inout Heap<Int>) -> [Int] {
    var out: [Int] = []
    while let v = heap.popMin() {
      out.append(v)
    }
    return out
  }

  /// Sorted descending via repeated `popMax`.
  private func drainDescending(_ heap: inout Heap<Int>) -> [Int] {
    var out: [Int] = []
    while let v = heap.popMax() {
      out.append(v)
    }
    return out
  }

  private func assertMinMaxMatch(
    _ heap: Heap<Int>,
    expectedSorted: [Int],
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    if expectedSorted.isEmpty {
      XCTAssertNil(heap.min, file: file, line: line)
      XCTAssertNil(heap.max, file: file, line: line)
      XCTAssertTrue(heap.isEmpty, file: file, line: line)
      return
    }
    XCTAssertEqual(heap.min, expectedSorted.first, file: file, line: line)
    XCTAssertEqual(heap.max, expectedSorted.last, file: file, line: line)
    XCTAssertEqual(heap.count, expectedSorted.count, file: file, line: line)
  }

  private func assertUnorderedMultiset(
    _ heap: Heap<Int>,
    equals expected: [Int],
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    XCTAssertEqual(
      heap.unordered.sorted(),
      expected.sorted(),
      file: file,
      line: line
    )
  }

  /// Deterministic LCG-like permutation of `0..<n`.
  private func deterministicPermutation(_ n: Int, seed: Int = 42) -> [Int] {
    var state = seed
    var values = Array(0..<n)
    for i in stride(from: n - 1, through: 1, by: -1) {
      state = (state &* 1103515245 &+ 12345) & 0x7fffffff
      let j = state % (i + 1)
      values.swapAt(i, j)
    }
    return values
  }

  // MARK: - Empty / single / tiny heaps

  func testEmptyHeapBasics() {
    var heap = Heap<Int>()
    XCTAssertTrue(heap.isEmpty)
    XCTAssertEqual(heap.count, 0)
    XCTAssertNil(heap.min)
    XCTAssertNil(heap.max)
    XCTAssertNil(heap.popMin())
    XCTAssertNil(heap.popMax())
    XCTAssertEqual(heap.unordered, [])
  }

  func testSingleElementInsertMinMaxPop() {
    var heap = Heap<Int>()
    heap.insert(7)
    XCTAssertFalse(heap.isEmpty)
    XCTAssertEqual(heap.count, 1)
    XCTAssertEqual(heap.min, 7)
    XCTAssertEqual(heap.max, 7)
    XCTAssertEqual(heap.popMin(), 7)
    XCTAssertTrue(heap.isEmpty)

    heap.insert(3)
    XCTAssertEqual(heap.popMax(), 3)
    XCTAssertTrue(heap.isEmpty)
  }

  func testTwoElementsMinMax() {
    var heap = Heap<Int>()
    heap.insert(10)
    heap.insert(1)
    XCTAssertEqual(heap.min, 1)
    XCTAssertEqual(heap.max, 10)
    XCTAssertEqual(heap.popMin(), 1)
    XCTAssertEqual(heap.min, 10)
    XCTAssertEqual(heap.max, 10)
    XCTAssertEqual(heap.popMax(), 10)
  }

  func testThreeElementsMaxSelection() {
    // count >= 3 uses first max-level pair for `max`.
    let heap = Heap([5, 1, 9])
    XCTAssertEqual(heap.min, 1)
    XCTAssertEqual(heap.max, 9)
    XCTAssertEqual(heap.count, 3)
  }

  // MARK: - Insert

  func testInsertAscendingSequence() {
    var heap = Heap<Int>()
    for v in 0..<20 {
      heap.insert(v)
      XCTAssertEqual(heap.min, 0)
      XCTAssertEqual(heap.max, v)
    }
    XCTAssertEqual(drainAscending(&heap), Array(0..<20))
  }

  func testInsertDescendingSequence_BubbleUpToRoot() {
    var heap = Heap<Int>()
    for v in stride(from: 19, through: 0, by: -1) {
      heap.insert(v)
      XCTAssertEqual(heap.min, v)
      XCTAssertEqual(heap.max, 19)
    }
    XCTAssertEqual(drainAscending(&heap), Array(0..<20))
  }

  func testInsertDuplicates() {
    var heap = Heap<Int>()
    for _ in 0..<8 {
      heap.insert(5)
    }
    XCTAssertEqual(heap.min, 5)
    XCTAssertEqual(heap.max, 5)
    XCTAssertEqual(heap.count, 8)
    XCTAssertEqual(drainAscending(&heap), Array(repeating: 5, count: 8))
  }

  func testInsertContentsOfOntoEmptyUsesHeapify() {
    var heap = Heap<Int>()
    heap.insert(contentsOf: [4, 1, 7, 3, 9, 0, 2, 8, 6, 5])
    assertMinMaxMatch(heap, expectedSorted: Array(0...9))
    assertUnorderedMultiset(heap, equals: Array(0...9))
    XCTAssertEqual(drainAscending(&heap), Array(0...9))
  }

  func testInsertContentsOfSmallBatchOntoExisting_BubbleUpPath() {
    // Small k relative to n should prefer per-item bubbleUp (see Heap.insert(contentsOf:)).
    var heap = Heap(Array(0..<32))
    heap.insert(contentsOf: [-3, -1, 50])
    XCTAssertEqual(heap.min, -3)
    XCTAssertEqual(heap.max, 50)
    var expected = Array(0..<32) + [-3, -1, 50]
    expected.sort()
    XCTAssertEqual(drainAscending(&heap), expected)
  }

  func testInsertContentsOfLargeBatchOntoExisting_HeapifyPath() {
    // Large k forces Floyd heapify branch in insert(contentsOf:).
    var heap = Heap([100, 101, 102])
    let batch = Array(0..<40)
    heap.insert(contentsOf: batch)
    var expected = [100, 101, 102] + batch
    expected.sort()
    assertMinMaxMatch(heap, expectedSorted: expected)
    XCTAssertEqual(drainAscending(&heap), expected)
  }

  // MARK: - Heapify via initializers

  func testHeapifyFromUnorderedCollection() {
    let input = [8, 3, 15, 1, 9, 2, 14, 7, 4, 10, 6, 11, 13, 5, 12]
    var heap = Heap(input)
    assertMinMaxMatch(heap, expectedSorted: input.sorted())
    XCTAssertEqual(drainAscending(&heap), input.sorted())
  }

  func testHeapifyFromOrderedInput() {
    var heap = Heap(Array(0..<25))
    XCTAssertEqual(heap.min, 0)
    XCTAssertEqual(heap.max, 24)
    XCTAssertEqual(drainAscending(&heap), Array(0..<25))
  }

  func testHeapifyFromReverseOrderedInput() {
    var heap = Heap(Array(stride(from: 24, through: 0, by: -1)))
    XCTAssertEqual(heap.min, 0)
    XCTAssertEqual(heap.max, 24)
    XCTAssertEqual(drainDescending(&heap), Array(stride(from: 24, through: 0, by: -1)))
  }

  func testHeapifyFromArrayLiteral() {
    let heap: Heap<Int> = [9, 2, 7, 1, 8]
    XCTAssertEqual(heap.min, 1)
    XCTAssertEqual(heap.max, 9)
    XCTAssertEqual(heap.count, 5)
  }

  func testHeapifySingleAndEmptySequences() {
    let empty = Heap<Int>([])
    XCTAssertTrue(empty.isEmpty)
    let one = Heap([42])
    XCTAssertEqual(one.min, 42)
    XCTAssertEqual(one.max, 42)
  }

  // MARK: - popMin / popMax / removeMin / removeMax

  func testPopMinAscendingDrain() {
    var heap = Heap(deterministicPermutation(30, seed: 7))
    XCTAssertEqual(drainAscending(&heap), Array(0..<30))
    XCTAssertTrue(heap.isEmpty)
  }

  func testPopMaxDescendingDrain() {
    var heap = Heap(deterministicPermutation(30, seed: 11))
    XCTAssertEqual(drainDescending(&heap), Array(stride(from: 29, through: 0, by: -1)))
  }

  func testAlternatingPopMinPopMax() {
    var heap = Heap(Array(0..<10))
    XCTAssertEqual(heap.popMin(), 0)
    XCTAssertEqual(heap.popMax(), 9)
    XCTAssertEqual(heap.popMin(), 1)
    XCTAssertEqual(heap.popMax(), 8)
    XCTAssertEqual(heap.min, 2)
    XCTAssertEqual(heap.max, 7)
    XCTAssertEqual(heap.count, 6)
  }

  func testRemoveMinRemoveMaxOnNonEmpty() {
    var heap = Heap([4, 1, 6, 2, 5, 3])
    XCTAssertEqual(heap.removeMin(), 1)
    XCTAssertEqual(heap.removeMax(), 6)
    XCTAssertEqual(heap.removeMin(), 2)
    XCTAssertEqual(heap.removeMax(), 5)
    assertUnorderedMultiset(heap, equals: [3, 4])
  }

  func testPopMinTrickleDownOnDeepHeap() {
    // Large heap forces multi-level trickleDownMin after removing root.
    var heap = Heap(deterministicPermutation(64, seed: 3))
    let first = heap.popMin()
    XCTAssertEqual(first, 0)
    XCTAssertEqual(heap.min, 1)
    XCTAssertEqual(heap.max, 63)
    XCTAssertEqual(heap.count, 63)
  }

  func testPopMaxTrickleDownOnDeepHeap() {
    var heap = Heap(deterministicPermutation(64, seed: 5))
    let first = heap.popMax()
    XCTAssertEqual(first, 63)
    XCTAssertEqual(heap.max, 62)
    XCTAssertEqual(heap.min, 0)
    XCTAssertEqual(heap.count, 63)
  }

  func testPopMaxOnCountTwo() {
    var heap = Heap([1, 2])
    XCTAssertEqual(heap.popMax(), 2)
    XCTAssertEqual(heap.popMax(), 1)
    XCTAssertNil(heap.popMax())
  }

  // MARK: - replaceMin / replaceMax

  func testReplaceMinWithLargerValue_TrickleDown() {
    var heap = Heap(Array(0..<16))
    let old = heap.replaceMin(with: 100)
    XCTAssertEqual(old, 0)
    XCTAssertEqual(heap.min, 1)
    XCTAssertEqual(heap.max, 100)
    var expected = Array(1..<16) + [100]
    expected.sort()
    XCTAssertEqual(drainAscending(&heap), expected)
  }

  func testReplaceMinWithSmallerValue_StaysAtRoot() {
    var heap = Heap([10, 20, 30, 40])
    let old = heap.replaceMin(with: -5)
    XCTAssertEqual(old, 10)
    XCTAssertEqual(heap.min, -5)
    XCTAssertEqual(heap.max, 40)
  }

  func testReplaceMaxWithSmallerValue_BubbleAndTrickle() {
    var heap = Heap(Array(0..<16))
    let old = heap.replaceMax(with: -10)
    XCTAssertEqual(old, 15)
    XCTAssertEqual(heap.min, -10)
    XCTAssertEqual(heap.max, 14)
  }

  func testReplaceMaxWithLargerValue() {
    var heap = Heap(Array(0..<16))
    let old = heap.replaceMax(with: 999)
    XCTAssertEqual(old, 15)
    XCTAssertEqual(heap.max, 999)
    XCTAssertEqual(heap.min, 0)
  }

  func testReplaceMaxOnSingleElement() {
    var heap = Heap([7])
    XCTAssertEqual(heap.replaceMax(with: 3), 7)
    XCTAssertEqual(heap.min, 3)
    XCTAssertEqual(heap.max, 3)
  }

  func testReplaceMaxOnTwoElements() {
    var heap = Heap([1, 9])
    XCTAssertEqual(heap.replaceMax(with: 0), 9)
    XCTAssertEqual(heap.min, 0)
    XCTAssertEqual(heap.max, 1)
  }

  func testReplaceMinOnTwoElements() {
    var heap = Heap([1, 9])
    XCTAssertEqual(heap.replaceMin(with: 5), 1)
    XCTAssertEqual(heap.min, 5)
    XCTAssertEqual(heap.max, 9)
  }

  // MARK: - removeAll + heapify rebuild

  func testRemoveAllNone() {
    var heap = Heap([3, 1, 2])
    heap.removeAll { _ in false }
    assertUnorderedMultiset(heap, equals: [1, 2, 3])
    XCTAssertEqual(heap.min, 1)
    XCTAssertEqual(heap.max, 3)
  }

  func testRemoveAllEverything() {
    var heap = Heap([3, 1, 2, 4])
    heap.removeAll { _ in true }
    XCTAssertTrue(heap.isEmpty)
    XCTAssertNil(heap.min)
  }

  func testRemoveAllEvensThenHeapifyRemainder() {
    var heap = Heap(Array(0..<20))
    heap.removeAll { $0 % 2 == 0 }
    let expected = Array(stride(from: 1, through: 19, by: 2))
    assertMinMaxMatch(heap, expectedSorted: expected)
    XCTAssertEqual(drainAscending(&heap), expected)
  }

  // MARK: - Min-level / max-level (package API)

  func testIsMinLevelOffsetsEvenLevels() {
    // Level 0 (offset 0): min; level 1 (offsets 1–2): max; level 2 (3–6): min; …
    XCTAssertTrue(Heap<Int>._isMinLevel(offset: 0))
    XCTAssertFalse(Heap<Int>._isMinLevel(offset: 1))
    XCTAssertFalse(Heap<Int>._isMinLevel(offset: 2))
    XCTAssertTrue(Heap<Int>._isMinLevel(offset: 3))
    XCTAssertTrue(Heap<Int>._isMinLevel(offset: 6))
    XCTAssertFalse(Heap<Int>._isMinLevel(offset: 7))
    XCTAssertFalse(Heap<Int>._isMinLevel(offset: 14))
    XCTAssertTrue(Heap<Int>._isMinLevel(offset: 15))
  }

  func testMinMaxHeapPropertySpotCheckOnStorage() {
    // After heapify, root is global min; children on first max level are ≥ root.
    let heap = Heap(deterministicPermutation(31, seed: 99))
    let storage = heap.unordered
    XCTAssertEqual(storage[0], heap.min)
    if storage.count >= 2 {
      XCTAssertGreaterThanOrEqual(storage[1], storage[0])
    }
    if storage.count >= 3 {
      XCTAssertGreaterThanOrEqual(storage[2], storage[0])
      XCTAssertEqual(Swift.max(storage[1], storage[2]), heap.max)
    }
  }

  // MARK: - Bubble-up / trickle-down scenarios

  func testBubbleUpAcrossGrandparentMinLevel() {
    // Insert a new global minimum into a non-trivial heap → bubble to root.
    var heap = Heap(Array(10..<40))
    heap.insert(0)
    XCTAssertEqual(heap.min, 0)
    XCTAssertEqual(heap.unordered[0], 0)
  }

  func testBubbleUpMaxLevelNewMaximum() {
    var heap = Heap(Array(0..<20))
    heap.insert(1000)
    XCTAssertEqual(heap.max, 1000)
  }

  func testTrickleDownMinAfterReplaceWithMedian() {
    var heap = Heap(deterministicPermutation(40, seed: 13))
    _ = heap.replaceMin(with: 20)
    XCTAssertEqual(heap.min, 1) // 0 was replaced; 1 remains
    // Still a valid heap for remaining multiset.
    var expected = Array(1..<40)
    expected.append(20)
    expected.sort()
    XCTAssertEqual(drainAscending(&heap), expected)
  }

  func testTrickleDownMaxAfterPopMaxRepeated() {
    var heap = Heap(deterministicPermutation(40, seed: 17))
    for expected in stride(from: 39, through: 30, by: -1) {
      XCTAssertEqual(heap.popMax(), expected)
    }
    XCTAssertEqual(heap.max, 29)
    XCTAssertEqual(heap.min, 0)
  }

  // MARK: - Deterministic pseudo-random sequences

  func testDeterministicPermutationRoundTripPopMin() {
    let values = deterministicPermutation(50, seed: 123)
    var heap = Heap(values)
    XCTAssertEqual(drainAscending(&heap), Array(0..<50))
  }

  func testDeterministicPermutationInterleavedInsertAndPop() {
    var heap = Heap<Int>()
    let values = deterministicPermutation(40, seed: 55)
    for (i, v) in values.enumerated() {
      heap.insert(v)
      if i % 3 == 2 {
        _ = heap.popMin()
      }
    }
    // Remaining elements are a subset; min/max must match sorted remainder.
    let remaining = heap.unordered.sorted()
    assertMinMaxMatch(heap, expectedSorted: remaining)
    XCTAssertEqual(drainAscending(&heap), remaining)
  }

  func testManyDuplicatesWithScatteredExtremes() {
    var heap = Heap(Array(repeating: 5, count: 20))
    heap.insert(-100)
    heap.insert(100)
    heap.insert(5)
    XCTAssertEqual(heap.min, -100)
    XCTAssertEqual(heap.max, 100)
    XCTAssertEqual(heap.popMin(), -100)
    XCTAssertEqual(heap.popMax(), 100)
    XCTAssertEqual(heap.min, 5)
    XCTAssertEqual(heap.max, 5)
  }

  // MARK: - Capacity / descriptions (light)

  func testReserveCapacityAndMinimumCapacityInit() {
    var heap = Heap<Int>(minimumCapacity: 32)
    XCTAssertTrue(heap.isEmpty)
    heap.reserveCapacity(64)
    for v in 0..<10 {
      heap.insert(v)
    }
    XCTAssertEqual(heap.count, 10)
    XCTAssertEqual(heap.min, 0)
    XCTAssertEqual(heap.max, 9)
  }

  func testDescriptionMentionsCount() {
    let heap: Heap = [1, 2, 3]
    XCTAssertTrue(heap.description.contains("3 item"))
    let empty = Heap<Int>()
    XCTAssertTrue(empty.description.contains("0 item"))
  }

  // MARK: - Struct Element (Comparable)

  private struct Score: Comparable {
    var value: Int
    var label: String
    static func < (lhs: Score, rhs: Score) -> Bool {
      lhs.value < rhs.value
    }
  }

  func testStructElementMinMaxPop() {
    var heap = Heap<Score>()
    heap.insert(Score(value: 10, label: "a"))
    heap.insert(Score(value: 1, label: "b"))
    heap.insert(Score(value: 7, label: "c"))
    XCTAssertEqual(heap.min?.value, 1)
    XCTAssertEqual(heap.max?.value, 10)
    XCTAssertEqual(heap.popMin()?.label, "b")
    XCTAssertEqual(heap.popMax()?.label, "a")
    XCTAssertEqual(heap.min?.value, 7)
  }

  func testStructEqualValuesStableEnoughForCount() {
    var heap = Heap([
      Score(value: 2, label: "x"),
      Score(value: 2, label: "y"),
      Score(value: 2, label: "z"),
    ])
    XCTAssertEqual(heap.count, 3)
    XCTAssertEqual(heap.min?.value, 2)
    XCTAssertEqual(heap.max?.value, 2)
    var labels: [String] = []
    while let s = heap.popMin() {
      labels.append(s.label)
    }
    XCTAssertEqual(labels.sorted(), ["x", "y", "z"])
  }

  // MARK: - Boundary sizes around max-level layout

  func testExactLevelBoundariesCounts() {
    // Heap sizes that complete exact levels: 1, 3, 7, 15, 31
    for n in [1, 3, 7, 15, 31] {
      var heap = Heap(Array(0..<n))
      XCTAssertEqual(heap.min, 0)
      XCTAssertEqual(heap.max, n - 1)
      XCTAssertEqual(drainAscending(&heap), Array(0..<n))
    }
  }

  func testJustPastLevelBoundaries() {
    for n in [2, 4, 8, 16, 32] {
      var heap = Heap(deterministicPermutation(n, seed: n * 9))
      XCTAssertEqual(heap.min, 0)
      XCTAssertEqual(heap.max, n - 1)
      XCTAssertEqual(drainDescending(&heap), Array(stride(from: n - 1, through: 0, by: -1)))
    }
  }

  func testReplaceMinThenReplaceMaxRoundTripMultiset() {
    var heap = Heap(deterministicPermutation(25, seed: 77))
    // Start: 0..<25
    // replaceMin(1000): remove 0, add 1000 → {1...24, 1000}
    // replaceMax(-1000): remove 1000, add -1000 → {1...24, -1000}
    _ = heap.replaceMin(with: 1000)
    _ = heap.replaceMax(with: -1000)
    var expected = Array(1...24) + [-1000]
    expected.sort()
    XCTAssertEqual(heap.min, -1000)
    XCTAssertEqual(heap.max, 24)
    XCTAssertEqual(drainAscending(&heap), expected)
  }

  func testInsertContentsOfEmptySequenceNoOp() {
    var heap = Heap([1, 2, 3])
    heap.insert(contentsOf: [])
    assertUnorderedMultiset(heap, equals: [1, 2, 3])
  }

  func testMixedOperationsStressDeterministic() {
    var heap = Heap<Int>()
    var mirror = [Int]()
    let ops = deterministicPermutation(60, seed: 901)
    for (i, v) in ops.enumerated() {
      heap.insert(v)
      mirror.append(v)
      if i % 5 == 4, !mirror.isEmpty {
        let removed = heap.popMin()
        let expectedMin = mirror.min()
        XCTAssertEqual(removed, expectedMin)
        if let idx = mirror.firstIndex(of: expectedMin!) {
          mirror.remove(at: idx)
        }
      }
      if i % 7 == 6, mirror.count >= 2 {
        let removed = heap.popMax()
        let expectedMax = mirror.max()
        XCTAssertEqual(removed, expectedMax)
        if let idx = mirror.firstIndex(of: expectedMax!) {
          mirror.remove(at: idx)
        }
      }
    }
    XCTAssertEqual(heap.unordered.sorted(), mirror.sorted())
    XCTAssertEqual(drainAscending(&heap), mirror.sorted())
  }
}
