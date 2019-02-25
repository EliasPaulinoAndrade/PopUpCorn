//
//  ClosableControllerProtocol.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 16/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

internal protocol ClosableProtocol: class {

}

protocol ClosableViewControllerProtocol: ClosableProtocol where Self: UIViewController {
    func close()
}
