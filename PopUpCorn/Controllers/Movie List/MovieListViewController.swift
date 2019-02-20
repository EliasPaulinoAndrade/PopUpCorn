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
        let expandedMovieCellNib = UINib.init(nibName: This.CONSTExpandedMovieCellNibName, bundle: Bundle.main)
        moviesCollectionView.register(expandedMovieCellNib, forCellWithReuseIdentifier: This.CONSTExpandedMovieCellReuseIdentifier)

        let normalMovieCellNib = UINib.init(nibName: This.CONSTNormalMovieCellNibName, bundle: Bundle.main)
        moviesCollectionView.register(normalMovieCellNib, forCellWithReuseIdentifier: This.CONSTNormalMovieCellReuseIdentifier)
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
                This.CONSTExpandedMovieCellReuseIdentifier :
                This.CONSTNormalMovieCellReuseIdentifier ,
            for: indexPath
        )

        guard let movie = delegate?.movies(self)[indexPath.row] else {
            return cell
        }

        if let movieCell = cell as? PUMovieCollectionViewCellProtocol {
            movieCell.setup(withMovie: movie)
            delegate?.imageForMovie(self,
                atPosition: indexPath.row,
                completion: { (movieImage) in

                    movieCell.set(image: movieImage)
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
        return UIImage.init(named: "expanded")
    }

    func imageForSecondButton() -> UIImage? {
        return UIImage.init(named: "grid")
    }

    func tintColor() -> UIColor {
        return UIColor.puRed
    }
}

private extension MovieListViewController {
    typealias This = MovieListViewController

    static let CONSTExpandedMovieCellNibName = "PUExpandedMovieCollectionViewCell"
    static let CONSTNormalMovieCellNibName = "PUNormalMovieCollectionViewCell"
    static let CONSTExpandedMovieCellReuseIdentifier = "expanded_movie_cell_identifier"
    static let CONSTNormalMovieCellReuseIdentifier = "normal_movie_cell_identifier"
    static let CONSTTitle = "UpComing"
}
