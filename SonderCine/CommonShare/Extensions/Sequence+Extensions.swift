//
//  Sequence+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import Foundation

public enum SortOrder {
    case ascending
    case descending
}

extension Sequence {
    public func sorted<Value>(
        by keyPath: KeyPath<Self.Element, Value?>,
        using areInIncreasingOrder: (Value?, Value?) throws -> Bool) rethrows -> [Self.Element] {
        return try self.sorted(by: {
            try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
        })
    }
    
    public func sorted<Value>(
        by keyPath: KeyPath<Self.Element, Value>,
        using areInIncreasingOrder: (Value, Value) throws -> Bool) rethrows -> [Self.Element] {
        return try self.sorted(by: {
            try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
        })
    }
    
    public func sorted<Value: Comparable>(
        by keyPath: KeyPath<Self.Element, Value?>,
        sortOrder: SortOrder = .ascending) -> [Self.Element] {
        switch sortOrder {
        case .ascending:
            return self.sorted(by: keyPath, using: <?)
        case .descending:
            return self.sorted(by: keyPath, using: >?)
        }
    }
    
    public func sorted<Value: Comparable>(
        by keyPath: KeyPath<Self.Element, Value>,
        sortOrder: SortOrder = .ascending) -> [Self.Element] {
        switch sortOrder {
        case .ascending:
            return self.sorted(by: keyPath, using: <)
        case .descending:
            return self.sorted(by: keyPath, using: >)
        }
    }
}
