//
//  Page.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 11/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

struct Page: Codable {
    var number: Int?
    var totalOfResults: Int?
    var totalOfPages: Int?
    var movies: [Movie]

    var nextPageNumber: Int {
        if let currentPageNumber = self.number {
            return currentPageNumber + 1
        }
        
        return 0
    }

    enum CodingKeys: String, CodingKey {
        case movies = "results"
        case number = "page"
        case totalOfResults = "total_results"
        case totalOfPages = "total_pages"
    }
}
