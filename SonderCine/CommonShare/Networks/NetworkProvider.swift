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
    func get<T: Decodable>(api: API, params: JSON?) -> Single<T>
    func post<T: Decodable>(api: API, params: JSON?) -> Single<T>
    func put<T: Decodable>(api: API, params: JSON?) -> Single<T>
    func patch<T: Decodable>(api: API, params: JSON?) -> Single<T>
    func multipartRequest<T: Decodable>(_ method: Alamofire.HTTPMethod, api: API, params: JSON?, closure: Request.ProgressHandler?) -> Single<T>

    func post(api: API, params: JSON?) -> Completable
    func put(api: API, params: JSON?) -> Completable
    func delete(api: API, params: JSON?) -> Completable
    
    func get(api: API, params: JSON?) -> Single<Data?>
}

extension NetworkProvider {
    func get<T: Decodable>(api: API, params: JSON? = nil) -> Single<T> {
        return get(api: api, params: params)
    }
    
    func post<T: Decodable>(api: API, params: JSON? = nil) -> Single<T> {
        return post(api: api, params: params)
    }
    
    func post(api: API, params: JSON? = nil) -> Completable {
        return post(api: api, params: params)
    }
    
    func put<T: Decodable>(api: API, params: JSON? = nil) -> Single<T> {
        return put(api: api, params: params)
    }
    
    func put(api: API, params: JSON? = nil) -> Completable {
        return put(api: api, params: params)
    }
    
    func delete(api: API, params: JSON? = nil) -> Completable {
        return delete(api: api, params: params)
    }
    
    func patch<T: Decodable>(api: API, params: JSON? = nil) -> Single<T> {
        return patch(api: api, params: params)
    }
    
    func get(api: API, params: JSON? = nil) -> Single<Data?> {
        return get(api: api, params: params)
    }
}

class NetworkClient: NetworkProvider {
    func get<T: Decodable>(api: API, params: JSON?) -> Single<T> {
        return request(.get, api: api, params: params)
    }
    
    func get(api: API, params: JSON?) -> Single<Data?> {
        return request(.get, api: api, params: params)
    }
    
    func post<T: Decodable>(api: API, params: JSON?) -> Single<T> {
        return request(.post, api: api, params: params)
    }
    
    func post(api: API, params: JSON?) -> Completable {
        return request(.post, api: api, params: params)
    }
    
    func put<T: Decodable>(api: API, params: JSON?) -> Single<T> {
        return request(.put, api: api, params: params)
    }
    
    func put(api: API, params: JSON?) -> Completable {
        return request(.put, api: api, params: params)
    }
    
    func delete(api: API, params: JSON?) -> Completable {
        return request(.delete, api: api, params: params)
    }
    
    func patch<T: Decodable>(api: API, params: JSON?) -> Single<T> {
        return request(.patch, api: api, params: params)
    }
    
    func request<T: Decodable>(_ method: Alamofire.HTTPMethod,
                               api: API,
                               params: JSON? = nil) -> Single<T> {
        let encodedUrlString = api.urlString.encodeUrlQueryAllowedCharacter()
        guard let url = URL(string: encodedUrlString) else { return .error(NetworkError.invalidUrl) }
        
        let single = Single<T>.create { single -> Disposable in
            let request = NetworkClient.alamofireRequest(url, method: method, parameters: params, payloadBody: api.httpBody, headers: api.headers)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let responseData):
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .formatted(.serverFormat)
                            let decodedObject = try decoder.decode(T.self, from: responseData)
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
        return single
    }
    
    func request(_ method: Alamofire.HTTPMethod,
                 api: API,
                 params: JSON? = nil) -> Completable {
        let encodedUrlString = api.urlString.encodeUrlQueryAllowedCharacter()
        guard let url = URL(string: encodedUrlString) else { return .error(NetworkError.invalidUrl) }
        
        let single = Completable.create { single -> Disposable in
            debugPrint(method.rawValue + " : " + url.absoluteString)
            let request = NetworkClient.alamofireRequest(url, method: method, parameters: params, payloadBody: api.httpBody, headers: api.headers)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success:
                        single(.completed)
                    case .failure(let error):
                        switch error {
                        case .responseSerializationFailed(let reason):
                            if case .inputDataNilOrZeroLength = reason {
                                single(.completed)
                            }
                        default:
                            if let data = response.data, let responseStr = String(data: data, encoding: .utf8) {
                                single(.error(NetworkError.serverError(responseStr)))
                            } else {
                                single(.error(error))
                            }
                        }
                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
        return single
    }

    func request(_ method: Alamofire.HTTPMethod,
                 api: API,
                 params: JSON? = nil) -> Single<Data?> {
        let encodedUrlString = api.urlString.encodeUrlQueryAllowedCharacter()
        guard let url = URL(string: encodedUrlString) else { return .error(NetworkError.invalidUrl) }
        
        let single = Single<Data?>.create { single -> Disposable in
            debugPrint(method.rawValue + " : " + url.absoluteString)
            let request = NetworkClient.alamofireRequest(url, method: method, parameters: params, payloadBody: api.httpBody, headers: api.headers)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let responseData):
                        single(.success(responseData))
                    case .failure(let error):
                        self.processError(error, for: single, responseData: response.data)
                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
        return single
    }
    
    func multipartRequest<T: Decodable>(_ method: Alamofire.HTTPMethod,
                                        api: API,
                                        params: JSON?,
                                        closure: Request.ProgressHandler?) -> Single<T> {
        let encodedUrlString = api.urlString.encodeUrlQueryAllowedCharacter()
        guard let url = URL(string: encodedUrlString) else { return .error(NetworkError.invalidUrl) }
        // Makeing url query
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = []
        params?.forEach { param in
            if let value = param.value as? String {
                let queryItem = URLQueryItem(name: param.key, value: value)
                urlComponents?.queryItems?.append(queryItem)
            }
        }
        
        let finalURL = urlComponents?.url ?? url

        return Single.create { single -> Disposable in
            var request = AF.upload(multipartFormData: { formData in api.formDataArray.forEach { formData.append($0) } },
                                    to: finalURL,
                                    usingThreshold: .init(),
                                    method: method,
                                    headers: api.headers)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let responseData):
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .formatted(.serverFormat)
                            let decodedObject = try decoder.decode(T.self, from: responseData)
                            single(.success(decodedObject))
                        } catch let error {
                            debugPrint(error)
                            single(.failure(error))
                        }
                    case .failure(let error):
                        self.processError(error, for: single, responseData: response.data)
                    }
            }
            
            if let closure = closure {
                request = request.uploadProgress(closure: closure)
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
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
}
