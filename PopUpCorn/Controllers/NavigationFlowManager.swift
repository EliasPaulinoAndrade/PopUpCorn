//
//  NavigationFlowManager.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 12/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

struct NavigationFlowManager {

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

    var tabBarController: UITabBarController = {
        let tabBarController = UITabBarController.init()

        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.barTintColor = UIColor.puLightPurple
        tabBarController.tabBar.tintColor = UIColor.puLightRed

        return tabBarController
    }()

    func firtViewController() -> UIViewController {

        let tabViewController = tabBarController
        let navigationViewController = navigationController
        let movieListViewController = upComingMoviesController

        tabViewController.viewControllers = [navigationViewController]
        navigationViewController.viewControllers = [movieListViewController]

        return tabViewController
    }
}
