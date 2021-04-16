//
//  OSlideLanguage.swift
//  CDL
//
//  Created by Andrey Chernyshev on 16.04.2021.
//

import UIKit

final class OSlideLanguageView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var langSpanishView = makeLangSpanishView()
    lazy var langEnglishView = makeLangEnglishView()
    lazy var button = makeButton()
    
    private var isSelected = false
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSlideLanguageView {
    @objc
    func selectedLangSpanish() {
        isSelected = true
        
        langSpanishView.isSelected = true
        langEnglishView.isSelected = false
    }
    
    @objc
    func selectedLangEnglish() {
        isSelected = true
        
        langSpanishView.isSelected = false
        langEnglishView.isSelected = true
    }
}

// MARK: Make constraints
private extension OSlideLanguageView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            titleLabel.bottomAnchor.constraint(equalTo: langSpanishView.topAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            langSpanishView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            langSpanishView.widthAnchor.constraint(equalToConstant: 166.scale),
            langSpanishView.heightAnchor.constraint(equalToConstant: 205.scale),
            langSpanishView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -48.scale)
        ])
        
        NSLayoutConstraint.activate([
            langEnglishView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            langEnglishView.widthAnchor.constraint(equalToConstant: 166.scale),
            langEnglishView.heightAnchor.constraint(equalToConstant: 205.scale),
            langEnglishView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -48.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            button.heightAnchor.constraint(equalToConstant: 53.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlideLanguageView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 245, green: 245, blue: 245))
            .font(Fonts.SFProRounded.bold(size: 36.scale))
            .lineHeight(43.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.SlideLanguage.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLangSpanishView() -> OLanguageSelectView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectedLangSpanish))
        
        let view = OLanguageSelectView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLangEnglishView() -> OLanguageSelectView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectedLangEnglish))
        
        let view = OLanguageSelectView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 31, green: 31, blue: 31))
            .font(Fonts.SFProRounded.semiBold(size: 18.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = UIColor(integralRed: 249, green: 205, blue: 106)
        view.layer.cornerRadius = 12.scale
        view.setAttributedTitle("Onboarding.Next".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
