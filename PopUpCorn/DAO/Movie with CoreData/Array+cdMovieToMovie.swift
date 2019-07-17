//
//  Array+cdMovieToMovie.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 08/06/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import CoreData

extension Array where Element == CDMovie {
    var toMovieArray: [Movie] {
        return self.map { (cdMovie) -> Movie in
            return cdMovie.toMovie
        }
    }
}
