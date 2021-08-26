//
//  Movie.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 26/8/21.
//

import Foundation

struct MovieListWrapper: Codable {
    var page: Int
    var totalPages: Int
    var results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}

struct Movie: Codable {
    var id: Int
    var backdropPath: String?
    var posterPath: String?
    var genres: [Genre]?
    var title: String?
    @StringValue var overview: String
    @DoubleValue var voteAverage: Double
    @IntValue var duration: Int
    
    enum CodingKeys: String, CodingKey {
        case id, genres, title, overview
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case duration = "runtime"
    }
}

extension Movie {
    struct Genre: Codable {
        var id: Int
        var name: String
    }
}
