//
//  API.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import Foundation
import Alamofire

enum API {
    case nowPlaying(page: Int)
    case topRated(page: Int)
    case movieDetail(id: Int)
    case credits(id: Int)
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
        case .topRated(let page), .nowPlaying(let page):
            return ["api_key": AppConfiguration.theMovieDBAPIKey.value ?? "",
                    "page": page,
                    "language": LanguageManager.shared.currentLanguage.rawValue]
        case .movieDetail:
            return ["api_key": AppConfiguration.theMovieDBAPIKey.value ?? "",
                    "language": LanguageManager.shared.currentLanguage.rawValue]
        case .credits:
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
        case .topRated, .nowPlaying, .credits, .movieDetail:
            return true
        default:
            return false
        }
    }
    
    var cacheLocation: CacheLocation {
        switch self {
        case .topRated(let page):
            return ("\(page)-\(LanguageManager.shared.currentLanguage.rawValue)", Constants.Cache.topRatedDirectory)
        case .nowPlaying(let page):
            return ("\(page)-\(LanguageManager.shared.currentLanguage.rawValue)", Constants.Cache.nowPLayingDirectory)
        case .movieDetail(let id):
            return ("\(id)-\(LanguageManager.shared.currentLanguage.rawValue)", Constants.Cache.movieDetailsDirectory)
        case .credits(let id):
            return ("\(id)", Constants.Cache.creditsDirectory)
        default:
            return ("", "/")
        }
    }
}

// MARK: Target decode key
extension API {
    var targetDecodeKey: String? {
        switch self {
        case .nowPlaying, .topRated:
            return "results"
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
