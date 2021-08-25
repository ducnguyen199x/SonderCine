//
//  Codable+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import Foundation

extension KeyedDecodingContainer {
    func decodeDateFromTimestamp(forKey key: K, divisor: Double = 1) throws -> Date {
        do {
            let timestamp = try decode(TimeInterval.self, forKey: key)
            return Date(timeIntervalSince1970: max(timestamp, 0) / max(divisor, 1))
        } catch let error {
            throw error
        }
    }
    
    func decodeWithoutPercentEncoding<T: Decodable>(_ type: T.Type, forKey key: K) throws -> T? {
        do {
            let string = try decode(String.self, forKey: key)
            let validStr = string.removingPercentEncoding?.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let validStrData = validStr?.data(using: .utf8) else { return nil }
            return try JSONDecoder().decode(type, from: validStrData)
        } catch let error {
            debugPrint(error)
            return nil
        }
    }
    
    func decodeWithoutPercentEncoding(_ type: String.Type, forKey key: K) throws -> String? {
        do {
            let string = try decode(String.self, forKey: key)
            return string.removingPercentEncoding?.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch let error {
            debugPrint(error)
            return nil
        }
    }
    
    func decodeStringToBool(forKey key: K) throws -> Bool {
        do {
            let string = try decode(String.self, forKey: key)
            return string.trimmingCharacters(in: .whitespacesAndNewlines) == "true"
        } catch let error {
            throw error
        }
    }
    
    func decodeDateFromString(forKey key: K) throws -> Date? {
        do {
            let string = try decode(String.self, forKey: key)
            let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
            return DateFormatter.format1.date(from: trimmed)
        } catch let error {
            throw error
        }
    }
}
