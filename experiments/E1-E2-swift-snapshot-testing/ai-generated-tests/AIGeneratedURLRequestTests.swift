import Foundation
import XCTest

@testable import SnapshotTesting

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

#if !os(WASI)

  /// AI-generated unit tests for `Snapshotting` URLRequest strategies.
  /// Uses deterministic string assertions against strategy output (not on-disk snapshots).
  final class AIGeneratedURLRequestTests: XCTestCase {

    // MARK: - Helpers

    private func render<Value>(
      _ value: Value,
      as strategy: Snapshotting<Value, String>
    ) -> String {
      var output: String?
      let expectation = expectation(description: "render snapshot")
      strategy.snapshot(value).run { format in
        output = format
        expectation.fulfill()
      }
      wait(for: [expectation], timeout: 1.0)
      return output!
    }

    private func makeRequest(
      url: String?,
      method: String? = nil,
      headers: [String: String] = [:],
      body: String? = nil
    ) -> URLRequest {
      var request: URLRequest
      if let url {
        request = URLRequest(url: URL(string: url)!)
      } else {
        // URLRequest requires a URL at init; use a placeholder then clear via reflection-safe path.
        // For nil-URL coverage of raw formatting we construct via URL(string:) failure avoidance:
        // use about:blank then replace — raw reads request.url, so we need a true nil URL.
        request = URLRequest(url: URL(string: "https://example.invalid")!)
        // URLRequest.url is settable on Apple platforms
        request.url = nil
      }
      if let method {
        request.httpMethod = method
      }
      for (key, value) in headers {
        request.addValue(value, forHTTPHeaderField: key)
      }
      if let body {
        request.httpBody = Data(body.utf8)
      }
      return request
    }

    // MARK: - raw: normal / methods

    func testRaw_defaultMethodIsGETWhenHttpMethodNil() {
      var request = URLRequest(url: URL(string: "https://example.com/path")!)
      request.httpMethod = nil
      let output = render(request, as: .raw)
      XCTAssertEqual(output, "GET https://example.com/path")
    }

    func testRaw_explicitGET() {
      let request = makeRequest(url: "https://example.com/", method: "GET")
      XCTAssertEqual(render(request, as: .raw), "GET https://example.com/")
    }

    func testRaw_POST() {
      let request = makeRequest(url: "https://example.com/subscribe", method: "POST")
      XCTAssertEqual(render(request, as: .raw), "POST https://example.com/subscribe")
    }

    func testRaw_PUT() {
      let request = makeRequest(url: "https://example.com/item/1", method: "PUT")
      XCTAssertEqual(render(request, as: .raw), "PUT https://example.com/item/1")
    }

    func testRaw_DELETE() {
      let request = makeRequest(url: "https://example.com/item/1", method: "DELETE")
      XCTAssertEqual(render(request, as: .raw), "DELETE https://example.com/item/1")
    }

    func testRaw_HEAD() {
      let request = makeRequest(url: "https://example.com/", method: "HEAD")
      XCTAssertEqual(render(request, as: .raw), "HEAD https://example.com/")
    }

    func testRaw_PATCH() {
      let request = makeRequest(url: "https://example.com/", method: "PATCH")
      XCTAssertEqual(render(request, as: .raw), "PATCH https://example.com/")
    }

    // MARK: - raw: headers

    func testRaw_headersAreSortedAlphabetically() {
      var request = makeRequest(url: "https://example.com/", method: "GET")
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.setValue("text/html", forHTTPHeaderField: "Accept")
      request.setValue("Bearer tok", forHTTPHeaderField: "Authorization")

      let expected = """
        GET https://example.com/
        Accept: text/html
        Authorization: Bearer tok
        Content-Type: application/json
        """
      XCTAssertEqual(render(request, as: .raw), expected)
    }

    func testRaw_includesCookieHeaderInRawOutput() {
      var request = makeRequest(url: "https://example.com/", method: "GET")
      request.setValue("session=abc", forHTTPHeaderField: "Cookie")
      request.setValue("text/plain", forHTTPHeaderField: "Accept")

      let expected = """
        GET https://example.com/
        Accept: text/plain
        Cookie: session=abc
        """
      XCTAssertEqual(render(request, as: .raw), expected)
    }

    func testRaw_emptyHeaderDictionary() {
      var request = URLRequest(url: URL(string: "https://example.com/")!)
      request.httpMethod = "GET"
      request.allHTTPHeaderFields = [:]
      XCTAssertEqual(render(request, as: .raw), "GET https://example.com/")
    }

    // MARK: - raw: body

    func testRaw_includesBodyWithLeadingBlankLine() {
      var request = makeRequest(url: "https://example.com/", method: "POST")
      request.httpBody = Data("name=blob".utf8)

      let expected = """
        POST https://example.com/

        name=blob
        """
      XCTAssertEqual(render(request, as: .raw), expected)
    }

    func testRaw_bodyWithHeaders() {
      var request = makeRequest(url: "https://example.com/", method: "POST")
      request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
      request.httpBody = Data("a=1&b=2".utf8)

      let expected = """
        POST https://example.com/
        Content-Type: application/x-www-form-urlencoded

        a=1&b=2
        """
      XCTAssertEqual(render(request, as: .raw), expected)
    }

    func testRaw_noBodyOmitsBodySection() {
      let request = makeRequest(url: "https://example.com/", method: "POST")
      XCTAssertEqual(render(request, as: .raw), "POST https://example.com/")
    }

    func testRaw_prettyFalseDoesNotPrettyPrintJSON() {
      var request = makeRequest(url: "https://example.com/", method: "POST")
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = Data(#"{"b":2,"a":1}"#.utf8)

      let expected = """
        POST https://example.com/
        Content-Type: application/json

        {"b":2,"a":1}
        """
      XCTAssertEqual(render(request, as: .raw), expected)
      XCTAssertEqual(render(request, as: .raw(pretty: false)), expected)
    }

    // MARK: - raw(pretty:)

    func testRawPretty_prettyPrintsAndSortsJSONKeys() {
      var request = makeRequest(url: "https://example.com/api", method: "POST")
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = Data(#"{"name":"tammy","salary":0,"age":"33"}"#.utf8)

      let output = render(request, as: .raw(pretty: true))

      XCTAssertTrue(output.hasPrefix("POST https://example.com/api\nContent-Type: application/json\n\n"))
      // Pretty JSON should contain sorted keys and indentation.
      XCTAssertTrue(output.contains("\"age\""))
      XCTAssertTrue(output.contains("\"name\""))
      XCTAssertTrue(output.contains("\"salary\""))
      if let ageRange = output.range(of: "\"age\""),
        let nameRange = output.range(of: "\"name\""),
        let salaryRange = output.range(of: "\"salary\"")
      {
        XCTAssertLessThan(ageRange.lowerBound, nameRange.lowerBound)
        XCTAssertLessThan(nameRange.lowerBound, salaryRange.lowerBound)
      } else {
        XCTFail("Expected pretty JSON keys in output:\n\(output)")
      }
      XCTAssertFalse(output.contains(#"{"name":"tammy","salary":0,"age":"33"}"#))
    }

    func testRawPretty_exactPrettyJSONBody() throws {
      var request = makeRequest(url: "https://example.com/", method: "POST")
      let original = Data(#"{"z":1,"a":2}"#.utf8)
      request.httpBody = original

      let prettyData = try JSONSerialization.data(
        withJSONObject: try JSONSerialization.jsonObject(with: original),
        options: [.prettyPrinted, .sortedKeys]
      )
      let prettyString = String(decoding: prettyData, as: UTF8.self)

      let expected = """
        POST https://example.com/

        \(prettyString)
        """
      XCTAssertEqual(render(request, as: .raw(pretty: true)), expected)
    }

    func testRawPretty_invalidJSONFallsBackToRawBody() {
      var request = makeRequest(url: "https://example.com/", method: "POST")
      request.httpBody = Data("not-json{".utf8)

      let expected = """
        POST https://example.com/

        not-json{
        """
      XCTAssertEqual(render(request, as: .raw(pretty: true)), expected)
    }

    func testRawPretty_emptyBody() {
      let request = makeRequest(url: "https://example.com/", method: "POST")
      XCTAssertEqual(render(request, as: .raw(pretty: true)), "POST https://example.com/")
    }

    func testRawPretty_jsonArray() throws {
      var request = makeRequest(url: "https://example.com/", method: "POST")
      let original = Data(#"[3,1,2]"#.utf8)
      request.httpBody = original
      let prettyData = try JSONSerialization.data(
        withJSONObject: try JSONSerialization.jsonObject(with: original),
        options: [.prettyPrinted, .sortedKeys]
      )
      let prettyString = String(decoding: prettyData, as: UTF8.self)
      let expected = """
        POST https://example.com/

        \(prettyString)
        """
      XCTAssertEqual(render(request, as: .raw(pretty: true)), expected)
    }

    // MARK: - raw: query parameters

    func testRaw_sortsQueryParameterNames() {
      let request = makeRequest(
        url: "https://example.com/search?z=9&a=1&m=5",
        method: "GET"
      )
      XCTAssertEqual(
        render(request, as: .raw),
        "GET https://example.com/search?a=1&m=5&z=9"
      )
    }

    func testRaw_preservesQueryValuesWhileSortingNames() {
      let request = makeRequest(
        url: "https://example.com/?key_2=value_2&key_1=value_1&key_3=value_3",
        method: "GET"
      )
      XCTAssertEqual(
        render(request, as: .raw),
        "GET https://example.com/?key_1=value_1&key_2=value_2&key_3=value_3"
      )
    }

    func testRaw_noQueryParametersUnchanged() {
      let request = makeRequest(url: "https://example.com/path", method: "GET")
      XCTAssertEqual(render(request, as: .raw), "GET https://example.com/path")
    }

    // MARK: - raw: edge cases

    func testRaw_nilURLRendersNullPlaceholder() {
      let request = makeRequest(url: nil, method: "GET")
      XCTAssertEqual(render(request, as: .raw), "GET (null)")
    }

    func testRaw_nilURLWithHeadersAndBody() {
      var request = makeRequest(url: nil, method: "POST")
      request.setValue("1", forHTTPHeaderField: "X-Test")
      request.httpBody = Data("body".utf8)
      let expected = """
        POST (null)
        X-Test: 1

        body
        """
      XCTAssertEqual(render(request, as: .raw), expected)
    }

    func testRaw_staticRawMatchesPrettyFalse() {
      var request = makeRequest(url: "https://example.com/", method: "POST")
      request.httpBody = Data(#"{"a":1}"#.utf8)
      XCTAssertEqual(
        render(request, as: .raw),
        render(request, as: .raw(pretty: false))
      )
    }

    // MARK: - curl: methods

    func testCurl_GETOmitsRequestFlag() {
      let request = makeRequest(url: "https://example.com/", method: "GET")
      XCTAssertEqual(
        render(request, as: .curl),
        """
        curl \\
        \t"https://example.com/"
        """
      )
    }

    func testCurl_HEADUsesHeadFlag() {
      let request = makeRequest(url: "https://example.com/", method: "HEAD")
      XCTAssertEqual(
        render(request, as: .curl),
        """
        curl \\
        \t--head \\
        \t"https://example.com/"
        """
      )
    }

    func testCurl_POSTUsesRequestFlag() {
      let request = makeRequest(url: "https://example.com/", method: "POST")
      XCTAssertEqual(
        render(request, as: .curl),
        """
        curl \\
        \t--request POST \\
        \t"https://example.com/"
        """
      )
    }

    func testCurl_PUTUsesRequestFlag() {
      let request = makeRequest(url: "https://example.com/", method: "PUT")
      XCTAssertEqual(
        render(request, as: .curl),
        """
        curl \\
        \t--request PUT \\
        \t"https://example.com/"
        """
      )
    }

    func testCurl_DELETEUsesRequestFlag() {
      let request = makeRequest(url: "https://example.com/", method: "DELETE")
      XCTAssertEqual(
        render(request, as: .curl),
        """
        curl \\
        \t--request DELETE \\
        \t"https://example.com/"
        """
      )
    }

    func testCurl_PATCHUsesRequestFlag() {
      let request = makeRequest(url: "https://example.com/", method: "PATCH")
      XCTAssertEqual(
        render(request, as: .curl),
        """
        curl \\
        \t--request PATCH \\
        \t"https://example.com/"
        """
      )
    }

    // MARK: - curl: headers

    func testCurl_headersSortedAndQuotedExcludingCookie() {
      var request = makeRequest(url: "https://example.com/", method: "GET")
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.setValue("text/html", forHTTPHeaderField: "Accept")
      request.setValue("session=1", forHTTPHeaderField: "Cookie")

      let expected = """
        curl \\
        \t--header "Accept: text/html" \\
        \t--header "Content-Type: application/json" \\
        \t--cookie "session=1" \\
        \t"https://example.com/"
        """
      XCTAssertEqual(render(request, as: .curl), expected)
    }

    func testCurl_escapesDoubleQuotesInHeaderValues() {
      var request = makeRequest(url: "https://example.com/", method: "GET")
      request.setValue("value with \"quotes\"", forHTTPHeaderField: "X-Custom")

      let expected = """
        curl \\
        \t--header "X-Custom: value with \\"quotes\\"" \\
        \t"https://example.com/"
        """
      XCTAssertEqual(render(request, as: .curl), expected)
    }

    func testCurl_noHeaders() {
      var request = URLRequest(url: URL(string: "https://example.com/")!)
      request.httpMethod = "GET"
      request.allHTTPHeaderFields = nil
      XCTAssertEqual(
        render(request, as: .curl),
        """
        curl \\
        \t"https://example.com/"
        """
      )
    }

    // MARK: - curl: cookies

    func testCurl_cookieEmittedSeparatelyAndEscaped() {
      var request = makeRequest(url: "https://example.com/", method: "GET")
      request.setValue("pf_session={\"user_id\":\"0\"}", forHTTPHeaderField: "Cookie")

      let expected = """
        curl \\
        \t--cookie "pf_session={\\"user_id\\":\\"0\\"}" \\
        \t"https://example.com/"
        """
      XCTAssertEqual(render(request, as: .curl), expected)
    }

    func testCurl_cookieOnlyNoOtherHeaders() {
      var request = makeRequest(url: "https://example.com/", method: "GET")
      request.setValue("a=b", forHTTPHeaderField: "Cookie")
      let expected = """
        curl \\
        \t--cookie "a=b" \\
        \t"https://example.com/"
        """
      XCTAssertEqual(render(request, as: .curl), expected)
    }

    // MARK: - curl: body

    func testCurl_includesDataForUTF8Body() {
      var request = makeRequest(url: "https://example.com/", method: "POST")
      request.httpBody = Data("pricing[billing]=monthly".utf8)

      let expected = """
        curl \\
        \t--request POST \\
        \t--data "pricing[billing]=monthly" \\
        \t"https://example.com/"
        """
      XCTAssertEqual(render(request, as: .curl), expected)
    }

    func testCurl_escapesQuotesInBody() {
      var request = makeRequest(url: "https://example.com/", method: "POST")
      request.httpBody = Data(#"{"name":"tammy"}"#.utf8)

      let expected = """
        curl \\
        \t--request POST \\
        \t--data "{\\"name\\":\\"tammy\\"}" \\
        \t"https://example.com/"
        """
      XCTAssertEqual(render(request, as: .curl), expected)
    }

    func testCurl_escapesBackslashQuoteSequencesInBody() {
      var request = makeRequest(url: "https://example.com/", method: "POST")
      // Body containing \" should become \\\" then quotes escaped.
      request.httpBody = Data(#"say \"hi\""#.utf8)

      let output = render(request, as: .curl)
      XCTAssertTrue(output.contains("--data "), output)
      XCTAssertTrue(output.hasPrefix("curl \\\n\t--request POST \\\n\t--data \""), output)
      XCTAssertTrue(output.hasSuffix(" \\\n\t\"https://example.com/\""), output)
    }

    func testCurl_omitsDataWhenBodyMissing() {
      let request = makeRequest(url: "https://example.com/", method: "POST")
      XCTAssertFalse(render(request, as: .curl).contains("--data"))
    }

    func testCurl_omitsDataWhenBodyNotUTF8() {
      var request = makeRequest(url: "https://example.com/", method: "POST")
      request.httpBody = Data([0xFF, 0xFE, 0xFD])
      XCTAssertFalse(render(request, as: .curl).contains("--data"))
      XCTAssertTrue(
        render(request, as: .curl).contains("--request POST"),
        render(request, as: .curl)
      )
    }

    // MARK: - curl: query parameters

    func testCurl_sortsQueryParameters() {
      let request = makeRequest(
        url: "https://example.com/?c=3&a=1&b=2",
        method: "GET"
      )
      XCTAssertEqual(
        render(request, as: .curl),
        """
        curl \\
        \t"https://example.com/?a=1&b=2&c=3"
        """
      )
    }

    // MARK: - curl: combined

    func testCurl_fullPOSTWithHeadersCookieBodyAndQuery() {
      var request = makeRequest(
        url: "https://example.com/subscribe?z=9&a=1",
        method: "POST"
      )
      request.setValue("text/html", forHTTPHeaderField: "Accept")
      request.setValue("pf_session={}", forHTTPHeaderField: "Cookie")
      request.httpBody = Data("x=1&y=2".utf8)

      let expected = """
        curl \\
        \t--request POST \\
        \t--header "Accept: text/html" \\
        \t--data "x=1&y=2" \\
        \t--cookie "pf_session={}" \\
        \t"https://example.com/subscribe?a=1&z=9"
        """
      XCTAssertEqual(render(request, as: .curl), expected)
    }

    // MARK: - strategy identity / path extension

    func testStrategies_useTxtPathExtensionViaLines() {
      XCTAssertEqual(Snapshotting<URLRequest, String>.raw.pathExtension, "txt")
      XCTAssertEqual(Snapshotting<URLRequest, String>.raw(pretty: true).pathExtension, "txt")
      XCTAssertEqual(Snapshotting<URLRequest, String>.curl.pathExtension, "txt")
    }
  }

#endif
