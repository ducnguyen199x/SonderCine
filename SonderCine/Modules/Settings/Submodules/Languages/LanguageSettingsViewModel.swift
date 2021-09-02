//
//  LanguageSettingsViewModel.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import Foundation

final class LanguageSettingsViewModel: BaseViewModel {
    let languages = Language.allCases
    
    var selectedIndex: Int {
        let currentLanguage = LanguageManager.shared.currentLanguage
        for (index, value) in languages.enumerated() where currentLanguage.rawValue == value.rawValue {
            return index
        }
        return 0
    }   
    
    func setLanguage(_ index: Int) {
        guard let newLanguage = languages[safe: index] else { return }
        LanguageManager.shared.setLanguage(newLanguage)
    }
}
