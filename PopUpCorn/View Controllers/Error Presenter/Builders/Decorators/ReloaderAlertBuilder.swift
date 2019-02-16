//
//  ReloaderAlertBuilder.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 16/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class ReloaderAlertBuilder: AlertBuilderDecorator {

    weak var delegate: ReloaderAlertBuilderDelegate?

    init(withAlertBuilder alertBuilder: AlertBuilderProtocol, andDelegate delegate: ReloaderAlertBuilderDelegate?) {
        super.init(withAlertBuilder: alertBuilder)

        self.delegate = delegate
    }

    override func alertController() -> UIAlertController {
        let alertController = super.alertController()

        let reloadAction = UIAlertAction.init(title: Constants.reloadActionTitle, style: .default) { (_) in
            self.delegate?.needReloadData(self)
        }

        alertController.addAction(reloadAction)

        return alertController
    }
}

private enum Constants {
    static let reloadActionTitle = "Reload"
}
