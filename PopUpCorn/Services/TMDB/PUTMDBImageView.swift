//
//  PUTMDBImageView.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 15/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit
import MetalPerformanceShaders

class PUTMDBImageView: UIImageView {

    var isBlured = false

    private let tmdbService = PUTMDBService.init()
    private var lastImageQuery: PUTMDBImageQuery?

    func setImage(fromPath path: String, placeHolderImage: UIImage) {

        self.lastImageQuery?.cancel()

        self.lastImageQuery = tmdbService.image(fromMovieWithPath: path,
            progressCompletion: { (movieImage, _) in
                DispatchQueue.main.async {
                    self.image = movieImage
                }
            },
            errorCompletion: { (_, state) in
                if state != .detail {
                    DispatchQueue.main.async {
                        self.image = placeHolderImage
                    }
                }
            }
        )
    }
}
