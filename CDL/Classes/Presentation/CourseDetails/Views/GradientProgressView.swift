//
//  GradientProgressView.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 25.04.2021.
//

import UIKit

class GradientProgressView: UIView {
    
    private var gradientLoacation = [NSNumber]()
    
    override func draw(_ rect: CGRect) {
        let correctColor = UIColor(integralRed: 143, green: 207, blue: 99)
        let incorrectColor = UIColor(integralRed: 241, green: 104, blue: 91)
        let emptyColor =  UIColor(integralRed: 212, green: 216, blue: 221)
        let gradientLayer = CAGradientLayer()
        
        let colors = [
            incorrectColor.cgColor,
            incorrectColor.cgColor,
            correctColor.cgColor,
            correctColor.cgColor,
            emptyColor.cgColor,
            emptyColor.cgColor
        ]
        
        gradientLayer.frame = rect
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.locations = gradientLoacation
        layer.masksToBounds = true
        layer.addSublayer(gradientLayer)
    }
    
    func setGradientLocation(correctPercent: Int, incorrectPercent: Int) {
        let incorrectLocation = Double(incorrectPercent) / 100
        let correctLocation = Double(correctPercent) / 100 + incorrectLocation
        
        gradientLoacation = [
            0,
            incorrectLocation,
            incorrectLocation + 0.0000001,
            correctLocation,
            correctLocation + 0.0000001,
            1
        ].map { NSNumber(value: $0) }
        
        
    }
}
