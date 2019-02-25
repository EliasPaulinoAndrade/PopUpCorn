//
//  Array+genreDict.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 14/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

extension Array where Element == Genre {

    func genreDictionary() -> [Int: String] {
        var genreDictionary: [Int: String] = [:]

        for genre in self {
            if let genreID = genre.id, let genreName = genre.name {
                genreDictionary[genreID] = genreName
            }
        }

        return genreDictionary
    }

    func nameArray(filteredByIds: [Int]) -> [String] {
        let genreDict = genreDictionary()
        var stringArray: [String] = []

        for genreID in filteredByIds {
            if let genreName = genreDict[genreID] {
                stringArray.append(genreName)
            }
        }

        return stringArray
    }
}
