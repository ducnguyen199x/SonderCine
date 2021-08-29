//
//  MovieDetailViewController.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 28/8/21.
//

import UIKit

protocol MovieDetailViewControllerDelegate: ViewControllerDelegate, SettingsPresentableViewControllerDelegate {
    func movieDetail(_ sender: UIViewController, didTap credit: Credit)
}

final class MovieDetailViewController: BaseViewController {
    var viewModel: MovieDetailViewModel!
    weak var delegate: MovieDetailViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyContentLabel: UILabel!
    
    override func setupNavigation() {
        
        // Add Settings Button
        let settingsButton = UIBarButtonItem(image: .settings,
                                             style: .plain,
                                             target: self,
                                             action: #selector(settingsTapped))
        navigationItem.setRightBarButton(settingsButton, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func setupView() {
        super.setupView()
        setupTableView()
    }
    
    override func localizedText() {
        super.localizedText()
        navigationItem.title = LocalizedKey.MovieDetails.title.localized()
        reloadData()
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
                guard let self = self else { return }
                self.emptyContentLabel.isHidden = state.isLoading || !self.viewModel.items.isEmpty
                switch state {
                case .error(_):
                    self.showDefaultAlert()
                default:
                    break
                }
            })
        ])
        viewModel.fetchDetail()
    }
    
    private func setupTableView() {
        tableView.setRefresh { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchDetail(shouldUseCache: false)
        }
        tableView.registerNib(HeroCell.self)
        tableView.registerNib(SynopsisCell.self)
        tableView.registerNib(DescriptionCell.self)
        tableView.registerNib(CreditsCell.self)
        tableView.contentInset = .bottom(50)
    }
    
    private func reloadData() {
        tableView.reloadData()
        loadingIndicator.stopAnimating()
    }
}

// MARK: Actions
extension MovieDetailViewController {
    @objc func settingsTapped() {
        delegate?.settingsTapped(self)
    }
}

// MARK: TableView Delegates
extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = viewModel.item(at: indexPath) else { return .init() }
        
        switch item {
        case let .heroMedia(path):
            let cell: HeroCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(path)
            return cell
        case let .synopsis(synopsis):
            let cell: SynopsisCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(synopsis)
            return cell
        case let .description(desc):
            let cell: DescriptionCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(desc)
            return cell
        case let .credit(credit):
            let cell: CreditsCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(credit) { [weak self] in
                guard let self = self else { return }
                self.delegate?.movieDetail(self, didTap: credit)
            }
            return cell
        }
    }
}
