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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

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
        setupTableView()
    }
    
    override func willDeinit() {
        delegate?.viewControllerWillDeinit()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        rx.disposeBag.insert([
            viewModel.$state.subscribe(onNext: { [weak self] state in
                switch state {
                case .completed:
                    self?.reloadData()
                case .error(_):
                    self?.showDefaultAlert()
                default:
                    break
                }
            })
        ])
        viewModel.fetchMovieList()
    }
    
    private func setupTableView() {
        tableView.setRefresh { [weak self] in
            self?.viewModel.fetchMovieList()
        }
        tableView.registerNib(MovieCell.self)
        tableView.contentInset = .bottom(100)
    }
    
    private func reloadData() {
        tableView.reloadData()
        tableView.endRefreshing()
        loadingIndicator.stopAnimating()
    }
}

// MARK: Actions
extension MovieListingViewController {
    @objc func settingsTapped() {
    }
}

// MARK: TableView Delegates
extension MovieListingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieCell = tableView.dequeueReusableCell(for: indexPath)
        if let movie = viewModel.movie(at: indexPath) {
            cell.configure(movie)
        }
        cell.hideSeparator(indexPath.row == viewModel.numberOfRows() - 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
