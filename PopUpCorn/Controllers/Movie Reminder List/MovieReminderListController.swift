//
//  MovieReminderListController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 08/06/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

class MovieReminderListController {
    private var moviesDAO = MovieCoreDataDAO()
    weak public var delegate: MovieReminderListControllerDelegate?

    var movies: [Movie] = []

    var numberOfMovies: Int {
        return movies.count
    }

    init() {
        self.movies = moviesDAO.getAll()
    }

    func reloadData() {
        self.movies = moviesDAO.getAll()
        delegate?.reloadRemindersData()
    }

    func remindMoviePosition(forID movieID: String) -> Int? {
        return movies.firstIndex { (movie) -> Bool in
            guard let currentMovieID = movie.id else {
                return false
            }

            return movieID == String(currentMovieID)
        }
    }

    func reminderWasRemoved(movie: DetailableMovie) {
        guard let movieID = movie.id else {
            return
        }

        let removedMovieID = remindMoviePosition(forID: movieID)

        guard let id = removedMovieID else {
            return
        }

        self.movies.remove(at: id)
        delegate?.removeReminderAtPosition(position: id)
    }
}
