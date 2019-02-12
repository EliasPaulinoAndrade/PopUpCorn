//
//  PUTMDBService.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 11/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

/// A service for TMDB API integration
struct PUTMDBService {
    var apiKey: String?
    var baseUrl: String?
    var imageBaseUrl: String?

    /// initialize the service getting the api atributtes from TMDB plist
    init() {
        let plistService = PUPlistService.init()
        let tmdbAtributtes = plistService.tmdbAtributtes

        self.apiKey = tmdbAtributtes.apiKey
        self.baseUrl = tmdbAtributtes.baseUrl.normal
        self.imageBaseUrl = tmdbAtributtes.baseUrl.image
    }
}
