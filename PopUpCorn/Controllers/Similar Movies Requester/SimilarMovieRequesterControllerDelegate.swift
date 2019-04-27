//
//  SimilarMovieRequesterControllerDelegate.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 27/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

protocol SimilarMovieRequesterControllerDelegate: AnyObject {
    func moviesHaveArrived(_ requester: SimilarMovieRequesterController)
    func errorHappend(_ requester: SimilarMovieRequesterController, error: Error?)
}
