//
//  IndexPath+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import UIKit

extension IndexPath {
    static func row(_ row: Int) -> IndexPath {
        IndexPath(row: row, section: 0)
    }
}
