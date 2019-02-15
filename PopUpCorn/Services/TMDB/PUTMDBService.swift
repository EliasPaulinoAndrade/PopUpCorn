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
    var credentials: PUTMDBCredentials?

    private var genres: [Genre]?

    /// initialize the service getting the api atributtes from TMDB plist
    init() {
        let plistService = PUPlistService.init()
        let tmdbAtributtes = plistService.tmdbAtributtes

        if let apiKey = tmdbAtributtes.apiKey,
           let baseUrl = tmdbAtributtes.baseUrl.normal,
           let imageBaseUrl = tmdbAtributtes.baseUrl.image {
            self.credentials = PUTMDBCredentials.init(
                withApiKey: apiKey,
                baseUrl: baseUrl,
                andImageBaseUrl: imageBaseUrl
            )
        }
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
              let baseUrl = self.credentials?.baseUrl,
              let apiKey = self.credentials?.apiKey else {
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
            let modelQuery = PUTMDBModelQuery<Page>()
            modelQuery.run(fromURL: url, sucessCompletion: sucessCompletion, errorCompletion: errorCompletion)
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
            let baseUrl = self.credentials?.baseUrl,
            let apiKey = self.credentials?.apiKey else {
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

            let modelQuery = PUTMDBModelQuery<Page>()
            modelQuery.run(fromURL: url, sucessCompletion: sucessCompletion, errorCompletion: errorCompletion)
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

        guard let baseUrl = self.credentials?.baseUrl,
              let apiKey = self.credentials?.apiKey else {
                errorCompletion(nil)
                return
        }

        let genresStringURL = PUTTMDBEndPoint.Genre.allGenres.with(baseURL: baseUrl, andApiKey: apiKey)

        if let url = URL.init(string: genresStringURL) {

            let modelQuery = PUTMDBModelQuery<[String: [Genre]]>()
            modelQuery.run(fromURL: url, sucessCompletion: { (genreDictionary :[String : [Genre]]) in
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

    /// Get a movie poster image from the API. First a preview image is loaded and sent to the progress completion, after that
    /// the detailt image is loaded and returned on the same completion. Image chache included.
    ///
    /// - Parameters:
    ///   - movie: the poster`s movie
    ///   - progressCompletion: the progression completion is called two times, with the preview and detail image
    ///   - errorCompletion: error completion
    func image(
        fromMovie movie: Movie,
        withID id: Int?,
        progressCompletion: @escaping (UIImage) -> Void,
        errorCompletion: @escaping (Error?) -> Void) {

        guard let imageBaseUrl = self.credentials?.imageBaseUrl,
              let imagePath = movie.posterPath else {
            errorCompletion(nil)
            return
        }

        let previewImageStringUrl = PUTTMDBEndPoint.Image.littleImage.with(imageBaseURL: imageBaseUrl, andImageName: imagePath)
        let imageStringUrl = PUTTMDBEndPoint.Image.bigImage.with(imageBaseURL: imageBaseUrl, andImageName: imagePath)

        if let previewImageUrl = URL.init(string: previewImageStringUrl),
           let detailImageUrl = URL.init(string: imageStringUrl) {

            let imageQuery = PUTMDBPreviewableImageQuery.init()

            imageQuery.run(
                fromPreviewURL: previewImageUrl,
                imageUrl: detailImageUrl,
                progressCompletion: progressCompletion,
                errorCompletion: errorCompletion
            )
        } else {
            errorCompletion(nil)
        }
    }
}
