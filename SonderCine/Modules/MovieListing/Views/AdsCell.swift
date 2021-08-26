//
//  AdsCell.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 26/8/21.
//

import UIKit

/// `AdsCell` display advertisement.
class AdsCell: BaseTableViewCell {
    /// the ads's title
    @IBOutlet weak var adsTitle: UILabel!
    
    override func setupView() {
        super.setupView()
        addSeparator()
    }
}
