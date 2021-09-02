//
//  DummyData.swift
//  SonderCineTests
//
//  Created by Nguyen Thanh Duc on 1/9/21.
//

import Foundation
@testable import SonderCine

class MockData {
    class func movieListWrapperOneItem() -> MovieListWrapper? {
        guard let data = Bundle.loadJsonData(from: "mock_movie_list_1_item") else { return nil }
        return try? JSONDecoder().decode(MovieListWrapper.self, from: data)
    }
    
    class func movieListWrapperThreeItem() -> MovieListWrapper? {
        guard let data = Bundle.loadJsonData(from: "mock_movie_list_3_items") else { return nil }
        return try? JSONDecoder().decode(MovieListWrapper.self, from: data)
    }
    
    class func movieDetail() -> Movie? {
        guard let data = Bundle.loadJsonData(from: "mock_movie_detail") else { return nil }
        return try? JSONDecoder().decode(Movie.self, from: data)
    }
    
    class func movieCredit() -> Credit? {
        guard let data = Bundle.loadJsonData(from: "mock_credits") else { return nil }
        return try? JSONDecoder().decode(Credit.self, from: data)
    }
    
    class func movie() -> Movie {
        Movie(id: 1, overview: "", voteAverage: 1.0, duration: 1)
    }
    
    class func paging() -> Paging {
        Paging(current: 1, total: 2)
    }
    
    class func synopsis() -> Movie.Synopsis {
        Movie.Synopsis(title: "", releaseDate: nil, duration: 1, voteAverage: 1.0, genres: [])
    }
}
