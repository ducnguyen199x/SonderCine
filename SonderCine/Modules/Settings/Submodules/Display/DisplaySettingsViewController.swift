//
//  DisplaySettingsViewController.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import UIKit

protocol DisplaySettingsViewControllerDelegate: ViewControllerDelegate {}

final class DisplaySettingsViewController: BaseViewController {
    var viewModel: DisplaySettingsViewModel!
    weak var delegate: DisplaySettingsViewControllerDelegate?
    
    @IBOutlet weak var contentView: UIStackView!

    override func setupNavigation() {
        let closeButton = UIBarButtonItem(image: .close, style: .plain, target: self, action: #selector(closeTapped(_:)))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    override func setupView() {
        super.setupView()
        
        // Theme section
        let theme = DisplaySettingOptionView(
          title: "Theme",
          options: viewModel.themeOptions) { [unowned self] option in
          viewModel.setTheme(option)
        }
        theme.select(index: viewModel.themSelectedIndex)
        contentView.addArrangedSubview(UIView.separator)
        contentView.addArrangedSubview(theme)
    }
    
    override func localizedText() {
        super.localizedText()
        title = "Display"
    }
    
    override func willDeinit() {
        delegate?.viewControllerWillDeinit()
    }
}

// MARK: Actions
extension DisplaySettingsViewController {
    @objc private func closeTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
