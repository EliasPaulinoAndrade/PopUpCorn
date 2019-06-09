//
//  TransitioningDelegateForDetailMovie.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 26/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

/// a transitioning delegate to setup the custom transitions between a movie listing and a movie detail view controller
class TransitioningDelegateForDetailMovie: NSObject, UIViewControllerTransitioningDelegate {

    /// the movie position in the movies lisiting
    var moviePosition: Int?

    var listingMoviesController: MovieListUserProtocol?

    var rootViewController: UIViewController

    var interactionController: UIViewControllerInteractiveTransitioning?

    init(withTargetMoviePosition targetMoviePosition: Int?, listingMoviesController: MovieListUserProtocol?, rootViewController: UIViewController, andInteractionController interactionController: UIViewControllerInteractiveTransitioning? = nil) {
        self.moviePosition = targetMoviePosition
        self.listingMoviesController = listingMoviesController
        self.interactionController = interactionController
        self.rootViewController = rootViewController
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let (movieImageFrame, movieImage) = movieItemViewInfo(parentController: listingMoviesController)

        return ImageFrameToMovieDetailTransitioning.init(withPlaceHolderImage: movieImage, andFrame: movieImageFrame, duration: 0.5)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let (movieImageFrame, movieImage) = movieItemViewInfo(parentController: listingMoviesController)

        return MovieDetailToImageFrameTransitioning(withPlaceHolderImage: movieImage, andFrame: movieImageFrame, duration: 0.5)
    }

    /// get the movie image and rect in the movies listing
    ///
    /// - Parameter parentController: the movie listing parent view controller, must be a UINavigationController
    /// - Returns: the movie info
    func movieItemViewInfo(parentController: MovieListUserProtocol?) -> (frame: CGRect?, image: UIImage?) {
        guard let movieItem = parentController?.movieListViewController.viewForMovieAt(position: moviePosition ?? 0) as? PUMovieCollectionViewCellProtocol,
              let movieItemView = movieItem as? UIView else {
            return (nil, nil)
        }

        let posterImageView = movieItem.moviePosterImageView

        let movieItemOrigin = movieItemView.convert(posterImageView.frame.origin, to: rootViewController.view)

        let movieImageFrame = CGRect.init(origin: movieItemOrigin, size: posterImageView.frame.size)

        return (movieImageFrame, posterImageView.image)
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        return self.interactionController
    }
}
