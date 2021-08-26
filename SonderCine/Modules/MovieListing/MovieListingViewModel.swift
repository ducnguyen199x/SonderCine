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
        
        state = .loading(nil)
        request.subscribe(onSuccess: { [weak self] movies in
            self?.movies = movies
            self?.state = .completed
        }, onFailure: { [weak self] error in
            self?.movies = []
            self?.state = .error(error)
        }).disposed(by: rx.disposeBag)
    }
    
    func numberOfRows() -> Int {
        movies.count
    }
    
    func movie(at indexPath: IndexPath) -> Movie? {
        movies[safe: indexPath.row]
    }
}

// MARK: Nested types
extension MovieListingViewModel {
    enum Category {
        case nowPlaying
        case topRated
    }
}
