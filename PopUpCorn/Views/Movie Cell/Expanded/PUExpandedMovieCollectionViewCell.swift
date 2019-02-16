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
    @IBOutlet weak var posterImageView: PUTMDBImageView!

    override func awakeFromNib() {
        self.clipsToBounds = true
        self.layer.cornerRadius = Dimens.Radius.bigCorner
    }

    func setup(withMovie movie: ListableMovie) {
        guard let moviePosterPath =  movie.posterPath else {

            releaseLabel.isHidden = true
            return
        }

        titleLabel.text = movie.title
        releaseLabel.text = "Release at \(movie.release)"

        self.posterImageView.setImage(fromPath: moviePosterPath, placeHolderImage: UIImage.init())

    }

    func set(genre: String?) {
        genresLabel.text = genre
    }
}
