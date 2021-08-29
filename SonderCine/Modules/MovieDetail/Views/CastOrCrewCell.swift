//
//  CastOrCrewCell.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 28/8/21.
//

import UIKit

/// `CastOrCrewCell` displays movie cast info.
class CastOrCrewCell: UICollectionViewCell {
    /// the participant' profile image
    @IBOutlet weak var profileImageView: UIImageView!
    
    /// the participant's name
    @IBOutlet weak var nameLabel: UILabel!
    
    /// the participant's role
    @IBOutlet weak var roleLabel: UILabel!
    
    /**
     Update the cell data
     - Parameter cast: cast object of the movie
     */
    func configure(_ participant: CastOrCrew) {
        loadImage(participant.profilePath)
        nameLabel.text = participant.name
        roleLabel.text = participant.role
    }
    
    /**
     Display movie profile image
     - Parameter path: path of the image
     */
    func loadImage(_ path: String?) {
        guard let path = path else { return }
        let urlString = API.image(type: ProfileImage.w92, path: path).urlString
        profileImageView.kf.setImage(with: URL(string: urlString))
    }
}
