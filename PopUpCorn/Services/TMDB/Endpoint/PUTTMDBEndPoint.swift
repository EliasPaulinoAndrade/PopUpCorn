//
//  PUTTMDBEndPointType.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 11/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

/// A struct the manage the endpoint enums from the TMDB API
enum PUTTMDBEndPoint {

    case genre(credentials: PUTMDBCredentials, language: String)

    case movie(credentials: PUTMDBCredentials, type: PUTMDBMovieType, language: String, pageNumber: String)

    case movieSearch(credentials: PUTMDBCredentials, type: PUTMDBMovieType, language: String, pageNumber: String, query: String)

    case image(type: PUTMDBImageType, baseURL: String, imageName: String)

    /// build the endpoint path for the enum case
    ///
    /// - Returns: the endpoint url
    func formatted() -> URL? {

        var urlComponents: URLComponents?
        switch self {
        case .genre(let credentials, let language):
            urlComponents = URLComponents.init(withCredentials: credentials, path: "genre/movie/list", withItems: [
                .language: language
            ])
        case .movie(let credentials, let type, let language, let pageNumber):
            urlComponents = URLComponents.init(withCredentials: credentials, path: "\(type)", withItems: [
                .language: language,
                .includeAdult: "false",
                .pageNumber: pageNumber
            ])
        case .movieSearch(let credentials, let type, let language, let pageNumber, let query):
            urlComponents = URLComponents.init(withCredentials: credentials, path: "\(type)", withItems: [
                .language: language,
                .includeAdult: "false",
                .pageNumber: pageNumber,
                .query: query
            ])
        case .image(let type, let baseURL, let imageName):
            let urlString = "\(baseURL)\(type)/\(imageName)"

            urlComponents = URLComponents.init(string: urlString)
        }

        return urlComponents?.url
    }
}
