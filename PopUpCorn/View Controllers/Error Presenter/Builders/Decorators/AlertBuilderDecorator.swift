//
//  AlertBuilderDecorator.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 16/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class AlertBuilderDecorator: AlertBuilderProtocol {

    var decoratedAlertBuilder: AlertBuilderProtocol

    init(withAlertBuilder alertBuilder: AlertBuilderProtocol) {
        self.decoratedAlertBuilder = alertBuilder
    }

    func alertController() -> UIAlertController {
        return decoratedAlertBuilder.alertController()
    }
}
