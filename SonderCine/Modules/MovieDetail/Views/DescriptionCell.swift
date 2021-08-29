//
//  DescriptionCell.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 28/8/21.
//

import UIKit

/// `DescriptionCell` displays movie overview.
class DescriptionCell: BaseTableViewCell {
    /// the movie's overview
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func setupView() {
        super.setupView()
    }
    
    /**
     Update the cell data
     - Parameter description: movie's overview
     */
    func configure(_ description: String) {
        descriptionLabel.text = description
    }
}
