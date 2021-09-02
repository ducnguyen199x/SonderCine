//
//  Comparable+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import Foundation

infix operator ==? : ComparisonPrecedence
infix operator <? : ComparisonPrecedence
infix operator >? : ComparisonPrecedence

func ==? <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    if let lhs = lhs, let rhs = rhs {
        return lhs == rhs
    } else {
        return lhs == nil && rhs == nil
    }
}

func <? <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    if let lhs = lhs, let rhs = rhs {
        return lhs < rhs
    } else {
        return false
    }
}

func >? <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    if let lhs = lhs, let rhs = rhs {
        return lhs > rhs
    } else {
        return false
    }
}
