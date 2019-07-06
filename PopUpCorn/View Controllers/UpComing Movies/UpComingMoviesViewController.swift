//
//  UpComingMoviesViewController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 13/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

/// a view controller that shows the inical app screen
class UpComingMoviesViewController: UIViewController, MovieListUserProtocol, MovieFormatterProtocol {

    var movieListViewController = MovieListViewController.init()
    private var movieRequesterController = MovieRequesterController.init()
    private var errorPresenterController = ErrorPresenterViewController.init()
    private var loadIndicatorViewController = LoadIndicatorViewController.init()

    weak var delegate: UpComingMoviesViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        movieListViewController.delegate = self
        movieRequesterController.delegate = self
        errorPresenterController.reloadDelegate = self

        self.addChild(errorPresenterController, inView: self.view)
        self.addChild(movieListViewController, inView: self.view)
        self.addChild(loadIndicatorViewController, inView: self.view)

        loadIndicatorViewController.startAnimating()
        movieRequesterController.needMoreMovies()
    }
}

extension UpComingMoviesViewController: MovieListViewControllerDelegate {
    func mustShowToggleBackground(_ movieList: MovieListViewController) -> Bool {
        return true
    }
    
    func noMovieTitle(_ movieList: MovieListViewController) -> String {
        return "No UpComing Movie"
    }

    func movieList(_ movieList: MovieListViewController, movieForPositon position: Int) -> ListableMovie {
        let movie = movieRequesterController.movies[position]

        let listableMovie: ListableMovie = format(movie: movie)

        return listableMovie
    }

    func numberOfMovies(_ movieList: MovieListViewController) -> Int {
        return movieRequesterController.numberOfMovies
    }

    func movies(_ movieList: MovieListViewController) -> [Movie] {
        return movieRequesterController.movies
    }

    func needLoadMoreMovies(_ movieList: MovieListViewController) {
        movieRequesterController.needMoreMovies()
    }

    func movieList(_ movieList: MovieListViewController, didSelectItemAt position: Int) {
        let movie = movieRequesterController.movies[position]

        let detailableMovie: DetailableMovie = format(
            movie: movie,
            imageType: movieList.toggleButton.isFistButtonSelected ? .backdrop : .poster)

        delegate?.upComingMovieWasSelected(movie: detailableMovie, atPosition: position)
    }
}

extension UpComingMoviesViewController: MovieRequesterControllerDelegate {
    func errorHappend(_ requester: MovieRequesterController, error: Error?) {
        errorPresenterController.showReloaderError(withTitle: Errors.Load.title, andMessage: Errors.Load.message)
    }

    func moviesEndPoint(_ requester: MovieRequesterController) -> PUTMDBMovieType {
        return .upComing
    }

    func moviesHaveArrived(_ requester: MovieRequesterController) {
        movieListViewController.reloadData()
        loadIndicatorViewController.stopAnimating()
    }
}

extension UpComingMoviesViewController: ReloaderAlertBuilderDelegate {
    func needReloadData(_ alertBuilder: ReloaderAlertBuilder) {
        loadIndicatorViewController.startAnimating()
        movieRequesterController.needMoreMovies()
    }
}
