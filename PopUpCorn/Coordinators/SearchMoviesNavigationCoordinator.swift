//
//  SearchMoviesNavigationCoordinator.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 24/06/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class SearchMoviesNavigationCoordinator: CoordinatorProtocol {

    var parentRootViewController: RootViewControllerProtocol

    var rootViewController: RootViewControllerProtocol = {
        let navigationViewController = UINavigationController.init()

        navigationViewController.navigationBar.isTranslucent = false
        navigationViewController.navigationBar.barTintColor = UIColor.puLightPurple
        navigationViewController.navigationBar.prefersLargeTitles = true
        navigationViewController.navigationBar.tintColor = UIColor.white
        navigationViewController.navigationBar.barStyle = .black

        return navigationViewController
    }()

    lazy var firstControllerCoordinator = SearchMoviesCoordinator(withRootViewController: rootViewController)

    init(rootViewController: RootViewControllerProtocol) {
        self.parentRootViewController = rootViewController
    }

    func start(previousController: UIViewController? = nil) {
        self.parentRootViewController.start(viewController: rootViewController)

        firstControllerCoordinator.start()

        rootViewController.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "search"), tag: 2)
    }

    func willDisappear() {
//        if firstControllerCoordinator.isPresentingSearchCoordinator {
//            firstControllerCoordinator.searchMoviesCoordinator.searchMoviesViewController.searchController.isActive = false
//            firstControllerCoordinator.searchMoviesCoordinator.searchMoviesViewController.navigationController?.popViewController(animated: false)
//            firstControllerCoordinator.upComingMoviesController.navigationItem.searchController = nil
//        }
    }
}
