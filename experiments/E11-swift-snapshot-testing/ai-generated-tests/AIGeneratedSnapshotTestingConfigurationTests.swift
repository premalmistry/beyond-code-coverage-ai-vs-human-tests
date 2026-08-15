import XCTest

@_spi(Internals) @testable import SnapshotTesting

/// AI-generated unit tests for `SnapshotTestingConfiguration.swift`
/// (withSnapshotTesting, Record, DiffTool). Generated from production API only.
final class AIGeneratedSnapshotTestingConfigurationTests: XCTestCase {

  // MARK: - Record.init?(rawValue:)

  func testRecordRawValue_all() {
    let record = SnapshotTestingConfiguration.Record(rawValue: "all")
    XCTAssertEqual(record, .all)
  }

  func testRecordRawValue_failed() {
    let record = SnapshotTestingConfiguration.Record(rawValue: "failed")
    XCTAssertEqual(record, .failed)
  }

  func testRecordRawValue_missing() {
    let record = SnapshotTestingConfiguration.Record(rawValue: "missing")
    XCTAssertEqual(record, .missing)
  }

  func testRecordRawValue_never() {
    let record = SnapshotTestingConfiguration.Record(rawValue: "never")
    XCTAssertEqual(record, .never)
  }

  func testRecordRawValue_invalidReturnsNil() {
    XCTAssertNil(SnapshotTestingConfiguration.Record(rawValue: "sometimes"))
    XCTAssertNil(SnapshotTestingConfiguration.Record(rawValue: ""))
    XCTAssertNil(SnapshotTestingConfiguration.Record(rawValue: "ALL"))
    XCTAssertNil(SnapshotTestingConfiguration.Record(rawValue: " never "))
  }

  // MARK: - Record boolean literal

  func testRecordBooleanLiteral_trueIsAll() {
    let record: SnapshotTestingConfiguration.Record = true
    XCTAssertEqual(record, .all)
  }

  func testRecordBooleanLiteral_falseIsMissing() {
    let record: SnapshotTestingConfiguration.Record = false
    XCTAssertEqual(record, .missing)
  }

  // MARK: - Record equality / static cases

  func testRecordStaticCases_areDistinct() {
    let cases: [SnapshotTestingConfiguration.Record] = [.all, .failed, .missing, .never]
    for (i, a) in cases.enumerated() {
      for (j, b) in cases.enumerated() {
        if i == j {
          XCTAssertEqual(a, b)
        } else {
          XCTAssertNotEqual(a, b)
        }
      }
    }
  }

  // MARK: - DiffTool.ksdiff / default / string literal

  func testDiffTool_ksdiff_quotesPaths() {
    let command = SnapshotTestingConfiguration.DiffTool.ksdiff(
      currentFilePath: "/tmp/current.txt",
      failedFilePath: "/tmp/failed.txt"
    )
    XCTAssertEqual(command, "ksdiff \"/tmp/current.txt\" \"/tmp/failed.txt\"")
  }

  func testDiffTool_default_includesFileURLsAndHelp() {
    let command = SnapshotTestingConfiguration.DiffTool.default(
      currentFilePath: "/a/ref.txt",
      failedFilePath: "/b/new.txt"
    )
    XCTAssertTrue(command.contains("file:///a/ref.txt"), command)
    XCTAssertTrue(command.contains("file:///b/new.txt"), command)
    XCTAssertTrue(command.contains("withSnapshotTesting"), command)
    XCTAssertTrue(command.contains(".ksdiff"), command)
  }

  func testDiffTool_stringLiteral_formatsAsToolThenPaths() {
    let tool: SnapshotTestingConfiguration.DiffTool = "opendiff"
    let command = tool(currentFilePath: "old.png", failedFilePath: "new.png")
    XCTAssertEqual(command, "opendiff old.png new.png")
  }

  func testDiffTool_customClosure() {
    let tool = SnapshotTestingConfiguration.DiffTool { current, failed in
      "compare:\(current)->\(failed)"
    }
    XCTAssertEqual(
      tool(currentFilePath: "c", failedFilePath: "f"),
      "compare:c->f"
    )
  }

  func testDiffTool_nilLiteral_isDefault() {
    let tool: SnapshotTestingConfiguration.DiffTool = nil
    let viaNil = tool(currentFilePath: "x", failedFilePath: "y")
    let viaDefault = SnapshotTestingConfiguration.DiffTool.default(
      currentFilePath: "x",
      failedFilePath: "y"
    )
    XCTAssertEqual(viaNil, viaDefault)
  }

  // MARK: - Configuration init

  func testConfigurationInit_storesRecordAndDiffTool() {
    let config = SnapshotTestingConfiguration(record: .never, diffTool: .ksdiff)
    XCTAssertEqual(config.record, .never)
    let command = config.diffTool?(currentFilePath: "a", failedFilePath: "b")
    XCTAssertEqual(command, "ksdiff \"a\" \"b\"")
  }

  func testConfigurationInit_allowsNils() {
    let config = SnapshotTestingConfiguration(record: nil, diffTool: nil)
    XCTAssertNil(config.record)
    XCTAssertNil(config.diffTool)
  }

  // MARK: - withSnapshotTesting (sync)

  func testWithSnapshotTesting_setsRecordAndDiffTool() {
    withSnapshotTesting(record: .all, diffTool: .ksdiff) {
      XCTAssertEqual(SnapshotTestingConfiguration.current?.record, .all)
      let command = SnapshotTestingConfiguration.current?.diffTool?(
        currentFilePath: "left",
        failedFilePath: "right"
      )
      XCTAssertEqual(command, "ksdiff \"left\" \"right\"")
    }
  }

  func testWithSnapshotTesting_returnsOperationValue() {
    let value = withSnapshotTesting(record: .never) {
      42
    }
    XCTAssertEqual(value, 42)
  }

  func testWithSnapshotTesting_nesting_innerOverridesRecord() {
    withSnapshotTesting(record: .all) {
      XCTAssertEqual(SnapshotTestingConfiguration.current?.record, .all)
      withSnapshotTesting(record: .never) {
        XCTAssertEqual(SnapshotTestingConfiguration.current?.record, .never)
      }
      XCTAssertEqual(SnapshotTestingConfiguration.current?.record, .all)
    }
  }

  func testWithSnapshotTesting_nesting_inheritsDiffToolWhenNil() {
    withSnapshotTesting(record: .all, diffTool: .ksdiff) {
      withSnapshotTesting(record: .failed) {
        XCTAssertEqual(SnapshotTestingConfiguration.current?.record, .failed)
        let command = SnapshotTestingConfiguration.current?.diffTool?(
          currentFilePath: "1",
          failedFilePath: "2"
        )
        XCTAssertEqual(command, "ksdiff \"1\" \"2\"")
      }
    }
  }

  func testWithSnapshotTesting_nesting_innerDiffToolOverrides() {
    withSnapshotTesting(diffTool: .ksdiff) {
      withSnapshotTesting(diffTool: "diff") {
        let command = SnapshotTestingConfiguration.current?.diffTool?(
          currentFilePath: "a",
          failedFilePath: "b"
        )
        XCTAssertEqual(command, "diff a b")
      }
      let outer = SnapshotTestingConfiguration.current?.diffTool?(
        currentFilePath: "a",
        failedFilePath: "b"
      )
      XCTAssertEqual(outer, "ksdiff \"a\" \"b\"")
    }
  }

  func testWithSnapshotTesting_propagatesThrow() {
    enum SampleError: Error { case boom }
    XCTAssertThrowsError(
      try withSnapshotTesting(record: .never) {
        throw SampleError.boom
      }
    ) { error in
      XCTAssertEqual(error as? SampleError, .boom)
    }
  }

  // MARK: - withSnapshotTesting (async)

  func testWithSnapshotTesting_async_setsConfiguration() async {
    await withSnapshotTesting(record: .missing, diffTool: .ksdiff) {
      XCTAssertEqual(SnapshotTestingConfiguration.current?.record, .missing)
      let command = SnapshotTestingConfiguration.current?.diffTool?(
        currentFilePath: "async-a",
        failedFilePath: "async-b"
      )
      XCTAssertEqual(command, "ksdiff \"async-a\" \"async-b\"")
    }
  }

  func testWithSnapshotTesting_async_returnsValue() async {
    let value = await withSnapshotTesting(record: .all) {
      "ok"
    }
    XCTAssertEqual(value, "ok")
  }

  func testWithSnapshotTesting_async_nestingOverrides() async {
    await withSnapshotTesting(record: .all) {
      XCTAssertEqual(SnapshotTestingConfiguration.current?.record, .all)
      await withSnapshotTesting(record: .never) {
        XCTAssertEqual(SnapshotTestingConfiguration.current?.record, .never)
      }
      XCTAssertEqual(SnapshotTestingConfiguration.current?.record, .all)
    }
  }
}
