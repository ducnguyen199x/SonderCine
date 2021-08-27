//
//  UserDefaults+Ex.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import Foundation

extension UserDefaults {
    var theme: Theme {
        get {
            if let result = value(forKey: #function) as? String {
                return Theme(rawValue: result) ?? .dark
            }
            return Theme.dark
        }
        set { set(newValue.rawValue, forKey: #function) }
    }
}
