//
//  MainTabbarCoordinator.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 25/8/21.
//

import UIKit

protocol MainTabbarCoordinatorDelegate: CoordinatorDelegate {}

final class MainTabbarCoordinator: Coordinator {
    weak var delegate: MainTabbarCoordinatorDelegate?
    
    override init() {
        super.init()
        coordinators = [MovieListingCoordinator(tabType: .nowPlaying),
                        MovieListingCoordinator(tabType: .topRated)]
    }
    
    override func makeNavigationController(payload: CoordinatorPayload? = nil) -> UINavigationController {
        let tabbarController = MainTabbarViewController.instantiate()
        tabbarController.vcDelegate = self
        tabbarController.viewModel = MainTabbarViewModel()
        let tabContentCoordinators = coordinators.compactMap { $0 as? TabContentCoordinator }
        let tabContentViewControllers = tabContentCoordinators.compactMap { coordinator -> UIViewController? in
            coordinator.delegate = self
            let viewController = coordinator.rootViewController.navigationController
            let tapType = coordinator.tabType
            viewController?.tabBarItem = UITabBarItem(title: tapType.title,
                                                      image: tapType.icon,
                                                      selectedImage: nil)
            return viewController
        }
        tabbarController.viewControllers = tabContentViewControllers
        tabbarController.selectedIndex = 1
        tabbarController.selectedIndex = 0
        return tabbarController.embeddedInNavigation(shouldHideNavigation: true)
    }
}

// MARK: Delegates
extension MainTabbarCoordinator: MainTabbarViewControllerDelegate {}

extension MainTabbarCoordinator: TabContentCoordinatorDelegate {}
