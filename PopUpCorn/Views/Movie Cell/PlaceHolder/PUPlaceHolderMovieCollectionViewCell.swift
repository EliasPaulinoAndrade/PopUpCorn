//
//  PUPlaceHolderMovieCollectionViewCell.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 16/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

class PUPlaceHolderMovieCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.layer.cornerRadius = Dimens.Radius.bigCorner
    }

    override func layoutSubviews() {
         setGradientBackground(colorSet: [UIColor.puRed.cgColor, UIColor.puLightRed.cgColor, UIColor.puRed.cgColor])
    }

    func setGradientBackground(colorSet: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorSet
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.locations = [0.4, 0.5, 0.6]
        gradientLayer.frame = bounds

        let animation1 = CABasicAnimation.init(keyPath: "locations")
        animation1.duration = 3
        animation1.fromValue = [0.0, 0.3, 0.6]
        animation1.toValue = [0.4, 0.7, 1]
        animation1.fillMode = .forwards
        animation1.isRemovedOnCompletion = false

        let animation2 = CABasicAnimation.init(keyPath: "locations")
        animation2.duration = 3
        animation2.fromValue = [0.4, 0.7, 1]
        animation2.toValue = [0.0, 0.3, 0.6]
        animation2.fillMode = .forwards
        animation2.beginTime = 3

        animation2.isRemovedOnCompletion = false

        let animationGroup = CAAnimationGroup.init()
        animationGroup.duration = 6
        animationGroup.repeatCount = .infinity
        animationGroup.animations = [animation1, animation2]

        gradientLayer.add(animationGroup, forKey: "group")

        layer.insertSublayer(gradientLayer, at: 0)
    }
}
