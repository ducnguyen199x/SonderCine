//
//  NetworkRelatedExtensions.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import Alamofire

extension Data: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        let method = request.httpMethod
        let headers = request.allHTTPHeaderFields
        
        if let parameters = parameters, let urlString = request.url?.absoluteString, let url = URL(string: urlString) {
            // Rebuild URLRequest with parameters
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            
            urlComponents?.queryItems = []
            parameters.forEach { parameter in
                if let value = parameter.value as? String {
                    let queryItem = URLQueryItem(name: parameter.key, value: value)
                    urlComponents?.queryItems?.append(queryItem)
                }
            }
            
            if let newURL = urlComponents?.url {
                request = URLRequest(url: newURL)
                request.httpMethod = method
                request.allHTTPHeaderFields = headers
            }
        }
        
        // Add necessary headers
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        
        // Add payload body
        request.httpBody = self
        return request
    }
}
