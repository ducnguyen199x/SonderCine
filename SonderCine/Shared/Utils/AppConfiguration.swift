//
//  AppConfiguration.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 25/8/21.
//

import Foundation

enum AppConfiguration: String {
    case apiEndpoint = "API_ENDPOINT"
    case theMovieDBAPIKey = "THE_MOVIE_DB_API_KEY"
    case imageEndpoint = "IMAGE_ENDPOINT"
    
    var value: String? {
        guard let infoDictionary = Bundle.main.infoDictionary?["UserDefined"] as? [String: Any] else { return nil }
        return infoDictionary[rawValue] as? String
    }
}
