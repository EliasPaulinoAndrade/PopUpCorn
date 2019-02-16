//
//  UIView+isStanding.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 16/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var isStanding: Bool {
        if self.frame.width < self.frame.height {
            return true
        }
        return false
    }
}
