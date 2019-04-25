//
//  UpComingMoviesCoordinator.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 25/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class UpComingMoviesCoordinator: NavigatorProtocol {
    var rootViewController: UINavigationController

    lazy var searchMoviesCoordinator = SearchMoviesCoordinator.init(withRootViewController: rootViewController)

    lazy var movieDetailCoordinator = MovieDetailCoordinator.init(withRootViewController: rootViewController)

    lazy var upComingMoviesController: UpComingMoviesViewController = {
        let upComingMoviesController = UpComingMoviesViewController.init()

        upComingMoviesController.delegate = self

        return upComingMoviesController
    }()

    init(withRootViewController rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    func start() {
        rootViewController.pushViewController(upComingMoviesController, animated: true)
    }
}

extension UpComingMoviesCoordinator: UpComingMoviesViewControllerDelegate {
    func upComingMovieWasSelected(movie: DetailableMovie) {
        movieDetailCoordinator.movieDetailViewController.movie = movie

        movieDetailCoordinator.start()
    }

    func searchButtonWasSelected() {

        searchMoviesCoordinator.start()
    }
}
