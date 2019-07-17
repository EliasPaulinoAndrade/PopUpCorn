//
//  Chain.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 02/05/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

protocol ImageChain {
    var next: ImageChain? { get set }
    var imageName: String { get set }
    func run(completion: @escaping (UIImage?) -> Void)
}
