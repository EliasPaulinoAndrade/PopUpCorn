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

    func imageForMovie(
        _ movieList: MovieListViewController,
        atPosition position: Int,
        completion: @escaping (UIImage?) -> Void)

    func needLoadMoreMovies(_ movieList: MovieListViewController)
}
