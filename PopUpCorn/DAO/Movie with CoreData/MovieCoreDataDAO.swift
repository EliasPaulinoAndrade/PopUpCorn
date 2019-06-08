//
//  MovieCoreDataDAO.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 08/06/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import CoreData

class MovieCoreDataDAO: DAOProtocol {

    typealias Element = Movie

    func getAll() -> [Movie] {
        let movieRequest: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()

        do {
            let cdMovies = try CoreDataStack.persistentContainer.viewContext.fetch(movieRequest)

            return cdMovies.toMovieArray
        } catch {
            return []
        }
    }

    func save(element: Movie) -> Movie? {
        do {
            CDMovie(fromMovie: element)

            try CoreDataStack.persistentContainer.viewContext.save()

            return element
        } catch {
            return nil
        }
    }

    func delete(element: Movie) {

    }

    func get(elementWithID daoID: String) -> Movie? {
        let movieRequest: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        movieRequest.predicate = NSPredicate(format: "id == %@", daoID)

        do {
            let movie = try CoreDataStack.persistentContainer.viewContext.fetch(movieRequest).first

            return movie?.toMovie
        } catch {
            return nil
        }
    }

    func update(element: Movie) -> Bool {
        guard let elementID = element.id else {
            return false
        }
        let movieRequest: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        movieRequest.predicate = NSPredicate(format: "id == %@", String(elementID))

        do {
            let cdMovie = try CoreDataStack.persistentContainer.viewContext.fetch(movieRequest).first
            cdMovie?.updateWithMovieValues(movie: element)
            return true
        } catch {
            return false
        }
    }
}
