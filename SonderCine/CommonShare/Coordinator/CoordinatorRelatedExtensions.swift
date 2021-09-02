//
//  CoordinatorRelatedExtensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import UIKit

extension UIView {
    func removeAllContainedViewControllers() {
        subviews.forEach { view in
            view.handlingViewController?.removeSelfAndViewFromParent()
        }
    }
    
    var handlingViewController: UIViewController? {
        do {
            var next: UIResponder? = self
            while next != nil {
                if next!.isKind(of: UIViewController.self) {
                    return next as? UIViewController
                }
                next = next?.next
            }
            return nil
        }
    }
}

extension UIViewController {
    func removeSelfAndViewFromParent() {
        removeFromParent()
        view.removeFromSuperview()
    }
}
