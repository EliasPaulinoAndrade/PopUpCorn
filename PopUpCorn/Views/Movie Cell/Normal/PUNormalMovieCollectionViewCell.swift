//
//  PUNormalMovieCollectionViewCell.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 14/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

class PUNormalMovieCollectionViewCell: UICollectionViewCell, PUMovieCollectionViewCellProtocol {

    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.clipsToBounds = true
            containerView.layer.cornerRadius = Dimens.Radius.shortCorner
        }
    }

    @IBOutlet weak var movieImageView: PUTMDBImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(withMovie movie: ListableMovie) {

        titleLabel.text = movie.title

        let placeHolderImage = UIImage.init(named: Constants.placeHolderImageName)

        movieImageView.image = placeHolderImage
        if let moviePosterPath = (movie.posterPath ?? movie.backdropPath) {
            movieImageView.setImage(
                fromPath: moviePosterPath,
                placeHolderImage: placeHolderImage ?? UIImage.init()
            )
        }
    }
}

private enum Constants {
    static let placeHolderImageName = "placeholderImage"
}
