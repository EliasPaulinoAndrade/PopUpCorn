//
//  MovieListViewController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 11/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

/// a view controller resposible by listing movies in expanded and normal way.
class MovieListViewController: UIViewController {

    @IBOutlet weak var moviesCollectionView: UICollectionView!

    @IBOutlet weak var toggleButton: PUToggleButtonView!

    @IBOutlet weak var loadIndicatorPlace: UIView!

    @IBOutlet weak var loadIndicatorPlaceHeightConstraint: NSLayoutConstraint!

    weak var delegate: MovieListViewControllerDelegate?

    var state = MovieListControllerState.expanded

    private var movies: [ListableMovie] = []

    private var loadIndicatorController = LoadIndicatorViewController.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(loadIndicatorController, inView: loadIndicatorPlace)
        loadIndicatorController.startAnimating()

        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        toggleButton.delegate = self

        registerMovieCells()
    }

    func registerMovieCells() {
        moviesCollectionView.register(
            nibWithName: MovieCell.Exapanded.nibName,
            identifiedBy: MovieCell.Exapanded.reuseIdentifier
        )

        moviesCollectionView.register(
            nibWithName: MovieCell.Normal.nibName,
            identifiedBy: MovieCell.Normal.reuseIdentifier
        )
    }

    func reloadData() {
        self.moviesCollectionView.reloadData()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        moviesCollectionView.collectionViewLayout.invalidateLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        moviesCollectionView.collectionViewLayout.invalidateLayout()
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return delegate?.numberOfMovies(self) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier:
                (state == .normal ?
                    MovieCell.Normal.reuseIdentifier :
                    MovieCell.Exapanded.reuseIdentifier
                ),
            for: indexPath
        )

        if let movieCell = cell as? PUMovieCollectionViewCellProtocol {
            if let movie = delegate?.movieList(self, movieForPositon: indexPath.row) {

                movies.append(movie)
                movieCell.setup(withMovie: movie)
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        switch state {
        case .expanded:
            if collectionView.isStanding {
                let cellWidth = collectionView.bounds.width
                let cellHeight = cellWidth * 1.1

                return CGSize.init(width: cellWidth, height: cellHeight)
            } else {
                let cellWidth = collectionView.bounds.width/2 - 10
                let cellHeight = cellWidth * 1.1

                return CGSize.init(width: cellWidth, height: cellHeight)
            }

        case .normal:
            if collectionView.isStanding {
                let cellWidth = collectionView.bounds.width/3 - 10
                let cellHeight = cellWidth * 1.7

                return CGSize.init(width: cellWidth, height: cellHeight)
            } else {
                let cellWidth = collectionView.bounds.width/5 - 10
                let cellHeight = cellWidth * 1.7

                return CGSize.init(width: cellWidth, height: cellHeight)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let moviesCount = delegate?.numberOfMovies(self) else {
            return
        }

        if indexPath.row == (moviesCount - 2) {
            delegate?.needLoadMoreMovies(self)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let bounceSize = scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.frame.height)

        if bounceSize < -Constants.scrollMinimunBounceToShowLoadIndicator {
            loadIndicatorPlaceHeightConstraint.constant = -bounceSize
        } else {
            loadIndicatorPlaceHeightConstraint.constant = 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.movieList(self, didSelectItemAt: indexPath.row)
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

        let firstCellIndexPath = IndexPath.init(row: 0, section: 0)
        self.moviesCollectionView.scrollToItem(at: firstCellIndexPath, at: .top, animated: true)
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

    static let scrollMinimunBounceToShowLoadIndicator: CGFloat = 15
}
