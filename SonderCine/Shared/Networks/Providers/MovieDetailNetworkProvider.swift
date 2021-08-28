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
    func fetchDetail(id: Int, shouldUseCache: Bool) -> Single<Movie>
    func fetchCredit(id: Int, shouldUseCache: Bool) -> Single<Credit?>
    func fetchDetailAndCredit(id: Int, shouldUseCache: Bool) -> Single<(Movie, Credit?)>
}

extension MovieDetailNetworkProvider {
    func fetchDetail(id: Int) -> Single<Movie> {
        fetchDetail(id: id, shouldUseCache: true)
    }
    
    func fetchCredit(id: Int) -> Single<Credit?> {
        fetchCredit(id: id, shouldUseCache: true)
    }
    
    func fetchDetailAndCredit(id: Int) -> Single<(Movie, Credit?)> {
        fetchDetailAndCredit(id: id, shouldUseCache: true)
    }
}

struct MovieDetailNetworkClient: MovieDetailNetworkProvider {
    let networkProvider: NetworkProvider
    
    init(networkProvider: NetworkProvider = NetworkClient()) {
        self.networkProvider = networkProvider
    }
     
    func fetchDetail(id: Int, shouldUseCache: Bool) -> Single<Movie> {
        networkProvider.get(api: .movieDetail(id: id), cacheType: shouldUseCache ? .default : .noCache)
    }
    
    func fetchCredit(id: Int, shouldUseCache: Bool) -> Single<Credit?> {
        networkProvider.get(api: .credits(id: id), cacheType: shouldUseCache ? .default : .noCache).catchAndReturn(nil)
    }
    
    func fetchDetailAndCredit(id: Int, shouldUseCache: Bool) -> Single<(Movie, Credit?)> {
        Single.zip(fetchDetail(id: id, shouldUseCache: shouldUseCache),
                   fetchCredit(id: id, shouldUseCache: shouldUseCache))
    }
}
