//
//  NowPlayingViewController.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 25/8/21.
//

import UIKit

protocol NowPlayingViewControllerDelegate: ViewControllerDelegate {}

final class NowPlayingViewController: BaseViewController {
    var viewModel: NowPlayingViewModel!
    weak var delegate: NowPlayingViewControllerDelegate?
    
    override func setupView() {
        super.setupView()
    }
    
    override func willDeinit() {
        delegate?.viewControllerWillDeinit()
    }
}
