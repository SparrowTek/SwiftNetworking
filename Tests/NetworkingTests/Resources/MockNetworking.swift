//
//  MockNetworking.swift
//  
//
//  Created by Thomas Rademaker on 7/6/21.
//

import Foundation
@testable import Networking

class MockNetworking: Networking {
    var responseData: Data?
    var urlResponse: URLResponse?
    
    init(resonseData: Data? = nil, urlResponse: URLResponse? = nil) {
        self.responseData = resonseData
        self.urlResponse = urlResponse
    }
    
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        guard let responseData = responseData, let urlResponse = urlResponse else { return (Data(), URLResponse()) }
        return (responseData, urlResponse)
    }
}
