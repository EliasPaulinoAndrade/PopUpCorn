//
//  PUTMDBService.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 11/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

/// A service for TMDB API integration
struct PUTMDBService {
    var apiKey: String?
    var baseUrl: String?
    var imageBaseUrl: String?
    var cacheService = PUCacheService.init()

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

    /// Get popular movies from the API
    ///
    /// - Parameters:
    ///   - pageNumber: the movies page number, default is the first page.
    ///   - sucessCompletion: sucess completion
    ///   - errorCompletion: error completion, some error happend or something was wrong
    func popularMovies(
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
                                               .popular
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

    /// Get a image from a given URL
    ///
    /// - Parameters:
    ///   - url: the url
    ///   - sucessCompletion: sucess completion
    ///   - errorCompletion: error completion
    func image(
        fromURL url: URL,
        sucessCompletion: @escaping (UIImage) -> Void,
        errorCompletion: @escaping (Error?) -> Void) {

        URLSession.shared.downloadTask(with: url) { (url, _, error) in
            if let error = error {
                errorCompletion(error)
                return
            }

            if let imageUrl = url,
               let image = try? UIImage.init(url: imageUrl),
               let safeImage = image {
                sucessCompletion(safeImage)
            } else {
                errorCompletion(nil)
            }
        }.resume()
    }

    /// Get a movie poster image from the API. First a preview image is loaded and sent to the progress completion, after that
    /// the detailt image is loaded and returned on the same completion. Image chache included.
    ///
    /// - Parameters:
    ///   - movie: the poster`s movie
    ///   - progressCompletion: the progression completion is called two times, with the preview and detail image
    ///   - errorCompletion: error completion
    func image(
        fromMovie movie: Movie,
        progressCompletion: @escaping (UIImage) -> Void,
        errorCompletion: @escaping (Error?) -> Void) {

        guard let imageBaseUrl = self.imageBaseUrl,
              let imagePath = movie.posterPath else {
            errorCompletion(nil)
            return
        }

        /// the image is already in the cache
        if let movieImage = cacheService.get(imageWithKey: imagePath) {
            progressCompletion(movieImage)
            return
        }

        let previewImageStringUrl = PUTTMDBEndPoint.Image.littleImage.with(imageBaseURL: imageBaseUrl, andImageName: imagePath)
        let imageStringUrl = PUTTMDBEndPoint.Image.bigImage.with(imageBaseURL: imageBaseUrl, andImageName: imagePath)

        if let previewImageUrl = URL.init(string: previewImageStringUrl),
           let detailtImageUrl = URL.init(string: imageStringUrl) {

            /// get the preview image
            image(fromURL: previewImageUrl, sucessCompletion: { (previewImage) in

                progressCompletion(previewImage)

                /// the the detail image
                self.image(fromURL: detailtImageUrl, sucessCompletion: { (detailImage) in

                    /// save the detail image to the image cache
                    self.cacheService.add(image: detailImage, withKey: imagePath)
                    progressCompletion(detailImage)

                }, errorCompletion: { (error) in
                    errorCompletion(error)
                })
            }, errorCompletion: { (error) in
                errorCompletion(error)
            })
        } else {
            errorCompletion(nil)
        }
    }
}
