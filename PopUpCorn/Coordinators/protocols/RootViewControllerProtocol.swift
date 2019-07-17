//
//  RootViewControllerProtocol.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 08/06/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

@objc protocol RootViewControllerProtocol where Self: UIViewController {
    func start(viewController: UIViewController)
    func reloadableChildController() -> ReloadableChildProtocol?
}
