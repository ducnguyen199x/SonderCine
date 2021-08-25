//
//  UIVIewController+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import UIKit

protocol UIViewControllerFactory {}
extension UIViewController: UIViewControllerFactory {}

extension UIViewControllerFactory where Self: UIViewController {
    static func instantiate() -> Self {
        let name = Self.string().replacingOccurrences(of: "ViewController", with: "")
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        guard let controller = initial as? Self else {
            fatalError("Could not create \(name), please check your storyboard again.")
        }
        return controller
    }
    
    func embeddedInNavigation(shouldHideNavigation: Bool = false) -> BaseNavigationController {
        let navigationController = BaseNavigationController(rootViewController: self)
        navigationController.isNavigationBarHidden = shouldHideNavigation
        navigationController.modalPresentationStyle = .overFullScreen
        return navigationController
    }
    
    func embeddedInPopover(size: CGSize) -> Self {
        preferredContentSize = size
        modalPresentationStyle = .popover
        popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
        popoverPresentationController?.permittedArrowDirections = [.up]
        popoverPresentationController?.passthroughViews = nil
        view.backgroundColor = .clear
        return self
    }
}

extension UIViewController {
    func add(viewController: UIViewController, to containerView: UIView) {
        viewController.willMove(toParent: self)
        
        addChild(viewController)
        containerView.addSubView(view: viewController.view)
        viewController.didMove(toParent: self)
    }
    
    func childViewControllersWithClass<T: UIViewController>(_ classToFind: T.Type) -> [T] {
        var result = [T]()
        self.children.forEach { candidateVC in
            if let candidateVC = candidateVC as? T {
                result.append(candidateVC)
            }
        }
        return result
    }
    
    func present(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        if let navigationController = viewController.navigationController {
            // Prevent crash when presenting a child view of a navigation controller
            present(navigationController, animated: false, completion: completion)
        } else {
            present(viewController, animated: false, completion: completion)
        }
    }
    
    func presentPopover(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        guard viewController.modalPresentationStyle == .popover else { return }
        if presentedViewController?.modalPresentationStyle == .popover {
            presentedViewController?.dismiss(animated: true, completion: {
                self.present(viewController)
            })
        } else {
            present(viewController)
        }
    }
    
    @objc func endEditing(_ force: Bool) {
        view.endEditing(force)
        navigationItem.searchController?.isActive = false
        children.forEach { $0.endEditing(true) }
    }
}

extension UIViewController {
    var preferredContentWidth: CGFloat {
        return preferredContentSize.width
    }
    
    var preferredContentHeight: CGFloat {
        return preferredContentSize.height
    }
}
