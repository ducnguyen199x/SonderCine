//
//  SettingsSectionView.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 27/8/21.
//

import UIKit
import TinyConstraints

extension SettingsSectionView {
    enum Item {
        case plain(label: String, value: String?)
        case link(label: String, handler: () -> Void)
    }
}

final class SettingsSectionView: UIView {
    convenience init(title: String, items: [Item]) {
        self.init(frame: .zero)
        let label = UILabel()
        label.text = title
        label.font = .boldSystemFont(ofSize: 25)
        addSubview(label)
        label.edgesToSuperview(excluding: .bottom, insets: .horizontal(15) + .top(40))
        
        let itemStack = UIStackView()
        itemStack.axis = .vertical
        itemStack.backgroundColor = R.color.backgroundColor()
        addSubview(itemStack)
        itemStack.edgesToSuperview(excluding: .top, insets: .horizontal(15))
        itemStack.topToBottom(of: label, offset: 13)
        
        for item in items {
            switch item {
            case let .plain(label: label, value: value):
                itemStack.addArrangedSubview(PlainView(label: label, value: value))
                itemStack.addArrangedSubview(UIView.separator)
                
            case let .link(label: label, handler: handler):
                itemStack.addArrangedSubview(LinkView(label: label, handler: handler))
                itemStack.addArrangedSubview(UIView.separator)
            }
        }
    }
}

private extension SettingsSectionView {
    final class PlainView: UIStackView {
        convenience init(label: String, value: String?) {
            let titleLabel = UILabel()
            titleLabel.text = label
            titleLabel.font = .boldSystemFont(ofSize: 18)
            
            let valueLabel = UILabel()
            valueLabel.text = value
            valueLabel.font = .systemFont(ofSize: 18)
            
            self.init(arrangedSubviews: [titleLabel, UIView(), valueLabel])
            height(59)
        }
    }
    
    final class LinkView: UIControl {
        private var handler: (() -> Void)!
        
        convenience init(label: String, handler: @escaping () -> Void) {
            self.init(frame: .zero)
            self.handler = handler
            let titleLabel = UILabel()
            titleLabel.text = label
            titleLabel.font = .boldSystemFont(ofSize: 18)
            
            let arrow = UIImage.forward?.withTintColor(.systemOrange)
            
            let stack = UIStackView(arrangedSubviews: [titleLabel, UIView(), UIImageView(image: arrow)])
            stack.alignment = .center
            stack.isUserInteractionEnabled = false
            addSubview(stack)
            stack.edgesToSuperview()
            height(59)
            
            addTarget(self, action: #selector(handle), for: .touchUpInside)
        }
        
        @objc private func handle() {
            handler()
        }
    }
}
