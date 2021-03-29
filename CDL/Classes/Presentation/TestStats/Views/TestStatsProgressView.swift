//
//  TestStatsProgressView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import UIKit

final class TestStatsProgressView: UIView {
    private lazy var circleLayer = CAShapeLayer()
    private lazy var progressLayer = CAShapeLayer()
    
    private var isConfigured = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !isConfigured else {
            return
        }
        
        createCircularPath()
        
        isConfigured = true
    }
}

// MARK: Public
extension TestStatsProgressView {
    func progress(progress: CGFloat) {
        progressLayer.strokeEnd = progress
    }
}

// MARK: Private
private extension TestStatsProgressView {
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2,
                                                           y: frame.size.height / 2),
                                        radius: frame.size.width / 2,
                                        startAngle: -.pi / 2,
                                        endAngle: 3 * .pi / 2,
                                        clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 15.scale
        circleLayer.strokeColor = UIColor(integralRed: 241, green: 104, blue: 91).cgColor
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 15.scale
        progressLayer.strokeColor = UIColor(integralRed: 143, green: 207, blue: 99).cgColor

        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
    }
}
