//
//  OExperienceCursor.swift
//  CDL
//
//  Created by Andrey Chernyshev on 29.06.2021.
//

import UIKit

final class OExperienceCursor: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    lazy var title: String = "" {
        didSet {
            let attrs = TextAttributes()
                .textColor(UIColor(integralRed: 245, green: 245, blue: 245))
                .font(Fonts.Lato.regular(size: 16.scale))
                .lineHeight(22.4.scale)
                .textAlignment(.center)
            label.attributedText = title.attributed(with: attrs)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension OExperienceCursor {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OExperienceCursor {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Onboarding.Experience")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
