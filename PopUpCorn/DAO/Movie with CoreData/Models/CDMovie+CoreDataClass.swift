//
//  CDMovie+CoreDataClass.swift
//  
//
//  Created by Elias Paulino on 08/06/19.
//
//

import Foundation
import CoreData

@objc(CDMovie)
public class CDMovie: NSManagedObject {
    var toMovie: Movie {
        var genresArray: [Int] = []

        if let genres = self.genres?.components(separatedBy: " ") {
            genresArray = genres.compactMap({ (genre) -> Int? in
                return Int(genre)
            })
        }
        let movie = Movie.init(id: Int(self.id ?? "nil"), title: self.title, posterPath: self.poster, backdropPath: self.backDrop, isAdult: nil, overview: self.overview, releaseDate: "", genreIDs: genresArray)

        return movie
    }

    @discardableResult
    convenience init?(_ context: NSManagedObjectContext? = CoreDataStack.persistentContainer.viewContext, fromMovie movie: Movie) {

        guard let context = context else {
            return nil
        }

        self.init(context: context)

        updateWithMovieValues(movie: movie)
    }

    func updateWithMovieValues(movie: Movie) {
        self.id = movie.id != nil ? String(movie.id!) : nil
        self.title = movie.title
        self.backDrop = movie.backdropPath
        self.poster = movie.posterPath
        self.overview = movie.overview
        self.genres = movie.genreIDs.map({ (genreID) -> String in
            return String(genreID)
            }
        ).joined(separator: " ")
    }
}
