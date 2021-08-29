//
//  CreditsCell.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 28/8/21.
//

import UIKit
import TinyConstraints

/// `CreditsCell` displays movie cast and crews.
class CreditsCell: BaseTableViewCell {
    /// the movie's cast collectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// the movie's director
    @IBOutlet weak var directorLabel: UILabel!
    
    /// the cell's title
    @IBOutlet weak var titleLabel: UILabel!
    
    /// the movie's director
    @IBOutlet weak var seeAllButton: UIButton!
    
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    // Collection view datasouce
    private var casts = [Cast]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private var seeAllHandler: (() -> Void)?
    private let maxNumberOfCasts = 4
    private let spacing: CGFloat = 20
    private var numberOfItems: Int {
        min(casts.count, maxNumberOfCasts)
    }
    private var itemSize: CGSize {
        let width = (UIScreen.main.bounds.width - 30 - spacing * 3) / 4
        let height = width * 3 / 2 + 86 // profile image height + (name + role) height
        return CGSize(width: width, height: height)
    }
    
    override func setupView() {
        super.setupView()
        collectionView.registerNib(CastOrCrewCell.self)
        collectionHeight.constant = itemSize.height
        let image = UIImage.backward?.withTintColor(R.color.textColor()!, renderingMode: .alwaysOriginal)
        seeAllButton.setImage(image, for: .normal)
        seeAllButton.titleEdgeInsets = .left(-10)
    }
    
    private func localizedText() {
        seeAllButton.setTitle(LocalizedKey.MovieDetails.seeAll.localized(), for: .normal)
        titleLabel.text = LocalizedKey.MovieDetails.castAndCrews.localized()
    }
    
    /**
     Update the cell data
     - Parameter credit: credit object of the movie
     */
    func configure(_ credit: Credit, seeAllHandler: (() -> Void)? = nil) {
        self.seeAllHandler = seeAllHandler
        casts = credit.cast ?? []
        displayDirectors(credit.crew)
        localizedText()
    }
    
    /**
     Filter Crews and display only directors
     - Parameter crews: all crews
     */
    private func displayDirectors(_ crews: [Crew]?) {
        guard let directors = crews?.filter({ $0.job.isDirector }), !directors.isEmpty else {
            directorLabel.isHidden = true
            return
        }
        var directorNames = ""
        if directors.count == 1 { // Only 1 director
            directorNames = directors.first!.name
        } else if directors.count == 2 { // 2 directors
            directorNames = directors.first!.name + " & " + directors.last!.name
        } else { // more than 2 directors
            directorNames = directors.first!.name + " & \(directors.count - 1) more"
        }
        directorLabel.text = LocalizedKey.MovieDetails.director.localized() + ": " + directorNames
    }
}

// MARK: Actions
extension CreditsCell {
    @IBAction func seeAllTapped(_ sender: UIButton) {
        seeAllHandler?()
    }
}

// MARK: Collection View Delegates
extension CreditsCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CastOrCrewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let participant = casts[safe: indexPath.item] {
            cell.configure(participant)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
}
