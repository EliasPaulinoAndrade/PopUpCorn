//
//  PUTMDBImageQuery.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 14/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class PUTMDBImageQuery: PUTMDBQuery {

    private var cacheService = PUCacheService.init()
    private var task: URLSessionDownloadTask?

    /// Get a image from a given URL
    ///
    /// - Parameters:
    ///   - url: the url
    ///   - sucessCompletion: sucess completion
    ///   - errorCompletion: error completion
    func run(
        fromURL url: URL,
        sucessCompletion: @escaping (UIImage) -> Void,
        errorCompletion: @escaping (Error?) -> Void) {

        if let currentTask = self.task, currentTask.state == .running {
            currentTask.cancel()
        }

        /// the image is already in the cache
        if let movieImage = cacheService.get(imageWithKey: url.absoluteString) {

            sucessCompletion(movieImage)
            return
        }

        self.task = URLSession.shared.downloadTask(with: url) { (responseUrl, _, error) in
            if let error = error {
                errorCompletion(error)
                return
            }

            if let imageUrl = responseUrl,
                let image = try? UIImage.init(url: imageUrl),
                let safeImage = image {

                /// save the image to the image cache
                self.cacheService.add(image: safeImage, withKey: url.absoluteString)

                sucessCompletion(safeImage)
            } else {
                errorCompletion(nil)
            }
        }

        task?.resume()
    }

    func cancel() {
        task?.cancel()
    }
}
