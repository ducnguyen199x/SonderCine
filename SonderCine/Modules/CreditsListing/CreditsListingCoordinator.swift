//
//  CreditsListingCoordinator.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 29/8/21.
//

import UIKit

protocol CreditsListingCoordinatorDelegate: CoordinatorDelegate {}

final class CreditsListingCoordinator: Coordinator {
    weak var delegate: CreditsListingCoordinatorDelegate?
    
    override func makeNavigationController(payload: CoordinatorPayload? = nil) -> UINavigationController {
        let viewController = CreditsListingViewController.instantiate()
        if let credit = payload as? Credit {
            viewController.viewModel = CreditsListingViewModel(credit: credit)
        }
        viewController.delegate = self
        return viewController.embeddedInNavigation()
    }
}

// MARK: Delegates
extension CreditsListingCoordinator: CreditsListingViewControllerDelegate, SettingsPresentableCoordinator {
    func settingsTapped(_ sender: UIViewController) {
        presentSettings()
    }
}
