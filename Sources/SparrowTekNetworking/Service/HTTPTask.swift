//
//  HTTPTask.swift
//  Avocadough
//
//  Created by Thomas Rademaker on 2/10/19.
//  Copyright © 2019 SparrowTek. All rights reserved.
//

public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    
    // case download, upload...etc
}
