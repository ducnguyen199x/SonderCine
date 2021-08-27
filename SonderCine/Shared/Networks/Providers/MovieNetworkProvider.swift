//
//  MovieNetworkProvider.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 26/8/21.
//

import RxSwift
import RxCocoa
import Alamofire

protocol MovieNetworkProvider {
    func fetchNowPlaying(page: Int, shouldUseCache: Bool) -> Single<MovieListWrapper>
    func fetchTopRated(page: Int, shouldUseCache: Bool) -> Single<MovieListWrapper>
}

extension MovieNetworkProvider {
    func fetchNowPlaying(page: Int) -> Single<MovieListWrapper> {
        fetchNowPlaying(page: page, shouldUseCache: true)
    }
    
    func fetchTopRated(page: Int) -> Single<MovieListWrapper> {
        fetchTopRated(page: page, shouldUseCache: true)
    }
}

struct MovieNetworkClient: MovieNetworkProvider {
    let networkProvider: NetworkProvider
    
    init(networkProvider: NetworkProvider = NetworkClient()) {
        self.networkProvider = networkProvider
    }
    
    func fetchNowPlaying(page: Int, shouldUseCache: Bool) -> Single<MovieListWrapper> {
        networkProvider.get(api: .nowPlaying(page: page), cacheType: shouldUseCache ? .default : .noCache)
    }

    func fetchTopRated(page: Int, shouldUseCache: Bool) -> Single<MovieListWrapper> {
        networkProvider.get(api: .topRated(page: page), cacheType: shouldUseCache ? .default : .noCache)
    }
}
