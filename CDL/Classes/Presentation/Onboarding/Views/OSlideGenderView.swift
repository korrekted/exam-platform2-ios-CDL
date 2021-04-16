//
//  OSlide2View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlideGenderView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var manView = makeManView()
    lazy var womanView = makeWomanView()
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
private extension OSlideGenderView {
    @objc
    func selectedMan() {
        isSelected = true
        
        womanView.isSelected = false
        manView.isSelected = true
    }
    
    @objc
    func selectedWoman() {
        isSelected = true
        
        womanView.isSelected = true
        manView.isSelected = false
    }
}

// MARK: Make constraints
private extension OSlideGenderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            titleLabel.bottomAnchor.constraint(equalTo: manView.topAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            manView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            manView.widthAnchor.constraint(equalToConstant: 166.scale),
            manView.heightAnchor.constraint(equalToConstant: 205.scale),
            manView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -48.scale)
        ])
        
        NSLayoutConstraint.activate([
            womanView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            womanView.widthAnchor.constraint(equalToConstant: 166.scale),
            womanView.heightAnchor.constraint(equalToConstant: 205.scale),
            womanView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -48.scale)
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
private extension OSlideGenderView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 245, green: 245, blue: 245))
            .font(Fonts.SFProRounded.bold(size: 36.scale))
            .lineHeight(43.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.SlideGender.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeManView() -> OGenderSelectView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectedMan))
        
        let view = OGenderSelectView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.imageView.image = UIImage(named: "Onboarding.Gender.Man")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeWomanView() -> OGenderSelectView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectedWoman))
        
        let view = OGenderSelectView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.imageView.image = UIImage(named: "Onboarding.Gender.Woman")
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
