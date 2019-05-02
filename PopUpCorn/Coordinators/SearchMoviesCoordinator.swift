//
//  SearchMoviesCoordinator.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 25/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class SearchMoviesCoordinator: CoordinatorProtocol {
    var rootViewController: UINavigationController

    var searchMoviesViewController = SearchMoviesViewController.init()

    init(withRootViewController rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    func start() {
        searchMoviesViewController.title = Constants.title
        rootViewController.pushViewController(searchMoviesViewController, animated: true)
    }
}

private enum Constants {
    static let title = "Search"
}
