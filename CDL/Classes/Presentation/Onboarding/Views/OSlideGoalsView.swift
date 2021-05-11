//
//  OSlide4View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlideGoalsView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var cell1 = makeCell(title: "Onboarding.Goals.Cell1", tag: 1)
    lazy var cell2 = makeCell(title: "Onboarding.Goals.Cell2", tag: 2)
    lazy var cell3 = makeCell(title: "Onboarding.Goals.Cell3", tag: 3)
    lazy var cell4 = makeCell(title: "Onboarding.Goals.Cell4", tag: 4)
    lazy var button = makeButton()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSlideGoalsView {
    @objc
    func selected(tapGesture: UITapGestureRecognizer) {
        guard let cell = tapGesture.view as? OGoalCell else {
            return
        }
        
        cell.isSelected = !cell.isSelected
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Goals Tap", parameters: [:])
    }
}

// MARK: Make constraints
private extension OSlideGoalsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: cell1.topAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cell1.bottomAnchor.constraint(equalTo: cell2.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cell2.bottomAnchor.constraint(equalTo: cell3.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cell3.bottomAnchor.constraint(equalTo: cell4.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell4.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            cell4.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cell4.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -48.scale)
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
private extension OSlideGoalsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.pickerText)
            .font(Fonts.SFProRounded.bold(size: 36.scale))
            .lineHeight(43.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Goals.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(title: String, tag: Int) -> OGoalCell {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selected(tapGesture:)))
        
        let view = OGoalCell()
        view.tag = tag
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.isSelected = false
        view.text = title.localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryButtonTint)
            .font(Fonts.SFProRounded.semiBold(size: 18.scale))
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
