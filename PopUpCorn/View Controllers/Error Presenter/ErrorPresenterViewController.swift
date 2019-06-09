//
//  ErrorPresenterViewController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 16/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

/// a view controller responsible by showing errors alerts. It make custom alerts using the alert decorators.
class ErrorPresenterViewController: UIViewController {

    weak var reloadDelegate: ReloaderAlertBuilderDelegate?

    private var isPresentingAlert = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = false
    }

    private func alertMiddleware(
        withTitle title: String,
        andMessage message: String,
        completion: (AlertBuilderProtocol, (AlertBuilderProtocol) -> Void) -> Void) {
        let alertBuilder: AlertBuilderProtocol = AlertBuilder.init(withTitle: title, andMessage: message)

        completion(alertBuilder, { alertBuilder in
            guard self.isPresentingAlert == false else {
                return
            }

            self.isPresentingAlert = true
            present(alertBuilder.alertController(), animated: true, completion: {
                self.isPresentingAlert = false
            })
        })
    }

    func showSimpleError(withTitle title: String, andMessage message: String) {
        alertMiddleware(withTitle: title, andMessage: message) { (simpleAlertBuilder, present) in
            present(simpleAlertBuilder)
        }
    }

    func showReloaderError(withTitle title: String, andMessage message: String) {

        alertMiddleware(withTitle: title, andMessage: message) { (alertBuilder, present) in
            let reloadAlertBuilder = ReloaderAlertBuilder.init(
                withAlertBuilder: alertBuilder,
                andDelegate: reloadDelegate
            )

            present(reloadAlertBuilder)
        }
    }

    func showQuitError(
        withTitle title: String,
        andMessage message: String,
        andControllerToQuit controllerToQuit: ClosableViewControllerProtocol) {

        alertMiddleware(withTitle: title, andMessage: message) { (alertBuilder, present) in
            let quitAlertBuilder = QuitAlertBuilder.init(
                withAlertBuilder: alertBuilder,
                controllerToQuit: controllerToQuit
            )

            present(quitAlertBuilder)
        }
    }
}
