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
    
    /// Pagination
    case pagination(Paging)
  }
}

final class MovieListingViewModel: BaseViewModel {
    let networkProvider: MovieListNetworkProvider
    let category: Category

    init(networkProvider: MovieListNetworkProvider = MovieListNetworkClient(), category: Category) {
        self.networkProvider = networkProvider
        self.category = category
    }
    
    /// The view controller's datasource
    @Relay var items = [Item]()
    var currentPage: Int = 1
    
    func fetchMovieList(page: Int = 1, shouldUseCache: Bool = true) {
        currentPage = page
        items = []
        let request: Single<MovieListWrapper> = {
            switch category {
            case .nowPlaying:
                return networkProvider.fetchNowPlaying(page: page, shouldUseCache: shouldUseCache)
            case .topRated:
                return networkProvider.fetchTopRated(page: page, shouldUseCache: shouldUseCache)
            }
        }()
        
        state = .loading(nil)
        request.subscribe(onSuccess: { [weak self] wrapper in
            self?.makeItems(wrapper)
            self?.state = .completed
        }, onFailure: { [weak self] error in
            self?.items = []
            self?.state = .error(error)
        }).disposed(by: rx.disposeBag)
    }
    
    func refreshCurrentPage(shouldUseCache: Bool = false) {
        fetchMovieList(page: currentPage, shouldUseCache: shouldUseCache)
    }
    
    func makeItems(_ wrapper: MovieListWrapper) {
        var items: [Item] = wrapper.results.map { .movie($0) }
        let adsNumber = items.count / 3
        if adsNumber > 0 {
            for i in 1...adsNumber {
                items.insert(.ads, at: i * 3 + i - 1)
            }
        }
        items.append(.pagination(wrapper.paging))
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
        
        var displayName: String {
            switch self {
            case .nowPlaying: return LocalizedKey.TabBar.nowPlaying.localized()
            case .topRated: return LocalizedKey.TabBar.topRated.localized()
            }
        }
    }
}
