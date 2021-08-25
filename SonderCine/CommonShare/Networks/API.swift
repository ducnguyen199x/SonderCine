//
//  API.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import Foundation
import Alamofire

typealias CacheLocation = (filename: String, subDirectory: String)

enum API {
    case firstAPI
    
    var urlString: String {
        switch self {
        case .firstAPI:
            return NetworkConfiguration.apiUrlString(self)
        default:
            return NetworkConfiguration.apiUrlString(self)
        }
    }
    
    var apiPath: String {
        switch self {
        case .firstAPI: return "firstAPI"
        default: return ""
        }
    }
    
    var apiVersionPath: String {
        return "/"
    }
    
    var apiAuthPath: String {
        return "/"
    }
    
    var shouldHandleExpiredToken: Bool {
        switch self {
        default:
            return true
        }
    }
}

// MARK: Headers
extension API {
    var headers: HTTPHeaders {
        var defaultHeaders: HTTPHeaders = ["Content-Type": "application/json"]
        switch self {
        default:
            break
        }
        return defaultHeaders
    }
}

// MARK: HTTP Body
extension API {
    var httpBody: Data? {
        var httpBody: [String: Any] = [:]
        switch self {
        default:
            break
        }
        return httpBody.isEmpty ? nil : httpBody.data()
    }
}

// MARK: Cache
extension API {
    var shouldUseCache: Bool {
        switch self {
        default: return false
        }
    }
    
    var cacheLocation: CacheLocation {
        switch self {
        default:
            return ("", "/")
        }
    }
}

// MARK: Target decode key
extension API {
    var targetDecodeKey: String? {
        switch self {
        default:
            return nil
        }
    }
}

// FormData
typealias FormData = (data: Data, name: String, fileName: String?, mimeType: String?)

extension API {
    var formDataArray: [FormData] {
        var array: [FormData] = []
            switch self {
            default:
                break
            }
        return array
    }
}

extension MultipartFormData {
    func append(_ formData: FormData) {
        if let fileName = formData.fileName, let mimeType = formData.mimeType {
            append(formData.data, withName: formData.name, fileName: fileName, mimeType: mimeType)
        } else {
            append(formData.data, withName: formData.name)
        }
    }
}
