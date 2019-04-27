//
//  MovieDetailViewController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 16/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

/// a view controller that shows the detail view of a detailableMovie
class MovieDetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: PUTMDBImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var headerView: UIView! {
        didSet {
            headerView.clipsToBounds = true
            headerView.layer.masksToBounds = false
            headerView.layer.cornerRadius = Dimens.Radius.shortCorner
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeImageView: UIImageView! {
        didSet {
            closeImageView.isUserInteractionEnabled = true
            closeImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(closeTapped(recognizer:))))
        }
    }

    weak var delegate: MovieDetailViewControllerDelegate?

    var movie: DetailableMovie?

    private var genresRequesterController = GenreRequesterController.init()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        genresRequesterController.delegate = self
        scrollView.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillAppear(_ animated: Bool) {

        self.detailImageView.image = nil
        navigationController?.navigationBar.prefersLargeTitles = false
        formatMovie()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if view.isStanding {
            UIView.animate(withDuration: Constants.scrollOffSetAnimationDuration) {
                self.scrollView.contentOffset.y = Constants.imageDefaultHeight
            }
        } else {
            UIView.animate(withDuration: Constants.scrollOffSetAnimationDuration) {
                self.scrollView.contentOffset.y = 0.0
            }
        }
    }

    @objc func closeTapped(recognizer: UITapGestureRecognizer) {
        delegate?.closeButtonTapped()
    }

    func formatMovie() {
        guard let movie = self.movie else {
            return
        }

        let placeHolderImage = UIImage.init(named: Constants.placeHolderImageName)

        titleLabel.set(unsafeText: movie.title, placeHolder: MoviePlaceholder.title)
        releaseLabel.set(unsafeText: movie.release, placeHolder: MoviePlaceholder.release)
        overviewLabel.set(unsafeText: movie.overview, placeHolder: MoviePlaceholder.overview)

        detailImageView.image = placeHolderImage
        if let movieImage = movie.image {
            detailImageView.setImage(
                fromPath: movieImage,
                placeHolderImage: placeHolderImage ?? UIImage.init()
            )
        }

        genresRequesterController.needGenres(withIDs: movie.genres)
    }
}

extension MovieDetailViewController: GenreRequesterControllerDelegate {
    func genresHasArrived(_ requester: GenreRequesterController, genres: [String]) {
        genresLabel.isHidden = false
        genresLabel.text = genres.reduce("") { (currentValue, currentString) -> String in
            return "\(currentValue) \(currentString.lowercased())"
        }
    }

    func errorHappend(_ requester: GenreRequesterController, error: Error?) {
        genresLabel.isHidden = true
    }
}

extension MovieDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let currentOffSet = scrollView.contentOffset

        if currentOffSet.y < 0.0 {
            detailImageView.translatesAutoresizingMaskIntoConstraints = false
            imageHeightConstraint.constant = Constants.imageDefaultHeight - currentOffSet.y
        }
    }
}

private enum Constants {
    static let placeHolderImageName = "placeholderImage"
    static let imageDefaultHeight: CGFloat = 350
    static let scrollOffSetAnimationDuration = 0.3
}
