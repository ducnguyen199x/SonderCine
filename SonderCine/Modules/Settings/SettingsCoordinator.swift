//
//  SettingsCoordinator.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import UIKit
import SafariServices

protocol SettingsCoordinatorDelegate: CoordinatorDelegate {}

final class SettingsCoordinator: Coordinator {
    weak var delegate: SettingsCoordinatorDelegate?
    
    override func makeNavigationController(payload: CoordinatorPayload? = nil) -> UINavigationController {
        let viewController = SettingsViewController.instantiate()
        viewController.viewModel = SettingsViewModel()
        viewController.delegate = self
        return viewController.embeddedInNavigation()
    }
}

extension SettingsCoordinator {
    func pushDisplaySettings() {
        guard let navigation = rootViewController.navigationController else { return }
        invoke(DisplaySettingsCoordinator(), sceneType: .push(navigation))
    }
    
    func pushLanguageSettings() {
        guard let navigation = rootViewController.navigationController else { return }
        invoke(LanguageSettingsCoordinator(), sceneType: .push(navigation))
    }
    
    func pushPrivacy() {
        let safari = SFSafariViewController(url: URL(string: "https://google.com")!)
        rootViewController.present(safari, animated: true)
    }
    
    func pushTermsOfUse() {
        let safari = SFSafariViewController(url: URL(string: "https://google.com")!)
        rootViewController.present(safari, animated: true)
    }
    
    func presentCineMap() {
        let coordinator = CineMapCoordinator()
        coordinator.delegate = self
        invoke(coordinator, sceneType: .customPresent(rootViewController, .automatic))
    }
}

// MARK: Delegates
extension SettingsCoordinator: SettingsViewControllerDelegate {
    func displaySettingsTapped() {
        pushDisplaySettings()
    }
    
    func languageSettingsTapped() {
        pushLanguageSettings()
    }
    
    func privacyTapped() {
        pushPrivacy()
    }
    
    func termsOfUseTapped() {
        pushTermsOfUse()
    }
    
    func changeCinemaTapped() {
        presentCineMap()
    }
}

extension SettingsCoordinator: CineMapCoordinatorDelegate {
    func cineMapDidSelectLocation(_ sender: Coordinator) {
        sender.rootViewController.dismiss(animated: true, completion: nil)
    }
}
