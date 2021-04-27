//
//  OLanguageSelectView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 16.04.2021.
//

import UIKit

final class OLanguageSelectView: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    var isSelected = false {
        didSet {
            updateColor()
        }
    }
    
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
private extension OLanguageSelectView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 60, green: 75, blue: 159)
        layer.cornerRadius = 12.scale
        layer.borderWidth = 3.scale
        layer.borderColor = UIColor.clear.cgColor
    }
    
    func updateColor() {
        layer.borderColor = isSelected ? UIColor(integralRed: 249, green: 205, blue: 106).cgColor : UIColor.clear.cgColor
    }
}

// MARK: Make constraints
private extension OLanguageSelectView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23.scale),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 27.scale),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -27.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OLanguageSelectView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor.black
        view.font = Fonts.SFProRounded.semiBold(size: 17.scale)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
