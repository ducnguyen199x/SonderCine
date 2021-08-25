//
//  SplashScreenViewController.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 25/8/21.
//

import UIKit

protocol SplashScreenViewControllerDelegate: ViewControllerDelegate {
    func splashScreenViewControllerCompleted()
}

final class SplashScreenViewController: BaseViewController {
    var viewModel: SplashScreenViewModel!
    weak var delegate: SplashScreenViewControllerDelegate?
    
    override func setupView() {
        super.setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rx.disposeBag.insert([
            viewModel.$state.subscribe(onNext: { [weak self] state in
                switch state {
                case .completed:
                    self?.delegate?.splashScreenViewControllerCompleted()
                default: break
                }
            })
        ])
        viewModel.fetchData()
    }
    
    override func willDeinit() {
        delegate?.viewControllerWillDeinit()
    }
}
