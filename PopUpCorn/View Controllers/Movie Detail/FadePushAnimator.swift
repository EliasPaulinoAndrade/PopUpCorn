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

    lazy var transitionPlaceHolderImageView: UIImageView = {
        let transitionPlaceHolderImageView = UIImageView.init()

        transitionPlaceHolderImageView.backgroundColor = UIColor.blue
        transitionPlaceHolderImageView.contentMode = .scaleAspectFill

        return transitionPlaceHolderImageView
    }()

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

        let movieItemOrigin = movieItemView.convert(movieItemView.posterImageView.frame.origin, to: fromViewController.view)

        transitionPlaceHolderImageView.frame.origin = movieItemOrigin
        transitionPlaceHolderImageView.frame.size = movieItemView.posterImageView.frame.size
        transitionPlaceHolderImageView.image = movieItemView.posterImageView.image

        transitionContext.containerView.addSubview(toViewController.view)
        transitionContext.containerView.addSubview(transitionPlaceHolderImageView)

        toViewController.view.alpha = 0
        toViewController.detailImageView.alpha = 0
        toViewController.view.frame.origin.y = toViewController.view.frame.size.height

        movieItemView.posterImageView.alpha = 0

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
            movieItemSuperView.addSubview(movieItemView)
            self.transitionPlaceHolderImageView.removeFromSuperview()
            movieItemView.posterImageView.alpha = 1
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
