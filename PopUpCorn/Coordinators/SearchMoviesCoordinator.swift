//
//  SearchMoviesCoordinator.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 25/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class SearchMoviesCoordinator: CoordinatorProtocol {
    var rootViewController: UINavigationController

    lazy var searchMoviesViewController: SearchMoviesViewController = {
        let searchMoviesViewController = SearchMoviesViewController.init()

        searchMoviesViewController.delegate = self

        return searchMoviesViewController
    }()

    lazy var movieDetailCoordinator = MovieDetailCoordinator.init(withRootViewController: rootViewController)

    init(withRootViewController rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    func start(previousController: UIViewController? = nil) {
        searchMoviesViewController.title = Constants.title
        rootViewController.pushViewController(searchMoviesViewController, animated: true)
    }
}

extension SearchMoviesCoordinator: SearchMoviesViewControllerDelegate {
    func searchMovieWasSelected(movie: DetailableMovie, atPosition position: Int) {
        movieDetailCoordinator.moviesLister = searchMoviesViewController
        movieDetailCoordinator.movie = movie
        movieDetailCoordinator.moviePosition = position

        movieDetailCoordinator.start(previousController: searchMoviesViewController.searchController)
    }
}

private enum Constants {
    static let title = "Search"
}
