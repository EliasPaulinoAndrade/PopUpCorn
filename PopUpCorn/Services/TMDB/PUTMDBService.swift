//
//  PUTMDBService.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 11/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

/// A service for read data from the TMDB API
struct PUTMDBService {
    var credentials: PUTMDBCredentials?

    var data = PUTMDBServiceData.shared

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

    /// Get movies from the API
    ///
    /// - Parameters:
    ///   - endPoint: the movie type
    ///   - pageNumber: the movies page number, default is the first page.
    ///   - sucessCompletion: sucess completion
    ///   - errorCompletion: error completion, some error happend or something was wrong
    func movies(
        type: PUTMDBMovieType,
        inPageNumber pageNumber: Int? = 1,
        withStringQuery stringQuery: String? = nil,
        sucessCompletion: @escaping (Page) -> Void,
        errorCompletion: @escaping (Error?) -> Void) {

        guard let pageNumber = pageNumber,
              let credentials = self.credentials else {

                errorCompletion(nil)
                return
        }

        var moviesUrl: URL?

        if let query = stringQuery {
            moviesUrl = PUTTMDBEndPoint.movieSearch(
                credentials: credentials,
                type: type, language: "en-US",
                pageNumber: "\(pageNumber)",
                query: query
            ).formatted()
        } else {
            moviesUrl = PUTTMDBEndPoint.movie(
                credentials: credentials,
                type: type,
                language: "en-US",
                pageNumber: "\(pageNumber)"
            ).formatted()
        }

        if let url = moviesUrl {
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

        guard let credentials = self.credentials else {
                errorCompletion(nil)
                return
        }

        if let genres = self.data.genres {
            sucessCompletion(genres)
            return
        }

        let genresURL = PUTTMDBEndPoint.genre(
            credentials: credentials,
            language: "en-US"
        ).formatted()

        if let url = genresURL {

            let modelQuery = PUTMDBModelQuery<[String: [Genre]]>()
            modelQuery.run(fromURL: url, sucessCompletion: { (genreDictionary :[String : [Genre]]) in
                if let genres = genreDictionary["genres"] {

                    self.data.genres = genres
                    sucessCompletion(genres)
                } else {
                    errorCompletion(nil)
                }
            }, errorCompletion: errorCompletion)
        } else {
            errorCompletion(nil)
        }
    }

    @discardableResult
    func image(
        fromMovieWithPath imagePath: String,
        progressCompletion: @escaping (UIImage, PUTMDBImageState) -> Void,
        errorCompletion: @escaping (Error?, PUTMDBImageState) -> Void) -> PUTMDBPreviewableImageQuery? {

        guard let imageBaseUrl = self.credentials?.imageBaseUrl else {
                errorCompletion(nil, .none)
                return nil
        }

        let previewImageUrl = PUTTMDBEndPoint.image(type: .littleImage, baseURL: imageBaseUrl, imageName: imagePath).formatted()
        let imageUrl = PUTTMDBEndPoint.image(type: .bigImage, baseURL: imageBaseUrl, imageName: imagePath).formatted()

        if let previewImageUrl = previewImageUrl, let detailImageUrl = imageUrl {

            let imageQuery = PUTMDBPreviewableImageQuery.init()

            imageQuery.run (
                fromPreviewURL: previewImageUrl,
                imageUrl: detailImageUrl,
                progressCompletion: progressCompletion,
                errorCompletion: errorCompletion
            )

            return imageQuery
        }

        errorCompletion(nil, .none)
        return nil
    }

    /// Get a movie poster image from the API. First a preview image is loaded and sent to the progress completion, after that
    /// the detailt image is loaded and returned on the same completion. Image chache included.
    ///
    /// - Parameters:
    ///   - movie: the poster`s movie
    ///   - progressCompletion: the progression completion is called two times, with the preview and detail image
    ///   - errorCompletion: error completion
    @discardableResult
    func image(
        fromMovie movie: Movie,
        progressCompletion: @escaping (UIImage, PUTMDBImageState) -> Void,
        errorCompletion: @escaping (Error?, PUTMDBImageState) -> Void) -> PUTMDBPreviewableImageQuery? {

        guard let imagePath = movie.backdropPath else {
            errorCompletion(nil, .none)
            return nil
        }

        return image(fromMovieWithPath: imagePath, progressCompletion: progressCompletion, errorCompletion: errorCompletion)
    }
}
