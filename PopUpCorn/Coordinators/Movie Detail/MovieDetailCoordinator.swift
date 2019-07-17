//
//  MovieDetailCoordinator.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 25/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailCoordinator: NSObject, CoordinatorProtocol {
    var rootViewController: RootViewControllerProtocol

    var moviesLister: MovieListUserProtocol?

    weak public var delegate: MovieDetailCoordinatorDelegate?

    lazy var transitioning = TransitioningDelegateForDetailMovie.init(withTargetMoviePosition: moviePosition, listingMoviesController: moviesLister, rootViewController: rootViewController, andInteractionController: interactiveTransision)

    lazy var interactiveTransision: PanGestureInteractiveTransition = {
        let interactiveTransision = PanGestureInteractiveTransition.init(viewController: movieDetailViewController)

        return interactiveTransision
    }()

    lazy var movieDetailCoordinator = MovieDetailCoordinator.init(withRootViewController: rootViewController)

    var movie: DetailableMovie? {
        didSet {
            movieDetailViewController.title = movie?.title ?? MoviePlaceholder.title
            movieDetailViewController.movie = movie
        }
    }

    var moviePosition: Int? {
        didSet {
            transitioning.interactionController = interactiveTransision
            transitioning.moviePosition = moviePosition
        }
    }

    lazy private var movieDetailViewController: MovieDetailViewController = {
        let movieDetailViewController = MovieDetailViewController.init()

        movieDetailViewController.delegate = self

        return movieDetailViewController
    }()

    var autoDismiss: Bool

    init(withRootViewController rootViewController: RootViewControllerProtocol, autoDismiss: Bool = false) {
        self.rootViewController = rootViewController
        self.autoDismiss = autoDismiss
    }

    func start(previousController: UIViewController?) {
        guard let previousController = previousController else {
            return
        }

        movieDetailViewController.resetSimilarMovies(toMovieId: movie?.id)

        if moviePosition != nil {
            movieDetailViewController.transitioningDelegate = transitioning
            movieDetailViewController.modalPresentationStyle = .custom
            movieDetailViewController.modalPresentationCapturesStatusBarAppearance = false
        }

        previousController.present(movieDetailViewController, animated: true, completion: nil)
    }
}

extension MovieDetailCoordinator: MovieDetailViewControllerDelegate {
    func scrollInteractionEnded(withTranslation translation: CGFloat, beganLimit: CGFloat) {

        self.interactiveTransision.finish(currentTranslation: translation - beganLimit, totalTranslation: 700)
    }

    func scrollInteractionHappend(withTranslation translation: CGFloat, beganLimit: CGFloat) {
        if translation > beganLimit {
            self.interactiveTransision.update(currentTranslation: translation - beganLimit, totalTranslation: 700)
        }
    }

    func similarMovieWasSelected(movie: DetailableMovie, atPosition position: Int) {
        movieDetailCoordinator.moviesLister = movieDetailViewController
        movieDetailCoordinator.movie = movie
        movieDetailCoordinator.moviePosition = position

        movieDetailCoordinator.start(previousController: movieDetailViewController)
    }

    func edgeInteractionHappend(recognizer: UIPanGestureRecognizer) {
        if let totalTranslation = recognizer.view?.bounds.size.width {
            self.interactiveTransision.update(recognizer: recognizer, totalTranslation: totalTranslation)
        }
    }

    func closeButtonTapped() {
        transitioning.interactionController = nil
        movieDetailViewController.dismiss(animated: true, completion: nil)
    }

    func movieWasRemoved(_ movie: DetailableMovie) {
        if autoDismiss {
            transitioning.interactionController = nil
            movieDetailViewController.dismiss(animated: true) { [weak self] in
                self?.delegate?.movieReminderWasRemoved(movie: movie)
            }
        } else {
            self.delegate?.movieReminderWasRemoved(movie: movie)
        }
    }
}
