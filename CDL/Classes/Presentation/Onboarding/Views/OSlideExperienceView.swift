//
//  OSlideExperienceView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 16.04.2021.
//

import UIKit
import RxSwift

final class OSlideExperienceView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var experienceView = makeExperienceView()
    lazy var button = makeButton()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSlideExperienceView {
    func initialize() {
        Observable
            .merge(
                experienceView
                    .period1Button.rx.tap
                    .map { OExperienceProgressView.Period.period1 },
                
                experienceView
                    .period2Button.rx.tap
                    .map { OExperienceProgressView.Period.period2 },
                
                experienceView
                    .period3Button.rx.tap
                    .map { OExperienceProgressView.Period.period3 },
                
                experienceView
                    .period4Button.rx.tap
                    .map { OExperienceProgressView.Period.period4 }
            )
            .subscribe(onNext: { [weak self] period in
                self?.experienceView.period = period
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints
private extension OSlideExperienceView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: experienceView.topAnchor, constant: -48.scale)
        ])
        
        NSLayoutConstraint.activate([
            experienceView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            experienceView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            experienceView.heightAnchor.constraint(equalToConstant: 85.scale),
            experienceView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -48.scale)
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
private extension OSlideExperienceView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryText)
            .font(Fonts.Lato.bold(size: 36.scale))
            .lineHeight(43.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Experience.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeExperienceView() -> OExperienceProgressView {
        let view = OExperienceProgressView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryButtonTint)
            .font(Fonts.Lato.regular(size: 18.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = Onboarding.primaryButton
        view.layer.cornerRadius = 12.scale
        view.setAttributedTitle("Onboarding.Next".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
