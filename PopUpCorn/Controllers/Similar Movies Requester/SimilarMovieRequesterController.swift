//
//  SimilarMovieRequesterController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 27/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

class SimilarMovieRequesterController: NSObject {

    weak var delegate: SimilarMovieRequesterControllerDelegate?

    var numberOfMovies: Int {
        return self.moviePage?.movies.count ?? 0
    }

    var movies: [Movie] {
        return moviePage?.movies ?? []
    }

    var movieID: String

    private var tmdbService = PUTMDBService.init()
    private var moviePage: Page?

    init(forMovieID movieID: String) {
        self.movieID = movieID
    }

    /// tells the controller to retrieve new movies
    func needMoreMovies() {

        if let totalOfPages = moviePage?.totalOfPages {
            if let nextPage = moviePage?.nextPageNumber, nextPage >= totalOfPages {
                return
            }
        } else if moviePage != nil {
            return
        }

        tmdbService.similarMovies(movieId: movieID, sucessCompletion: { (newMoviePage) in
            if self.moviePage != nil {
                self.moviePage?.conformTo(page: newMoviePage)
            } else {
                self.moviePage = newMoviePage
            }

            DispatchQueue.main.async {
                self.delegate?.moviesHaveArrived(self)
            }
        }, errorCompletion: { (error) in
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
