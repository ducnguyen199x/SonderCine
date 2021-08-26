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
            viewModel.$state.bind(to: loadingIndicator.rx.viewModelAnimating),
            viewModel.$items.subscribe(onNext: { [weak self] _ in
                self?.reloadData()
            }),
            viewModel.$state.subscribe(onNext: { [weak self] state in
                switch state {
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
            guard let self = self else { return }
            self.viewModel.fetchMovieList(page: self.viewModel.currentPage)
        }
        tableView.registerNib(MovieCell.self)
        tableView.registerNib(AdsCell.self)
        tableView.registerClass(PaginationCell.self)
        tableView.contentInset = .bottom(50)
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
        guard let item = viewModel.item(at: indexPath) else { return .init() }
        
        switch item {
        case let .movie(movie):
            let cell: MovieCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(movie, position: tableView.position(of: indexPath))
            return cell
        case .ads:
            let cell: AdsCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case let .pagination(paging):
            let cell: PaginationCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setPaging(paging) { [weak self] page in
                guard let self = self else { return }
                self.tableView.scrollToRow(at: .init(row: 0, section: 0), at: .top, animated: true)
                self.viewModel.fetchMovieList(page: page)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
