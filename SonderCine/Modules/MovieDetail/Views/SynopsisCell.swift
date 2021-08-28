//
//  SynopsisCel.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 28/8/21.
//

import UIKit

/// `SynopsisCell` display movie briefs.
class SynopsisCell: BaseTableViewCell {
    /// the movie's name and release year
    @IBOutlet weak var titleLabel: UILabel!
    
    /// the movie's vote and duration
    @IBOutlet weak var voteDurationLabel: UILabel!
    
    /// the movie's genres
    @IBOutlet weak var genresLabel: UILabel!
    
    override func setupView() {
        super.setupView()
        addSeparator(leftInset: 15, rightInset: 15)
    }
    
    /**
     Update the cell data
     - Parameter synopsis: movie's synopsis
     */
    func configure(_ synopsis: Movie.Synopsis) {
        var title = synopsis.title ?? ""
        if let releaseYear = synopsis.releaseDate?.year() {
            title += " (\(releaseYear))"
        }
        titleLabel.text = title
        buildVoteDurationAttributedString(synopsis.voteAverage, duration: synopsis.duration)
        genresLabel.text = synopsis.genres?.map { $0.name }.joined(separator: ", ")
    }
    
    /**
     Display movie vote
     - Parameter vote: movie vote
     */
    private func buildVoteDurationAttributedString(_ vote: Double, duration: Int) {
        /// Vote part
        let attachment = NSTextAttachment()
        let voteImage = UIImage.vote ?? .init()
        attachment.image = voteImage
        let mutableAttributed = NSMutableAttributedString(attachment: attachment)
        // Adjust vertical offset for the right
        attachment.bounds = CGRect(x: 0, y: -voteImage.size.height/5, width: voteImage.size.width, height: voteImage.size.height)
        let voteAttributedString = NSAttributedString(string: " \(vote)/10", attributes: [.font: UIFont.systemFont(ofSize: 15)])
        mutableAttributed.append(voteAttributedString)
        
        /// Duration part
        let durationAttributedString = NSAttributedString(string: " | " + duration.durationString, attributes: [.font: UIFont.systemFont(ofSize: 15)])
        mutableAttributed.append(durationAttributedString)

        self.voteDurationLabel.attributedText = mutableAttributed
    }
}
