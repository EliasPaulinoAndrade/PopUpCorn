//
//  RemindMovesViewControllerDelegate.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 08/06/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

protocol RemindMovesViewControllerDelegate: AnyObject {
    func remindMovieWasSelected(movie: DetailableMovie, atPosition position: Int)
}
