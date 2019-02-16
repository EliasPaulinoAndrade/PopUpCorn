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
    func movies(_ movieList: MovieListViewController) -> [Movie]

    func genresForMovie(
        _ movieList: MovieListViewController,
        atPosition position: Int,
        completion: @escaping (String) -> Void)

    func needLoadMoreMovies(_ movieList: MovieListViewController)
}
