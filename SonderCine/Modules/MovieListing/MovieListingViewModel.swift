//
//  MovieListingViewModel.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 26/8/21.
//

import Foundation
import RxSwift
import RxCocoa

extension MovieListingViewModel {
  /// Datasource item type
  enum Item {
    /// Movie
    case movie(Movie)

    /// Ads
    case ads
  }
}

final class MovieListingViewModel: BaseViewModel {
    let networkProvider: MovieNetworkProvider
    let category: Category
    var movies = [Movie]() {
        didSet {
            makeItems()
        }
    }
    
    /// The view controller's datasource
    var items = [Item]()

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
    
    private func makeItems() {
        var items: [Item] = movies.map { .movie($0) }
        let adsNumber = items.count / 3
        for i in 1...adsNumber {
            items.insert(.ads, at: i * 3 + i - 1)
        }
        self.items = items
    }
    
    func numberOfRows() -> Int {
        items.count
    }
    
    func item(at indexPath: IndexPath) -> Item? {
        items[safe: indexPath.row]
    }
}

// MARK: Nested types
extension MovieListingViewModel {
    enum Category {
        case nowPlaying
        case topRated
    }
}
