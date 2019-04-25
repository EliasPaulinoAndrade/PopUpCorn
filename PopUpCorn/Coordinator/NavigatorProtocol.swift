//
//  NavigatorProtocol.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 25/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

protocol NavigatorProtocol {
    var rootViewController: UINavigationController { get set }
    func start()
}
