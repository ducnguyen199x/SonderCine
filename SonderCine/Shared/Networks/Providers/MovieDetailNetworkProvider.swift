//
//  MovieDetailNetworkProvider.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 28/8/21.
//

import RxSwift
import RxCocoa
import Alamofire

protocol MovieDetailNetworkProvider {
    func fetchDetailAndCredit(id: Int, shouldUseCache: Bool) -> Single<(Movie, Credit?)>
}

extension MovieDetailNetworkProvider {
    func fetchDetailAndCredit(id: Int) -> Single<(Movie, Credit?)> {
        fetchDetailAndCredit(id: id, shouldUseCache: true)
    }
}

struct MovieDetailNetworkClient: MovieDetailNetworkProvider {
    let networkProvider: NetworkProvider
    
    init(networkProvider: NetworkProvider = NetworkClient()) {
        self.networkProvider = networkProvider
    }
     
    private func fetchDetail(id: Int, shouldUseCache: Bool) -> Single<Movie> {
        networkProvider.get(api: .movieDetail(id: id), cacheType: shouldUseCache ? .default : .noCache)
    }
    
    private func fetchCredit(id: Int, shouldUseCache: Bool) -> Single<Credit?> {
        networkProvider.get(api: .credits(id: id), cacheType: shouldUseCache ? .default : .noCache).catchAndReturn(nil)
    }
    
    func fetchDetailAndCredit(id: Int, shouldUseCache: Bool) -> Single<(Movie, Credit?)> {
        Single.zip(fetchDetail(id: id, shouldUseCache: shouldUseCache),
                   fetchCredit(id: id, shouldUseCache: shouldUseCache))
    }
}
