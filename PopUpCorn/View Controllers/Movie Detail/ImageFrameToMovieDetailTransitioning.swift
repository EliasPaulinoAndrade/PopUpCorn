//
//  FadePushAnimator.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 26/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

open class ImageFrameToMovieDetailTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    var placeHolderImage: UIImage?

    var placeHolderFrame: CGRect?

    lazy var transitionPlaceHolderImageView: UIImageView = {
        let transitionPlaceHolderImageView = UIImageView.init()

        transitionPlaceHolderImageView.backgroundColor = UIColor.blue
        transitionPlaceHolderImageView.contentMode = .scaleAspectFill
        transitionPlaceHolderImageView.image = placeHolderImage
        transitionPlaceHolderImageView.frame = placeHolderFrame ?? CGRect.zero

        return transitionPlaceHolderImageView
    }()

    lazy var transitionBackgroundView: UIView = {
        let transitionBackgroundView = UIView.init()

        transitionBackgroundView.backgroundColor = UIColor.black

        return transitionBackgroundView
    }()

    public init(withPlaceHolderImage placeHolderImage: UIImage?, andFrame placeHolderFrame: CGRect?) {
        self.placeHolderImage = placeHolderImage
        self.placeHolderFrame = placeHolderFrame
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) as? MovieDetailViewController else {
                return
        }

        transitionBackgroundView.frame = toViewController.view.frame

        transitionContext.containerView.addSubview(transitionBackgroundView)
        transitionContext.containerView.addSubview(transitionPlaceHolderImageView)
        transitionContext.containerView.addSubview(toViewController.view)

        let oldToControllerBackground = toViewController.view.backgroundColor
        toViewController.view.backgroundColor = UIColor.clear
        toViewController.view.alpha = 0
        toViewController.detailImageView.alpha = 0
        toViewController.view.frame.origin.y = toViewController.view.frame.size.height

        let duration = self.transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration, animations: {

            toViewController.view.frame.origin.y = 0
            toViewController.view.alpha = 1

            self.transitionPlaceHolderImageView.frame.size.width = toViewController.view.frame.width
            self.transitionPlaceHolderImageView.frame.origin.x = 0
            self.transitionPlaceHolderImageView.frame.size.height = 350

            self.transitionPlaceHolderImageView.frame.origin.y = 0

        }, completion: { _ in
            toViewController.detailImageView.alpha = 1
            toViewController.view.backgroundColor = oldToControllerBackground
            self.transitionPlaceHolderImageView.removeFromSuperview()
            self.transitionBackgroundView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
