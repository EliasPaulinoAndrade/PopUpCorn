//
//  FadePopAnimator.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 26/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailToImageFrameTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    var placeHolderImage: UIImage?

    var placeHolderFrame: CGRect?

    var duration: TimeInterval

    lazy var transitionPlaceHolderImageView: UIImageView = {
        let transitionPlaceHolderImageView = UIImageView.init()

        transitionPlaceHolderImageView.backgroundColor = UIColor.blue
        transitionPlaceHolderImageView.contentMode = .scaleAspectFill
        transitionPlaceHolderImageView.image = placeHolderImage
        transitionPlaceHolderImageView.frame.origin = CGPoint.zero

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

    public init(withPlaceHolderImage placeHolderImage: UIImage?, andFrame placeHolderFrame: CGRect?, duration: TimeInterval) {
        self.placeHolderImage = placeHolderImage
        self.placeHolderFrame = placeHolderFrame
        self.duration = duration
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else {
                return
        }

        transitionPlaceHolderImageView.frame.size = CGSize.init(width: fromViewController.view.frame.width, height: 350)

        transitionContext.containerView.addSubview(transitionBackgroundView)
        transitionContext.containerView.addSubview(transitionPlaceHolderImageView)

        transitionBackgroundView.frame = fromViewController.view.frame

        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromViewController.view.alpha = 0
            self.transitionPlaceHolderImageView.frame = self.placeHolderFrame ?? CGRect.zero
        }, completion: { _ in
            self.transitionPlaceHolderImageView.removeFromSuperview()
            self.transitionBackgroundView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
