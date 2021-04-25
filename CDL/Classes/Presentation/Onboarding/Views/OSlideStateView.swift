//
//  OSlideStateView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 16.04.2021.
//

import UIKit
import RxSwift

final class OSlideStateView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var pickerView = makePickerView()
    lazy var cursorView = makeCursorView()
    lazy var button = makeButton()
    
    private lazy var manager = ProfileManagerCore()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var countries = [
        "Albania",
        "Algeria",
        "Angola",
        "Argentina",
        "Australia",
        "Austria",
        "Belgium",
        "Bolivia",
        "Brazil",
        "Bulgaria",
        "Cameroon",
        "Canada",
        "Chile",
        "China",
        "Colombia",
        "Cuba",
        "Czech Republic",
        "Democratic Republic of the Congo",
        "Denmark",
        "Dominican Republic",
        "Ecuador",
        "Egypt",
        "Estonia",
        "Ethiopia",
        "Finland",
        "France",
        "Germany",
        "Ghana",
        "Greece",
        "Guatemala",
        "Haitti",
        "Hungary",
        "India",
        "Iraq",
        "Ireland",
        "Israel",
        "Italy",
        "Ivory Coast",
        "Japan",
        "Jordan",
        "Kenya",
        "Latvia",
        "Lebanon",
        "Lithuania",
        "Luxembourg",
        "Madagascar",
        "Mexico",
        "Morocco",
        "Mozambique",
        "Netherlands",
        "New Zeland",
        "Nigeria",
        "Norway",
        "Peru",
        "Poland",
        "Portugal",
        "Romania",
        "Saudi Arabia",
        "Somalia",
        "South Africa",
        "Spain",
        "Sudan",
        "Sweden",
        "Switzerland",
        "Syria",
        "Tanzania",
        "Tunisia",
        "Turkey",
        "U.S.S.R. (Former)",
        "Uganda",
        "United Arab Emirates",
        "United Kingdom",
        "United States",
        "Venezuela",
        "Yemen",
        "Yugoslavia (Former)",
        "Other Europe",
        "Other Asia",
        "Other South America",
        "Other Africa"
    ]
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UIPickerViewDataSource
extension OSlideStateView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        countries.count
    }
}

// MARK: UIPickerViewDelegate
extension OSlideStateView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as? UILabel
        
        if label == nil {
            label = UILabel()
            label?.backgroundColor = UIColor.clear
        }
        
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 245, green: 245, blue: 245))
            .font(Fonts.SFProRounded.bold(size: 24.scale))
        
        label?.attributedText = countries[row].attributed(with: attrs)
        
        label?.sizeToFit()
        
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        40.scale
    }
}

// MARK: Private
private extension OSlideStateView {
    func initialize() {
        pickerView.reloadAllComponents()
        
        nextAction()
        setupInitialValue()
    }
    
    func nextAction() {
        button.rx.tap
            .flatMapLatest { [weak self] _ -> Single<Void> in
                guard let self = self else {
                    return .never()
                }
                
                let row = self.pickerView.selectedRow(inComponent: 0)
                
                guard self.countries.indices.contains(row) else {
                    return .never()
                }
                
                let name = self.countries[row]
                let state = State(name: name)
                
                return self.manager.saveSelected(state: state)
            }
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] in
                self?.onNext()
            })
            .disposed(by: disposeBag)
    }
    
    func setupInitialValue() {
        manager.obtainSelectedState()
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] state in
                guard let self = self else {
                    return
                }
                
                if !self.setupState(state) {
                    self.setupUS()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setupState(_ state: State?) -> Bool {
        guard let name = state?.name else {
            return false
        }
        
        guard let index = countries.firstIndex(of: name) else {
            return false
        }
        
        pickerView.selectRow(index, inComponent: 0, animated: false)
        
        return true
    }
    
    func setupUS() {
        guard let us = countries.firstIndex(of: "United States") else {
            return
        }
        
        pickerView.selectRow(us, inComponent: 0, animated: false)
    }
}

// MARK: Make constraints
private extension OSlideStateView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: pickerView.topAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pickerView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24.scale),
            pickerView.widthAnchor.constraint(equalToConstant: 375.scale),
            pickerView.heightAnchor.constraint(equalToConstant: 417.scale)
        ])
        
        NSLayoutConstraint.activate([
            cursorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            cursorView.widthAnchor.constraint(equalToConstant: 24.scale),
            cursorView.heightAnchor.constraint(equalToConstant: 24.scale),
            cursorView.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor)
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
private extension OSlideStateView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 245, green: 245, blue: 245))
            .font(Fonts.SFProRounded.bold(size: 36.scale))
            .lineHeight(43.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.SlideState.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePickerView() -> UIPickerView {
        let view = PaddingPickerView()
        view.padding = UIEdgeInsets(top: 0, left: 200.scale, bottom: 0, right: 200.scale)
        view.backgroundColor = UIColor.clear
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCursorView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Cursor")
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
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
