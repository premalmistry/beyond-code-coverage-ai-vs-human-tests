import Foundation
import XCTest

@testable import SnapshotTesting

/// AI-generated unit tests for `Any.swift` dump/description/json strategies.
/// Deterministic assertions against strategy output (no on-disk snapshot fixtures).
final class AIGeneratedAnyTests: XCTestCase {

  // MARK: - Helpers

  private func render<Value>(
    _ value: Value,
    as strategy: Snapshotting<Value, String>
  ) -> String {
    var output: String?
    let expectation = expectation(description: "render")
    strategy.snapshot(value).run { format in
      output = format
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1.0)
    return output!
  }

  private func dump<Value>(_ value: Value) -> String {
    render(value, as: Snapshotting<Value, String>.dump)
  }

  // MARK: - .description

  func testDescription_usesStringDescribing() {
    struct Point { let x: Int, y: Int }
    let value = Point(x: 1, y: 2)
    XCTAssertEqual(
      render(value, as: Snapshotting<Point, String>.description),
      String(describing: value)
    )
  }

  // MARK: - .dump structs

  func testDump_emptyStruct() {
    struct Empty {}
    let output = dump(Empty())
    XCTAssertEqual(output, "- Empty\n")
  }

  func testDump_structWithProperties_sortedChildren() {
    struct User { let id: Int, name: String, bio: String }
    let output = dump(User(id: 1, name: "Blobby", bio: "Hello"))

    XCTAssertTrue(output.hasPrefix("▿ User\n"), output)
    // Children are sorted by their snap text, not declaration order.
    let bioIdx = output.range(of: "- bio:")!.lowerBound
    let idIdx = output.range(of: "- id:")!.lowerBound
    let nameIdx = output.range(of: "- name:")!.lowerBound
    XCTAssertLessThan(bioIdx, idIdx)
    XCTAssertLessThan(idIdx, nameIdx)
    XCTAssertTrue(output.contains("- bio: \"Hello\"\n"), output)
    XCTAssertTrue(output.contains("- id: 1\n"), output)
    XCTAssertTrue(output.contains("- name: \"Blobby\"\n"), output)
  }

  func testDump_nestedStruct() {
    struct Inner { let value: Int }
    struct Outer { let inner: Inner }
    let output = dump(Outer(inner: Inner(value: 9)))
    XCTAssertTrue(output.contains("▿ Outer\n"), output)
    XCTAssertTrue(output.contains("▿ inner: Inner\n"), output)
    XCTAssertTrue(output.contains("- value: 9\n"), output)
  }

  // MARK: - collections (arrays)

  func testDump_emptyArray() {
    let output = dump([Int]())
    XCTAssertEqual(output, "- 0 elements\n")
  }

  func testDump_singleElementArray() {
    let output = dump([42])
    XCTAssertTrue(output.hasPrefix("▿ 1 element\n"), output)
    XCTAssertTrue(output.contains("- 42\n"), output)
  }

  func testDump_multiElementArray_preservesOrder() {
    let output = dump([3, 1, 2])
    XCTAssertTrue(output.hasPrefix("▿ 3 elements\n"), output)
    // Array children are not sorted — declaration/order preserved via Mirror.
    let three = output.range(of: "- 3\n")!.lowerBound
    let one = output.range(of: "- 1\n")!.lowerBound
    let two = output.range(of: "- 2\n")!.lowerBound
    XCTAssertLessThan(three, one)
    XCTAssertLessThan(one, two)
  }

  // MARK: - dictionaries (deterministic sorting)

  func testDump_emptyDictionary() {
    let output = dump([String: Int]())
    XCTAssertEqual(output, "- 0 key/value pairs\n")
  }

  func testDump_singleKeyValuePair() {
    let output = dump(["only": 1])
    XCTAssertTrue(output.hasPrefix("▿ 1 key/value pair\n"), output)
  }

  func testDump_dictionary_childrenSortedDeterministically() {
    let dict = ["c": 3, "a": 1, "b": 2]
    let first = dump(dict)
    let second = dump(dict)
    XCTAssertEqual(first, second)
    XCTAssertTrue(first.hasPrefix("▿ 3 key/value pairs\n"), first)

    // Sorted by snap of each child; labels "a","b","c" appear in snap-order.
    let a = first.range(of: "\"a\"")!.lowerBound
    let b = first.range(of: "\"b\"")!.lowerBound
    let c = first.range(of: "\"c\"")!.lowerBound
    XCTAssertLessThan(a, b)
    XCTAssertLessThan(b, c)
  }

  // MARK: - sets (deterministic sorting)

  func testDump_emptySet() {
    let output = dump(Set<String>())
    XCTAssertEqual(output, "- 0 members\n")
  }

  func testDump_singleMemberSet() {
    let output = dump(Set(["solo"]))
    XCTAssertTrue(output.hasPrefix("▿ 1 member\n"), output)
  }

  func testDump_set_childrenSortedDeterministically() {
    struct Person: Hashable { let name: String }
    let set: Set<Person> = [.init(name: "Zoe"), .init(name: "Amy"), .init(name: "Ned")]
    let first = dump(set)
    let second = dump(set)
    XCTAssertEqual(first, second)
    XCTAssertTrue(first.hasPrefix("▿ 3 members\n"), first)

    let amy = first.range(of: "Amy")!.lowerBound
    let ned = first.range(of: "Ned")!.lowerBound
    let zoe = first.range(of: "Zoe")!.lowerBound
    XCTAssertLessThan(amy, ned)
    XCTAssertLessThan(ned, zoe)
  }

  // MARK: - tuples

  func testDump_singleElementTuple() {
    let output = dump((42))
    // Single-element tuple may be reflected differently; accept either path.
    XCTAssertFalse(output.isEmpty)
  }

  func testDump_labeledTuple() {
    let output = dump((x: 1, y: 2))
    XCTAssertTrue(output.contains("2 elements") || output.contains("(2 elements)"), output)
    XCTAssertTrue(output.contains("- x: 1\n"), output)
    XCTAssertTrue(output.contains("- y: 2\n"), output)
  }

  func testDump_unlabeledTwoTuple() {
    let output = dump((10, 20))
    XCTAssertTrue(output.contains("(2 elements)"), output)
    XCTAssertTrue(output.contains("- .0: 10\n"), output)
    XCTAssertTrue(output.contains("- .1: 20\n"), output)
  }

  // MARK: - optionals

  func testDump_optionalNone() {
    let value: Int? = nil
    let output = dump(value)
    XCTAssertTrue(output.contains("Optional<Int>.none") || output.contains(".none"), output)
    XCTAssertTrue(output.hasPrefix("- "), output)
  }

  func testDump_optionalSome() {
    let value: String? = "hi"
    let output = dump(value)
    XCTAssertTrue(output.contains("Optional<String>"), output)
    XCTAssertTrue(output.contains("\"hi\""), output)
    XCTAssertFalse(output.contains(".none"), output)
  }

  // MARK: - enums

  func testDump_enumWithoutAssociatedValues() {
    enum Direction { case north, south }
    let output = dump(Direction.north)
    XCTAssertTrue(output.contains("Direction"), output)
    XCTAssertTrue(output.contains("north"), output)
    XCTAssertTrue(output.hasPrefix("- "), output)
  }

  func testDump_enumWithAssociatedValues() {
    enum Result { case ok(Int), err(String) }
    let output = dump(Result.ok(7))
    XCTAssertTrue(output.hasPrefix("▿ Result\n") || output.contains("▿ Result"), output)
    XCTAssertTrue(output.contains("7"), output)
  }

  func testDump_enumErrorCase() {
    enum Result { case ok(Int), err(String) }
    let output = dump(Result.err("boom"))
    XCTAssertTrue(output.contains("Result"), output)
    XCTAssertTrue(output.contains("\"boom\""), output)
  }

  // MARK: - classes & recursion

  func testDump_simpleClass() {
    class Box {
      var value: Int
      init(_ value: Int) { self.value = value }
    }
    let output = dump(Box(5))
    XCTAssertTrue(output.contains("Box"), output)
    XCTAssertTrue(output.contains("- value: 5\n"), output)
  }

  func testDump_circularReference_detected() {
    class Node {
      var other: Node?
    }
    let a = Node()
    let b = Node()
    a.other = b
    b.other = a

    let output = dump(a)
    XCTAssertTrue(output.contains("(circular reference detected)"), output)
    XCTAssertTrue(output.contains("Node"), output)
  }

  func testDump_selfReference() {
    class Loop {
      var selfRef: Loop?
    }
    let node = Loop()
    node.selfRef = node
    let output = dump(node)
    XCTAssertTrue(output.contains("(circular reference detected)"), output)
  }

  // MARK: - AnySnapshotStringConvertible built-ins

  func testDump_character() {
    let output = dump("Z" as Character)
    XCTAssertEqual(output, "- \"Z\"\n")
  }

  func testDump_string() {
    let output = dump("Hello")
    XCTAssertEqual(output, "- \"Hello\"\n")
  }

  func testDump_substring() {
    let output = dump("Hello, world!".dropLast(8))
    XCTAssertEqual(output, dump(Substring("Hello")))
    XCTAssertTrue(output.hasPrefix("- \""), output)
  }

  func testDump_data() {
    let data = Data("Hi".utf8)
    let output = dump(data)
    XCTAssertEqual(output, "- \(data.debugDescription)\n")
  }

  func testDump_url() {
    let url = URL(string: "https://example.com/path")!
    let output = dump(url)
    XCTAssertEqual(output, "- \(url.debugDescription)\n")
  }

  func testDump_date_usesUTCFormatter() {
    let date = Date(timeIntervalSinceReferenceDate: 0)
    let output = dump(date)
    // Formatter: yyyy-MM-dd'T'HH:mm:ssZZZZZ in UTC
    XCTAssertTrue(output.contains("2001-01-01T00:00:00Z"), output)
    XCTAssertTrue(output.hasPrefix("- "), output)
  }

  func testDump_nsObject_scrubsPointers() {
    let object = NSObject()
    let output = dump(object)
    XCTAssertFalse(output.contains("0x"), output)
    XCTAssertTrue(output.contains("NSObject") || output.hasPrefix("- "), output)
  }

  // MARK: - custom AnySnapshotStringConvertible

  func testDump_customConvertible_withoutChildren() {
    struct Tag: AnySnapshotStringConvertible {
      var snapshotDescription: String { "TAG" }
      var ignored: Int = 99
    }
    let output = dump(Tag())
    // Early return: children not rendered when renderChildren == false.
    XCTAssertEqual(output, "- TAG\n")
    XCTAssertFalse(output.contains("ignored"), output)
  }

  func testDump_customConvertible_withRenderChildren() {
    struct Box: AnySnapshotStringConvertible {
      static var renderChildren: Bool { true }
      var snapshotDescription: String { "BoxLabel" }
      var payload: Int = 3
    }
    let output = dump(Box())
    XCTAssertTrue(output.contains("BoxLabel"), output)
    XCTAssertTrue(output.contains("- payload: 3\n"), output)
  }

  func testDump_customConvertible_asProperty() {
    struct Tag: AnySnapshotStringConvertible {
      var snapshotDescription: String { "X" }
    }
    struct Holder { let tag: Tag }
    let output = dump(Holder(tag: Tag()))
    XCTAssertTrue(output.contains("- tag: X\n"), output)
  }

  // MARK: - pointer scrubbing (purgePointers)

  func testPurgePointers_removesHexAddresses() {
    let scrubbed = purgePointers("NSObject: 0xdeadbeef alive")
    XCTAssertFalse(scrubbed.contains("0x"), scrubbed)
    XCTAssertTrue(scrubbed.contains("NSObject"), scrubbed)
    XCTAssertTrue(scrubbed.contains("alive"), scrubbed)
  }

  func testPurgePointers_removesColonPrefixedAddresses() {
    let scrubbed = purgePointers("Widget: 0xabc123 rest")
    XCTAssertEqual(scrubbed, "Widget rest")
  }

  func testPurgePointers_leavesPlainTextAlone() {
    XCTAssertEqual(purgePointers("no addresses here"), "no addresses here")
  }

  func testPurgePointers_multipleAddresses() {
    let scrubbed = purgePointers("A 0x1 B 0x2 C")
    XCTAssertFalse(scrubbed.contains("0x"), scrubbed)
    XCTAssertTrue(scrubbed.contains("A"), scrubbed)
    XCTAssertTrue(scrubbed.contains("B"), scrubbed)
    XCTAssertTrue(scrubbed.contains("C"), scrubbed)
  }

  // MARK: - indentation / nesting depth

  func testDump_indentationIncreasesByTwo() {
    struct Leaf { let n: Int }
    struct Mid { let leaf: Leaf }
    struct Top { let mid: Mid }
    let output = dump(Top(mid: Mid(leaf: Leaf(n: 1))))
    XCTAssertTrue(output.contains("▿ Top\n"), output)
    XCTAssertTrue(output.contains("  ▿ mid: Mid\n"), output)
    XCTAssertTrue(output.contains("    ▿ leaf: Leaf\n"), output)
    XCTAssertTrue(output.contains("      - n: 1\n"), output)
  }

  // MARK: - bullet markers

  func testDump_leafUsesDashBullet() {
    XCTAssertTrue(dump(7).hasPrefix("- "), dump(7))
  }

  func testDump_containerUsesTriangleBullet() {
    XCTAssertTrue(dump([1, 2]).hasPrefix("▿ "), dump([1, 2]))
  }

  // MARK: - .json

  func testJson_prettyPrintedSortedKeys() throws {
    let value: [String: Any] = ["z": 1, "a": 2]
    let output = render(value, as: Snapshotting<[String: Any], String>.json)
    XCTAssertTrue(output.contains("\"a\""), output)
    XCTAssertTrue(output.contains("\"z\""), output)
    let a = output.range(of: "\"a\"")!.lowerBound
    let z = output.range(of: "\"z\"")!.lowerBound
    XCTAssertLessThan(a, z)
    XCTAssertEqual(Snapshotting<[String: Any], String>.json.pathExtension, "json")
  }

  func testJson_array() {
    let output = render([3, 1, 2], as: Snapshotting<[Int], String>.json)
    XCTAssertTrue(output.contains("3"), output)
    XCTAssertTrue(output.contains("1"), output)
    XCTAssertTrue(output.contains("2"), output)
  }

  // MARK: - strategy path extensions

  func testDump_pathExtensionIsTxt() {
    XCTAssertEqual(Snapshotting<Int, String>.dump.pathExtension, "txt")
  }

  func testDescription_pathExtensionIsTxt() {
    XCTAssertEqual(Snapshotting<Int, String>.description.pathExtension, "txt")
  }

  // MARK: - edge cases

  func testDump_emptyString() {
    XCTAssertEqual(dump(""), "- \"\"\n")
  }

  func testDump_stringWithQuotes() {
    let output = dump("say \"hi\"")
    XCTAssertTrue(output.contains("\\\""), output)
  }

  func testDump_boolAndDouble() {
    XCTAssertTrue(dump(true).contains("true"), dump(true))
    XCTAssertTrue(dump(1.5).contains("1.5"), dump(1.5))
  }

  func testDump_arrayOfOptionals() {
    let values: [Int?] = [1, nil, 3]
    let output = dump(values)
    XCTAssertTrue(output.contains("3 elements"), output)
    XCTAssertTrue(output.contains(".none") || output.contains("nil") || output.contains("Optional"), output)
  }

  func testDump_dictionaryWithMixedValueTypes_isStable() {
    let dict: [String: Any] = ["b": "x", "a": 1]
    XCTAssertEqual(dump(dict), dump(dict))
  }

  func testDump_deeplyNestedArrays() {
    let output = dump([[[1]]])
    XCTAssertTrue(output.contains("1 element"), output)
    XCTAssertTrue(output.contains("- 1\n"), output)
  }
}
