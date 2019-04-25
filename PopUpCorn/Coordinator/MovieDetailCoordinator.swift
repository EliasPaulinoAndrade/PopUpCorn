//
//  MovieDetailCoordinator.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 25/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailCoordinator: NavigatorProtocol {
    var rootViewController: UINavigationController

    var movieDetailViewController = MovieDetailViewController.init()

    init(withRootViewController rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    func start() {
        rootViewController.pushViewController(movieDetailViewController, animated: true)
    }
}
