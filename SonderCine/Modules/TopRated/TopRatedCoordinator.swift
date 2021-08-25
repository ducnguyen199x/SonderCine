//
//  TopRatedCoordinator.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 25/8/21.
//

import UIKit

protocol TopRatedCoordinatorDelegate: CoordinatorDelegate {}

final class TopRatedCoordinator: TabContentCoordinator {
    
    override init() {
        super.init()
        tabType = .topRated
    }
    
    override func makeNavigationController(payload: CoordinatorPayload? = nil) -> UINavigationController {
        let viewController = TopRatedViewController.instantiate()
        viewController.viewModel = TopRatedViewModel()
        viewController.delegate = self
        return viewController.embeddedInNavigation()
    }
}

// MARK: Delegates
extension TopRatedCoordinator: TopRatedViewControllerDelegate {}
