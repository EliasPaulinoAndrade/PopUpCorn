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
            progressCompletion: { (movieImage) in
                DispatchQueue.main.async {
                    self.image = movieImage
                    if self.isBlured {
                        self.applyBlur()
                    }
                }
            },
            errorCompletion: { (_) in
                DispatchQueue.main.async {
                    self.image = placeHolderImage
                }
            }
        )
    }

    func applyBlur() {

//        guard let device = MTLCreateSystemDefaultDevice(),
//              let queue = device.makeCommandQueue(),
//              let commandBuffer = queue.makeCommandBuffer() else {
//            return
//        }
//
//        let blur = MPSImageGaussianBlur(device: device, sigma: 50)
//
//
//        blur.encode(commandBuffer: commandBuffer, sourceImage: MPSImage, destinationImage: <#T##MPSImage#>)

    }
}
