//
//  ReloaderAlertBuilderDelegate.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 16/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

protocol ReloaderAlertBuilderDelegate: AnyObject {
    func needReloadData(_ alertBuilder: ReloaderAlertBuilder)
}
