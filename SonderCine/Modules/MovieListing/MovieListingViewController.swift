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
    
    override func setupView() {
        super.setupView()
    }
    
    override func willDeinit() {
        delegate?.viewControllerWillDeinit()
    }
}
