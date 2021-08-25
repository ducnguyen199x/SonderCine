//
//  UINavigationController+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import UIKit

extension UINavigationController {
    func removeShadowAndLine() {
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    func configureCustomBackButton() {
        let backImage = #imageLiteral(resourceName: "back-icon")
        navigationBar.backIndicatorImage = backImage
        navigationBar.backIndicatorTransitionMaskImage = backImage
        
        navigationBar.topItem?.title = ""
    }
    
    func addTransition(_ transition: CATransition) {
        self.view.layer.add(transition, forKey: nil)
    }
    
    func removeTitleBackButton() {
        navigationBar.topItem?.title = ""
    }
    
    func push(_ viewController: UIViewController, animated: Bool) {
        var viewController: UIViewController? = viewController
        if let navigationController = viewController as? UINavigationController {
            // Prevent crash when trying to push a navigation controller
            viewController = navigationController.viewControllers.first
        }
        guard let targetViewController = viewController else { return }
        pushViewController(targetViewController, animated: animated)
    }
    
    func makeTranslucentNavigationBar() {
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backItem?.title = title
        navigationItem.titleView = UIView()
    }
}

extension UINavigationItem {
    @discardableResult
    func addLeftTitle(_ title: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.text = title
        leftBarButtonItem = UIBarButtonItem(customView: label)
        return label
    }
    
    func addRightButton(_ button: UIButton) {
        rightBarButtonItem = UIBarButtonItem(customView: button)
    }
}

extension CATransition {
    func pushFromLeft() -> CATransition {
        self.duration = 0.2
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.moveIn
        self.subtype = CATransitionSubtype.fromLeft
        return self
    }
    
    func popFromRight() -> CATransition {
        self.duration = 0.2
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.reveal
        self.subtype = CATransitionSubtype.fromRight
        return self
    }

    func fadeInOut() -> CATransition {
        self.duration = 0.2
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.fade
        self.subtype = CATransitionSubtype.fromRight
        return self
    }
}

extension UINavigationItem {
    var allItems: [UIBarButtonItem] {
        return (leftBarButtonItems ?? []) + (rightBarButtonItems ?? [])
    }
}
