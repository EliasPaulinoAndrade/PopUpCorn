//
//  MovieFormatterStrategy.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 02/05/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

protocol MovieFormatterProtocol {
    func format(movie: Movie) -> ListableMovie
    func format(movie: Movie) -> DetailableMovie
}

extension MovieFormatterProtocol {
    func format(movie: Movie) -> ListableMovie {
        let listableMovie = ListableMovie.init(
            title: movie.title ?? MoviePlaceholder.title,
            release: movie.releaseDate ?? MoviePlaceholder.release,
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath,
            genresIDs: movie.genreIDs
        )

        return listableMovie
    }

    func format(movie: Movie) -> DetailableMovie {
        let detailableMovie = DetailableMovie.init(
            title: movie.title,
            release: movie.releaseDate,
            image: movie.backdropPath ?? movie.posterPath,
            genres: movie.genreIDs,
            overview: movie.overview,
            id: "\(movie.id ?? -1)"
        )

        return detailableMovie
    }
}
