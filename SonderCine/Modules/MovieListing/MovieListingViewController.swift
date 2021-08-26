//
//  MovieListingViewController.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 26/8/21.
//

import UIKit

protocol MovieListingViewControllerDelegate: ViewControllerDelegate {}

final class MovieListingViewController: BaseViewController {
    var viewModel: MovieListingViewModel!
    weak var delegate: MovieListingViewControllerDelegate?
    
    override func setupNavigation() {
        navigationItem.title = "WizeMovie"
        
        // Add Settings Button
        let settingsButton = UIBarButtonItem(image: .settings,
                                             style: .plain,
                                             target: self,
                                             action: #selector(settingsTapped))
        navigationItem.setRightBarButton(settingsButton, animated: true)
    }
    
    override func setupView() {
        super.setupView()
    }
    
    override func willDeinit() {
        delegate?.viewControllerWillDeinit()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        viewModel.fetchMovieList()
    }
}

// MARK: Actions
extension MovieListingViewController {
    @objc func settingsTapped() {
        
    }
}
