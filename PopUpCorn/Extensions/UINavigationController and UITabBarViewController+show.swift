//
//  UINavigationController and UITabBarViewController+show.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 08/06/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

extension UINavigationController: RootViewControllerProtocol {
    func reloadableChildController() -> ReloadableChildProtocol? {
        return nil
    }

    func start(viewController: UIViewController) {
        self.pushViewController(viewController, animated: true)
    }
}

extension UITabBarController: RootViewControllerProtocol {
    func reloadableChildController() -> ReloadableChildProtocol? {
        return nil
    }

    func start(viewController: UIViewController) {
        guard let controllerIndex = self.viewControllers?.index(of: viewController) else {
            self.addChild(viewController)
            let currentPosition = (self.viewControllers?.count ?? 1)
            self.viewControllers?.insert(viewController, at: 0)
            self.viewControllers?.remove(at: currentPosition)
            self.selectedIndex = 0
            return
        }
        self.selectedIndex = controllerIndex
    }
}
