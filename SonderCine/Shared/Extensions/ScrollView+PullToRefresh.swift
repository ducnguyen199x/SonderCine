//
//  ScrollView+PullToRefresh.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 26/8/21.
//

import UIKit

extension UIScrollView {
    func setRefresh(title: String = "Pull To Refresh", action: @escaping () -> Void) {
        addSubview(RefreshControl(title: title, action: action))
    }
    
    func endRefreshing() {
        (viewWithTag(.refreshControlTag) as? RefreshControl)?.endRefreshing()
    }
}

final class RefreshControl: UIRefreshControl {
    required init?(coder: NSCoder) { fatalError() }
    
    private let action: () -> Void
    
    init(title: String, action: @escaping () -> Void) {
        self.action = action
        super.init(frame: .zero)
        tag = .refreshControlTag
        attributedTitle = NSAttributedString(string: title)
        addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc private func refresh() {
        action()
    }
}
