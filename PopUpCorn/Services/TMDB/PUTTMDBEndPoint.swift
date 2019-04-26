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

            var urlString = "\(baseURL)\(self.rawValue)"

            PUTTMDBEndPoint.insert(parameters: [
                "api_key": apiKey,
                "language": language
                ], inStringURL: &urlString)

            return URL(string: urlString)
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

            var urlString = "\(baseURL)\(self.rawValue)"

            var paramenters = [
                "api_key": apiKey,
                "language": language,
                "page": pageNumber,
                "include_adult": "false"
            ]

            if let queryString = query {
                paramenters["query"] = queryString
            }

            PUTTMDBEndPoint.insert(parameters: paramenters, inStringURL: &urlString)
            return URL(string: urlString)
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

    static private func insert(parameters: [String: Any], inStringURL stringURL: inout String) {

        stringURL.append("?")
        for (paramenterKey, paramenterValue) in parameters {
            stringURL.append("\(paramenterKey)=\(paramenterValue)&")
        }
    }
}
