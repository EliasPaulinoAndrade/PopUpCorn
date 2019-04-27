//
//  PanGestureInteractiveTransition.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 27/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class PanGestureInteractiveTransition: UIPercentDrivenInteractiveTransition {

    private weak var viewController: UIViewController!

    public init(viewController: UIViewController) {
        super.init()

        self.viewController = viewController
    }

    func update(recognizer: UIPanGestureRecognizer, totalTranslation: CGFloat) {
        let translate = recognizer.translation(in: recognizer.view)
        let percent = translate.x / totalTranslation

        switch recognizer.state {
        case .began:
            viewController.dismiss(animated: true, completion: nil)
        case .changed:
            self.update(percent)
        case .cancelled:
            self.cancel()
        case .ended:
            if percent > 0.2 {
                self.finish()
            } else {
                self.cancel()
            }
        default:
            break
        }
    }
}
