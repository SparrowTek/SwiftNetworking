//
//  Encodable.swift
//  
//
//  Created by Thomas Rademaker on 2/11/22.
//

import Foundation

extension Encodable {
    func toJSONData() throws -> Data {
        try JSONEncoder().encode(self)
    }
}
