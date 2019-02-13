//
//  ListType.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 11/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

/// a enum to store plist file names
enum PUListType: String, CustomStringConvertible {

    case tmdb

    var description: String {
        return self.rawValue
    }
}
