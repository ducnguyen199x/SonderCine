//
//  CreditsListingViewController.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 29/8/21.
//

import UIKit

protocol CreditsListingViewControllerDelegate: ViewControllerDelegate, SettingsPresentableViewControllerDelegate {}

final class CreditsListingViewController: BaseViewController {
    var viewModel: CreditsListingViewModel!
    weak var delegate: CreditsListingViewControllerDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!

    private let spacing: CGFloat = 20
    private var itemSize: CGSize {
        let width = (UIScreen.main.bounds.width - 30 - spacing * 3) / 4
        let height = width * 3 / 2 + 86 // profile image height + (name + role) height
        return CGSize(width: width, height: height)
    }
    
    override func setupView() {
        super.setupView()
        setupCollectionView()
    }
    
    override func setupNavigation() {
        
        // Add Settings Button
        let settingsButton = UIBarButtonItem(image: .settings,
                                             style: .plain,
                                             target: self,
                                             action: #selector(settingsTapped))
        navigationItem.setRightBarButton(settingsButton, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func localizedText() {
        super.localizedText()
        title = LocalizedKey.MovieDetails.castAndCrews.localized()
        segmentControl.setTitle(LocalizedKey.MovieDetails.casts.localized(), forSegmentAt: 0)
        segmentControl.setTitle(LocalizedKey.MovieDetails.crews.localized(), forSegmentAt: 1)
    }
    
    private func setupCollectionView() {
        collectionView.registerNib(CastOrCrewCell.self)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        viewModel.$filteredCredits.subscribe(onNext: { [weak self] _ in
            self?.collectionView.reloadData()
        }).disposed(by: rx.disposeBag)
        viewModel.fetchData()
    }
    
    override func willDeinit() {
        delegate?.viewControllerWillDeinit()
    }
}

// MARK: Actions
extension CreditsListingViewController {
    @IBAction func filterChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: viewModel.filterType = .cast
        case 1: viewModel.filterType = .crew
        default: break
        }
    }
    
    @objc func settingsTapped() {
        delegate?.settingsTapped(self)
    }
}

// MARK: Collection view delegates
extension CreditsListingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CastOrCrewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let item = viewModel.item(at: indexPath) {
            cell.configure(item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
}
