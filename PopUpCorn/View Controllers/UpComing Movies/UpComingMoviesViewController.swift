//
//  UpComingMoviesViewController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 13/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

class UpComingMoviesViewController: UIViewController {

    private var searchMoviesViewControler = SearchMoviesViewController.init()
    private var movieListViewController = MovieListViewController.init()
    private var movieRequesterController = MovieRequesterController.init()
    private var errorPresenterController = ErrorPresenterViewController.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Constants.title
        movieListViewController.delegate = self
        movieRequesterController.delegate = self
        errorPresenterController.reloadDelegate = self
        movieRequesterController.needMoreMovies()

        self.addChild(errorPresenterController, inView: self.view)
        self.addChild(movieListViewController, inView: self.view)

        formatNavigationBar()
    }

    func formatNavigationBar() {
        let navigationBarButton = UIBarButtonItem.init(
            barButtonSystemItem: UIBarButtonItem.SystemItem.search,
            target: self,
            action: #selector(searchButtonWasTapped(sender:))
        )

        self.navigationItem.rightBarButtonItem = navigationBarButton
    }

    @objc func searchButtonWasTapped(sender: UIBarButtonItem) {
        navigationController?.pushViewController(searchMoviesViewControler, animated: true)
    }
}

extension UpComingMoviesViewController: MovieListViewControllerDelegate {
    func movieList(_ movieList: MovieListViewController, movieForPositon position: Int) -> ListableMovie {
        let movie = movieRequesterController.movies[position]

        let listableMovie = ListableMovie.init(
            title: movie.title ?? Constants.MoviePlaceholder.title,
            release: movie.releaseDate ?? Constants.MoviePlaceholder.release,
            posterPath: movie.posterPath,
            genresIDs: movie.genreIDs
        )

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

    func genresForMovie(_ movieList: MovieListViewController, atPosition position: Int, completion: @escaping (String) -> Void) {

    }
}

extension UpComingMoviesViewController: MovieRequesterControllerDelegate {
    func errorHappend(_ requester: MovieRequesterController, error: Error?) {
        errorPresenterController.showReloaderError(withTitle: Errors.Load.title, andMessage: Errors.Load.message)
    }

    func moviesEndPoint(_ requester: MovieRequesterController) -> PUTTMDBEndPoint.Movie {
        return .upComing
    }

    func moviesHaveArrived(_ requester: MovieRequesterController) {
        movieListViewController.reloadData()
    }
}

extension UpComingMoviesViewController: ReloaderAlertBuilderDelegate {
    func needReloadData(_ alertBuilder: ReloaderAlertBuilder) {
        movieRequesterController.needMoreMovies()
    }
}

private enum Constants {
    static let title = "UpComing"

    enum MoviePlaceholder {
        static let title = "No Title"
        static let release = "No Release Date"
    }
}
