//
//  PUTMDBCredentials.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 14/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

class PUTMDBCredentials: Decodable {
    var apiKey: String
    var baseUrl: String
    var imageBaseUrl: String

    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case baseUrl = "base_url"
        case imageBaseUrl = "image_base_url"
    }

    init(withApiKey apiKey: String, baseUrl: String, andImageBaseUrl imageBaseUrl: String) {
        self.apiKey = apiKey
        self.baseUrl = baseUrl
        self.imageBaseUrl = imageBaseUrl
    }
}
