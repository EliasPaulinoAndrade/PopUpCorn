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

    /// Get a movies page from a given URL from TBDB API.
    ///
    /// - Parameters:
    ///   - moviesURL: the TMDB URL that returs movies
    ///   - sucessCompletion: this completion is called when all ocurred well
    ///   - errorCompletion: this completion is called when something bad or some error happend in the request
    func movies(
        fromURL moviesURL: URL,
        sucessCompletion: @escaping (Page) -> Void,
        errorCompletion: @escaping (Error?) -> Void) {

        URLSession.shared.dataTask(with: moviesURL) { (data, _, error) in
            if let error = error {
                errorCompletion(error)
                return
            }

            if let data = data {
                let jsonDecoder = JSONDecoder.init()

                do {
                    let movies = try jsonDecoder.decode(Page.self, from: data)
                    sucessCompletion(movies)
                } catch {
                    errorCompletion(error)
                }
            } else {
                errorCompletion(nil)
            }
        }.resume()
    }

    func upComingMovies(
        inPageNumber pageNumber: Int? = 1,
        sucessCompletion: @escaping (Page) -> Void,
        errorCompletion: @escaping (Error?) -> Void) {

        guard let pageNumber = pageNumber,
              let baseUrl = self.baseUrl,
              let apiKey = self.apiKey else {
            errorCompletion(nil)
            return
        }

        let upComingStringURL = PUTTMDBEndPointType.Movie
                                                   .upComing
                                                   .with(
                                                        baseURL: baseUrl,
                                                        pageNumber: "\(pageNumber)",
                                                        andApiKey: apiKey
                                                    )

        if let url = URL.init(string: upComingStringURL) {
            movies(fromURL: url, sucessCompletion: sucessCompletion, errorCompletion: errorCompletion)
        } else {
            errorCompletion(nil)
        }
    }
}
