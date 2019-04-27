//
//  TransitioningDelegateForDetailMovie.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 26/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class TransitioningDelegateForDetailMovie: NSObject, UIViewControllerTransitioningDelegate {

    var moviePosition: Int?
    var rootViewController: UIViewController

    init(withTargetMoviePosition targetMoviePosition: Int?, rootViewController: UIViewController) {
        self.moviePosition = targetMoviePosition
        self.rootViewController = rootViewController
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let (movieImageFrame, movieImage) = movieItemViewInfo(parentController: presenting)

        return ImageFrameToMovieDetailTransitioning.init(withPlaceHolderImage: movieImage, andFrame: movieImageFrame)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let (movieImageFrame, movieImage) = movieItemViewInfo(parentController: rootViewController)

        return MovieDetailToImageFrameTransitioning(withPlaceHolderImage: movieImage, andFrame: movieImageFrame)
    }

    func movieItemViewInfo(parentController: UIViewController) -> (frmae: CGRect?, image: UIImage?) {
        guard let fromViewController = parentController as? UINavigationController,
            let movieListUser = fromViewController.topViewController as? MovieListUserProtocol,
            let movieItem = movieListUser.movieListViewController.viewForMovieAt(position: moviePosition ?? 0) as? PUMovieCollectionViewCellProtocol,
            let movieItemView = movieItem as? UIView else {

                return (nil, nil)
        }

        let posterImageView = movieItem.moviePosterImageView

        let movieItemOrigin = movieItemView.convert(posterImageView.frame.origin, to: fromViewController.view)

        let movieImageFrame = CGRect.init(origin: movieItemOrigin, size: posterImageView.frame.size)

        return (movieImageFrame, posterImageView.image)
    }
}
