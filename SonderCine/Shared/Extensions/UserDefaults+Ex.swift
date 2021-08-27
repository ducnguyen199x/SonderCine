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
            return .dark
        }
        set { set(newValue.rawValue, forKey: #function) }
    }
    
    var defaultAppLanguage: Language {
        get {
            if let result = value(forKey: #function) as? String {
                return Language(rawValue: result) ?? .english
            }
            return .english
        }
        set { set(newValue.rawValue, forKey: #function) }
    }
}
