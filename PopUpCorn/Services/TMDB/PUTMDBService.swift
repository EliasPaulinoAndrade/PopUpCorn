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
    func dataTask<T: Decodable>(
        fromURL url: URL,
        sucessCompletion: @escaping (T) -> Void,
        errorCompletion: @escaping (Error?) -> Void) {

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                errorCompletion(error)
                return
            }

            if let data = data {
                let jsonDecoder = JSONDecoder.init()

                do {
                    let movies = try jsonDecoder.decode(T.self, from: data)
                    sucessCompletion(movies)
                } catch {
                    errorCompletion(error)
                }
            } else {
                errorCompletion(nil)
            }
        }.resume()
    }

    /// Get upcoming movies from the API
    ///
    /// - Parameters:
    ///   - pageNumber: the movies page number, default is the first page.
    ///   - sucessCompletion: sucess completion
    ///   - errorCompletion: error completion, some error happend or something was wrong
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

        let upComingStringURL = PUTTMDBEndPoint.Movie
                                               .upComing
                                               .with(
                                                    baseURL: baseUrl,
                                                    pageNumber: "\(pageNumber)",
                                                    andApiKey: apiKey
                                                )

        if let url = URL.init(string: upComingStringURL) {
            dataTask(fromURL: url, sucessCompletion: sucessCompletion, errorCompletion: errorCompletion)
        } else {
            errorCompletion(nil)
        }
    }

    /// Get movie genres list from the API
    ///
    /// - Parameters:
    ///   - sucessCompletion: the sucess completion with a Genre array
    ///   - errorCompletion: error completion, some error happend or something was wrong
    func genres(
        sucessCompletion: @escaping ([Genre]) -> Void,
        errorCompletion: @escaping (Error?) -> Void) {

        guard let baseUrl = self.baseUrl,
              let apiKey = self.apiKey else {
                errorCompletion(nil)
                return
        }

        let genresStringURL = PUTTMDBEndPoint.Genre.allGenres.with(baseURL: baseUrl, andApiKey: apiKey)

        if let url = URL.init(string: genresStringURL) {
            dataTask(fromURL: url, sucessCompletion: { (genreDictionary: [String: [Genre]]) in
                if let genres = genreDictionary["genres"] {
                    sucessCompletion(genres)
                } else {
                    errorCompletion(nil)
                }
            }, errorCompletion: errorCompletion)
        } else {
            errorCompletion(nil)
        }
    }
    
}
