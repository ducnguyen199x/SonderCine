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
    
    @IBOutlet weak var noInternetLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!

    override func setupView() {
        super.setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rx.disposeBag.insert([
            viewModel.$state.bind(to: loadingIndicator.rx.viewModelAnimating),
            viewModel.$state.subscribe(onNext: { [weak self] state in
                switch state {
                case .loading(_) :
                    self?.noInternetLabel.isHidden = true
                    self?.introLabel.isHidden = false
                    self?.retryButton.isHidden = true
                case .completed:
                    self?.delegate?.splashScreenViewControllerCompleted()
                case .error:
                    self?.noInternetLabel.isHidden = false
                    self?.introLabel.isHidden = true
                    self?.retryButton.isHidden = false
                default: break
                }
            }),
            NetworkManager.shared.$connection.subscribe(onNext: { [weak self] _ in
                self?.viewModel.fetchData()
            })
        ])
        viewModel.fetchData()
    }
    
    override func willDeinit() {
        delegate?.viewControllerWillDeinit()
    }
}

extension SplashScreenViewController {
    @IBAction func retry(_ sender: UIButton) {
        viewModel.fetchData()
    }
}
