//
//  PUTMDBPreviewableImageQuery.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 14/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class PUTMDBPreviewableImageQuery: PUTMDBImageQuery {

    func run(fromPreviewURL previewImageUrl: URL, imageUrl: URL, progressCompletion: @escaping (UIImage, PUTMDBImageState) -> Void, errorCompletion: @escaping (Error?, PUTMDBImageState) -> Void) {

        run(fromURL: previewImageUrl, sucessCompletion: { (previewImage) in

            progressCompletion(previewImage, .preview)

            /// the the detail image
            self.run(fromURL: imageUrl, sucessCompletion: { (detailImage) in

                progressCompletion(detailImage, .detail)

            }, errorCompletion: { (error) in
                errorCompletion(error, .detail)
            })
        }, errorCompletion: { (error) in
            errorCompletion(error, .preview)
        })
    }
}
