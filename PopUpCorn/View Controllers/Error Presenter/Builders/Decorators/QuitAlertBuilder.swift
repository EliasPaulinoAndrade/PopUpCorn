//
//  QuitReloaderAlertBuilder.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 16/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class QuitAlertBuilder: AlertBuilderDecorator {

    weak var closableController: ClosableViewControllerProtocol?

    init(withAlertBuilder alertBuilder: AlertBuilderProtocol, controllerToQuit: ClosableViewControllerProtocol) {
        self.closableController = controllerToQuit

        super.init(withAlertBuilder: alertBuilder)
    }

    override func alertController() -> UIAlertController {
        let alertController = super.alertController()

        let quitAction = UIAlertAction.init(title: Constants.quitActionTitle, style: .default) { (_) in
            self.closableController?.close()
        }

        alertController.addAction(quitAction)

        return alertController
    }
}

private enum Constants {
    static let quitActionTitle = "Quit"
}
