//
//  PUTTMDBEndPointType.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 11/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

/// A struct the manage the endpoint enums from the TMDB API
struct PUTTMDBEndPoint {

    enum Genre: String {
        case allGenres = "genre/movie/list"

        func with(
            baseURL: String,
            language: String = "en-US",
            andApiKey apiKey: String) -> URL? {

            let urlString = "\(baseURL)\(self.rawValue)"

            var urlComponents = URLComponents.init(string: urlString)

            urlComponents?.queryItems = [
                URLQueryItem.init(name: "api_key", value: apiKey),
                URLQueryItem.init(name: "language", value: language)
            ]

            return urlComponents?.url
        }
    }

    enum Movie: String {
        case upComing = "movie/upcoming"
        case popular = "movie/popular"
        case search = "search/movie"

        func with(
            baseURL: String,
            pageNumber: String,
            language: String = "en-US",
            query: String? = nil,
            andApiKey apiKey: String) -> URL? {

            let urlString = "\(baseURL)\(self.rawValue)"

            var urlComponents = URLComponents.init(string: urlString)

            urlComponents?.queryItems = [
                URLQueryItem.init(name: "api_key", value: apiKey),
                URLQueryItem.init(name: "language", value: language),
                URLQueryItem.init(name: "page", value: pageNumber),
                URLQueryItem.init(name: "include_adult", value: "false")
            ]

            if let queryString = query {
                urlComponents?.queryItems?.append(URLQueryItem.init(name: "query", value: queryString))
            }

            return urlComponents?.url
        }
    }

    enum Image: String {
        case littleImage = "w92"
        case bigImage = "w500"

        func with(
            imageBaseURL baseURL: String,
            andImageName imageName: String) -> URL? {

            let urlString = "\(baseURL)\(self.rawValue)/\(imageName)"
            return URL(string: urlString)
        }
    }
}
