//
//  CourseDetailsTestCell.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 24.04.2021.
//

import UIKit

class CourseDetailsTestCell: UITableViewCell {
    
    private lazy var container = makeContainer()
    private lazy var progressContainer = makeProgressContainer()
    private lazy var numberLabel = makeNumberLabel()
    private lazy var questionsCountLabel = makeQuestionsLabel()
    private lazy var progressView = makeProgressView()
    private lazy var iconView = makeImageView()
    let gradientLayer = CAGradientLayer()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = progressView.frame
    }
}

extension CourseDetailsTestCell {
    func setup(config: CourseDetailsTestConfig) {
        numberLabel.attributedText = config.number.attributed(with: .numberAttrs)
        questionsCountLabel.attributedText = "\(config.questionCounts) \("CourseDetails.Questions".localized)".attributed(with: .questionCountAttrs)
        progressView.setGradientLocation(correctPercent: config.correctProgress, incorrectPercent: config.incorrectProgress)
    }
}

private extension CourseDetailsTestCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

private extension CourseDetailsTestCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: container.topAnchor),
            numberLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            numberLabel.widthAnchor.constraint(equalToConstant: 81.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressContainer.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 24.scale),
            progressContainer.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -18.scale),
            progressContainer.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            questionsCountLabel.topAnchor.constraint(equalTo: progressContainer.topAnchor),
            questionsCountLabel.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor),
            questionsCountLabel.trailingAnchor.constraint(equalTo: progressContainer.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: questionsCountLabel.bottomAnchor, constant: 9.scale),
            progressView.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: progressContainer.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 8.scale),
            progressView.bottomAnchor.constraint(equalTo: progressContainer.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 32.scale),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12.scale)
        ])
    }
}

private extension CourseDetailsTestCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12.scale
        view.backgroundColor = UIColor(integralRed: 232, green: 234, blue: 237)
        contentView.addSubview(view)
        return view
    }
    
    func makeNumberLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeQuestionsLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        progressContainer.addSubview(view)
        return view
    }
    
    func makeProgressContainer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        container.addSubview(view)
        return view
    }
    
    func makeProgressView() -> GradientProgressView {
        let view = GradientProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4.scale
        view.backgroundColor = UIColor(integralRed: 212, green: 216, blue: 221)
        progressContainer.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4.scale
        view.image = UIImage(named: "CourseDetails.ArrowForward")
        view.contentMode = .center
        view.tintColor = UIColor(integralRed: 245, green: 245, blue: 245)
        view.backgroundColor = UIColor(integralRed: 41, green: 55, blue: 137)
        container.addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let numberAttrs = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 64.scale))
        .textColor(UIColor(integralRed: 212, green: 216, blue: 221))
    
    static let questionCountAttrs = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 14.scale))
        .textColor(UIColor(integralRed: 68, green: 68, blue: 68))
}
