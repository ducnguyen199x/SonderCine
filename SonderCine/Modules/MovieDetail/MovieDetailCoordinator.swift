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

// MARK: Delegates
extension MovieDetailCoordinator: MovieDetailViewControllerDelegate, SettingsPresentableCoordinator {
    func settingsTapped(_ sender: UIViewController) {
        presentSettings()
    }
}
