//
//  SettingsViewController.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import UIKit

protocol SettingsViewControllerDelegate: ViewControllerDelegate {
    func displaySettingsTapped()
}

final class SettingsViewController: BaseViewController {
    var viewModel: SettingsViewModel!
    weak var delegate: SettingsViewControllerDelegate?
    
    @IBOutlet weak var contentView: UIStackView!
    
    override func setupView() {
        super.setupView()
        // Refresh content view if needed
        contentView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // General section
        contentView.addArrangedSubview(SettingsSectionView(title: LocalizedKey.Settings.general.localized(), items: [
            .link(label: LocalizedKey.Settings.languages.localized()) { },
            .link(label: LocalizedKey.Settings.display.localized()) { [weak self] in self?.delegate?.displaySettingsTapped() }
        ]))
        
        // About section
        contentView.addArrangedSubview(SettingsSectionView(title: LocalizedKey.Settings.about.localized(), items: [
            .plain(label: LocalizedKey.Settings.version.localized(), value: Bundle.main.currentAppVersion),
            .link(label: LocalizedKey.Settings.privacy.localized()) { },
            .link(label: LocalizedKey.Settings.terms.localized()) { }
        ]))
    }
    
    override func setupNavigation() {
        let closeButton = UIBarButtonItem(image: .close, style: .plain, target: self, action: #selector(closeTapped(_:)))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    override func localizedText() {
        super.localizedText()
        title = LocalizedKey.Settings.title.localized()
        setupView()
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
