//
//  ListableMovie.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 16/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

struct ListableMovie {
    var title: String
    var release: Date?
    var posterPath: String?
    var backdropPath: String?
    var genresIDs: [Int]
}
