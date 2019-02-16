//
//  GenreRequesterControllerDelegate.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 16/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

protocol GenreRequesterControllerDelegate: AnyObject {
    func genresHasArrived(_ requester: GenreRequesterController, genres: [String])
    func errorHappend(_ requester: GenreRequesterController, error: Error?)
}
