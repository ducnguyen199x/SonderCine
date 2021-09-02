//
//  StringValue.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 26/8/21.
//

import Foundation

/// Property wrapper for decoding string
@propertyWrapper
struct StringValue: Codable, ExpressibleByStringLiteral {
    var wrappedValue: String
    
    init(stringLiteral value: StringLiteralType) {
        wrappedValue = value
    }
    
    init(from decoder: Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(String.self) {
            wrappedValue = value
        } else {
            wrappedValue = ""
        }
    }
}

extension KeyedDecodingContainer {
    func decode(_ type: StringValue.Type, forKey key: Key) throws -> StringValue {
        try decodeIfPresent(StringValue.self, forKey: key) ?? .init(stringLiteral: "")
    }
}
