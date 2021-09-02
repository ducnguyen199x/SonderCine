//
//  DisplaySettingsCoordinator.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import UIKit

protocol DisplaySettingsCoordinatorDelegate: CoordinatorDelegate {}

final class DisplaySettingsCoordinator: Coordinator {
    weak var delegate: DisplaySettingsCoordinatorDelegate?
        
    override func makeNavigationController(payload: CoordinatorPayload? = nil) -> UINavigationController {
        let viewController = DisplaySettingsViewController.instantiate()
        viewController.viewModel = DisplaySettingsViewModel()
        viewController.delegate = self
        return viewController.embeddedInNavigation()
    }
}

// MARK: Delegates
extension DisplaySettingsCoordinator: DisplaySettingsViewControllerDelegate {}
