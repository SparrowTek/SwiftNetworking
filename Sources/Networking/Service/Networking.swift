//
//  Networking.swift
//  
//
//  Created by Thomas Rademaker on 7/6/21.
//

import Foundation

public protocol Networking {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: Networking { }
