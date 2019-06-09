//
//  RemindMoviesCoordinator.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 08/06/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

class RemindMoviesCoordinator: CoordinatorProtocol, ReloadableChildProtocol {
    var rootViewController: RootViewControllerProtocol

    lazy var movieDetailCoordinator = MovieDetailCoordinator.init(withRootViewController: rootViewController, autoDismiss: true)

    lazy var remindMoviesViewController: RemindMoviesViewController = {
        let remindMoviesViewController = RemindMoviesViewController()
        remindMoviesViewController.delegate = self
        return remindMoviesViewController
    }()

    init(withRootViewController rootViewController: RootViewControllerProtocol) {
        self.rootViewController = rootViewController
        movieDetailCoordinator.delegate = self
    }

    func start(previousController: UIViewController? = nil) {
        remindMoviesViewController.title = Constants.title
        rootViewController.start(viewController: remindMoviesViewController)
    }

    func reloadData() {
        self.remindMoviesViewController.movieReminderListController.reloadData()
    }

    func openRemindMovieWithID(_ id: String) {
        guard let moviePosition = self.remindMoviesViewController.movieReminderListController.remindMoviePosition(forID: id) else {
            return
        }

        let movie = self.remindMoviesViewController.movieReminderListController.movies[moviePosition]
        let detailableMovie: DetailableMovie = self.remindMoviesViewController.format(movie: movie)
        movieDetailCoordinator.moviesLister = remindMoviesViewController
        movieDetailCoordinator.movie = detailableMovie
        movieDetailCoordinator.moviePosition = moviePosition
        movieDetailCoordinator.start(previousController: remindMoviesViewController)
    }
}

extension RemindMoviesCoordinator: RemindMovesViewControllerDelegate {
    func remindMovieWasSelected(movie: DetailableMovie, atPosition position: Int) {
        movieDetailCoordinator.moviesLister = remindMoviesViewController
        movieDetailCoordinator.movie = movie
        movieDetailCoordinator.moviePosition = position
        movieDetailCoordinator.start(previousController: remindMoviesViewController)
    }
}

extension RemindMoviesCoordinator: MovieDetailCoordinatorDelegate {
    func movieReminderWasRemoved(movie: DetailableMovie) {
        remindMoviesViewController.movieReminderListController.reminderWasRemoved(movie: movie)
    }
}

private enum Constants {
    static let title = "Reminder"
}
