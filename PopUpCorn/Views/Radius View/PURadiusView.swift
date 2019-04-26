//
//  PURadiusView.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 16/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

class PURadiusView: UIView {

    var radius = Dimens.Radius.shortCorner {
        didSet {
            setContentView()
        }
    }

    var shadowColor: CGColor = UIColor.black.cgColor {
        didSet {
            setShadow()
        }
    }

    override var backgroundColor: UIColor? {
        didSet {
            contentView.backgroundColor = backgroundColor
        }
    }

    private var contentView = UIView.init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        insertSubview(contentView, at: 0)
        setContentView()
        setShadow()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        insertSubview(contentView, at: 0)
        setContentView()
        setShadow()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setContentViewConstraints()
        setShadow()
    }

    private func setContentView() {
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = radius
        contentView.backgroundColor = self.backgroundColor
    }

    private func setShadow() {
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = shadowColor
        layer.shadowOffset = CGSize(width: 0, height: 0.0)
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 2
    }

    private func setContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
}
