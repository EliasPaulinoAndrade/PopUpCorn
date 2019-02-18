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
        ofEndPoint endPoint: PUTTMDBEndPoint.Movie,
        inPageNumber pageNumber: Int? = 1,
        withStringQuery stringQuery: String? = nil,
        sucessCompletion: @escaping (Page) -> Void,
        errorCompletion: @escaping (Error?) -> Void) {

        guard let pageNumber = pageNumber,
              let baseUrl = self.credentials?.baseUrl,
              let apiKey = self.credentials?.apiKey else {

                errorCompletion(nil)
                return
        }

        let moviesStringUrl = endPoint.with(
            baseURL: baseUrl,
            pageNumber: "\(pageNumber)",
            query: stringQuery,
            andApiKey: apiKey
        )

        if let url = URL.init(string: moviesStringUrl) {
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

        if let genres = self.data.genres {
            sucessCompletion(genres)
            return
        }

        let genresStringURL = PUTTMDBEndPoint.Genre.allGenres.with(baseURL: baseUrl, andApiKey: apiKey)

        if let url = URL.init(string: genresStringURL) {

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
