//
//  PUCacheService.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 12/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

struct PUCacheService {
    public var cacheCenter = PUCacheCenter.shared

    func add(image: UIImage, withKey key: String) {
        cacheCenter.imageCache.setObject(image, forKey: key as NSString)
    }

    func get(imageWithKey imageKey: String) -> UIImage? {
        return cacheCenter.imageCache.object(forKey: imageKey as NSString)
    }
}
