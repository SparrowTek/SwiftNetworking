//
//  TestObject.swift
//  
//
//  Created by Thomas Rademaker on 7/6/21.
//

import Foundation

struct TestObject: Codable {
    let stringValue: String?
    let intValue: Int?
    let boolValue: Bool?
    let dictValue: TestDictObject?
    let arrayValue: [String]?
}

struct TestDictObject: Codable {
    let stringValue: String
}

extension TestObject {
    var dataValue: Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try! encoder.encode(self)
    }
}
