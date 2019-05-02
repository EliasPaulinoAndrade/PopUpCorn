//
//  MovieDetailCoordinator.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 25/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailCoordinator: CoordinatorProtocol {
    var rootViewController: UINavigationController

    var movie: DetailableMovie? {
        didSet {
            movieDetailViewController.title = movie?.title ?? MoviePlaceholder.title
            movieDetailViewController.movie = movie
        }
    }

    private var movieDetailViewController = MovieDetailViewController.init()

    init(withRootViewController rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    func start() {
        rootViewController.pushViewController(movieDetailViewController, animated: true)
    }
}
