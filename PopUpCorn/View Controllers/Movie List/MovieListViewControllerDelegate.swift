//
//  MovieListViewControllerDelegate.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 13/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

protocol MovieListViewControllerDelegate: AnyObject {
    func numberOfMovies(_ movieList: MovieListViewController) -> Int

    func movieList(_ movieList: MovieListViewController, movieForPositon position: Int) -> ListableMovie

    func needLoadMoreMovies(_ movieList: MovieListViewController)

    func movieList(_ movieList: MovieListViewController, didSelectItemAt position: Int)

    func noMovieTitle(_ movieList: MovieListViewController) -> String

    func mustShowToggleBackground(_ movieList: MovieListViewController) -> Bool
}
