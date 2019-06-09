//
//  RemindMoviesNavigationCoordinator.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 08/06/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

class RemindMoviesNavigationCoordinator: CoordinatorProtocol {

    var parentRootViewController: RootViewControllerProtocol

    lazy var rootViewController: RootViewControllerProtocol = {
        let navigationViewController = MoviesNavigationController()

        navigationViewController.navigationBar.isTranslucent = false
        navigationViewController.navigationBar.barTintColor = UIColor.puLightPurple
        navigationViewController.navigationBar.prefersLargeTitles = true
        navigationViewController.navigationBar.tintColor = UIColor.white
        navigationViewController.navigationBar.barStyle = .black

        return navigationViewController
    }()

    lazy var firstControllerCoordinator = RemindMoviesCoordinator(withRootViewController: rootViewController)

    init(rootViewController: RootViewControllerProtocol) {
        self.parentRootViewController = rootViewController
    }

    func start(previousController: UIViewController? = nil) {
        self.parentRootViewController.start(viewController: rootViewController)
        firstControllerCoordinator.start()

        rootViewController.tabBarItem = UITabBarItem.init(tabBarSystemItem: .bookmarks, tag: 0)

        if let moviesNavigationController = self.rootViewController as? MoviesNavigationController {
            moviesNavigationController.reloadableChild = firstControllerCoordinator
        }
    }
}
