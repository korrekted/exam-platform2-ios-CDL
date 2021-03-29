//
//  TestComunityResultLineView.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 29.03.2021.
//

import UIKit

class TestComunityResultLineView: UIView {
    private lazy var valueLabel = makeValueLabel()
    private lazy var subtitleLabel = makeSubtitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension TestComunityResultLineView {
    func setup(name: String, value: String) {
        subtitleLabel.attributedText = name.attributed(with: .subtitleAttr)
        valueLabel.attributedText = value.attributed(with: .valueAttr)
    }
}

// MARK: Make constraints
private extension TestComunityResultLineView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: 4.scale)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TestComunityResultLineView {
    func makeValueLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.font = Fonts.SFProRounded.bold(size: 24)
        view.textAlignment = .center
        view.textColor = UIColor(integralRed: 31, green: 31, blue: 31)
        addSubview(view)
        return view
    }
    
    func makeSubtitleLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 2
        view.font = Fonts.SFProRounded.regular(size: 14)
        view.textAlignment = .center
        view.textColor = UIColor(integralRed: 31, green: 31, blue: 31)
        addSubview(view)
        return view
    }
}


// MARK: Private
private extension TextAttributes {
    static let valueAttr = TextAttributes()
        .font(Fonts.SFProRounded.bold(size: 24.scale))
        .textColor(UIColor(integralRed: 31, green: 31, blue: 31))
        .textAlignment(.center)
        .lineHeight(28.8.scale)
    
    static let subtitleAttr = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 14.scale))
        .textColor(UIColor(integralRed: 31, green: 31, blue: 31))
        .textAlignment(.center)
        .lineHeight(19.6.scale)
}
