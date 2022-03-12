//
//  Encodable.swift
//  
//
//  Created by Thomas Rademaker on 2/11/22.
//

import Foundation

extension Encodable {
    public func toJSONData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
