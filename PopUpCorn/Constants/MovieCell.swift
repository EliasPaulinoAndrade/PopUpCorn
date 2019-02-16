//
//  CellConstants.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 15/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

enum MovieCell {

    enum Normal {
        static let nibName = "PUNormalMovieCollectionViewCell"
        static let reuseIdentifier = "normalMovieIdenfier"
    }

    enum Exapanded {
        static let nibName = "PUExpandedMovieCollectionViewCell"
        static let reuseIdentifier = "expandedMovieIdenfier"
    }
}
