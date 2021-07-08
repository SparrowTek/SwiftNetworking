//
//  HTTPTask.swift
//
//
//  Created by Thomas Rademaker on 12/20/20.
//  Copyright © 2020 Barstool Sports. All rights reserved.
//

public enum HTTPTask {
    case request
    
    case requestParameters(encoding: ParameterEncoding)
    
    // case download, upload...etc
}
