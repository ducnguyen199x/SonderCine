//
//  MovieListingViewModel.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 26/8/21.
//

import Foundation
import RxSwift
import RxCocoa

final class MovieListingViewModel: BaseViewModel {
    let networkProvider: MovieNetworkProvider
    let category: Category
    @Relay var movies: [Movie] = []

    init(networkProvider: MovieNetworkProvider = MovieNetworkClient(), category: Category) {
        self.networkProvider = networkProvider
        self.category = category
    }
    
    func fetchMovieList() {
        let request: Single<[Movie]> = {
            switch category {
            case .nowPlaying:
                return networkProvider.fetchNowPlaying()
            case .topRated:
                return networkProvider.fetchTopRated()
            }
        }()
        
        request.subscribe(onSuccess: { [weak self] movies in
            self?.movies = movies
        }, onFailure: { [weak self] _ in
            self?.movies = []
        }).disposed(by: rx.disposeBag)
    }
}

// MARK: Nested types
extension MovieListingViewModel {
    enum Category {
        case nowPlaying
        case topRated
    }
}
