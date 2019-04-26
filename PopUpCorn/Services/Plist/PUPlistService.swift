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
    var tmdbAtributtes: PUTMDBCredentials? = {
        let plistDecoder = PropertyListDecoder.init()

        if let path = Bundle.main.path(forPlist: "\(PUListType.tmdb)"),
           let plistData = FileManager.default.contents(atPath: path),
           let credentials = try? plistDecoder.decode(PUTMDBCredentials.self, from: plistData) {

            return credentials
        }
        return nil
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
