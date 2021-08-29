//
//  MovieDetailCoordinator.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 28/8/21.
//

import UIKit

protocol MovieDetailCoordinatorDelegate: CoordinatorDelegate {}

final class MovieDetailCoordinator: Coordinator {
    weak var delegate: MovieDetailCoordinatorDelegate?
    
    override func makeNavigationController(payload: CoordinatorPayload? = nil) -> UINavigationController {
        let viewController = MovieDetailViewController.instantiate()
        if let id = payload as? Int {
            viewController.viewModel = MovieDetailViewModel(id: id)
        }
        viewController.delegate = self
        return viewController.embeddedInNavigation()
    }
}

// MARK: Navigation
extension MovieDetailCoordinator {
    private func pushCreditsListing(_ credit: Credit) {
        guard let navigation = rootViewController.navigationController else { return }
        let coordinator = CreditsListingCoordinator()
        add(coordinator)
        coordinator.start(sceneType: .push(navigation), payload: credit)
    }
}

// MARK: Delegates
extension MovieDetailCoordinator: MovieDetailViewControllerDelegate, SettingsPresentableCoordinator {
    func settingsTapped(_ sender: UIViewController) {
        presentSettings()
    }
    
    func movieDetail(_ sender: UIViewController, didTap credit: Credit) {
        pushCreditsListing(credit)
    }
}
