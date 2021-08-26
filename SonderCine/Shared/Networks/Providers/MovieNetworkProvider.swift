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
    func fetchNowPlaying(page: Int) -> Single<MovieListWrapper>
    func fetchTopRated(page: Int) -> Single<MovieListWrapper>
}

struct MovieNetworkClient: MovieNetworkProvider {
    let networkProvider: NetworkProvider
    
    init(networkProvider: NetworkProvider = NetworkClient()) {
        self.networkProvider = networkProvider
    }
    
    func fetchNowPlaying(page: Int) -> Single<MovieListWrapper> {
        networkProvider.get(api: .nowPlaying, params: ["page": page])
    }

    func fetchTopRated(page: Int) -> Single<MovieListWrapper> {
        networkProvider.get(api: .topRated, params: ["page": page])
    }
}
