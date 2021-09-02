//
//  NetworkProvider.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import Foundation
import RxSwift
import Alamofire

protocol NetworkProvider {
    func get<T: Decodable>(api: API, params: JSON?, cacheType: CacheType) -> Single<T>
    func post<T: Decodable>(api: API, params: JSON?, cacheType: CacheType) -> Single<T>
    func put<T: Decodable>(api: API, params: JSON?, cacheType: CacheType) -> Single<T>
    func patch<T: Decodable>(api: API, params: JSON?, cacheType: CacheType) -> Single<T>
}

extension NetworkProvider {
    func get<T: Decodable>(api: API, params: JSON? = nil, cacheType: CacheType = .default) -> Single<T> {
        return get(api: api, params: params, cacheType: cacheType)
    }
    
    func post<T: Decodable>(api: API, params: JSON? = nil, cacheType: CacheType = .default) -> Single<T> {
        return post(api: api, params: params, cacheType: cacheType)
    }
    
    func put<T: Decodable>(api: API, params: JSON? = nil, cacheType: CacheType = .default) -> Single<T> {
        return put(api: api, params: params, cacheType: cacheType)
    }
    
    func patch<T: Decodable>(api: API, params: JSON? = nil, cacheType: CacheType = .default) -> Single<T> {
        return patch(api: api, params: params, cacheType: cacheType)
    }
}

class NetworkClient: NetworkProvider {
    func get<T: Decodable>(api: API, params: JSON?, cacheType: CacheType) -> Single<T> {
        return request(.get, api: api, params: params, cacheType: cacheType)
    }
    
    func post<T: Decodable>(api: API, params: JSON?, cacheType: CacheType) -> Single<T> {
        return request(.post, api: api, params: params, cacheType: cacheType)
    }
    
    func put<T: Decodable>(api: API, params: JSON?, cacheType: CacheType) -> Single<T> {
        return request(.put, api: api, params: params, cacheType: cacheType)
    }
    
    func patch<T: Decodable>(api: API, params: JSON?, cacheType: CacheType) -> Single<T> {
        return request(.patch, api: api, params: params, cacheType: cacheType)
    }
    
    func request<T: Decodable>(_ method: Alamofire.HTTPMethod,
                               api: API,
                               params: JSON? = nil,
                               cacheType: CacheType = .default) -> Single<T> {
        let encodedUrlString = api.urlString.encodeUrlQueryAllowedCharacter()
        guard let url = URL(string: encodedUrlString) else { return .error(NetworkError.invalidUrl) }
        
        let single = Single<T>.create { single -> Disposable in
            var mergeParams = api.defaultParams
            if let params = params {
                mergeParams.merge(params) { _, second in second }
            }
            let request = NetworkClient.alamofireRequest(url, method: method, parameters: mergeParams, payloadBody: api.httpBody, headers: api.headers)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let responseData):
                        do {
                            let decodedObject = try JSONDecoder().decode(T.self, from: responseData)
                            // Cache raw reponse data if needed
                            if api.shouldUseCache {
                                CacheManager.saveCache(for: api, data: responseData)
                            }
                            single(.success(decodedObject))
                        } catch let error {
                            debugPrint(method.rawValue + " : " + url.absoluteString)
                            debugPrint(error)
                            single(.failure(error))
                        }
                    case .failure(let error):
                        debugPrint(method.rawValue + " : " + url.absoluteString)
                        debugPrint(error)
                        self.processError(error, for: single, responseData: response.data)
                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
        return cache(for: single, api: api, cacheType: cacheType)
    }
    
    fileprivate static func alamofireRequest(_ url: URL,
                                             method: Alamofire.HTTPMethod,
                                             parameters: JSON?,
                                             payloadBody: Data?,
                                             headers: HTTPHeaders?) -> DataRequest {
        if let payloadBody = payloadBody {
            return AF.request(url, method: method, parameters: parameters, encoding: payloadBody, headers: headers)
        }
        
        return AF.request(url, method: method, parameters: parameters, headers: headers)
    }

    private func processError<T>(_ error: AFError, for sequence: (SingleEvent<T>) -> Void, responseData: Data?) {
        if error.responseCode == 401 {
            Alert.showOneButtonAlert("Session expired!",
                                     message: "Please login again.",
                                     cancelButtonTitle: "OK",
                                     in: nil)
        }
        sequence(.failure(error))
    }
    
    private func processError(_ error: AFError, for sequence: (CompletableEvent) -> Void, responseData: Data?) {
        if error.responseCode == 401 {
            Alert.showOneButtonAlert("Session expired!",
                                     message: "Please login again.",
                                     cancelButtonTitle: "OK",
                                     in: nil)
        }
        sequence(.error(error))
    }
    
    private func cache<T: Decodable>(for sequence: Single<T>, api: API, cacheType: CacheType) -> Single<T> {
        // Check Cache first
        if cacheType == .default, api.shouldUseCache {
            return CacheManager.getCache(for: api).flatMap { cacheData in
                if let cacheData = cacheData {
                    do {
                        let decodedObject = try JSONDecoder().decode(T.self, from: cacheData)
                        return Single.just(decodedObject)
                    } catch let error {
                        debugPrint(error)
                        // Remove damaged cache
                        CacheManager.removeCache(for: api)
                        // Call Network if cannot decode Cache
                        return sequence
                    }
                } else {
                    // Call Network if there is no Cache
                    return sequence
                }
            }
        } else {
            // Remove old cache
            CacheManager.removeCache(for: api)
            // Call Network for API not support Caching
            return sequence
        }
    }
}
