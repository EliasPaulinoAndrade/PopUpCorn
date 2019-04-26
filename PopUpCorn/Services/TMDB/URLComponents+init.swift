//
//  URLComponents+init.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 24/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

extension URLComponents {

    /// init specialized for tmdb endpoints
    ///
    /// - Parameters:
    ///   - credentials: the tmdb credentials
    ///   - path: the sub url path
    ///   - items: the url items for the endpoint
    init?(withCredentials credentials: PUTMDBCredentials, path: String, withItems items: [PUTMDBQueryProperty: String]) {

        let baseUrl = credentials.baseUrl
        let apiKey = credentials.apiKey

        let url = "\(baseUrl)\(path)"

        self.init(string: url)

        self.queryItems = [
            URLQueryItem.init(name: PUTMDBQueryProperty.apiKey.rawValue, value: apiKey)
        ]
        for (item, value) in items {
            self.queryItems?.append(URLQueryItem.init(name: item.rawValue, value: value))
        }
    }
}
