//
//  CineMapCoordinator.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 30/8/21.
//

import UIKit
import MapKit

protocol CineMapCoordinatorDelegate: CoordinatorDelegate {
    func cineMapDidSelectLocation()
}

final class CineMapCoordinator: Coordinator {
    weak var delegate: CineMapCoordinatorDelegate?
    
    override func makeNavigationController(payload: CoordinatorPayload? = nil) -> UINavigationController {
        let viewController = CineMapViewController.instantiate()
        viewController.viewModel = CineMapViewModel()
        viewController.delegate = self
        return viewController.embeddedInNavigation(shouldHideNavigation: true)
    }
}

// MARK: Delegates
extension CineMapCoordinator: CineMapViewControllerDelegate {
    func cineMap(_ sender: UIViewController, didSelect location: CLLocationCoordinate2D) {
        delegate?.cineMapDidSelectLocation()
    }
}
