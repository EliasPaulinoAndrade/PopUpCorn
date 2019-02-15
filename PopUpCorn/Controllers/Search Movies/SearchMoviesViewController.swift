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
    private var tmdbService = PUTMDBService.init()
    private var moviesPage: Page?

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController.init(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "\(This.CONSTSearchBarPlaceHolder)"
        searchController.definesPresentationContext = true
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor.white

        return searchController
    }()

    override func viewDidLoad() {

        self.title = This.CONSTTitle
        self.addChild(movieListViewController, inView: self.view)
        self.movieListViewController.delegate = self

        formatNavigationBar()
    }

    func formatNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension SearchMoviesViewController: MovieListViewControllerDelegate {
    func movies(_ movieList: MovieListViewController) -> [Movie] {
        return moviesPage?.movies ?? []
    }

    func imageForMovie(_ movieList: MovieListViewController, atPosition position: Int, completion: @escaping (UIImage?) -> Void) {
        guard let movie = self.moviesPage?.movies[position] else {
            return
        }

        tmdbService.image(fromMovie: movie, withID: position,
            progressCompletion: { (movieImage) in
                DispatchQueue.main.async {
                    completion(movieImage)
                }
            },
            errorCompletion: { (_) in
                completion(nil)
            }
        )
    }

    func needLoadMoreMovies(_ movieList: MovieListViewController) {
        guard let currentPageNumber = moviesPage?.number,
              let searchText = searchController.searchBar.text,
              !searchText.isEmpty else {

            return
        }

        tmdbService.searchMovies(inPageNumber: currentPageNumber, withStringQuery: searchText, sucessCompletion: { (page) in

            self.moviesPage?.movies.append(contentsOf: page.movies)
            self.moviesPage?.number = currentPageNumber + 1

            DispatchQueue.main.async {
                self.movieListViewController.reloadData()
            }

        }, errorCompletion: { (_) in

        })
    }
}

extension SearchMoviesViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {

        guard let searchText = searchController.searchBar.text,
              !searchText.isEmpty else {

            return
        }

        tmdbService.searchMovies(withStringQuery: searchText, sucessCompletion: { (page) in

            self.moviesPage = page
            DispatchQueue.main.async {
                self.movieListViewController.reloadData()
            }
        
        }, errorCompletion: { (_) in

        })
    }

    func willPresentSearchController(_ searchController: UISearchController) {

    }

    func didPresentSearchController(_ searchController: UISearchController) {

    }

    func didDismissSearchController(_ searchController: UISearchController) {

    }
}

private extension SearchMoviesViewController {
    typealias This = SearchMoviesViewController

    static let CONSTTitle = "Search"
    static let CONSTSearchBarPlaceHolder = "tap here"
}
