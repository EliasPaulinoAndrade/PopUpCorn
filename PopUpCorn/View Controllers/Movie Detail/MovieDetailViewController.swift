//
//  MovieDetailViewController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 16/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: PUTMDBImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var headerView: UIView!

    var movie: DetailableMovie?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillDisappear(_ animated: Bool) {

        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillAppear(_ animated: Bool) {

        navigationController?.navigationBar.prefersLargeTitles = false
        formatMovie()
    }

    func formatMovie() {
        guard let movie = self.movie else {
            return
        }

        titleLabel.text = movie.title
        releaseLabel.text = movie.release
        genresLabel.text = movie.genres
        overviewLabel.text = movie.overview
        detailImageView.setImage(fromPath: movie.image, placeHolderImage: UIImage.init())
    }
}
