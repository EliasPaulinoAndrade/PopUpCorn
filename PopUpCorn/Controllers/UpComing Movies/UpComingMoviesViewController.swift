//
//  UpComingMoviesViewController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 13/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

class UpComingMoviesViewController: UIViewController {

    private var movieListViewController = MovieListViewController.init()
    private var tmdbService = PUTMDBService.init()
    private var moviePage: Page?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = This.CONSTTitle
        movieListViewController.delegate = self

        formatMovieList()
        requestMovieList()

    }

    func formatMovieList() {
        addChild(movieListViewController)
        view.addSubview(movieListViewController.view)

        movieListViewController.view.translatesAutoresizingMaskIntoConstraints = false

        movieListViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        movieListViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        movieListViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        movieListViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        movieListViewController.didMove(toParent: self)
    }

    func requestMovieList() {
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

    func imageForMovie(_ movieList: MovieListViewController, atPosition position: Int, completion: @escaping (UIImage?) -> Void) {

        guard let movie = self.moviePage?.movies[position] else {
            return
        }

        tmdbService.image(fromMovie: movie, withID: position,
            progressCompletion: { (movieImage, id) in
                if let moviePosition = id, moviePosition == position {
                    DispatchQueue.main.async {
                        completion(movieImage)
                    }
                }
            },
            errorCompletion: { (_) in
                completion(nil)
            }
        )
    }
}

private extension UpComingMoviesViewController {
    typealias This = UpComingMoviesViewController

    static let CONSTTitle = "UpComing"
}
