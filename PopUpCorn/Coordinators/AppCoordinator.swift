//
//  AppCoordinator.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 08/06/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

class AppCoordinator: NSObject, CoordinatorProtocol {
    lazy var rootViewController: RootViewControllerProtocol = {
        let tabBarController = UITabBarController()
        tabBarController.delegate = self
        tabBarController.tabBar.backgroundColor = UIColor.puLightPurple
        tabBarController.tabBar.tintColor = UIColor.white
        tabBarController.tabBar.barStyle = .black

        return tabBarController
    }()

    lazy var firstTabControllerCoordinator = UpComingMoviesNavigationCoordinator(rootViewController: rootViewController)
    lazy var secondTabControllerCoordinator = RemindMoviesNavigationCoordinator(rootViewController: rootViewController)

    func start(previousController: UIViewController? = nil) {
        guard let window = UIApplication.shared.delegate?.window else {
            return
        }

        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        secondTabControllerCoordinator.start()
        firstTabControllerCoordinator.start()
    }

    func showTabAt(position: Int) {
        guard let tabBarController = self.rootViewController as? UITabBarController else {
            return
        }
        tabBarController.selectedIndex = position
    }

    func configureNavigationDueNotification(withNotificationIdentifier notificationIdentifier: String) {
        UIView.animate(
            withDuration: 0.2,
            animations: {
               self.showTabAt(position: 1)
            },
            completion: { (_) in
                self.secondTabControllerCoordinator.firstControllerCoordinator.openRemindMovieWithID(notificationIdentifier)
            }
        )
    }
}

extension AppCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        var reloadableController: ReloadableChildProtocol?

        if let rootViewController = viewController as? RootViewControllerProtocol {
            reloadableController = rootViewController.reloadableChildController()
        } else if let reloadableViewController = viewController as? ReloadableChildProtocol {
            reloadableController = reloadableViewController
        }

        reloadableController?.reloadData()
    }
}
