//
//  TopicsCollectionCell.swift
//  CDL
//
//  Created by Andrey Chernyshev on 22.04.2021.
//

import UIKit

final class TopicsCollectionCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension TopicsCollectionCell {
    func setup(element: TopicsCollectionElement) {
        let textColor = element.isSelected ? Onboarding.Topics.selectedText : Onboarding.Topics.text
        
        let titleAttr = TextAttributes().font(Fonts.SFProRounded.bold(size: 24.scale)).textColor(textColor)
        let subtitleAttr = TextAttributes().font(Fonts.SFProRounded.regular(size: 18.scale)).textColor(textColor)
        
        let attrs = NSMutableAttributedString()
        attrs.append(element.topic.title.attributed(with: titleAttr))
        
        if element.topic.isMain {
            attrs.append(("\n" + element.topic.description).attributed(with: subtitleAttr))
        }
        
        label.attributedText = attrs
        
        container.backgroundColor = element.isSelected ? Onboarding.Topics.selectedBackground : Onboarding.Topics.background
    }
}

// MARK: Private
private extension TopicsCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension TopicsCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TopicsCollectionCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
