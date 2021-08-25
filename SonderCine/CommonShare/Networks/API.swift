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
    case nowPlaying
    case topRated
    case movieDetail(id: String)
    case credits(id: String)
    case image(type: ImageType, path: String)
    
    var urlString: String {
        return NetworkConfiguration.apiUrlString(self)
    }
    
    var apiPath: String {
        switch self {
        case .topRated: return "movie/top_rated"
        case .nowPlaying: return "movie/now_playing"
        case .movieDetail(let id): return "movie/\(id)"
        case .credits(let id): return "movie/\(id)/credits"
        case let .image(type, path): return "t/p/\(type.size)\(path)"
        }
    }
    
    var apiVersionPath: String {
        return "/"
    }
    
    var shouldHandleExpiredToken: Bool {
        return true
    }
}

// MARK: Default params
extension API {
    var defaultParams: JSON {
        switch self {
        case .topRated, .nowPlaying, .movieDetail, .credits:
            return ["api_key": AppConfiguration.theMovieDBAPIKey.value ?? ""]
        default:
            return [:]
        }
    }
}

// MARK: Headers
extension API {
    var headers: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }
}

// MARK: HTTP Body
extension API {
    var httpBody: Data? {
        return nil
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
        return []
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
