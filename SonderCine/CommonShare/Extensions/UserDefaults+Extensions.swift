//
//  UserDefaults+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import Foundation

extension UserDefaults {

    var isFirstLaunch: Bool {
        get {
            if let result = value(forKey: #function) as? Bool {
                return result
            }
            return true
        }
        set { set(newValue, forKey: #function) }
    }
}
