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
        if self.view.isStanding {
            self.tabBar.frame.origin.y -= 5
            self.tabBar.subviews.first?.clipsToBounds = true
            self.tabBar.subviews.first?.layer.cornerRadius = 10
            self.tabBar.backgroundColor = .clear
            self.tabBar.layer.shadowOpacity = 1
            self.tabBar.layer.shadowColor = UIColor.black.cgColor
            self.tabBar.layer.shadowOffset = CGSize.zero
            self.tabBar.layer.shadowRadius = 10
            self.tabBar.frame.size.height = 50
        }
    }

    override func viewDidLayoutSubviews() {
        if self.view.isStanding {
            self.tabBar.frame.origin.y -= 5
            self.tabBar.center.x = self.view.center.x
            self.tabBar.frame.size.width = self.view.frame.width - 20
            self.tabBar.subviews.first?.clipsToBounds = true
            self.tabBar.subviews.first?.layer.cornerRadius = 10
            self.tabBar.center.x = self.view.center.x
            self.tabBar.frame.size.height = 50
        } else {
            self.tabBar.subviews.first?.layer.cornerRadius = 0
        }
    }
}
