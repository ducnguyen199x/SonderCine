//
//  BaseTableViewCell.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    var separator = UIView()
    private var didSetupView: Bool = false
    
    var position: UITableView.IndexPathPosition = .invalid {
        didSet {
            refreshUI()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    func addSeparator(height: CGFloat = 1,
                      color: UIColor? = UITableView().separatorColor,
                      leftInset: CGFloat = 10,
                      rightInset: CGFloat = 10) {
        separator.removeFromSuperview()
        addSubview(separator)
        separator.backgroundColor = color
        separator.height(height)
        separator.leadingToSuperview(offset: leftInset)
        separator.trailingToSuperview(offset: rightInset)
        separator.bottomToSuperview()
    }
    
    func refreshUI() {
        switch position {
        case .firstInSection, .middle:
            hideSeparator(false)
        default:
            hideSeparator(true)
        }
    }
    
    /**
     Hide bottom separator
     - Parameter hide: hide or not hide
     */
    func hideSeparator(_ hide: Bool = true) {
        separator.isHidden = hide
    }
}
