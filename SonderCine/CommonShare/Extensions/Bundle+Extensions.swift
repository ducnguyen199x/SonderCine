//
//  Bundle+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import Foundation

extension Bundle {
    static func loadJsonData(from fileName: String) -> Data? {
        guard let path = main.path(forResource: fileName, ofType: "json") else { return nil }
        return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }
    
    var currentAppVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    static func userDefine(key: String) -> String? {
        guard let infoDictionary = main.infoDictionary?["UserDefine"] as? [String: Any] else { return nil }
        return infoDictionary[key] as? String
    }
}
