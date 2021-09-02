//
//  DoubleValue.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 26/8/21.
//

import Foundation

/// Property wrapper for decoding double
@propertyWrapper
struct DoubleValue: Codable, ExpressibleByFloatLiteral {
    var wrappedValue: Double
    
    init(floatLiteral value: FloatLiteralType) {
        wrappedValue = value
    }
    
    init(from decoder: Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(Double.self) {
            wrappedValue = value
        } else {
            wrappedValue = 0
        }
    }
}

extension KeyedDecodingContainer {
    func decode(_ type: DoubleValue.Type, forKey key: Key) throws -> DoubleValue {
        try decodeIfPresent(DoubleValue.self, forKey: key) ?? .init(floatLiteral: 0)
    }
}
