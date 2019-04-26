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

    var suggestions: Queue<String> = {
        var suggestions = Queue<String>.init(withLimit: Suggestions.limitOfSuggestions)

        if let path = Bundle.main.path(forPlist: "\(PUListType.suggestions)"),
           let listOfSuggestions = NSArray(contentsOfFile: path) as? [String] {

            suggestions.add(array: listOfSuggestions)
        }
        return suggestions
    }()

    func saveSuggestions() {

        let suggestionsArray = NSArray.init(array: suggestions.array)

        if let path = Bundle.main.path(forPlist: "\(PUListType.suggestions)") {
            suggestionsArray.write(toFile: path, atomically: true)
        }
    }
}
