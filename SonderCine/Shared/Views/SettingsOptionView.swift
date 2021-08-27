//
//  DisplaySettingsOptionView.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import UIKit
import TinyConstraints

/// A view show display settings options for a section
final class SettingOptionView: UIView {
    private var optionViews = [OptionView]()
    
    /// Init
    /// - Parameters:
    ///   - title: the section's title
    ///   - options: the section's options
    convenience init(title: String, options: [String], select: @escaping (Int) -> Void) {
        self.init(frame: .zero)
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 25)
        addSubview(titleLabel)
        titleLabel.edgesToSuperview(excluding: .bottom, insets: .horizontal(15) + .top(40))
        let stack = UIStackView()
        stack.axis = .vertical
        stack.backgroundColor = R.color.backgroundColor()
        for (index, option) in options.enumerated() {
            let optionView = OptionView(title: option) { [unowned self] optionView in
                self.optionViews.forEach { $0.isSelected = $0 === optionView }
                select(index)
            }
            optionViews.append(optionView)
            stack.addArrangedSubview(optionView)
            stack.addArrangedSubview(UIView.separator)
        }
        addSubview(stack)
        stack.edgesToSuperview(excluding: .top, insets: .horizontal(15))
        stack.topToBottom(of: titleLabel, offset: 10)
    }
    
    /// Select a option from an index
    /// - Parameter index: option index
    func select(index: Int) {
        optionViews.forEach { $0.isSelected = false }
        optionViews[index].isSelected = true
    }
    
    /// `OptionView`: SettingOptionView's subtype
    private final class OptionView: UIControl {
        /// Option title label
        private let title = UILabel()
                
        /// Option tick icon
        private let icon = UIImageView()
        private var selectOption: ((OptionView) -> Void)!
        
        /// Option isSelected state, reset title/icon when switched
        override var isSelected: Bool {
            didSet {
                title.font = isSelected ? .boldSystemFont(ofSize: 18) : .systemFont(ofSize: 18)
                icon.isHidden = !isSelected
            }
        }
        
        /// Init
        /// - Parameters:
        ///   - title: the option's title
        ///   - select: the callback when tap at this
        convenience init(title: String, select: @escaping (OptionView) -> Void) {
            self.init(frame: .zero)
            height(58)
            
            self.title.text = title
            self.title.font = .systemFont(ofSize: 15)
            self.selectOption = select
            addSubview(self.title)
            addSubview(self.icon)
            
            self.title.leadingToSuperview()
            self.title.centerYToSuperview()
            
            self.icon.rightToSuperview(offset: -20)
            self.icon.centerYToSuperview()
            self.icon.isHidden = true
            self.icon.image = .checkmark?.withTintColor(.systemOrange)
            
            addTarget(self, action: #selector(_selectOption), for: .touchUpInside)
        }
        
        @objc private func _selectOption() {
            selectOption(self)
        }
    }
}
