//
//  PUExpandedMovieCollectionViewCell.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 12/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

class PUExpandedMovieCollectionViewCell: UICollectionViewCell, PUMovieCollectionViewCellProtocol {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!

    override func awakeFromNib() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
    }

    func setup(withMovie movie: Movie) {
        titleLabel.text = movie.title

        if let movieReleaseDateString = movie.releaseDate {
            releaseLabel.text = "Release at \(movieReleaseDateString)"
        } else {
            releaseLabel.isHidden = true
        }
        posterImageView.image = nil

    }

    func set(image: UIImage?) {
        posterImageView.image = image
    }
}
