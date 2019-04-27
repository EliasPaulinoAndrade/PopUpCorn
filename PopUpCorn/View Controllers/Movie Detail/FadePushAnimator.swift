//
//  FadePushAnimator.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 26/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

open class FadePushAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var movieItemPosition: Int

    public init(withMovieItemPosition movieItemPosition: Int) {
        self.movieItemPosition = movieItemPosition
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) as? MovieDetailViewController,
              let fromViewController = transitionContext.viewController(forKey: .from) as? UINavigationController,
              let movieListUser = fromViewController.topViewController as? MovieListUserProtocol,
              let movieItemView = movieListUser.movieListViewController.viewForMovieAt(position: movieItemPosition) as? PUExpandedMovieCollectionViewCell,
              let movieItemSuperView = movieItemView.superview else {
                return
        }

        let itemOldFrame = movieItemView.frame
        let itemOldColor = movieItemView.containerView.backgroundColor
        let itemOldRadius = movieItemView.containerView.radius

        movieItemView.frame.origin = movieItemView.convert(movieItemView.frame.origin, to: fromViewController.view)

        transitionContext.containerView.addSubview(toViewController.view)
        transitionContext.containerView.addSubview(movieItemView)

        toViewController.view.alpha = 0
        toViewController.detailImageView.alpha = 0
        toViewController.view.frame.origin.y = toViewController.view.frame.size.height

        movieItemView.containerView.backgroundColor = UIColor.clear

        let duration = self.transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration, animations: {
            toViewController.view.alpha = 1
            toViewController.view.frame.origin.y = 0

            movieItemView.containerView.radius = 0
            movieItemView.frame.size.width = toViewController.view.frame.width
            movieItemView.frame.origin.x = 0
//            movieItemView.headerContainerView.layer.opacity = 0
//            movieItemView.headerImageView.layer.opacity = 0

            movieItemView.frame.origin.y = -movieItemView.headerContainerView.frame.height

            //                movieItemView.posterImageView.frame.size.height = 400
        }, completion: { _ in
            movieItemSuperView.addSubview(movieItemView)
            movieItemView.frame = itemOldFrame
            movieItemView.headerContainerView.layer.opacity = 1
            movieItemView.headerImageView.layer.opacity = 1
            movieItemView.containerView.backgroundColor = itemOldColor
            toViewController.detailImageView.alpha = 1
            movieItemView.containerView.radius = itemOldRadius
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
