//
//  Int+Ex.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 26/8/21.
//

import Foundation

// MARK: View tag constants
extension Int {
  static let refreshControlTag = 1000
}

extension Int {
    /**
     hour + minutes duration string from minutes
     */
    var durationString: String {
        let minutes = Int(self % 60)
        let hours = Int(self / 60)
        return "\(hours)h \(minutes)min"
    }
}
