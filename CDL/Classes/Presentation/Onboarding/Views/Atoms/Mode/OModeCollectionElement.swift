//
//  OModeCollectionElement.swift
//  CDL
//
//  Created by Andrey Chernyshev on 21.06.2021.
//

final class OModeCollectionElement {
    let title: String
    let subtitle: String
    var isSelected: Bool
    
    init(title: String,
         subtitle: String,
         isSelected: Bool) {
        self.title = title
        self.subtitle = subtitle
        self.isSelected = isSelected
    }
}
