//
//  UIView+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import UIKit

extension UIView {
    func addSubView(view: UIView, inset: UIEdgeInsets = UIEdgeInsets.zero) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset.left).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: inset.right).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: inset.top).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: inset.bottom).isActive = true
    }
    
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
}
