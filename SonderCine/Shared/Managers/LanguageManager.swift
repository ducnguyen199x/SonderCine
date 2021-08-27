//
//  LanguageManager.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import Foundation

enum Language: String, CaseIterable, Equatable {
    case english = "en"
    case vietnamese = "vi"
    
    static func == (_ lhs: Language, rhs: Language) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

class LanguageManager {
    static let shared = LanguageManager()
    private(set) var currentLanguage: Language {
        didSet {
            UserDefaults.standard.defaultAppLanguage = currentLanguage
        }
    }
    
    init() {
        currentLanguage = UserDefaults.standard.defaultAppLanguage
    }
    
    private var loadedBundles: [Language: Bundle] = [:]
    
    var allLanguages = Language.allCases
    
    func setLanguage(_ language: Language) {
        guard currentLanguage != language else { return }
        currentLanguage = language
        NotificationCenter.postLanguageChanged()
    }
    
    func currentBundle() -> Bundle {
        return getLanguageBundle(for: currentLanguage)
    }
    
    func getLanguageBundle(for language: Language) -> Bundle {
        if let bundle = loadedBundles[language] {
            // Return already loaded bundle
            return bundle
        }
        
        if let lproj = Bundle.main.url(forResource: language.rawValue, withExtension: "lproj"),
           let lbundle = Bundle(url: lproj) {
            let strings = lbundle.url(forResource: Constants.Localizable.fileName, withExtension: "strings")
            if strings != nil {
                loadedBundles[language] = lbundle
                return lbundle
            }
        }
        
        loadedBundles[language] = .main
        return .main
    }
}
