//
//  PUPlistService.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 11/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

/// A service that reads/write plist files
struct PUPlistService {
    var tmdbAtributtes: (apiKey: String?, baseUrl: (image: String?, normal: String?)) = {
        if let path = Bundle.main.path(forPlist: "\(PUListType.tmdb)"),
           let tmdbDictionary = NSDictionary(contentsOfFile: path) as? [String: String] {

            return  (apiKey: tmdbDictionary["api_key"],
                     baseUrl: (
                        (normal: tmdbDictionary["base_url"],
                         image: tmdbDictionary["image_base_url"])
                     )
                    )
        }
        return (nil, (nil, nil))
    }()
}
