//
//  NSCacheImageChain.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 03/05/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

struct NSCacheImageChain: ImageChain {

    var imageName: String

    var next: ImageChain?

    private var cacheService = PUCacheService.init()

    private var tmdbService = PUTMDBService.init()

    init(withImageName imageName: String) {
        self.imageName = imageName
    }

    func run(completion: (UIImage?) -> Void) {

        guard let detailImageUrl = tmdbService.imageUrls(forImageName: imageName).detail else {
            return
        }

        /// the image is already in the cache
        if let movieImage = cacheService.get(imageWithKey: detailImageUrl.absoluteString) {

            completion(movieImage)
            return
        }
        completion(nil)
    }
}
