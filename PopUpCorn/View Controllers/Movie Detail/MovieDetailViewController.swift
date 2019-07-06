//
//  MovieDetailViewController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 16/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

/// a view controller that shows the detail view of a detailableMovie
class MovieDetailViewController: UIViewController, MovieListUserProtocol, MovieFormatterProtocol {

    @IBOutlet weak var reminderImageView: UIImageView!
    @IBOutlet weak var detailImageView: PUTMDBImageView!
    @IBOutlet weak var similarMoviesTitleLabel: UILabel!
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

    @IBOutlet weak var moviesListPlaceView: UIView!

    var movieListViewController = MovieListViewController.init()

    weak var delegate: MovieDetailViewControllerDelegate?

    var movie: DetailableMovie?

    private var genresRequesterController = GenreRequesterController.init()
    private var similarMoviesRequesterController = SimilarMovieRequesterController()
    private var movieReminderController = MovieReminderController()
    private var errorPresenter = ErrorPresenterViewController()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        genresRequesterController.delegate = self
        similarMoviesRequesterController.delegate = self
        movieListViewController.delegate = self
        movieReminderController.delegate = self

        self.addChild(movieListViewController, inView: self.moviesListPlaceView)
        self.addChild(errorPresenter, inView: self.view)
        movieListViewController.scrollDirection = .horizontal

        scrollView.delegate = self
        formatGestures()
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillAppear(_ animated: Bool) {

        self.detailImageView.image = nil
        navigationController?.navigationBar.prefersLargeTitles = false
        formatMovie()
        similarMoviesRequesterController.needMoreMovies()
        movieReminderController.controllerWillAppear()
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

    func formatGestures() {
        let edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer.init(
            target: self,
            action: #selector(edgePanned(recognizer:))
        )

        edgePanGestureRecognizer.edges = .left

        let reminderTapGesture = UITapGestureRecognizer(target: self, action: #selector(reminderTapped(recognizer:)))

        self.view.addGestureRecognizer(edgePanGestureRecognizer)
        self.reminderImageView.isUserInteractionEnabled = true
        self.reminderImageView.addGestureRecognizer(reminderTapGesture)
    }

    @objc func edgePanned(recognizer: UIScreenEdgePanGestureRecognizer) {
        delegate?.edgeInteractionHappend(recognizer: recognizer)
    }

    @objc func closeTapped(recognizer: UITapGestureRecognizer) {
        delegate?.closeButtonTapped()
    }

    @objc func reminderTapped(recognizer: UITapGestureRecognizer) {
        guard let movie = self.movie else {
            return
        }

        movieReminderController.needRemindMovie(movie)
    }

    func formatMovie() {
        guard let movie = self.movie else {
            return
        }

        let placeHolderImage = UIImage.init(named: Constants.placeHolderImageName)

        titleLabel.set(unsafeText: movie.title, placeHolder: MoviePlaceholder.title)
        releaseLabel.set(unsafeText: releaseString(fromDate: movie.release), placeHolder: MoviePlaceholder.release)
        overviewLabel.set(unsafeText: movie.overview, placeHolder: MoviePlaceholder.overview)

        detailImageView.image = placeHolderImage
        if let movieImage = movie.image {
            detailImageView.setImage(
                fromPath: movieImage,
                placeHolderImage: placeHolderImage ?? UIImage.init()
            )
        }

        genresRequesterController.needGenres(withIDs: movie.genres)
        if movieReminderController.mustShowReminderButton(forMovie: movie) {
            reminderImageView.isHidden = false
        } else {
            reminderImageView.isHidden = true
        }
    }

    func resetSimilarMovies(toMovieId movieId: String?) {
        similarMoviesRequesterController.resetPagination()

        if movieListViewController.isViewLoaded {
            movieListViewController.reloadData()
            scrollView.contentOffset = CGPoint.zero
        }

        similarMoviesRequesterController.movieID = movieId
    }
}

extension MovieDetailViewController: GenreRequesterControllerDelegate {
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

extension MovieDetailViewController: SimilarMovieRequesterControllerDelegate {
    func moviesHaveArrived(_ requester: SimilarMovieRequesterController) {
        movieListViewController.reloadData()
    }

    func errorHappend(_ requester: SimilarMovieRequesterController, error: Error?) {
        similarMoviesTitleLabel.isHidden = false
    }
}

extension MovieDetailViewController: MovieListViewControllerDelegate {
    func mustShowToggleBackground(_ movieList: MovieListViewController) -> Bool {
        return true
    }

    func noMovieTitle(_ movieList: MovieListViewController) -> String {
        return "No Related Movies."
    }

    func movieList(_ movieList: MovieListViewController, movieForPositon position: Int) -> ListableMovie {
        let movie = similarMoviesRequesterController.movies[position]

        let listableMovie: ListableMovie = format(movie: movie)

        return listableMovie
    }

    func numberOfMovies(_ movieList: MovieListViewController) -> Int {
        let numberOfMovies = similarMoviesRequesterController.numberOfMovies

        if numberOfMovies == 0 {
            similarMoviesTitleLabel.isHidden = true
        } else {
            similarMoviesTitleLabel.isHidden = false
        }

        return numberOfMovies
    }

    func movies(_ movieList: MovieListViewController) -> [Movie] {
        return similarMoviesRequesterController.movies
    }

    func needLoadMoreMovies(_ movieList: MovieListViewController) {
        similarMoviesRequesterController.needMoreMovies()
    }

    func movieList(_ movieList: MovieListViewController, didSelectItemAt position: Int) {
        let movie = similarMoviesRequesterController.movies[position]

        let detailableMovie: DetailableMovie = format(
            movie: movie,
            imageType: movieList.toggleButton.isFistButtonSelected ? .backdrop : .poster
        )

        delegate?.similarMovieWasSelected(movie: detailableMovie, atPosition: position)
    }
}

extension MovieDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let currentOffSet = scrollView.contentOffset

        if currentOffSet.y < 0.0 {
            let translation = Constants.imageDefaultHeight - currentOffSet.y
            detailImageView.translatesAutoresizingMaskIntoConstraints = false
            imageHeightConstraint.constant = translation

//            delegate?.scrollInteractionHappend(withTranslation: translation, beganLimit: 500)
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let currentOffSet = scrollView.contentOffset
//        let translation = Constants.imageDefaultHeight - currentOffSet.y
//        delegate?.scrollInteractionEnded(withTranslation: translation, beganLimit: 500)
    }
}

extension MovieDetailViewController: MovieReminderControllerDelegate {
    func reminderWasAdded(inReminders: Bool) {
        if inReminders {
            showReminderAlert(message: "A reminder was added. You will notified when \(movie?.title ?? "...") be released.")
        } else {
            showReminderAlert(message: "A reminder was added. You can see it in the reminders tab.")
        }
    }

    func needRemoveMovie(movie: DetailableMovie) {
        self.delegate?.movieWasRemoved(movie)
    }

    func reloadReminderButton() {
        guard let movie = self.movie else {
            return
        }

        if movieReminderController.movieHasReminder(movie) {
            self.reminderImageView.image = UIImage(named: Constants.removeReminderImage)
        } else {
            self.reminderImageView.image = UIImage(named: Constants.addReminderImage)
        }
    }

    func needShowError(message: String) {
        errorPresenter.showSimpleError(withTitle: "Error", andMessage: message)
    }

    func showReminderAlert(message: String) {
        let alertController = UIAlertController(title: "Reminder", message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

private enum Constants {
    static let placeHolderImageName = "placeholderImage"
    static let addReminderImage = "addReminder"
    static let removeReminderImage = "removeReminder"
    static let imageDefaultHeight: CGFloat = 350
    static let scrollOffSetAnimationDuration = 0.3
}
