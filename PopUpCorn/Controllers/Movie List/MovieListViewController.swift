//
//  MovieListViewController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 11/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {

    @IBOutlet weak var moviesCollectionView: UICollectionView!

    weak var delegate: MovieListViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self

        registerMovieCell()
    }

    func registerMovieCell() {
        let movieCellNib = UINib.init(nibName: This.CONSTMovieCellNibName, bundle: Bundle.main)
        moviesCollectionView.register(movieCellNib, forCellWithReuseIdentifier: This.CONSTMovieCellReuseIdentifier)
    }

    func reloadData() {
        self.moviesCollectionView.reloadData()
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return delegate?.movies(self).count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: This.CONSTMovieCellReuseIdentifier, for: indexPath)

        if let movieCell = cell as? PUExpandedMovieCollectionViewCell,
           let movie = delegate?.movies(self)[indexPath.row] {

            movieCell.titleLabel.text = movie.title
            movieCell.posterImageView.image = nil

            delegate?.imageForMovie(self,
                atPosition: indexPath.row,
                completion: { (movieImage) in

                    DispatchQueue.main.async {
                        movieCell.posterImageView.image = movieImage
                    }
                }
            )
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellWidth = collectionView.bounds.width

        //ajeitar aqui
        let cellHeight = cellWidth * 1.1

        return CGSize.init(width: cellWidth, height: cellHeight)
    }
}

private extension MovieListViewController {
    typealias This = MovieListViewController

    static let CONSTMovieCellNibName = "PUExpandedMovieCollectionViewCell"
    static let CONSTMovieCellReuseIdentifier = "movie_cell_identifier"
    static let CONSTTitle = "UpComing"
}
