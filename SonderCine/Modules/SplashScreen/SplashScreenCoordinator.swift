//
//  SplashScreenCoordinator.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 25/8/21.
//

import UIKit

protocol SplashScreenCoordinatorDelegate: CoordinatorDelegate {
    func splashScreenCoordinatorCompleted()
}

final class SplashScreenCoordinator: Coordinator {
    weak var delegate: SplashScreenCoordinatorDelegate?
    
    override func makeNavigationController(payload: CoordinatorPayload? = nil) -> UINavigationController {
        let viewController = SplashScreenViewController.instantiate()
        viewController.viewModel = SplashScreenViewModel()
        viewController.delegate = self
        return viewController.embeddedInNavigation()
    }
}

// MARK: Delegates
extension SplashScreenCoordinator: SplashScreenViewControllerDelegate {
    func splashScreenViewControllerCompleted() {
        delegate?.splashScreenCoordinatorCompleted()
    }
}
