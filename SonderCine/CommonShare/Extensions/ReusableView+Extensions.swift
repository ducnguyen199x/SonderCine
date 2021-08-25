//
//  ReusableView+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import UIKit

protocol ReusableView where Self: UIView {
    static var reuseIdentifier: String { get }
    static var nibName: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return self.string()
    }
    
    static var nibName: String {
        return self.string()
    }
}

extension UITableViewCell: ReusableView {}

extension UICollectionViewCell: ReusableView {}

extension UITableViewHeaderFooterView: ReusableView {}
