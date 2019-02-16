//
//  UICollectionView.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 15/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {

    func register(nibWithName nibName: String, identifiedBy identifier: String, inBundle bundle: Bundle? = Bundle.main) {

        let cellNib = UINib.init(nibName: nibName, bundle: bundle)
        register(cellNib, forCellWithReuseIdentifier: identifier)
    }
}
