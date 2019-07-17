//
//  PUExpandedMovieCollectionViewCell.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 12/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit
import MetalPerformanceShaders

class PUExpandedMovieCollectionViewCell: UICollectionViewCell, PUMovieCollectionViewCellProtocol, MovieFormatterProtocol {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var posterImageView: PUTMDBImageView!
    @IBOutlet weak var headerImageView: PUTMDBImageView!
    @IBOutlet weak var containerView: PURadiusView!
    @IBOutlet weak var headerContainerView: PUTMDBImageView!

    lazy var moviePosterImageView: UIImageView = {
        return posterImageView
    }()

    private var genresRequesterController = GenreRequesterController.init()

    override func awakeFromNib() {
        self.clipsToBounds = true
        self.layer.cornerRadius = Dimens.Radius.bigCorner

        genresRequesterController.delegate = self
    }

    func setup(withMovie movie: ListableMovie) {
        titleLabel.text = movie.title
        releaseLabel.text = "\(releaseString(fromDate: movie.release) ?? "No Release Date")"
        releaseLabel.isHidden = false

        let placeHolderImage = UIImage.init(named: Constants.placeHolderImageName)

        if let moviePosterPath = (movie.backdropPath ?? movie.posterPath) {
            self.posterImageView.setImage(
                fromPath: moviePosterPath,
                placeHolderImage: placeHolderImage ?? UIImage.init()
            )

            self.headerImageView.setImage(
                fromPath: moviePosterPath,
                placeHolderImage: placeHolderImage ?? UIImage.init()
            )
        }

        self.headerImageView.image = placeHolderImage
        self.posterImageView.image = placeHolderImage

        genresLabel.isHidden = false
        genresRequesterController.needGenres(withIDs: movie.genresIDs)
    }
}

extension PUExpandedMovieCollectionViewCell: GenreRequesterControllerDelegate {
    func genresHasArrived(_ requester: GenreRequesterController, genres: [String]) {
        genresLabel.isHidden = false
        genresLabel.text = genres.reduce("") { (currentValue, currentString) -> String in
            return "\(currentValue) \(currentString.capitalized)"
        }
    }

    func errorHappend(_ requester: GenreRequesterController, error: Error?) {
        genresLabel.isHidden = true
    }
}

private enum Constants {
    static let releaseSufix = "Release at"
    static let placeHolderImageName = "placeholderImage"
}
