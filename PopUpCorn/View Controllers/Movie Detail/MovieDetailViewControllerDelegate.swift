//
//  MovieDetailViewControllerDelegate.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 26/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

protocol MovieDetailViewControllerDelegate: AnyObject {
    func closeButtonTapped()
    func edgeInteractionHappend(recognizer: UIPanGestureRecognizer)
    func similarMovieWasSelected(movie: DetailableMovie, atPosition position: Int)
}
