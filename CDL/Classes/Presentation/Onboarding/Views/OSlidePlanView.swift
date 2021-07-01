//
//  OSlide15View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit
import Lottie

final class OSlidePlanView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var chartView = makeChartView()
    lazy var planTitleLabel = makePlanTitleLabel()
    lazy var scrollView = makeScrollView()
    lazy var cell1 = makeCell(title: "Onboarding.SlidePlan.Cell1.Title",
                              subtitle: "Onboarding.SlidePlan.Cell1.Subtitle",
                              image: "Onboarding.SlidePlan.Cell1")
    lazy var cell2 = makeCell(title: "Onboarding.SlidePlan.Cell2.Title",
                              subtitle: "Onboarding.SlidePlan.Cell2.Subtitle",
                              image: "Onboarding.SlidePlan.Cell2")
    lazy var cell3 = makeCell(title: "Onboarding.SlidePlan.Cell3.Title",
                              subtitle: "Onboarding.SlidePlan.Cell3.Subtitle",
                              image: "Onboarding.SlidePlan.Cell3")
    lazy var cell4 = makeCell(title: "Onboarding.SlidePlan.Cell4.Title",
                              subtitle: "Onboarding.SlidePlan.Cell4.Subtitle",
                              image: "Onboarding.SlidePlan.Cell4")
    lazy var button = makeButton()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        chartView.play()
    }
}

// MARK: Make constraints
private extension OSlidePlanView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 84.scale : 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            chartView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 222.scale : 150.scale),
            chartView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 276.scale : 234.scale)
        ])
        
        NSLayoutConstraint.activate([
            planTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            planTitleLabel.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 99.scale),
            scrollView.topAnchor.constraint(equalTo: planTitleLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            cell1.topAnchor.constraint(equalTo: scrollView.topAnchor),
            cell1.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            cell1.heightAnchor.constraint(equalToConstant: 99.scale),
            cell1.widthAnchor.constraint(equalToConstant: 310.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: cell1.trailingAnchor, constant: 12.scale),
            cell2.topAnchor.constraint(equalTo: scrollView.topAnchor),
            cell2.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            cell2.heightAnchor.constraint(equalToConstant: 99.scale),
            cell2.widthAnchor.constraint(equalToConstant: 284.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: cell2.trailingAnchor, constant: 12.scale),
            cell3.topAnchor.constraint(equalTo: scrollView.topAnchor),
            cell3.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            cell3.heightAnchor.constraint(equalToConstant: 99.scale),
            cell3.widthAnchor.constraint(equalToConstant: 349.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell4.leadingAnchor.constraint(equalTo: cell3.trailingAnchor, constant: 12.scale),
            cell4.topAnchor.constraint(equalTo: scrollView.topAnchor),
            cell4.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            cell4.heightAnchor.constraint(equalToConstant: 99.scale),
            cell4.widthAnchor.constraint(equalToConstant: 349.scale),
            cell4.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            button.heightAnchor.constraint(equalToConstant: 60.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlidePlanView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryText)
            .font(Fonts.Lato.bold(size: 32.scale))
            .lineHeight(38.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.SlidePlan.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeChartView() -> AnimationView {
        let view = AnimationView()
        view.animation = Animation.named("Onboarding.Chart")
        view.contentMode = .scaleAspectFit
        view.loopMode = .playOnce
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePlanTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 245, green: 245, blue: 245))
            .font(Fonts.Lato.bold(size: 18.scale))
            .lineHeight(25.2.scale)
        
        let view = UILabel()
        view.attributedText = "Onboarding.SlidePlan.CellsTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(title: String, subtitle: String, image: String) -> OSlidePlanCell {
        let view = OSlidePlanCell()
        view.title = title.localized
        view.subtitle = subtitle.localized
        view.imageView.image = UIImage(named: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
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
        view.setAttributedTitle("Onboarding.SlidePlan.Button".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
