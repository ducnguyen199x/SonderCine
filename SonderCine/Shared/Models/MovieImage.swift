//
//  MovieConfiguration.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 25/8/21.
//

import Foundation

protocol ImageType {
    var size: String { get }
}

enum BackdropImage: String, ImageType {
    case w300
    case w780
    case w1280
    case original
    
    var size: String {
        return rawValue
    }
}

enum PosterImage: String, ImageType {
    case w92
    case w154
    case w185
    case original
    
    var size: String {
        return rawValue
    }
}
