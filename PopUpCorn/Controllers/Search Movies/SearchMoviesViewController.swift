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

    override func viewDidLoad() {

        self.title = This.CONSTTitle
        self.addChild(movieListViewController, inView: self.view)
    }

}

private extension SearchMoviesViewController {
    typealias This = SearchMoviesViewController

    static let CONSTTitle = "Search"
}
