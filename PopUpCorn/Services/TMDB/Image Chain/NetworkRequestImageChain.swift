//
//  NetworkRequestImageChain.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 03/05/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class NetworkRequestImageChain: ImageChain {
    var next: ImageChain?

    var imageName: String

    private let tmdbService = PUTMDBService.init()

    private var lastImageQuery: PUTMDBImageQuery?

    init(withImageName imageName: String) {
        self.imageName = imageName
    }

    func run(completion: @escaping (UIImage?) -> Void) {
        self.lastImageQuery?.cancel()

        self.lastImageQuery = tmdbService.image(fromMovieWithPath: imageName,
            progressCompletion: { (movieImage, _) in
                DispatchQueue.main.async {
                    completion(movieImage)
                }
            }, errorCompletion: { (_, state) in
                if state != .detail {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        )
    }
}
