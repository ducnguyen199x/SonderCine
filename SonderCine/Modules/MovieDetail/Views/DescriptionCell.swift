//
//  DescriptionCell.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 28/8/21.
//

import UIKit

/// `DescriptionCell` display movie overview.
class DescriptionCell: BaseTableViewCell {
    /// the movie's overview
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func setupView() {
        super.setupView()
        addSeparator(leftInset: 15, rightInset: 15)
    }
    
    /**
     Update the cell data
     - Parameter description: movie's overview
     */
    func configure(_ description: String) {
        descriptionLabel.text = description
    }
}
