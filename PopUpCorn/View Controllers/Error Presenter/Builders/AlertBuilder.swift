//
//  AlertBuilder.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 16/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class AlertBuilder: AlertBuilderProtocol {

    var title: String
    var message: String

    init(withTitle title: String, andMessage message: String) {
        self.title = title
        self.message = message
    }

    func alertController() -> UIAlertController {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)

        let closeAction = UIAlertAction.init(title: Constants.closeActionTitle, style: .cancel) { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(closeAction)

        return alertController
    }
}

private enum Constants {
    static let closeActionTitle = "Close"
}
