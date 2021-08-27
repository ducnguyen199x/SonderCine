//
//  DisplaySettingsViewModel.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import Foundation
import UIKit

/// `Theme` types
enum Theme: String, CaseIterable {
    case systemDefault = "System Default", light = "Light", dark = "Dark"
    
    var interfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .systemDefault: return .unspecified
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    var displayName: String {
        switch self {
        case .systemDefault:
            return LocalizedKey.Settings.themeDefault.localized()
        case .light:
            return LocalizedKey.Settings.themeLight.localized()
        case .dark:
            return LocalizedKey.Settings.themeDark.localized()
        }
    }
}

final class DisplaySettingsViewModel: BaseViewModel {
    let themeOptions = Theme.allCases
    
    var themSelectedIndex: Int {
        let currentTheme = AppSettings.shared.getSavedAppTheme()
        for (index, value) in themeOptions.enumerated() where currentTheme.rawValue == value.rawValue {
            return index
        }
        return 0
    }
    
    func setTheme(_ rawValue: String) {
        guard let newTheme = Theme(rawValue: rawValue) else { return }
        AppSettings.shared.setTheme(newTheme)
    }
}
