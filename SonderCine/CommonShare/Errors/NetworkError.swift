//
//  NetworkError.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidUrl
    case invalidResponse
    case parseDataError
    case cancelled
    case refreshTokenFailed
    case serverError(String)
    case noNetwork
    
    var localizedDescription: String {
        switch self {
        case .serverError(let str):
            return str
        default:
            return "Something went wrong. Please try again."
        }
    }
}
