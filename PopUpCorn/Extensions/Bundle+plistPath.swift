//
//  Bundle_plistPath.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 11/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

// MARK: - shortcuit to get a plist file path
extension Bundle {
    func path(forPlist plistName: String) -> String? {
        return path(forResource: plistName, ofType: "plist")
    }
}
