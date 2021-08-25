//
//  NetworkConfiguration.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import Foundation

struct NetworkConfiguration {
    static let baseURL = AppConfiguration.apiEndpoint.value ?? ""
    static let baseImageURL = AppConfiguration.imageEndpoint.value ?? ""
    
    static func apiUrlString(_ apiType: API) -> String {
        switch apiType {
        case .image:
            return self.baseImageURL + apiType.apiVersionPath + apiType.apiPath
        default:
            return self.baseURL + apiType.apiVersionPath + apiType.apiPath
        }
    }
}
