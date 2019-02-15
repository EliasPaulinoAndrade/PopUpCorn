//
//  Array+genreDict.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 14/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

extension Array where Element == Genre {

    func genreDictionary() -> [Int: Genre] {
        var dictionary: [Int: Genre] = [:]

        for genre in self {
            if let genreID = genre.id {
                dictionary[genreID] = genre
            }
        }

        return dictionary
    }
}
