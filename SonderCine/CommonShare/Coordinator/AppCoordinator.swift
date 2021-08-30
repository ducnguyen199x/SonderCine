//
//  AppCoordinator.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import UIKit

class AppCoordinator: Coordinator {
    var window: UIWindow?
    
    override init() {
        super.init()
        bind()
    }
    
    private func bind() {
        rx.disposeBag.insert([
            NetworkManager.shared.$connection.subscribe(onNext: { [weak self] status in
                if status == .notReachable {
                    self?.showNoNetwork()
                }
            })
        ])
    }
    
    override func start(sceneType: SceneType, payload: CoordinatorPayload? = nil) {
        if case .root(let window) = sceneType {
            self.window = window
            openSplashScreen()
        } else {
            fatalError("AppCoordinator must be root type")
        }
    }
}

extension AppCoordinator {
    func openSplashScreen() {
        guard let window = window else { return }
        let coordinator = SplashScreenCoordinator()
        coordinator.delegate = self
        removeAllCoordinators()
        invoke(coordinator, sceneType: .root(window))
    }
    
    func openMainTabbarScreen() {
        guard let window = window else { return }
        let coordinator = MainTabbarCoordinator()
        coordinator.delegate = self
        removeAllCoordinators()
        invoke(coordinator, sceneType: .root(window))
    }
    
    func openCineMapScreen() {
        guard let window = window else { return }
        let coordinator = CineMapCoordinator()
        coordinator.delegate = self
        removeAllCoordinators()
        invoke(coordinator, sceneType: .root(window))
    }
    
    func showNoNetwork() {
        openSplashScreen()
    }
}

extension AppCoordinator: SplashScreenCoordinatorDelegate {
    func splashScreenCoordinatorCompleted() {
        openCineMapScreen()
    }
}

extension AppCoordinator: MainTabbarCoordinatorDelegate {
}

extension AppCoordinator: CineMapCoordinatorDelegate {
}
