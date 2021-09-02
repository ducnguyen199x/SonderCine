//
//  AppSettings.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import Foundation
import UIKit

class AppSettings: NSObject {
    static let shared = AppSettings()
    private override init() {}
    
    func saveAppTheme(_ theme: Theme) {
        UserDefaults.standard.theme = theme
    }
    
    func getSavedAppTheme() -> Theme {
        UserDefaults.standard.theme
    }
    
    func setTheme(_ theme: Theme) {
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = theme.interfaceStyle
        }
        saveAppTheme(theme)
    }
    
    func loadSavedAppTheme() {
        setTheme(getSavedAppTheme())
    }
}
