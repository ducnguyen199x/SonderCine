//
//  GeoCoding.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 30/8/21.
//

import Foundation

struct Geocoding: Decodable {
    var geometry: Geometry
}

struct Geometry: Decodable {
    var location: Coordinate
}

struct Coordinate: Decodable {
    var lat: Double
    var lng: Double
}
