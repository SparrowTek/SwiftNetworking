import XCTest

#if !canImport(ObjectiveC)
@available(iOS 15.0, macOS 10.15, *)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(NetworkingTests.allTests),
    ]
}
#endif
