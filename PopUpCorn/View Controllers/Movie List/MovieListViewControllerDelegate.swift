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

    func genresForMovie(
        _ movieList: MovieListViewController,
        atPosition position: Int,
        completion: @escaping (String) -> Void)

    func needLoadMoreMovies(_ movieList: MovieListViewController)
}
