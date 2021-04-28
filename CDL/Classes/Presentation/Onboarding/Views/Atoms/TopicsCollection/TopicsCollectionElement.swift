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
        var string = topic.title
        if topic.isMain {
            string += "\n" + topic.description
        }
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = string
            .boundingRect(with: constraintRect,
                          options: .usesLineFragmentOrigin,
                          attributes: attrs.dictionary,
                          context: nil)

        return ceil(boundingBox.width)
    }
}
