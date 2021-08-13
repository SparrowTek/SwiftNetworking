//
//  ParameterEncoding.swift
//  
//
//  Created by Thomas Rademaker on 12/20/20.
//  Copyright © 2020 Barstool Sports. All rights reserved.
//

import Foundation

@available(iOS 15.0, macOS 9999, *)
public typealias Parameters = [String:Any]

@available(iOS 15.0, macOS 9999, *)
public protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

@available(iOS 15.0, macOS 9999, *)
public enum ParameterEncoding {
    
    case urlEncoding(parameters: Parameters)
    case jsonEncoding(parameters: Parameters)
    case urlAndJsonEncoding(urlParameters: Parameters, bodyParameters: Parameters)
    
    public func encode(urlRequest: inout URLRequest) throws {
        do {
            switch self {
            case .urlEncoding(let parameters):
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: parameters)
            case .jsonEncoding(let parameters):
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: parameters)
            case .urlAndJsonEncoding(let urlParameters, let bodyParameters):
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
            }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}
