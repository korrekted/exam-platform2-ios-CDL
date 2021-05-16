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
        let titleAttr = TextAttributes().font(Fonts.SFProRounded.bold(size: 24.scale))
        let subtitleAttr = TextAttributes().font(Fonts.SFProRounded.regular(size: 18.scale))
        
        let attrs = NSMutableAttributedString()
        attrs.append(topic.title.attributed(with: titleAttr))
        
        if topic.isMain {
            attrs.append(("\n" + topic.description).attributed(with: subtitleAttr))
        }
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        
        let boundingBox = attrs.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.width + 32)
    }
}
