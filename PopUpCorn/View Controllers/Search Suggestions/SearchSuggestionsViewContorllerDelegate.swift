//
//  SearchSuggestionsViewContorllerDelegate.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 17/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

protocol SearchSuggestionsViewContorllerDelegate: AnyObject {
    func userDidSelectSuggestion(_ controller: SearchSuggestionsViewController, suggestion: String)
}
