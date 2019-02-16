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

    private var genresRequesterController = GenreRequesterController.init()

    override func awakeFromNib() {
        self.clipsToBounds = true
        self.layer.cornerRadius = Dimens.Radius.bigCorner

        genresRequesterController.delegate = self
    }

    func setup(withMovie movie: ListableMovie) {
        guard let moviePosterPath =  movie.posterPath else {

            releaseLabel.isHidden = true
            return
        }

        titleLabel.text = movie.title
        releaseLabel.text = "Release at \(movie.release)"

        self.posterImageView.setImage(fromPath: moviePosterPath, placeHolderImage: UIImage.init())

        genresRequesterController.needGenres(withIDs: movie.genresIDs)
    }

    func set(genre: String?) {
        genresLabel.text = genre
    }
}

extension PUExpandedMovieCollectionViewCell: GenreRequesterControllerDelegate {
    func genresHasArrived(_ requester: GenreRequesterController, genres: [String]) {
        genresLabel.text = genres.reduce("") { (currentValue, currentString) -> String in
            return "\(currentValue) \(currentString.lowercased())"
        }
    }

    func errorHappend(_ requester: GenreRequesterController, error: Error?) {
        genresLabel.isHidden = true
    }
}
