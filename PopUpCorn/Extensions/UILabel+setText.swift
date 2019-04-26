//
//  UILabel+setText.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 17/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func set(unsafeText: String?, placeHolder: String) {
        if let safeText = unsafeText, !safeText.isEmpty {
            self.text = safeText
        } else {
            self.text = placeHolder
        }
    }
}
