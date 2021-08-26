//
//  MovieCell.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 26/8/21.
//

import UIKit
import Kingfisher

/// `MovieCell` display movie poster.
class MovieCell: BaseTableViewCell {
    /// the movie's thumbnail image
    @IBOutlet weak var thumbnail: UIImageView!

    /// the movie's title
    @IBOutlet weak var titleLabel: UILabel!
    
    /// the movie's release date
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    /// the movie's overview
    @IBOutlet weak var descriptionLabel: UILabel!
    
    /// the movie's vote
    @IBOutlet weak var voteLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnail.image = nil
    }
    
    override func setupView() {
        super.setupView()
        addSeparator()
    }
    
    /**
     Update the cell displays with the movie
     - Parameter movie: movie
     - Parameter position: position of the cell
     */
    func configure(_ movie: Movie, position: UITableView.IndexPathPosition = .invalid) {
        self.position = position
        loadImage(movie.posterPath)
        titleLabel.text = movie.title
        releaseDateLabel.text = movie.releaseDate?.year()
        descriptionLabel.text = movie.overview
        buildVoteAttributedString(movie.voteAverage)
    }
    
    /**
     Display movie thumbnail
     - Parameter posterPath: path of thumbnail
     */
    private func loadImage(_ posterPath: String?) {
        guard let posterPath = posterPath else { return }
        let urlString = API.image(type: PosterImage.w154, path: posterPath).urlString
        thumbnail.kf.setImage(with: URL(string: urlString))
        thumbnail.roundCorners(.allCorners, radius: 3)
        thumbnail.layer.borderWidth = 0.5
        thumbnail.layer.borderColor = R.color.textColor()?.withAlphaComponent(0.3).cgColor
    }
    
    /**
     Display movie vote
     - Parameter vote: movie vote
     */
    private func buildVoteAttributedString(_ vote: Double) {
        let attachment = NSTextAttachment()
        let voteImage = UIImage.vote ?? .init()
        attachment.image = voteImage
        let mutableAttributed = NSMutableAttributedString(attachment: attachment)
        // Adjust vertical offset for the right
        attachment.bounds = CGRect(x: 0, y: -voteImage.size.height/5, width: voteImage.size.width, height: voteImage.size.height)
        let voteAttributedString = NSAttributedString(string: " \(vote)", attributes: [.font: UIFont.systemFont(ofSize: 13)])
        mutableAttributed.append(voteAttributedString)
        self.voteLabel.attributedText = mutableAttributed
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {}
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
}
