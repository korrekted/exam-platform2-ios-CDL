//
//  TopicsCollectionElement.swift
//  CDL
//
//  Created by Andrey Chernyshev on 22.04.2021.
//

import UIKit

final class TopicsCollectionElement {
    let title: String
    var isSelected: Bool
    
    init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
}

// MARK: API
extension TopicsCollectionElement {
    func width(with attrs: TextAttributes, height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = title
            .boundingRect(with: constraintRect,
                          options: .usesLineFragmentOrigin,
                          attributes: attrs.dictionary,
                          context: nil)

        return ceil(boundingBox.width)
    }
}
