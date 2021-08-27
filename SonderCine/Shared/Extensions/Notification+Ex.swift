//
//  Notification+Ex.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import Foundation

extension NSNotification.Name {
    static let languageChanged = NSNotification.Name(rawValue: "LanguageChanged")
}

extension NotificationCenter {
    class func postLanguageChanged() {
        self.default.post(name: .languageChanged, object: nil)
    }
}
