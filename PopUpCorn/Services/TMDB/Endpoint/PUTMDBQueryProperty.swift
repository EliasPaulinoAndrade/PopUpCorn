//
//  TMDBQueryProperty.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 24/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

//the url properties for tmdb API
enum PUTMDBQueryProperty: String {
    case query
    case language
    case apiKey = "api_key"
    case pageNumber = "page"
    case includeAdult = "include_adult"
}
