//
//  DateValue.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 26/8/21.
//

import Foundation

protocol DateDecodingStrategy {
  associatedtype T: Decodable
  
  /// Format a string into a date
  static func date(from string: T) -> Date?
}

struct DateFormatterGeneral: DateDecodingStrategy {
  static func date(from string: String) -> Date? {
    DateFormatter.general.date(from: string)
  }
}

/// Property wrapper for decoding date value with suitable strategy
@propertyWrapper
struct DateValue<Strategy: DateDecodingStrategy>: Codable {
  var wrappedValue: Date?

  init() {} // Init with nil wrappedValue
  init(from decoder: Decoder) throws {
    if let value = try? decoder.singleValueContainer().decode(Strategy.T.self) {
      wrappedValue = Strategy.date(from: value)
    } else {
    wrappedValue = nil
    }
  }
}

/// Make sure the wrapper will use `decodeIfPresent`
extension KeyedDecodingContainer {
  func decode<Strategy: DateDecodingStrategy>(_ type: DateValue<Strategy>.Type, forKey key: Key) throws -> DateValue<Strategy> {
    try decodeIfPresent(type, forKey: key) ?? DateValue()
  }
}
