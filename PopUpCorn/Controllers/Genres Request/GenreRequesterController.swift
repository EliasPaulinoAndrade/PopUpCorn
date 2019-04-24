//
//  GenreRequesterController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 16/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation


/// a controller to control the genres requests
class GenreRequesterController {

    weak var delegate: GenreRequesterControllerDelegate?

    private var tmdbService = PUTMDBService.init()

    
    /// tells the controller to retrieve the genres with given genreIDs
    ///
    /// - Parameter genreIDs: the genre IDs of the required genres
    func needGenres(withIDs genreIDs: [Int]) {
        requestMiddleware { (genres) in
            let genresNames = genres.nameArray(filteredByIds: genreIDs)
            if genresNames.count == genreIDs.count {
                DispatchQueue.main.async {
                    self.delegate?.genresHasArrived(self, genres: genresNames)
                }
            } else {
                self.tmdbService.data.invalidateGenges()
                self.requestMiddleware(sucessCompletion: { (genres) in
                    let genresNames = genres.nameArray(filteredByIds: genreIDs)
                    DispatchQueue.main.async {
                        self.delegate?.genresHasArrived(self, genres: genresNames)
                    }
                })
            }
        }
    }

    private func requestMiddleware(sucessCompletion: @escaping ([Genre]) -> Void) {
        tmdbService.genres(sucessCompletion: sucessCompletion, errorCompletion: { (error) in
            DispatchQueue.main.async {
                self.delegate?.errorHappend(self, error: error)
            }
        })
    }
}
