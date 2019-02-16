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

    func movies(_ movieList: MovieListViewController) -> [Movie] {
        return movieRequesterController.movies
    }

    func needLoadMoreMovies(_ movieList: MovieListViewController) {

        movieRequesterController.needMoreMovies()
    }

    func genresForMovie(_ movieList: MovieListViewController, atPosition position: Int, completion: @escaping (String) -> Void) {

//        guard let movie = self.moviePage?.movies[position] else {
//            completion(String())
//            return
//        }
//
//        tmdbService.genres(sucessCompletion: { (genres) in
//            let genreDict = genres.genreDictionary()
//            var genresString = String()
//
//            for genreID in movie.genreIDs {
//                if let genreName = genreDict[genreID]?.name {
//                    genresString.append("\(genreName.lowercased()) ")
//                }
//            }
//            completion(genresString)
//        }, errorCompletion: { (_) in
//
//            completion(String())
//        })
    }
}

extension UpComingMoviesViewController: MovieRequesterControllerDelegate {
    func moviesHaveArrived(_ requester: MovieRequesterController) {
        movieListViewController.reloadData()
    }
}

private enum Constants {
    static let title = "UpComing"
}
