//
//  UIApplication+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import UIKit

extension UIApplication {
    var currentOrientation: UIInterfaceOrientation? {
        guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else { return nil }
        return orientation
    }

    class func rootViewController() -> UIViewController? {
        return UIApplication.shared.windows.first?.rootViewController
    }

    class func topMostController() -> UIViewController? {
        guard let rootViewController = UIApplication.rootViewController() else {
            return nil
        }
        var topController = rootViewController
        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }
        if let vc = (topController as? UINavigationController)?.visibleViewController {
            topController = vc
        }
        return topController
    }
}
