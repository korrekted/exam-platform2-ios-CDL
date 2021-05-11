//
//  OQuestionFormView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 16.04.2021.
//

import UIKit

final class OQuestionFormView: UIView {
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

// MARK: Private
private extension OQuestionFormView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension OQuestionFormView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24.scale),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OQuestionFormView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Onboarding.Question.containerBackground
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = Onboarding.Question.text
        view.font = Fonts.SFProRounded.regular(size: 24.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
