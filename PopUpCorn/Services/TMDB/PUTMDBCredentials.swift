//
//  PUTMDBCredentials.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 14/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

class PUTMDBCredentials {
    var apiKey: String
    var baseUrl: String
    var imageBaseUrl: String

    init(withApiKey apiKey: String, baseUrl: String, andImageBaseUrl imageBaseUrl: String) {
        self.apiKey = apiKey
        self.baseUrl = baseUrl
        self.imageBaseUrl = imageBaseUrl
    }
}
