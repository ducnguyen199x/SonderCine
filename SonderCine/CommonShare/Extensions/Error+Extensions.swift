//
//  Error+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import Foundation

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
    var userInfo: [String: Any] { return (self as NSError).userInfo }
}
