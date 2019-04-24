//
//  UpCommingMoviesController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 15/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

/// A controller to control the movies request
class MovieRequesterController {

    weak var delegate: MovieRequesterControllerDelegate?

    var numberOfMovies: Int {
        return self.moviePage?.movies.count ?? 0
    }

    var movies: [Movie] {
        return moviePage?.movies ?? []
    }

    private var tmdbService = PUTMDBService.init()
    private var moviePage: Page?

    /// tells the controller to retrieve new movies
    func needMoreMovies() {

        guard let moviesEndPoint = delegate?.moviesEndPoint(self) else {
            return
        }

        if let totalOfPages = moviePage?.totalOfPages {
            if let nextPage = moviePage?.nextPageNumber, nextPage >= totalOfPages {
                return
            }
        } else if moviePage != nil {
            return
        }

        tmdbService.movies(
            ofEndPoint: moviesEndPoint,
            inPageNumber: moviePage?.nextPageNumber ?? 1,
            withStringQuery: delegate?.asSearchDelegate?.queryString(self),
            sucessCompletion: { (newMoviePage) in

                if self.moviePage != nil {
                    self.moviePage?.conformTo(page: newMoviePage)
                } else {
                    self.moviePage = newMoviePage
                }

                DispatchQueue.main.async {
                    self.delegate?.moviesHaveArrived(self)
                }
            },
            errorCompletion: { (error) in
                DispatchQueue.main.async {
                    self.delegate?.errorHappend(self, error: error)
                }
            }
        )
    }

    func resetPagination() {
        moviePage = nil
    }
}
