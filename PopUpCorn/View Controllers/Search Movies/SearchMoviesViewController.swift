//
//  SearchMoviesViewController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 14/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

import UIKit

class SearchMoviesViewController: UIViewController {

    private var movieListViewController = MovieListViewController.init()
    private var movieRequesterController = MovieRequesterController.init()
    private var errorPresenterController = ErrorPresenterViewController.init()
    private var movieDetailViewController = MovieDetailViewController.init()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController.init(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "\(Constants.searchBarPlaceHolder)"
        searchController.definesPresentationContext = true
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor.white

        return searchController
    }()

    override func viewDidLoad() {

        self.title = Constants.title

        self.searchController.addChild(errorPresenterController, inView: self.view)
        self.addChild(movieListViewController, inView: self.view)

        self.movieListViewController.delegate = self
        self.movieRequesterController.delegate = self
        self.errorPresenterController.reloadDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        formatNavigationBar()
    }

    func formatNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.becomeFirstResponder()
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.resignFirstResponder()
        searchController.resignFirstResponder()
    }
}

extension SearchMoviesViewController: MovieListViewControllerDelegate {

    func movieList(_ movieList: MovieListViewController, movieForPositon position: Int) -> ListableMovie {
        let movie = movieRequesterController.movies[position]

        let listableMovie = ListableMovie.init(
            title: movie.title ?? "No Title",
            release: movie.releaseDate ?? "No Release Date",
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath,
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

    func movieList(_ movieList: MovieListViewController, didSelectItemAt position: Int) {
        let movie = movieRequesterController.movies[position]

        let detailableMovie = DetailableMovie.init(
            title: movie.title ?? "No Title",
            release: movie.releaseDate ?? "No Release",
            image: movie.backdropPath ?? movie.posterPath,
            genres: movie.genreIDs,
            overview: movie.overview ?? "No Overview."
        )

        movieDetailViewController.movie = detailableMovie
        searchController.isActive = false
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

extension SearchMoviesViewController: UISearchControllerDelegate, UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text,
            !searchText.isEmpty else {
                
                return
        }
        
        movieRequesterController.resetPagination()
        movieListViewController.reloadData()
        movieRequesterController.needMoreMovies()
    }
}

extension SearchMoviesViewController: MovieRequesterControllerSearchDelegate {
    func errorHappend(_ requester: MovieRequesterController, error: Error?) {
        errorPresenterController.showReloaderError(withTitle: Errors.Load.title, andMessage: Errors.Load.message)
    }

    func moviesHaveArrived(_ requester: MovieRequesterController) {
        self.movieListViewController.reloadData()
    }

    func moviesEndPoint(_ requester: MovieRequesterController) -> PUTTMDBEndPoint.Movie {
        return .search
    }

    func queryString(_ requester: MovieRequesterController) -> String? {
        guard let searchText = searchController.searchBar.text,
            !searchText.isEmpty else {

            return nil
        }

        return searchText
    }
}

extension SearchMoviesViewController: ReloaderAlertBuilderDelegate {
    func needReloadData(_ alertBuilder: ReloaderAlertBuilder) {
        movieRequesterController.needMoreMovies()
    }
}

private enum Constants {
    static let title = "Search"
    static let searchBarPlaceHolder = "tap here"
}
