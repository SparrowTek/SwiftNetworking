//
//  EndpointType.swift
//  Avocadough
//
//  Created by Thomas Rademaker on 2/10/19.
//  Copyright © 2019 SparrowTek LLC. All rights reserved.
//

import Foundation

public protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
