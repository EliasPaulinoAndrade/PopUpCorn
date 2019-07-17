//
//  MoviesNavigationController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 08/06/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

class MoviesNavigationController: UINavigationController {
    var reloadableChild: ReloadableChildProtocol?

    init() {
        super.init(nibName: nil, bundle: nil)

        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.puLightPurple
        navigationBar.prefersLargeTitles = true
        navigationBar.tintColor = UIColor.white
        navigationBar.barStyle = .black
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func reloadableChildController() -> ReloadableChildProtocol? {
        return reloadableChild
    }
}
