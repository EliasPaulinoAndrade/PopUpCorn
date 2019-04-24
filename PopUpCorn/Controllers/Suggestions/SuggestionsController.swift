//
//  SuggestionHandlerController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 17/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation


/// A controller the abstracts retrieve, creation and listing of suggestions
class SuggestionsController {
    private var plistService = PUPlistService.init()

    var numberOfSuggestions: Int {
        return plistService.suggestions.count
    }

    func add(suggestion: String) {
        if !plistService.suggestions.contains(suggestion) {
            plistService.suggestions.add(suggestion)
        }
    }

    func allSuggestions() -> [String] {
        return plistService.suggestions.array
    }

    func suggestionAt(position: Int) -> String {
        return plistService.suggestions[position]
    }

    func saveSuggestions() {
        plistService.saveSuggestions()
    }

    //search a string in the suggestions
    func searchOnSuggestions(text: String) -> [String] {
        let suggestions = plistService.suggestions.array

        let results = suggestions.filter { (suggestion) -> Bool in
            return suggestion.contains(text) || suggestion == text
        }

        return results
    }
}
