//
//  BaseZibOwnerView.swift
//  ZombieChallenge
//
//  Created by Elias Paulino on 12/11/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class PUBaseZibOwnerView: UIView {
    var contentViewZib: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCommon()
    }

    private func initCommon() {
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        addSubview(contentViewZib)

        contentViewZib.frame = self.bounds
        contentViewZib.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
