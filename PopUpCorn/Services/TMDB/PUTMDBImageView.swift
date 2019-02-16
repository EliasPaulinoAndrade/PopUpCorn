//
//  PUTMDBImageView.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 15/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class PUTMDBImageView: UIImageView {

    let tmdbService = PUTMDBService.init()
    var lastImageQuery: PUTMDBImageQuery?

    func setImage(fromPath path: String, placeHolderImage: UIImage) {

        self.lastImageQuery?.cancel()

        self.lastImageQuery = tmdbService.image(fromMovieWithPath: path,
            progressCompletion: { (movieImage) in
                DispatchQueue.main.async {
                    self.image = movieImage
                }
            },
            errorCompletion: { (_) in
                DispatchQueue.main.async {
                    self.image = placeHolderImage
                }
            }
        )
    }
}
