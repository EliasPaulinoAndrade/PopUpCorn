//
//  PUTMDBServiceData.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 14/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

class PUTMDBServiceData {
    static let shared = PUTMDBServiceData.init()
    var genres: [Genre]?

    private init() { }
}
