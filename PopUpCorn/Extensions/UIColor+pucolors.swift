//
//  UIColor+pucolors.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 12/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Including colors
extension UIColor {

    static private var defaultColor: UIColor {
        return UIColor.cyan
    }

    static var puRed: UIColor {
        return UIColor.init(named: "red") ?? defaultColor
    }

    static var puExtraLightRed: UIColor {
        return UIColor.init(named: "light_extra_red") ?? defaultColor
    }

    static var puLightRed: UIColor {
        return UIColor.init(named: "light_red") ?? defaultColor
    }

    static var puPurple: UIColor {
        return UIColor.init(named: "purple") ?? defaultColor
    }

    static var puLightPurple: UIColor {
        return UIColor.init(named: "light_purple") ?? defaultColor
    }

    static var puTextPurple: UIColor {
        return UIColor.init(named: "text_purple") ?? defaultColor
    }

    static var puTextBlue: UIColor {
        return UIColor.init(named: "text_blue") ?? defaultColor
    }
}
