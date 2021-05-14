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
    
    private lazy var states = [
        State(title: "ALABAMA", code: "AL"),
        State(title: "ALASKA", code: "AK"),
        State(title: "ARIZONA", code: "AZ"),
        State(title: "ARKANSAS", code: "AR"),
        State(title: "CALIFORNIA", code: "CA"),
        State(title: "COLORADO", code: "CO"),
        State(title: "CONNECTICUT", code: "CT"),
        State(title: "DELAWARE", code: "DE"),
        State(title: "DISTRICT OF COLUMBIA", code: "DC"),
        State(title: "FLORIDA", code: "FL"),
        State(title: "GEORGIA", code: "GA"),
        State(title: "HAWAII", code: "HI"),
        State(title: "IDAHO", code: "ID"),
        State(title: "ILLINOIS", code: "IL"),
        State(title: "INDIANA", code: "IN"),
        State(title: "IOWA", code: "IA"),
        State(title: "KANSAS", code: "KS"),
        State(title: "KENTUCKY", code: "KY"),
        State(title: "LOUISIANA", code: "LA"),
        State(title: "MAINE", code: "ME"),
        State(title: "MARYLAND", code: "MD"),
        State(title: "MASSACHUSETTS", code: "MA"),
        State(title: "MICHIGAN", code: "MI"),
        State(title: "MINNESOTA", code: "MN"),
        State(title: "MISSISSIPPI", code: "MS"),
        State(title: "MISSOURI", code: "MO"),
        State(title: "MONTANA", code: "MT"),
        State(title: "NEBRASKA", code: "NE"),
        State(title: "NEVADA", code: "NV"),
        State(title: "NEW HAMPSHIRE", code: "NH"),
        State(title: "NEW JERSEY", code: "NJ"),
        State(title: "NEW MEXICO", code: "NM"),
        State(title: "NEW YORK", code: "NY"),
        State(title: "NORTH CAROLINA", code: "NC"),
        State(title: "NORTH DAKOTA", code: "ND"),
        State(title: "OHIO", code: "OH"),
        State(title: "OKLAHOMA", code: "OK"),
        State(title: "OREGON", code: "OR"),
        State(title: "PENNSYLVANIA", code: "PA"),
        State(title: "RHODE ISLAND", code: "RI"),
        State(title: "SOUTH CAROLINA", code: "SC"),
        State(title: "SOUTH DAKOTA", code: "SD"),
        State(title: "TENNESSEE", code: "TN"),
        State(title: "TEXAS", code: "TX"),
        State(title: "UTAH", code: "UT"),
        State(title: "VERMONT", code: "VT"),
        State(title: "VIRGINIA", code: "VA"),
        State(title: "WASHINGTON", code: "WA"),
        State(title: "WEST VIRGINIA", code: "WV"),
        State(title: "WISCONSIN", code: "WI"),
        State(title: "WYOMING", code: "WY")
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
        states.count
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
            .textColor(Onboarding.pickerText)
            .font(Fonts.SFProRounded.bold(size: 24.scale))
        
        label?.attributedText = states[row].title.attributed(with: attrs)
        
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
                
                guard self.states.indices.contains(row) else {
                    return .never()
                }
                
                let state = self.states[row]
                
                return self.manager
                    .set(state: state.code)
                    .flatMap {
                        self.manager.saveSelected(state: state)
                    }
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
        guard let state = state else {
            return false
        }
        
        guard let index = states.firstIndex(where: { $0.title == state.title }) else {
            return false
        }
        
        pickerView.selectRow(index, inComponent: 0, animated: false)
        
        return true
    }
    
    func setupUS() {
        guard let us = states.firstIndex(where: { $0.title == "KANSAS" }) else {
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
            .textColor(Onboarding.primaryText)
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
            .textColor(Onboarding.primaryButtonTint)
            .font(Fonts.SFProRounded.semiBold(size: 18.scale))
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
