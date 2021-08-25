//
//  NetworkConfiguration.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import Foundation

struct NetworkConfiguration {
    static let baseURL = Bundle.userDefine(key: "API_ENDPOINT") ?? ""

    static func apiUrlString(_ apiType: API) -> String {
        return self.baseURL + apiType.apiVersionPath + apiType.apiPath
    }
}
