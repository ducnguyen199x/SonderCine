//
//  MainCoordinator.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 22/1/21.
//

import UIKit

protocol MainCoordinatorDelegate: CoordinatorDelegate {}

final class MainCoordinator: Coordinator {
    weak var delegate: MainCoordinatorDelegate?
    
    override func makeNavigationController(payload: CoordinatorPayload? = nil) -> UINavigationController {
        let viewController = MainViewController.instantiate()
        viewController.viewModel = MainViewModel()
        viewController.delegate = self
        return viewController.embeddedInNavigation()
    }
}

// MARK: Delegates
extension MainCoordinator: MainViewControllerDelegate {}
