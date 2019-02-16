//
//  UpCommingMoviesController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 15/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

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

    func needMoreMovies() {

        let pageNumber = self.moviePage?.nextPageNumber ?? 1

        tmdbService.movies(
            ofEndPoint: PUTTMDBEndPoint.Movie.upComing,
            inPageNumber: pageNumber,
            sucessCompletion: { (moviePage) in

                if self.moviePage != nil {
                    self.moviePage?.movies.append(contentsOf: moviePage.movies)
                    self.moviePage?.number = pageNumber
                } else {
                    self.moviePage = moviePage
                }

                DispatchQueue.main.async {
                    self.delegate?.moviesHaveArrived(self)
                }
            },
            errorCompletion: { (_) in

            }
        )
    }
}
