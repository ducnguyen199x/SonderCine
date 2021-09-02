//
//  IntValue.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 26/8/21.
//

import Foundation

/// Property wrapper for decoding int
@propertyWrapper
struct IntValue: Codable, ExpressibleByIntegerLiteral {
    var wrappedValue: Int
    
    init(integerLiteral value: IntegerLiteralType) {
        wrappedValue = value
    }
    
    init(from decoder: Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(Int.self) {
            wrappedValue = value
        } else {
            wrappedValue = 0
        }
    }
}

extension KeyedDecodingContainer {
    func decode(_ type: IntValue.Type, forKey key: Key) throws -> IntValue {
        try decodeIfPresent(IntValue.self, forKey: key) ?? .init(integerLiteral: 0)
    }
}
