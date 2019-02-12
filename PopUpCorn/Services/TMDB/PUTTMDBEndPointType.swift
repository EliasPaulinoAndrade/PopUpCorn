//
//  PUTTMDBEndPointType.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 11/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

enum PUTTMDBEndPointType {

    enum Movie: String {
        case upComing = "movie/upcoming"
        case popular = "movie/popular"

        func with(
            baseURL: String,
            pageNumber: String,
            language: String = "en-US",
            andApiKey apiKey: String) -> String {

            var urlString = "\(baseURL)\(self.rawValue)"

            urlString.append("?api_key=\(apiKey)")
            urlString.append("&language=\(language)")
            urlString.append("&page=\(pageNumber)")

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
}
