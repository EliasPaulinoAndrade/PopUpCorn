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

    @IBOutlet weak var toggleButton: PUToggleButtonView!

    weak var delegate: MovieListViewControllerDelegate?

    var state = MovieListControllerState.expanded

    override func viewDidLoad() {
        super.viewDidLoad()

        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        toggleButton.delegate = self

        registerMovieCells()
    }

    func registerMovieCells() {
        moviesCollectionView.register(nibWithName: MovieCell.Exapanded.nibName, identifiedBy: MovieCell.Exapanded.reuseIdentifier)

        moviesCollectionView.register(nibWithName: MovieCell.Normal.nibName, identifiedBy: MovieCell.Normal.reuseIdentifier)
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

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: state == .expanded ?
                MovieCell.Exapanded.reuseIdentifier :
                MovieCell.Normal.reuseIdentifier ,
            for: indexPath
        )

        guard let movie = delegate?.movies(self)[indexPath.row] else {
            return cell
        }

        if let movieCell = cell as? PUMovieCollectionViewCellProtocol {
            movieCell.setup(withMovie: movie)
        }

        if let expandedMovieCell = cell as? PUExpandedMovieCollectionViewCell {
            delegate?.genresForMovie(self,
                 atPosition: indexPath.row,
                 completion: { (genresString) in
                    DispatchQueue.main.async {
                        expandedMovieCell.set(genre: genresString)
                    }
                }
            )
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        switch state {
        case .expanded:
            let cellWidth = collectionView.bounds.width
            let cellHeight = cellWidth * 1.1

            return CGSize.init(width: cellWidth, height: cellHeight)
        case .normal:
            let cellWidth = collectionView.bounds.width/3 - 10
            let cellHeight = cellWidth * 1.5

            return CGSize.init(width: cellWidth, height: cellHeight)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let moviesCount = delegate?.movies(self).count else {
            return
        }

        if indexPath.row == (moviesCount - 2) {
            delegate?.needLoadMoreMovies(self)
        }
    }
}

extension MovieListViewController: PUToggleButtonViewDelegate {

    func didSelectButton(currentState: PUToggleButtonState) {

        if currentState == .first {
            self.state = .expanded
        } else if currentState == .second {
            self.state = .normal
        }

        self.reloadData()
    }

    func imageForFirstButton() -> UIImage? {
        return UIImage.init(named: Constants.ImagesName.expanded)
    }

    func imageForSecondButton() -> UIImage? {
        return UIImage.init(named: Constants.ImagesName.grid)
    }

    func tintColor() -> UIColor {
        return UIColor.puRed
    }
}

private enum Constants {
    enum ImagesName {
        static let expanded = "expanded"
        static let grid = "grid"
    }
}
