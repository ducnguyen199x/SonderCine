//
//  UIView+Ex.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import UIKit

extension UIView {
    static var separator: UIView {
        let separator = UIView()
        separator.backgroundColor = UITableView().separatorColor
        separator.height(1)
        return separator
    }
}
