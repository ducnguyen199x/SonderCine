//
//  LanguageSettingsViewController.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import UIKit

protocol LanguageSettingsViewControllerDelegate: ViewControllerDelegate {}

final class LanguageSettingsViewController: BaseViewController {
    var viewModel: LanguageSettingsViewModel!
    weak var delegate: LanguageSettingsViewControllerDelegate?
    
    @IBOutlet weak var contentView: UIStackView!

    override func setupNavigation() {
        let closeButton = UIBarButtonItem(image: .close, style: .plain, target: self, action: #selector(closeTapped(_:)))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    override func setupView() {
        super.setupView()
        // Refresh content view if needed
        contentView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Language section
        let language = SettingOptionView(
            title: LocalizedKey.Settings.languages.localized(),
            options: viewModel.languages.map { $0.displayName }) { [unowned self] option in
            viewModel.setLanguage(option)
        }
        language.select(index: viewModel.selectedIndex)
        contentView.addArrangedSubview(UIView.separator)
        contentView.addArrangedSubview(language)
    }
    
    override func localizedText() {
        super.localizedText()
        title = LocalizedKey.Settings.languages.localized()
        setupView()
    }
    
    override func willDeinit() {
        delegate?.viewControllerWillDeinit()
    }
}

// MARK: Actions
extension LanguageSettingsViewController {
    @objc private func closeTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
