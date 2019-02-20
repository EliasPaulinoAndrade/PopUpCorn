//
//  PUToggleButtonViewDelegate.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 14/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

protocol PUToggleButtonViewDelegate: AnyObject {

    func didSelectButton(currentState: PUToggleButtonState)
    func imageForFirstButton() -> UIImage?
    func imageForSecondButton() -> UIImage?
    func tintColor() -> UIColor
}
