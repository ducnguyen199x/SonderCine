//
//  LocalizedError.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

protocol LocalizedError: Error {
    var localizedDescription: String { get }
}
