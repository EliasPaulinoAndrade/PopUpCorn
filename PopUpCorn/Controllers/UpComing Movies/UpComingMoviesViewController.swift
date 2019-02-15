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
        requestMovieList()
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
}

private extension UpComingMoviesViewController {
    typealias This = UpComingMoviesViewController

    static let CONSTTitle = "UpComing"
}
