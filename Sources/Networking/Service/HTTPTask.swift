//
//  HTTPTask.swift
//
//
//  Created by Thomas Rademaker on 12/20/20.
//  Copyright © 2020 Barstool Sports. All rights reserved.
//

@available(iOS 15.0, macOS 9999, *)
public enum HTTPTask {
    case request
    
    case requestParameters(encoding: ParameterEncoding)
    
    // case download, upload...etc
}
