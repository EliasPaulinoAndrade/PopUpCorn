//
//  PUToggleButtonView.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 13/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

class PUToggleButtonView: PUBaseZibOwnerView {

    @IBOutlet weak var secondButton: UIView!
    @IBOutlet weak var firstButton: UIView!
    @IBOutlet weak var selectedIndicatorView: UIView! {
        didSet {
            selectedIndicatorView.clipsToBounds = true
            selectedIndicatorView.layer.cornerRadius = 10
        }
    }

    @IBOutlet var containerView: UIView! {
        didSet {
            self.contentViewZib = containerView
        }
    }

    @IBOutlet weak var selectedIndicatorLeft: NSLayoutConstraint!

    var isFistButtonSelected: Bool = true

    weak var delegate: PUToggleButtonViewDelegate?

    func change(toState state: PUToggleButtonState) {

        self.selectedIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        if state == .first {
            self.selectedIndicatorLeft.constant = 0
            self.isFistButtonSelected = true
        } else {
            self.selectedIndicatorLeft.constant = self.firstButton.frame.width
            self.isFistButtonSelected = false
        }

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }

    @IBAction func firstButtonTapped(_ sender: Any) {
        change(toState: .first)
        delegate?.didSelectButton(currentState: .first)
    }

    @IBAction func secondButtonTapped(_ sender: Any) {
        change(toState: .second)
        delegate?.didSelectButton(currentState: .second)
    }
}
