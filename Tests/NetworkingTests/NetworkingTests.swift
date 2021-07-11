import XCTest
@testable import Networking

final class NetworkingTests: XCTestCase {
    
    func testBuildRequest() {
        do {
            let router = NetworkRouter<TestAPI>(networking: MockNetworking())
            let request = try router.buildRequest(from: .getTest(id: 123))
            XCTAssertEqual(request.httpMethod, "GET", "Wrong http method. Should be GET but is: \(String(describing: request.httpMethod))")
            XCTAssertEqual(request.url, URL(string: "\(TestAPI.baseURLPath)/test/123"), "Wrong url. Should be \(TestAPI.baseURLPath)/test/123 but is: \(String(describing: request.url))")
        } catch {
            XCTFail("Expected XXX, but failed with error: \(error)")
        }
    }
    
    @available(iOS 15.0, macOS 10.15, *)
    func testExecute() async throws {
        do {
            let testData = TestObject(stringValue: "testString", intValue: nil, boolValue: nil, dictValue: nil, arrayValue: nil).dataValue
            let response = HTTPURLResponse(url: URL(string: "http://www.google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            let router = NetworkRouter<TestAPI>(networking: MockNetworking(resonseData: testData, urlResponse: response))
            let test: TestObject = try await router.execute(.getTest(id: 123))
            XCTAssert(test.stringValue == "testString", "Wrong value for Test. Should be testString but is: \(String(describing: test.stringValue))")
        } catch {
            XCTFail("Expected XXX, but failed with error: \(error)")
        }
    }

    @available(iOS 15.0, macOS 10.15, *)
    static var allTests = [
        ("testExecute", testExecute),
        ("testBuildRequest", testBuildRequest),
    ]
}
