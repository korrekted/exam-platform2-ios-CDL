//
//  TopicsCollectionElement.swift
//  CDL
//
//  Created by Andrey Chernyshev on 22.04.2021.
//

import UIKit

final class TopicsCollectionElement {
    let topic: SpecificTopic
    var isSelected: Bool
    
    init(topic: SpecificTopic, isSelected: Bool) {
        self.topic = topic
        self.isSelected = isSelected
    }
}

// MARK: API
extension TopicsCollectionElement {
    func width(for height: CGFloat) -> CGFloat {
        return TopicsCollectionCell.size(for: self, with: height).width
    }
}
