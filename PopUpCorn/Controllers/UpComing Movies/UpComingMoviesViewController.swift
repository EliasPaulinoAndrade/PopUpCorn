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
    private var tmdbService = PUTMDBService.init()
    private var moviePage: Page?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = This.CONSTTitle
        movieListViewController.delegate = self

        self.addChild(movieListViewController, inView: self.view)

        formatNavigationBar()
        requestInitialMovieList()
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

    func requestInitialMovieList() {
        tmdbService.upComingMovies(
            sucessCompletion: { (moviePage) in
                self.moviePage = moviePage
                DispatchQueue.main.async {
                    self.movieListViewController.reloadData()
                }
            },
            errorCompletion: { (_) in

            }
        )
    }
}

extension UpComingMoviesViewController: MovieListViewControllerDelegate {

    func movies(_ movieList: MovieListViewController) -> [Movie] {
        return moviePage?.movies ?? []
    }

    func needLoadMoreMovies(_ movieList: MovieListViewController) {
        guard let currentPageNumber = moviePage?.number else {
            return
        }

        tmdbService.upComingMovies(inPageNumber: currentPageNumber, sucessCompletion: { (page) in

            self.moviePage?.movies.append(contentsOf: page.movies)
            self.moviePage?.number = currentPageNumber + 1

            DispatchQueue.main.async {
                self.movieListViewController.reloadData()
            }

            }, errorCompletion: { (_) in

        })
    }

    func imageForMovie(_ movieList: MovieListViewController, atPosition position: Int, completion: @escaping (UIImage?) -> Void) {

        guard let movie = self.moviePage?.movies[position] else {
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

    func genresForMovie(_ movieList: MovieListViewController, atPosition position: Int, completion: @escaping (String) -> Void) {

        guard let movie = self.moviePage?.movies[position] else {
            completion(String())
            return
        }

        tmdbService.genres(sucessCompletion: { (genres) in
            let genreDict = genres.genreDictionary()
            var genresString = String()

            for genreID in movie.genreIDs {
                if let genreName = genreDict[genreID]?.name {
                    genresString.append("\(genreName) ")
                }
            }

            completion(genresString)

        }, errorCompletion: { (_) in

            completion(String())
        })
    }
}

private extension UpComingMoviesViewController {
    typealias This = UpComingMoviesViewController

    static let CONSTTitle = "UpComing"
}
