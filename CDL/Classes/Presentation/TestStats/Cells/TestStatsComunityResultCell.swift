//
//  TestStatsComunityResultCell.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 29.03.2021.
//

import UIKit

class TestStatsComunityResultCell: UITableViewCell {
    
    private lazy var timeView = makeComunityLineView()
    private lazy var averageView = makeComunityLineView()
    private lazy var scoreView = makeComunityLineView()
    private lazy var firstSeparator = makeSeparatorView()
    private lazy var secondSeparator = makeSeparatorView()
    private lazy var containerView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(element: TestStatsComunityResult) {
        timeView.setup(name: "TestStats.TestTime".localized, value: element.userTime)
        averageView.setup(name: "TestStats.ComunityAverage".localized, value: element.communityAverage)
        scoreView.setup(name: "TestStats.ComunityScore".localized, value: element.communityScore)
    }
}

// MARK: Private
private extension TestStatsComunityResultCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: Make constraints
private extension TestStatsComunityResultCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24.scale),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timeView.topAnchor.constraint(equalTo: containerView.topAnchor),
            timeView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            timeView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            timeView.trailingAnchor.constraint(equalTo: firstSeparator.leadingAnchor, constant: -24.scale),
            timeView.widthAnchor.constraint(equalToConstant: 65.scale)
        ])
        
        NSLayoutConstraint.activate([
            firstSeparator.topAnchor.constraint(equalTo: containerView.topAnchor),
            firstSeparator.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            firstSeparator.widthAnchor.constraint(equalToConstant: 1.scale)
        ])
        
        NSLayoutConstraint.activate([
            averageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            averageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            averageView.leadingAnchor.constraint(equalTo: firstSeparator.trailingAnchor, constant: 24.scale),
            averageView.trailingAnchor.constraint(equalTo: secondSeparator.leadingAnchor, constant: -24.scale),
            averageView.widthAnchor.constraint(equalToConstant: 65.scale)
        ])
        
        NSLayoutConstraint.activate([
            secondSeparator.topAnchor.constraint(equalTo: containerView.topAnchor),
            secondSeparator.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            secondSeparator.widthAnchor.constraint(equalToConstant: 1.scale)
        ])
        
        NSLayoutConstraint.activate([
            scoreView.topAnchor.constraint(equalTo: containerView.topAnchor),
            scoreView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            scoreView.leadingAnchor.constraint(equalTo: secondSeparator.trailingAnchor, constant: 24.scale),
            scoreView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            scoreView.widthAnchor.constraint(equalToConstant: 65.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TestStatsComunityResultCell {
    func makeSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 68, green: 68, blue: 68, alpha: 0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeComunityLineView() -> TestComunityResultLineView {
        let view = TestComunityResultLineView()
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
}
