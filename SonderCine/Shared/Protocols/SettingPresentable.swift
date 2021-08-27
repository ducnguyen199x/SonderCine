//
//  SettingPresentable.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import UIKit

protocol SettingsPresentableViewControllerDelegate: AnyObject {
    func settingsTapped(_ sender: UIViewController)
}

protocol SettingsPresentableCoordinator where Self: Coordinator {
    func presentSettings()
}

extension SettingsPresentableCoordinator {
    func presentSettings() {
        let coordinator = SettingsCoordinator()
        add(coordinator)
        coordinator.start(sceneType: .present(rootViewController))
    }
}
