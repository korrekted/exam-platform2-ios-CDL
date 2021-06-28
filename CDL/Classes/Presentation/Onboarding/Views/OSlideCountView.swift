//
//  OSlide8View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit
import RxSwift

final class OSlideCountView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var choiseContainer = makeChoiseContainer()
    lazy var choiseIconView = makeChoiseIconView()
    lazy var choiseLabel = makeChoiseLabel()
    lazy var largeCircleView = makeLargeCirleView()
    lazy var smallCircleView = makeSmallCirleView()
    lazy var learningSpeedLabel = makeLearninSpeedLabel()
    lazy var slider = makeSlider()
    lazy var button = makeButton()
    
    private lazy var valueLabel = makeValueLabel()
    
    private lazy var manager = ProfileManagerCore()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        update(sender: slider)
    }
}

// MARK: Private
private extension OSlideCountView {
    func initialize() {
        button.rx.tap
            .flatMapLatest { [weak self] _ -> Single<Bool> in
                guard let self = self else {
                    return .never()
                }

                let count = Int(self.slider.value)
                
                return self.manager
                    .set(testNumber: count)
                    .map { true }
                    .catchAndReturn(false)
            }
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] success in
                guard success else {
                    Toast.notify(with: "Onboarding.FailedToSave".localized, style: .danger)
                    return
                }

                self?.onNext()
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func update(sender: UISlider) {
        sender.value = round(sender.value)
        
        valueLabel.text = sender.value >= 7 ? "7+" : String(Int(sender.value))
        valueLabel.sizeToFit()
        
        let trackRect = sender.trackRect(forBounds: sender.frame)
        let thumbRect = sender.thumbRect(forBounds: sender.bounds, trackRect: trackRect, value: roundf(sender.value))
        valueLabel.center = CGPoint(x: thumbRect.midX, y: sender.frame.minY - valueLabel.frame.height)
        
        largeCircleView.value = Int(sender.value)
        smallCircleView.value = Int(sender.value)
        
        let speed = (sender.value + 3) / 10
        learningSpeedLabel.attributedText = String(format: "Onboarding.SlideCount.LearningSpeed".localized, speed)
            .attributed(with: TextAttributes()
                            .textColor(UIColor.white)
                            .font(Fonts.Lato.bold(size: 18.scale))
                            .lineHeight(21.6.scale))
    }
}

// MARK: Make constraints
private extension OSlideCountView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 137.scale : 80.scale)
        ])
        
        NSLayoutConstraint.activate([
            choiseContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            choiseContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            choiseContainer.heightAnchor.constraint(equalToConstant: 46.scale),
            choiseContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            choiseIconView.leadingAnchor.constraint(equalTo: choiseContainer.leadingAnchor, constant: 76.scale),
            choiseIconView.widthAnchor.constraint(equalToConstant: 17.29.scale),
            choiseIconView.heightAnchor.constraint(equalToConstant: 22.scale),
            choiseIconView.centerYAnchor.constraint(equalTo: choiseContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            choiseLabel.leadingAnchor.constraint(equalTo: choiseIconView.trailingAnchor, constant: 8.29.scale),
            choiseLabel.centerYAnchor.constraint(equalTo: choiseContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            largeCircleView.widthAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 183.scale : 153.scale),
            largeCircleView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 183.scale : 153.scale),
            largeCircleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            largeCircleView.topAnchor.constraint(equalTo: choiseContainer.bottomAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            smallCircleView.widthAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 135.scale : 105.scale),
            smallCircleView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 135.scale : 105.scale),
            smallCircleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            smallCircleView.topAnchor.constraint(equalTo: choiseContainer.bottomAnchor, constant: 54.scale)
        ])
        
        NSLayoutConstraint.activate([
            learningSpeedLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 224.scale),
            learningSpeedLabel.topAnchor.constraint(equalTo: smallCircleView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            slider.bottomAnchor.constraint(equalTo: button.topAnchor, constant: ScreenSize.isIphoneXFamily ? -56.scale : -25.scale)
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
private extension OSlideCountView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryText)
            .font(Fonts.Lato.bold(size: 36.scale))
            .lineHeight(43.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.SlideCount.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeChoiseContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 60, green: 75, blue: 159)
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeChoiseIconView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Onboarding.SlideCount.PopularChoise")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        choiseContainer.addSubview(view)
        return view
    }
    
    func makeChoiseLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 245, green: 245, blue: 245))
            .font(Fonts.Lato.bold(size: 16.scale))
            .lineHeight(22.4.scale)
        
        let view = UILabel()
        view.attributedText = "Onboarding.SlideCount.PopularChoise".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        choiseContainer.addSubview(view)
        return view
    }
    
    func makeLargeCirleView() -> CountCircleView {
        let view = CountCircleView()
        view.value = 1
        view.pieBackgroundColor = UIColor(integralRed: 60, green: 75, blue: 159)
        view.pieFilledColor = UIColor(integralRed: 249, green: 205, blue: 106)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSmallCirleView() -> CountCircleView {
        let view = CountCircleView()
        view.value = 1
        view.pieBackgroundColor = UIColor(integralRed: 81, green: 97, blue: 189)
        view.pieFilledColor = UIColor(integralRed: 251, green: 222, blue: 157)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLearninSpeedLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.leftInset = 12.scale
        view.rightInset = 12.scale
        view.topInset = 10.scale
        view.bottomInset = 10.scale
        view.backgroundColor = UIColor(integralRed: 60, green: 75, blue: 159)
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeValueLabel() -> UILabel {
        let view = UILabel()
        view.textColor = Onboarding.primaryText
        view.font = Fonts.Lato.bold(size: 32.scale)
        addSubview(view)
        return view
    }
    
    func makeSlider() -> OSlider {
        let view = OSlider()
        view.minimumValue = 1
        view.maximumValue = 7
        view.minimumTrackTintColor = Onboarding.Slider.minimumTrackTint
        view.maximumTrackTintColor = Onboarding.Slider.maximumTrackTint
        view.addTarget(self, action: #selector(update(sender:)), for: .valueChanged)
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
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
