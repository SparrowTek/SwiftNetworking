//
//  EndpointType.swift
//
//
//  Created by Thomas Rademaker on 12/20/20.
//  Copyright © 2020 Barstool Sports. All rights reserved.
//

import Foundation

public protocol EndpointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
