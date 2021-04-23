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
    func width(with attrs: TextAttributes, height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = topic.title
            .boundingRect(with: constraintRect,
                          options: .usesLineFragmentOrigin,
                          attributes: attrs.dictionary,
                          context: nil)

        return ceil(boundingBox.width)
    }
}
