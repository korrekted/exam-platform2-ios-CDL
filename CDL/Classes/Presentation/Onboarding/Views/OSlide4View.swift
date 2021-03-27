//
//  OSlide4View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlide4View: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var cell1 = makeCell(title: "Onboarding.Slide4.Cell1", tag: 1)
    lazy var cell2 = makeCell(title: "Onboarding.Slide4.Cell2", tag: 2)
    lazy var cell3 = makeCell(title: "Onboarding.Slide4.Cell3", tag: 3)
    lazy var cell4 = makeCell(title: "Onboarding.Slide4.Cell4", tag: 4)
    lazy var cell5 = makeCell(title: "Onboarding.Slide4.Cell5", tag: 5)
    lazy var button = makeButton()
    lazy var imageView = makeImageView()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSlide4View {
    @objc
    func selected(tapGesture: UITapGestureRecognizer) {
        guard let cell = tapGesture.view as? OSlide4Cell else {
            return
        }
        
        cell.isSelected = !cell.isSelected
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Goals Tap", parameters: [:])
    }
}

// MARK: Make constraints
private extension OSlide4View {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 134.scale : 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            cell1.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 282.scale : 200.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell4.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            cell4.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            cell4.topAnchor.constraint(equalTo: cell3.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell5.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            cell5.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            cell5.topAnchor.constraint(equalTo: cell4.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            button.heightAnchor.constraint(equalToConstant: 60.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -70.scale : -30.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 269.scale),
            imageView.heightAnchor.constraint(equalToConstant: 582.scale),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 124.scale : 40.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlide4View {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.SFProRounded.bold(size: 27.scale))
            .lineHeight(32.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Slide4.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(title: String, tag: Int) -> OSlide4Cell {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selected(tapGesture:)))
        
        let view = OSlide4Cell()
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
            .textColor(UIColor.white)
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .lineHeight(23.scale)
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = UIColor(integralRed: 95, green: 70, blue: 245)
        view.layer.cornerRadius = 30.scale
        view.setAttributedTitle("Onboarding.Proceed".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        view.image = UIImage(named: "Onboarding.Slide4")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
