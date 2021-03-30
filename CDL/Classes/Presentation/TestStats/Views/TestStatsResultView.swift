//
//  TestStatsResultView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import UIKit

class TestStatsResultView: UIView {
        
    private lazy var stackView = makeStackView()
    private lazy var attemptedLineView = makeLineView()
    private lazy var correctLineView = makeLineView()
    private lazy var incorrectLineView = makeLineView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TestStatsResultView {
    func setup(element: TestStatsDescriptionElement) {
        attemptedLineView.setup(title: "TestStats.Attempted".localized, value: element.userTime)
        correctLineView.setup(title: "TestStats.Correct".localized, value: element.communityTime)
        incorrectLineView.setup(title: "TestStats.Incorrect".localized, value: "\(element.communityScore) %")
    }
}

// MARK: Private
private extension TestStatsResultView {
    func configure() {
        layer.cornerRadius = 12.scale
        [attemptedLineView, makeSeparatorView(), correctLineView, makeSeparatorView(), incorrectLineView].forEach(stackView.addArrangedSubview)
    }
}

// MARK: Make constraints
private extension TestStatsResultView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.scale),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TestStatsResultView {
    func makeLineView() -> MainStatsDescriptionLineView {
        let view = MainStatsDescriptionLineView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 68, green: 68, blue: 68, alpha: 0.05)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1.scale).isActive = true
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
