//
//  Coordinator.swift
//
//  Created by Nguyen Thanh Duc on 19/1/21.
//

import Foundation
import UIKit

enum SceneType {
    case root(UIWindow)
    case push(UINavigationController)
    case present(UIViewController)
    case popup(UIViewController, CGSize, Bool)
    case embedded(UIViewController, UIView)
}

protocol CoordinatorPayload {}
extension String: CoordinatorPayload {}
extension Int: CoordinatorPayload {}
extension Array: CoordinatorPayload {}
extension URL: CoordinatorPayload {}

protocol CoordinatorDelegate: AnyObject {}

class Coordinator: NSObject {
    deinit {
        debugPrint("Deinit \(type(of: self))")
    }
    
    var coordinators: [Coordinator] = []

    lazy var rootViewController: UIViewController = {
        return makeNavigationController().viewControllers.first ?? UIViewController()
    }()
    
    var detachHandler: (() -> Void) = { () in }
        
    func start(sceneType: SceneType, payload: CoordinatorPayload? = nil) {
        let navigationController = makeNavigationController(payload: payload)
        rootViewController = navigationController.viewControllers.first ?? UIViewController()
        launch(target: navigationController, sceneType: sceneType)
    }
    
    func invoke(_ coordinator: Coordinator, sceneType: SceneType, payload: CoordinatorPayload? = nil) {
        add(coordinator)
        coordinator.start(sceneType: sceneType, payload: payload)
    }
    
    func makeNavigationController(payload: CoordinatorPayload? = nil) -> UINavigationController {
        return UINavigationController()
    }
    
    func add(_ coordinator: Coordinator) {
        coordinator.detachHandler = { [weak self, weak coordinator] in
            self?.remove(coordinator)
        }
        coordinators.append(coordinator)
    }
    
    func remove(_ coordinator: Coordinator?) {
        guard let coordinator = coordinator else { return }
        coordinators = coordinators.filter { $0 !== coordinator }
    }
    
    func removeAllCoordinators() {
        coordinators.removeAll()
    }
    
    func removeCoordinators<T: Coordinator>(type: T.Type) {
        coordinators = coordinators.filter { !($0.self is T)}
    }
    
    func firstChild<T: Coordinator>(of type: T.Type) -> T? {
        return coordinators.first(where: { $0 is T }) as? T
    }
    
    func launch(target: UIViewController, sceneType: SceneType) {
        switch sceneType {
        case .present(let viewController):
            viewController.present(target, animated: true, completion: nil)
        case .push(let navigationController):
            navigationController.push(target, animated: true)
        case .root(let window):
            window.rootViewController = target
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        case .popup(let viewController, let size, let isAutoDismissable):
            target.isModalInPresentation = !isAutoDismissable
            if size != .zero {
                target.modalPresentationStyle = .formSheet
                target.preferredContentSize = size
            } else {
                target.modalPresentationStyle = .pageSheet
            }
            viewController.present(target, animated: true, completion: {
                target.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = isAutoDismissable
            })
        case .embedded(let parent, let container):
            container.removeAllContainedViewControllers()
            parent.add(viewController: target, to: container)
        }
    }
}
