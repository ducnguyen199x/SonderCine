//
//  CineMapCoordinator.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 30/8/21.
//

import UIKit

protocol CineMapCoordinatorDelegate: CoordinatorDelegate {}

final class CineMapCoordinator: Coordinator {
    weak var delegate: CineMapCoordinatorDelegate?
    
    override func makeNavigationController(payload: CoordinatorPayload? = nil) -> UINavigationController {
        let viewController = CineMapViewController.instantiate()
        viewController.viewModel = CineMapViewModel()
        viewController.delegate = self
        return viewController.embeddedInNavigation()
    }
}

// MARK: Delegates
extension CineMapCoordinator: CineMapViewControllerDelegate {}
