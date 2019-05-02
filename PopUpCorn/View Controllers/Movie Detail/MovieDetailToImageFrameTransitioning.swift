//
//  FadePopAnimator.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 26/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

/// a custom transition that shows a animating image begining in the movie detail image
class MovieDetailToImageFrameTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    /// the animating imageview image
    var placeHolderImage: UIImage?

    /// the target frame
    var placeHolderFrame: CGRect?

    var duration: TimeInterval

    lazy var transitionPlaceHolderImageView: UIImageView = {
        let transitionPlaceHolderImageView = UIImageView.init()

        transitionPlaceHolderImageView.backgroundColor = UIColor.blue
        transitionPlaceHolderImageView.contentMode = .scaleAspectFill
        transitionPlaceHolderImageView.image = placeHolderImage
        transitionPlaceHolderImageView.frame.origin = CGPoint.zero
        transitionPlaceHolderImageView.clipsToBounds = true

        return transitionPlaceHolderImageView
    }()

    lazy var transitionBackgroundView: UIView = {
        let transitionBackgroundView = UIView.init()

        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = transitionBackgroundView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        transitionBackgroundView.addSubview(blurEffectView)

        return transitionBackgroundView
    }()

    /// if the target rect is nil the defaultRect is used
    lazy var defaultPlaceHolderTargetRect = CGRect.init(origin: CGPoint.init(x: 0, y: UIScreen.main.bounds.height), size: CGSize.init(width: UIScreen.main.bounds.width, height: 350))

    public init(withPlaceHolderImage placeHolderImage: UIImage?, andFrame placeHolderFrame: CGRect?, duration: TimeInterval) {
        self.placeHolderImage = placeHolderImage
        self.placeHolderFrame = placeHolderFrame
        self.duration = duration
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? MovieDetailViewController else {
                return
        }

        let oldFromControllerBackground = fromViewController.view.backgroundColor

        transitionPlaceHolderImageView.frame.size = fromViewController.detailImageView.frame.size
        if transitionPlaceHolderImageView.image == nil {
            transitionPlaceHolderImageView.image = fromViewController.detailImageView.image
        }

        transitionContext.containerView.addSubview(transitionBackgroundView)
        transitionContext.containerView.addSubview(transitionPlaceHolderImageView)
        transitionContext.containerView.addSubview(fromViewController.view)

        transitionBackgroundView.frame = fromViewController.view.frame

        fromViewController.view.layer.opacity = 1
        fromViewController.detailImageView.layer.opacity = 0
        fromViewController.view.backgroundColor = UIColor.clear

        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromViewController.view.layer.opacity = 0
            self.transitionPlaceHolderImageView.frame = self.placeHolderFrame ?? self.defaultPlaceHolderTargetRect
            fromViewController.view.frame.origin.y = fromViewController.view.frame.size.height
        }, completion: { _ in
            self.transitionPlaceHolderImageView.removeFromSuperview()
            self.transitionBackgroundView.removeFromSuperview()

            fromViewController.view.backgroundColor = oldFromControllerBackground
            fromViewController.detailImageView.layer.opacity = 1
            fromViewController.view.frame.origin.y = 0
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
