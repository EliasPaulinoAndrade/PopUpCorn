//
//  ImageType.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 24/04/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

enum PUTMDBImageType: String, CustomStringConvertible {
    var description: String {
        return self.rawValue
    }

    case littleImage = "w92"
    case bigImage = "w500"
}
