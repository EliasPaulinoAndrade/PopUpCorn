//
//  PUTTMDBEndPointType.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 11/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

struct PUTTMDBEndPoint {

    enum Genre: String {
        case allGenres = "genre/movie/list"

        func with(
            baseURL: String,
            language: String = "en-US",
            andApiKey apiKey: String) -> String {

            var urlString = "\(baseURL)\(self.rawValue)"

            PUTTMDBEndPoint.insert(parameters: [
                "api_key": apiKey,
                "language": language
                ], inStringURL: &urlString)

            return urlString
        }
    }

    enum Movie: String {
        case upComing = "movie/upcoming"
        case popular = "movie/popular"

        func with(
            baseURL: String,
            pageNumber: String,
            language: String = "en-US",
            andApiKey apiKey: String) -> String {

            var urlString = "\(baseURL)\(self.rawValue)"

            PUTTMDBEndPoint.insert(parameters: [
                "api_key": apiKey,
                "language": language,
                "page": pageNumber
                ], inStringURL: &urlString)
            return urlString
        }
    }

    enum Image: String {
        case littleImage = "w92"
        case bigImage = "w500"

        func with(
            imageBaseURL baseURL: String,
            andImageName imageName: String) -> String {

            let urlString = "\(baseURL)\(self.rawValue)/\(imageName)"
            return urlString
        }
    }

    static private func insert(parameters: [String: Any], inStringURL stringURL: inout String) {

        stringURL.append("?")
        for (paramenterKey, paramenterValue) in parameters {
            stringURL.append("\(paramenterKey)=\(paramenterValue)&")
        }
    }
}
