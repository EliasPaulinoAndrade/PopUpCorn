//
//  NavigationFlowManager.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 12/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class NavigationFlowManager {

    static let shared = NavigationFlowManager.init()

    private init() {}

    var upComingMoviesController: UpComingMoviesViewController = {
        let upComingMoviesController = UpComingMoviesViewController.init()

        return upComingMoviesController
    }()

    var navigationController: UINavigationController = {
        let navigationViewController = UINavigationController.init()

        navigationViewController.navigationBar.isTranslucent = false
        navigationViewController.navigationBar.barTintColor = UIColor.puLightPurple
        navigationViewController.navigationBar.prefersLargeTitles = true
        navigationViewController.navigationBar.tintColor = UIColor.white
        navigationViewController.navigationBar.barStyle = .black

        return navigationViewController
    }()

    func firtViewController() -> UIViewController {

        let navigationViewController = navigationController
        let movieListViewController = upComingMoviesController

        navigationViewController.viewControllers = [movieListViewController]

        return navigationController
    }
}
