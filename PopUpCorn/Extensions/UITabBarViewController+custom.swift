//
//  UITabBarViewController+custom.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 24/06/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidAppear(_ animated: Bool) {
        self.tabBar.tintColor = .puExtraLightRed
        self.tabBar.backgroundColor = .clear
        self.tabBar.layer.shadowOpacity = 1
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOffset = CGSize.zero
        self.tabBar.layer.shadowRadius = 10
    }
}
