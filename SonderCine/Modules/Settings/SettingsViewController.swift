//
//  SettingsViewController.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import UIKit

protocol SettingsViewControllerDelegate: ViewControllerDelegate {}

final class SettingsViewController: BaseViewController {
    var viewModel: SettingsViewModel!
    weak var delegate: SettingsViewControllerDelegate?
    
    @IBOutlet weak var contentView: UIStackView!
    
    override func setupView() {
        super.setupView()
        // Refresh content view if needed
        contentView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        // About section
        contentView.addArrangedSubview(SettingsSectionView(title: "About", items: [
            .plain(label: "App Version", value: Bundle.main.currentAppVersion)
        ]))
    }
    
    override func setupNavigation() {
        let closeButton = UIBarButtonItem(image: .close, style: .plain, target: self, action: #selector(closeTapped(_:)))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    override func localizedText() {
        super.localizedText()
        title = "Settings"
    }
    
    override func willDeinit() {
        delegate?.viewControllerWillDeinit()
    }
}

// MARK: Actions
extension SettingsViewController {
    @objc private func closeTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
