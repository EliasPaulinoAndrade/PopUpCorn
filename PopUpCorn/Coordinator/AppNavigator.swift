//
//  AppNavigator.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 25/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class AppNavigator: NavigatorProtocol {
    var rootViewController: UINavigationController = {
        let navigationViewController = UINavigationController.init()

        navigationViewController.navigationBar.isTranslucent = false
        navigationViewController.navigationBar.barTintColor = UIColor.puLightPurple
        navigationViewController.navigationBar.prefersLargeTitles = true
        navigationViewController.navigationBar.tintColor = UIColor.white
        navigationViewController.navigationBar.barStyle = .black

        return navigationViewController
    }()

    lazy var firstControllerCoordinator = UpComingMoviesCoordinator(withRootViewController: rootViewController)

    func start() {

        guard let window = UIApplication.shared.delegate?.window else {
            return
        }

        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        firstControllerCoordinator.start()
    }
}
