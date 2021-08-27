//
//  SettingsCoordinator.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import UIKit

protocol SettingsCoordinatorDelegate: CoordinatorDelegate {}

final class SettingsCoordinator: Coordinator {
    weak var delegate: SettingsCoordinatorDelegate?
    
    override func makeNavigationController(payload: CoordinatorPayload? = nil) -> UINavigationController {
        let viewController = SettingsViewController.instantiate()
        viewController.viewModel = SettingsViewModel()
        viewController.delegate = self
        return viewController.embeddedInNavigation()
    }
}

// MARK: Delegates
extension SettingsCoordinator: SettingsViewControllerDelegate {}
