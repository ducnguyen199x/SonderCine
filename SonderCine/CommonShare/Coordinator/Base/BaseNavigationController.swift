//
//  BaseNavigationController.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import UIKit

class BaseNavigationController: UINavigationController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        viewControllers.first?.dismiss(animated: flag)
    }
}
