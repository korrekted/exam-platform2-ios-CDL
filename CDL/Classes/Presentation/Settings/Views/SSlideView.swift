//
//  SSlideView.swift
//  CDL
//
//  Created by Андрей Чернышев on 17.05.2022.
//

import UIKit

class SSlideView: UIView {
    var didNextTapped: (() -> Void)?
    
    func moveToThis() {}
    
    @objc
    func onNext() {
        didNextTapped?()
    }
}
