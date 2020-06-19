import XCTest
import Combine
@testable import SparrowTekNetworking

final class SparrowTekNetworkingTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        XCTAssertEqual(SparrowTekNetworking().text, "Hello, World!")
    }
    
    func testGet() {
//        let router = NetworkRouter<TestAPI>()
//        
//        let cancelable = (router.request(TestAPI.get) as AnyPublisher<TestObject, Never>)
    }
    
    func testPost() {
        
    }

    static var allTests = [
        ("testGet", testGet),
        ("testPost", testPost),
    ]
}

struct TestObject: ResponseObject {
    let name: String
    let arg2: Int
    
    static func emptyImplementation() -> TestObject {
        return TestObject(name: "", arg2: 0)
    }
}

enum TestAPI {
    case get
    case getWithParameter(parameter: String)
    case post
    case postWithParameter(parameter: String)
}

extension TestAPI: EndPointType {
    static let baseURLPath = "localhost"
    
    var baseURL: URL {
        guard let url = URL(string: TestAPI.baseURLPath) else { fatalError("baseURL not configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .get, .getWithParameter:
            return "get/"
        case .post, .postWithParameter:
            return "post/"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .get,
             .getWithParameter:
             return .get
        case .post,
             .postWithParameter:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .get:
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: nil)
        case .getWithParameter(let parameter):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: ["parameter" : parameter])
        case .post:
            return .requestParameters(bodyParameters: nil, bodyEncoding: .jsonEncoding, urlParameters: nil)
        case .postWithParameter(let parameter):
            return .requestParameters(bodyParameters: ["parameter" : parameter], bodyEncoding: .jsonEncoding, urlParameters: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
//        case .post:
//            return ["x-access-token" : Key.accessToken]
        default:
            return nil
        }
    }
}
