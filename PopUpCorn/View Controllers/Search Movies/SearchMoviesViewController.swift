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

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController.init(searchResultsController: nil)
        searchController.searchResultsUpdater = self
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
        self.addChild(movieListViewController, inView: self.view)
        self.movieListViewController.delegate = self
        self.movieRequesterController.delegate = self

        formatNavigationBar()
    }

    func formatNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension SearchMoviesViewController: MovieListViewControllerDelegate {

    func movies(_ movieList: MovieListViewController) -> [Movie] {
        return movieRequesterController.movies
    }

    func needLoadMoreMovies(_ movieList: MovieListViewController) {
        movieRequesterController.needMoreMovies()
    }

    func genresForMovie(_ movieList: MovieListViewController, atPosition position: Int, completion: @escaping (String) -> Void) {

    }
}

extension SearchMoviesViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {

        movieRequesterController.resetPagination()
        movieRequesterController.needMoreMovies()
    }

    func willPresentSearchController(_ searchController: UISearchController) {

    }

    func didPresentSearchController(_ searchController: UISearchController) {

    }

    func didDismissSearchController(_ searchController: UISearchController) {

    }
}

extension SearchMoviesViewController: MovieRequesterControllerSearchDelegate {
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

private enum Constants {
    static let title = "Search"
    static let searchBarPlaceHolder = "tap here"
}
