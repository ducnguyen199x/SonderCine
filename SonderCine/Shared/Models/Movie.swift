//
//  Movie.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 26/8/21.
//

import Foundation

struct MovieListWrapper: Decodable {
    var paging: Paging
    var results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        results = (try? container?.decodeIfPresent([Movie].self, forKey: .results)) ?? []
        let page = (try? container?.decodeIfPresent(Int.self, forKey: .page)) ?? 0
        let totalPages = (try? container?.decodeIfPresent(Int.self, forKey: .totalPages)) ?? 0
        paging = Paging(current: page, total: totalPages)
    }
}

struct Movie: Decodable {
    var id: Int
    var backdropPath: String?
    var posterPath: String?
    var genres: [Genre]?
    var title: String?
    @StringValue var overview: String
    @DoubleValue var voteAverage: Double
    @IntValue var duration: Int
    @DateValue<DateFormatterGeneral> var releaseDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, genres, title, overview
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case duration = "runtime"
        case releaseDate = "release_date"
    }
}

extension Movie {
    struct Genre: Decodable {
        var id: Int
        var name: String
    }
}
