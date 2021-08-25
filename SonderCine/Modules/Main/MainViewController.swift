//
//  MainViewController.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 22/1/21.
//

import UIKit

protocol MainViewControllerDelegate: ViewControllerDelegate {}

final class MainViewController: BaseViewController {
    var viewModel: MainViewModel!
    weak var delegate: MainViewControllerDelegate?
    
    override func setupView() {
        super.setupView()
    }
    
    override func willDeinit() {
        delegate?.viewControllerWillDeinit()
    }
}
