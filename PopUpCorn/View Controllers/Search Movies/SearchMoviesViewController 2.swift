//
//  SearchMoviesViewController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 14/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

import UIKit

/// a view controller that shows the search screen.
class SearchMoviesViewController: UIViewController, MovieListUserProtocol, MovieFormatterProtocol {

    var movieListViewController = MovieListViewController.init()
    private var movieRequesterController = MovieRequesterController.init()
    private var errorPresenterController = ErrorPresenterViewController.init()
    private var movieDetailViewController = MovieDetailViewController.init()
    private var searchSuggestionsViewController = SearchSuggestionsViewController.init()
    private var loadIndicatorController = LoadIndicatorViewController.init()

    weak var delegate: SearchMoviesViewControllerDelegate?

    lazy var searchController: UISearchController = {
        let searchController = UISearchController.init(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "\(Constants.searchBarPlaceHolder)"
        searchController.definesPresentationContext = true
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barStyle = .black

        return searchController
    }()

    override func viewDidLoad() {

        searchController.addChild(errorPresenterController, inView: self.view)
        addChild(searchSuggestionsViewController, inView: self.view)
        addChild(movieListViewController, inView: self.view)
        searchController.addChild(loadIndicatorController, inView: self.view)

        showSuggestions()

        searchSuggestionsViewController.delegate = self
        movieListViewController.delegate = self
        movieRequesterController.delegate = self
        errorPresenterController.reloadDelegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(appMoveToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        formatNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        searchSuggestionsViewController.saveSuggestions()
    }

    @objc func appMoveToBackground() {
        searchSuggestionsViewController.saveSuggestions()
    }

    func formatNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.becomeFirstResponder()
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.resignFirstResponder()
        searchController.resignFirstResponder()
    }

    func showSuggestions() {
        movieListViewController.view.isHidden = true
        searchSuggestionsViewController.view.isHidden = false
        searchSuggestionsViewController.reloadData()
    }

    func hideSuggestions() {
        movieListViewController.view.isHidden = false
        searchSuggestionsViewController.view.isHidden = true
    }
}

extension SearchMoviesViewController: MovieListViewControllerDelegate {
    func noMovieTitle(_ movieList: MovieListViewController) -> String {
        return "No Results in Search."
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

        let detailableMovie: DetailableMovie = format(movie: movie, imageType: movieList.toggleButton.isFistButtonSelected)

        movieDetailViewController.movie = detailableMovie

        delegate?.searchMovieWasSelected(movie: detailableMovie, atPosition: position)
    }
}

extension SearchMoviesViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
                return
        }

        if searchText.isEmpty {
            searchSuggestionsViewController.removeParamenter()
        } else {
            searchSuggestionsViewController.setParamenter(text: searchText)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text,
            !searchText.isEmpty else {

                return
        }

        hideSuggestions()
        searchSuggestionsViewController.add(suggestion: searchText)
        movieRequesterController.resetPagination()
        movieListViewController.reloadData()
        loadIndicatorController.startAnimating()
        movieRequesterController.needMoreMovies()
    }

    func willPresentSearchController(_ searchController: UISearchController) {
        showSuggestions()
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        searchSuggestionsViewController.removeParamenter()
        showSuggestions()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showSuggestions()
    }
}

extension SearchMoviesViewController: MovieRequesterControllerSearchDelegate {
    func errorHappend(_ requester: MovieRequesterController, error: Error?) {
        errorPresenterController.showReloaderError(withTitle: Errors.Load.title, andMessage: Errors.Load.message)
    }

    func moviesHaveArrived(_ requester: MovieRequesterController) {
        movieListViewController.reloadData()
        loadIndicatorController.stopAnimating()
    }

    func moviesEndPoint(_ requester: MovieRequesterController) -> PUTMDBMovieType {
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

extension SearchMoviesViewController: SearchSuggestionsViewContorllerDelegate {
    func userDidSelectSuggestion(_ controller: SearchSuggestionsViewController, suggestion: String) {
        searchController.isActive = true
        searchController.isEditing = true

        self.searchController.searchBar.text = suggestion
    }
}

private enum Constants {
    static let title = "Search"
    static let searchBarPlaceHolder = "type here"
}
