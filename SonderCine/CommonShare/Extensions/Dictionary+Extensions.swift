//
//  Dictionary+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import Foundation

public typealias JSON = [String: Any]

extension Dictionary where Key: StringProtocol, Value: Any {
    func data() -> Data? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return data
        } catch {
            debugPrint("Error converting data: \(error)")
            return nil
        }
    }
}

extension Dictionary where Key == String {
    subscript(caseInsensitive key: Key) -> Value? {
        guard let key = keys.first(where: { $0.caseInsensitiveCompare(key) == .orderedSame }) else {
            return nil
        }
        return self[key]
    }
}
