//
//  RemindMoviesViewController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 08/06/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

class RemindMoviesViewController: UIViewController, MovieListUserProtocol, MovieFormatterProtocol {

    var movieListViewController = MovieListViewController(showLoadIndicator: false)
    private var errorPresenterController = ErrorPresenterViewController()
    var movieReminderListController = MovieReminderListController()

    weak public var delegate: RemindMovesViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        movieListViewController.delegate = self
        movieReminderListController.delegate = self

        self.addChild(errorPresenterController, inView: self.view)
        self.addChild(movieListViewController, inView: self.view)
    }
}

extension RemindMoviesViewController: MovieListViewControllerDelegate {
    func noMovieTitle(_ movieList: MovieListViewController) -> String {
        return "No Movies to Remind."
    }

    func movieList(_ movieList: MovieListViewController, movieForPositon position: Int) -> ListableMovie {
        let movie = movieReminderListController.movies[position]

        let listableMovie: ListableMovie = format(movie: movie)

        return listableMovie
    }

    func numberOfMovies(_ movieList: MovieListViewController) -> Int {
        return movieReminderListController.numberOfMovies
    }

    func movies(_ movieList: MovieListViewController) -> [Movie] {
        return movieReminderListController.movies
    }

    func needLoadMoreMovies(_ movieList: MovieListViewController) { }

    func movieList(_ movieList: MovieListViewController, didSelectItemAt position: Int) {
        let movie = movieReminderListController.movies[position]

        let detailableMovie: DetailableMovie = format(
            movie: movie,
            imageType: movieList.toggleButton.isFistButtonSelected ? .backdrop : .poster
        )

        delegate?.remindMovieWasSelected(movie: detailableMovie, atPosition: position)
    }
}

extension RemindMoviesViewController: MovieReminderListControllerDelegate {
    func removeReminderAtPosition(position: Int) {
        movieListViewController.removeMovie(atPosition: position)
    }

    func reloadRemindersData() {
        self.movieListViewController.reloadData()
    }
}
