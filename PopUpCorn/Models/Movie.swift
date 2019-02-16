//
//  Movie.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 11/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

struct Movie: Codable {
    var id: Int?
    var title: String?
    var posterPath: String?
    var backdropPath: String?
    var isAdult: Bool?
    var overview: String?
    var releaseDate: String?
    var genreIDs: [Int]

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case isAdult = "adult"
        case releaseDate = "release_date"
        case genreIDs = "genre_ids"
    }

}
