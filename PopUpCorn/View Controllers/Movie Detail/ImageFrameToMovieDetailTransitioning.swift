//
//  FadePushAnimator.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 26/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

/// a custom transition that animates a imageview from a target frame to the movie detail image rect
class ImageFrameToMovieDetailTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    /// the animating imageview image
    var placeHolderImage: UIImage?

    /// the inital imageview frame
    var placeHolderFrame: CGRect?

    var duration: TimeInterval

    lazy var transitionPlaceHolderImageView: UIImageView = {
        let transitionPlaceHolderImageView = UIImageView.init()

        transitionPlaceHolderImageView.backgroundColor = UIColor.blue
        transitionPlaceHolderImageView.contentMode = .scaleAspectFill
        transitionPlaceHolderImageView.image = placeHolderImage
        transitionPlaceHolderImageView.frame = placeHolderFrame ?? CGRect.zero
        transitionPlaceHolderImageView.clipsToBounds = true

        return transitionPlaceHolderImageView
    }()

    /// a background showed while the image is animating
    lazy var transitionBackgroundView: UIView = {
        let transitionBackgroundView = UIView.init()

        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = transitionBackgroundView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        transitionBackgroundView.addSubview(blurEffectView)

        return transitionBackgroundView
    }()

    public init(withPlaceHolderImage placeHolderImage: UIImage?, andFrame placeHolderFrame: CGRect?, duration: TimeInterval) {
        self.placeHolderImage = placeHolderImage
        self.placeHolderFrame = placeHolderFrame
        self.duration = duration
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) as? MovieDetailViewController else {
                return
        }

        transitionBackgroundView.frame = toViewController.view.frame

        transitionContext.containerView.addSubview(transitionBackgroundView)
        transitionContext.containerView.addSubview(transitionPlaceHolderImageView)
        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.frame = UIScreen.main.bounds

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
