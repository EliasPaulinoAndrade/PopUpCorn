//
//  PanGestureInteractiveTransition.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 27/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

/// a interactive controller to transition with user pan gesture
class PanGestureInteractiveTransition: UIPercentDrivenInteractiveTransition {

    private weak var viewController: UIViewController!

    private var wasFinished: Bool = false

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

    func update(currentTranslation: CGFloat, totalTranslation: CGFloat) {
        if !viewController.isBeingDismissed {
            viewController.dismiss(animated: true, completion: nil)
        }

        if !wasFinished {
            self.update(currentTranslation/totalTranslation)
        }
    }

    func finish(currentTranslation: CGFloat, totalTranslation: CGFloat) {
        wasFinished = true
        self.finish()
    }
}
