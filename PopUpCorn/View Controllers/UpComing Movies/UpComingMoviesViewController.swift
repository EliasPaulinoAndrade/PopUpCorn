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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Constants.title
        movieListViewController.delegate = self
        movieRequesterController.delegate = self
        movieRequesterController.needMoreMovies()

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
            title: movie.title ?? "No Title",
            release: movie.releaseDate ?? "No Release Date",
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

    }

    func moviesEndPoint(_ requester: MovieRequesterController) -> PUTTMDBEndPoint.Movie {
        return .upComing
    }

    func moviesHaveArrived(_ requester: MovieRequesterController) {
        movieListViewController.reloadData()
    }
}

private enum Constants {
    static let title = "UpComing"
}
