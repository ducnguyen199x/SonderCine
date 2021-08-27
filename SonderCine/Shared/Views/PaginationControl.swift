//
//  PaginationControl.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 26/8/21.
//

import UIKit

/// A pagination control
final class PaginationControl: UIStackView {
    /// The number of pages
    private var numberOfPages = 0
    
    /// The current page
    private var current = 1 { didSet { updateStack() } }
    
    /// The select block
    private var selectPage: ((Int) -> Void)?
    
    func setPaging(_ paging: Paging, selectPage: @escaping (Int) -> Void) {
        self.numberOfPages = paging.total
        self.current = paging.current
        self.selectPage = selectPage
        
        isHidden = numberOfPages == 0
        updateStack()
    }
    
    private func updateStack() {
        guard numberOfPages > 0 else { return }
        // Remove old stack
        arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Go previous button
        addArrangedSubview(makeButton(image: .backward, page: max(1, current - 1)))
        
        switch current {
        case _ where numberOfPages <= 6:
            for i in 1...numberOfPages {
                addArrangedSubview(makeButton(page: i))
            }
            
        case 1...3:
            for i in 1...5 {
                addArrangedSubview(makeButton(page: i))
            }
            addArrangedSubview(makeButton(image: .ellipsis))
            
        case (numberOfPages-2)...:
            addArrangedSubview(makeButton(image: .ellipsis))
            for i in numberOfPages-4...numberOfPages {
                addArrangedSubview(makeButton(page: i))
            }
            
        default:
            addArrangedSubview(makeButton(image: .ellipsis))
            for i in current-2...current+1 {
                addArrangedSubview(makeButton(page: i))
            }
            addArrangedSubview(makeButton(image: .ellipsis))
        }
        
        // Go next button
        addArrangedSubview(makeButton(image: .forward, page: min(current + 1, numberOfPages)))
    }
    
    private func makeButton(image: UIImage? = nil, page: Int? = nil) -> UIButton {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.contentMode = .center
        button.size(CGSize(width: 35, height: 35))
        
        switch (image, page) {
        case let(.some(image), .some(page)):
            button.tag = page
            button.setImage(image, for: .normal)
            button.tintColor = .systemOrange
            button.addTarget(self, action: #selector(goPage(_:)), for: .touchUpInside)
            
        case let(_, .some(page)):
            button.tag = page
            button.setTitle(String(page), for: .normal)
            button.addTarget(self, action: #selector(goPage(_:)), for: .touchUpInside)
            if page == current {
                button.backgroundColor = .systemOrange
                button.layer.cornerRadius = 5
                button.setTitleColor(.white, for: .normal)
            } else {
                button.setTitleColor(.systemOrange, for: .normal)
            }
            
        default:
            button.setTitle("...", for: .normal)
            button.setTitleColor(.systemOrange, for: .normal)
            button.isEnabled = false
        }
        return button
    }
    
    @objc private func goPage(_ sender: UIButton) {
        if current != sender.tag {
            current = sender.tag
            selectPage?(sender.tag)
        }
    }
}
