//
//  HeroMediaCell.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 28/8/21.
//

import UIKit

/// `HeroCell` displays movie backdrop image.
class HeroCell: BaseTableViewCell {
    /// the movie's backdrop image
    @IBOutlet weak var thumbnail: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnail.image = nil
    }
    
    /**
     Update the cell displays with the movie
     - Parameter movie: movie
     - Parameter position: position of the cell
     */
    func configure(_ path: String?) {
        loadImage(path)
    }
    
    /**
     Display movie backdrop image
     - Parameter path: path of the image
     */
    private func loadImage(_ path: String?) {
        guard let path = path else { return }
        let urlString = API.image(type: BackdropImage.w780, path: path).urlString
        thumbnail.kf.setImage(with: URL(string: urlString))
    }
}
