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
            containerView.layer.cornerRadius = 5
        }
    }

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(withMovie movie: Movie) {

        titleLabel.text = movie.title
        movieImageView.image = nil
    }

    func set(image: UIImage?) {
        movieImageView.image = image
    }
}
