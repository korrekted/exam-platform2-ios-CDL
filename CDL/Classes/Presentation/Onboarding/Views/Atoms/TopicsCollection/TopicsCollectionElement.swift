//
//  TopicsCollectionElement.swift
//  CDL
//
//  Created by Andrey Chernyshev on 22.04.2021.
//

import UIKit

final class TopicsCollectionElement {
    let course: Course
    var isSelected: Bool
    
    init(course: Course, isSelected: Bool) {
        self.course = course
        self.isSelected = isSelected
    }
}

// MARK: API
extension TopicsCollectionElement {
    func width(for height: CGFloat) -> CGFloat {
        return TopicsCollectionCell.size(for: self, with: height).width
    }
}
