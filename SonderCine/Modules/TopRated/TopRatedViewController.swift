//
//  TopRatedViewController.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 25/8/21.
//

import UIKit

protocol TopRatedViewControllerDelegate: ViewControllerDelegate {}

final class TopRatedViewController: BaseViewController {
    var viewModel: TopRatedViewModel!
    weak var delegate: TopRatedViewControllerDelegate?
    
    override func setupView() {
        super.setupView()
    }
    
    override func willDeinit() {
        delegate?.viewControllerWillDeinit()
    }
}
