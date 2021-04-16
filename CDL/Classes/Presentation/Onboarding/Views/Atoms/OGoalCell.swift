//
//  OSlide4Cell.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OGoalCell: PaddingLabel {
    var isSelected = false {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OGoalCell {
    func initialize() {
        backgroundColor = UIColor(integralRed: 60, green: 75, blue: 159)
        
        layer.masksToBounds = true
        layer.cornerRadius = 12.scale
        
        topInset = 16.scale
        bottomInset = 16.scale
        leftInset = 16.scale
        rightInset = 16.scale
        
        font = Fonts.SFProRounded.regular(size: 18.scale)
    }
    
    func update() {
        backgroundColor = isSelected ? UIColor(integralRed: 249, green: 205, blue: 106) : UIColor(integralRed: 60, green: 75, blue: 159)
        textColor = isSelected ? UIColor(integralRed: 31, green: 31, blue: 31) : UIColor(integralRed: 245, green: 245, blue: 245)
    }
}
