//
//  MovieListingCoordinator.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 26/8/21.
//

import UIKit

protocol MovieListingCoordinatorDelegate: CoordinatorDelegate {}

final class MovieListingCoordinator: TabContentCoordinator {
    init(tabType: TabType) {
        super.init()
        self.tabType = tabType
    }
    
    override func makeNavigationController(payload: CoordinatorPayload? = nil) -> UINavigationController {
        let viewController = MovieListingViewController.instantiate()
        switch self.tabType {
        case .nowPlaying:
            viewController.viewModel = MovieListingViewModel(category: .nowPlaying)
        case .topRated:
            viewController.viewModel = MovieListingViewModel(category: .topRated)
        }
        viewController.delegate = self
        return viewController.embeddedInNavigation()
    }
}

// MARK: Delegates
extension MovieListingCoordinator: MovieListingViewControllerDelegate, SettingsPresentableCoordinator {
    func settingsTapped(_ sender: UIViewController) {
        presentSettings()
    }
}
