//
//  MovieType.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 24/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

/// the movie endpoint types
enum PUTMDBMovieType: String, CustomStringConvertible {
    var description: String {
        return self.rawValue
    }

    case upComing = "movie/upcoming"
    case popular = "movie/popular"
    case search = "search/movie"
}
