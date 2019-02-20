//
//  PUCacheCenter.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 12/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class PUCacheCenter {
    static var shared = PUCacheCenter.init()

    var imageCache: NSCache<NSString, UIImage> = NSCache.init()

    private init() { }
}
