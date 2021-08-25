//
//  MainTabbarViewController.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 25/8/21.
//

import UIKit

protocol MainTabbarViewControllerDelegate: ViewControllerDelegate {}

final class MainTabbarViewController: BaseTabbarController {
    var viewModel: MainTabbarViewModel!
    weak var vcDelegate: MainTabbarViewControllerDelegate?
    
    override func setupView() {
        super.setupView()
    }
    
    override func willDeinit() {
        vcDelegate?.viewControllerWillDeinit()
    }
}
