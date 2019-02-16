//
//  MovieRequesterDelegate.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 15/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

protocol MovieRequesterControllerDelegate: AnyObject {
    func moviesHaveArrived(_ requester: MovieRequesterController)
}
