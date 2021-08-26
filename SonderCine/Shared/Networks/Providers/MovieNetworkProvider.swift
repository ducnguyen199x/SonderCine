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
    func fetchNowPlaying() -> Single<[Movie]>
    func fetchTopRated() -> Single<[Movie]>
}

struct MovieNetworkClient: MovieNetworkProvider {
    let networkProvider: NetworkProvider
    
    init(networkProvider: NetworkProvider = NetworkClient()) {
        self.networkProvider = networkProvider
    }
    
    func fetchNowPlaying() -> Single<[Movie]> {
        let request: Single<MovieListWrapper> = networkProvider.get(api: .nowPlaying)
        return request.map { $0.results }
    }

    func fetchTopRated() -> Single<[Movie]> {
        let request: Single<MovieListWrapper> = networkProvider.get(api: .topRated)
        return request.map { $0.results }
    }
}
