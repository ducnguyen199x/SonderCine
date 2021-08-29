//
//  Constants.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import Foundation

enum Constants {
    enum Cache {
        static let defaultSubDirectory = "sondercine.data"
        static let nowPLayingDirectory = "sondercine.data/now_playing"
        static let topRatedDirectory = "sondercine.data/top_rated"
        static let creditsDirectory = "sondercine.data/credits"
        static let movieDetailsDirectory = "sondercine.data/movie_details"
        static let cacheInterval: TimeInterval = 24 * 3600 // 24 hours
    }
    
    enum Localizable {
        static let fileName = "Localizable"
    }
}
