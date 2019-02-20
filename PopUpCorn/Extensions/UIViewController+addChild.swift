//
//  UIViewController+addChild.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 14/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func addChild(_ child: UIViewController, inView view: UIView) {
        addChild(child)
        view.addSubview(child.view)

        child.view.translatesAutoresizingMaskIntoConstraints = false

        child.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        child.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        child.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        child.didMove(toParent: self)
    }
}
