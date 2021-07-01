//
//  WelcomeSlide3View.swift
//  CDL
//
//  Created by Andrey Chernyshev on 20.06.2021.
//

import UIKit

final class WelcomeSlide3View: UIView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subtitleLabel = makeSubtitleLabel()
    
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
private extension WelcomeSlide3View {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension WelcomeSlide3View {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 343.scale),
            imageView.heightAnchor.constraint(equalToConstant: 180.scale),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -23.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -230.scale : -180.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WelcomeSlide3View {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Welcome3")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 245, green: 245, blue: 245))
            .font(Fonts.Lato.bold(size: 36.scale))
            .lineHeight(43.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Welcome.Title3".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubtitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 245, green: 245, blue: 245))
            .font(Fonts.Lato.regular(size: 18.scale))
            .lineHeight(25.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Welcome.Subtitle3".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
