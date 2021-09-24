//
//  File.swift
//  
//
//  Created by Thomas Rademaker on 7/6/21.
//

import Foundation
@testable import Networking

public enum TestAPI {
    case getTest(id: Int)
}

extension TestAPI: EndpointType {
    static let baseURLPath = "http://www.google.com"
    
    public var baseURL: URL {
        guard let url = URL(string: TestAPI.baseURLPath) else { fatalError("baseURL not configured") }
        return url
    }
    
    public var path: String {
        switch self {
        case .getTest(let id): return "/test/\(id)"
        }
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .getTest: return .get
        }
    }
    
    public var task: HTTPTask {
        switch self {
        case .getTest:
            let parameters: [String : Any] = [:]
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        }
    }
    
    public var headers: HTTPHeaders? {
        nil
    }
}
