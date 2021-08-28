//
//  MovieDetailViewModel.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 28/8/21.
//

import Foundation
import RxSwift
import RxCocoa

extension MovieDetailViewModel {
    /// Datasource item type
    enum Item {
        /// Main Thumbnail
        case heroMedia(path: String?)
        
        /// Brief
        case synopsis(Movie.Synopsis)
        
        /// Description
        case description(String)
        
        /// Credit
        case credit(Credit)
    }
}

final class MovieDetailViewModel: BaseViewModel {
    let networkProvider: MovieDetailNetworkProvider
    let id: Int
    
    init(networkProvider: MovieDetailNetworkProvider = MovieDetailNetworkClient(), id: Int) {
        self.networkProvider = networkProvider
        self.id = id
    }
    
    /// The view controller's datasource
    @Relay var items = [Item]()
    
    func fetchDetail(shouldUseCache: Bool = true) {
        state = .loading(nil)
        networkProvider.fetchDetailAndCredit(id: id, shouldUseCache: shouldUseCache)
            .subscribe(onSuccess: { [weak self] (movie, credit) in
                self?.makeItems(movie, credit: credit)
                self?.state = .completed
            }, onFailure: { [weak self] error in
                self?.items = []
                self?.state = .error(error)
            }).disposed(by: rx.disposeBag)
    }
    
    private func makeItems(_ movie: Movie, credit: Credit?) {
        var items: [Item] = [.heroMedia(path: movie.backdropPath),
                             .synopsis(movie.sysnopsis),
                             .description(movie.overview)]
//        if let credit = credit {
//            items.append(.credit(credit))
//        }
        self.items = items
    }
    
    func numberOfRows() -> Int {
        items.count
    }
    
    func item(at indexPath: IndexPath) -> Item? {
        items[safe: indexPath.row]
    }
}
