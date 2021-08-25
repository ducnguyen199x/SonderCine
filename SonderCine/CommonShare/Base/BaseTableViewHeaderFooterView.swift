//
//  BaseTableViewHeaderFooterView.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import UIKit

class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView {
    var separator = UIView()
    private var didSetupView: Bool = false

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: superview)
        if !didSetupView {
            setupView()
        }
    }

    func setupView() {
        didSetupView = true
    }
    
    func addSeparator(height: CGFloat = 0.5, color: UIColor? = .lightGray, leftInset: CGFloat = 20) {
        addSubview(separator)
        separator.height(height)
        separator.leadingToSuperview(offset: leftInset)
        separator.trailingToSuperview()
        separator.bottomToSuperview()
    }
}
