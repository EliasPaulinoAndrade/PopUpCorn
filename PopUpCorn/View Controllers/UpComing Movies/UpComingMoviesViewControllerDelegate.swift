//
//  UpComingMoviesViewControllerDelegate.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 25/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

protocol UpComingMoviesViewControllerDelegate: AnyObject {

    func upComingMovieWasSelected(movie: DetailableMovie)
    func searchButtonWasSelected()
}
