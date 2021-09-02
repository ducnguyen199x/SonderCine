//
//  LanguageSettingsCoordinator.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import UIKit

protocol LanguageSettingsCoordinatorDelegate: CoordinatorDelegate {}

final class LanguageSettingsCoordinator: Coordinator {
    weak var delegate: LanguageSettingsCoordinatorDelegate?
    
    override func makeNavigationController(payload: CoordinatorPayload? = nil) -> UINavigationController {
        let viewController = LanguageSettingsViewController.instantiate()
        viewController.viewModel = LanguageSettingsViewModel()
        viewController.delegate = self
        return viewController.embeddedInNavigation()
    }
}

// MARK: Delegates
extension LanguageSettingsCoordinator: LanguageSettingsViewControllerDelegate {}
