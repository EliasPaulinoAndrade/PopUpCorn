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
    var rootViewController: UINavigationController

    lazy var transitioningDelegate = TransitioningDelegateForDetailMovie.init(withTargetMoviePosition: moviePosition, rootViewController: rootViewController)

    var movie: DetailableMovie? {
        didSet {
            movieDetailViewController.title = movie?.title ?? MoviePlaceholder.title
            movieDetailViewController.movie = movie
        }
    }

    var moviePosition: Int? {
        didSet {
            transitioningDelegate.moviePosition = moviePosition
        }
    }

    lazy private var movieDetailViewController: MovieDetailViewController = {
        let movieDetailViewController = MovieDetailViewController.init()

        movieDetailViewController.delegate = self

        return movieDetailViewController
    }()

    init(withRootViewController rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    func start(previousController: UIViewController?) {
        guard let previousController = previousController else {
            return
        }

        if moviePosition != nil {
            movieDetailViewController.transitioningDelegate = transitioningDelegate
            movieDetailViewController.modalPresentationStyle = .custom
            movieDetailViewController.modalPresentationCapturesStatusBarAppearance = false
        }

        previousController.present(movieDetailViewController, animated: true, completion: nil)
    }
}

extension MovieDetailCoordinator: MovieDetailViewControllerDelegate {
    func closeButtonTapped() {
        movieDetailViewController.dismiss(animated: true, completion: nil)
    }
}
