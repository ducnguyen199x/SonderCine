//
//  Localization.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, bundle: LanguageManager.shared.currentBundle(), comment: "")
    }
}

extension RawRepresentable where Self.RawValue == String {
    func localized() -> String {
        return rawValue.localized
    }
}

struct LocalizedKey {
    enum TabBar: String, RawRepresentable {
        case nowPlaying = "now_playing"
        case topRated = "top_rated"
    }
    
    enum Settings: String, RawRepresentable {
        case title = "settings.title"
        case general = "settings.general"
        case languages = "settings.languages"
        case english = "settings.languages.english"
        case vietnamese = "settings.languages.vietnamese"
        case display = "settings.display"
        case about = "settings.about"
        case version = "settings.version"
        case privacy = "settings.privacy"
        case terms = "settings.terms"
        case theme = "settings.theme"
        case themeDefault = "settings.theme.default"
        case themeLight = "settings.theme.light"
        case themeDark = "settings.theme.dark"
    }
    
    enum MovieDetails: String, RawRepresentable {
        case title = "detail.title"
        case castAndCrews = "detail.cast_crews"
        case seeAll = "detail.see_all"
        case director = "detail.director"
    }
}
