//
//  ParameterEncoding.swift
//  
//
//  Created by Thomas Rademaker on 12/20/20.
//  Copyright © 2020 SparrowTek. All rights reserved.
//

import Foundation

public typealias Parameters = [String:Any]

public protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum ParameterEncoding {
    
    case urlEncoding(parameters: Parameters)
    case jsonEncoding(parameters: Parameters)
    case jsonDataEncoding(data: Data?)
    case jsonEncodableEncoding(encodable: Encodable)
    case urlAndJsonEncoding(urlParameters: Parameters, bodyParameters: Parameters)
    
    public func encode(urlRequest: inout URLRequest) throws {
        do {
            switch self {
            case .urlEncoding(let parameters):
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: parameters)
            case .jsonEncoding(let parameters):
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: parameters)
            case .jsonDataEncoding(let data):
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: data)
            case .jsonEncodableEncoding(let encodable):
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: encodable)
            case .urlAndJsonEncoding(let urlParameters, let bodyParameters):
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
            }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}
