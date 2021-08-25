//
//  NowPlayingCoordinator.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 25/8/21.
//

import UIKit

protocol NowPlayingCoordinatorDelegate: CoordinatorDelegate {}

final class NowPlayingCoordinator: TabContentCoordinator {
    
    override init() {
        super.init()
        tabType = .nowPlaying
    }
    
    override func makeNavigationController(payload: CoordinatorPayload? = nil) -> UINavigationController {
        let viewController = NowPlayingViewController.instantiate()
        viewController.viewModel = NowPlayingViewModel()
        viewController.delegate = self
        return viewController.embeddedInNavigation()
    }
}

// MARK: Delegates
extension NowPlayingCoordinator: NowPlayingViewControllerDelegate {}
