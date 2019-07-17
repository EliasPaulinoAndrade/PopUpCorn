//
//  SearchMoviesViewControllerDelegate.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 25/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

protocol SearchMoviesViewControllerDelegate: AnyObject {
    func searchMovieWasSelected(movie: DetailableMovie, atPosition position: Int)
}
