//
//  TestProgressView.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 28.03.2021.
//

import UIKit

class TestProgressView: UIView {
    
    private lazy var scoreTitle = makeTitleLabel(title: "Score")
    private lazy var progressTitle = makeTitleLabel(title: "Question")
    private lazy var scoreContent = makeContentLabel()
    private lazy var progressContent = makeContentLabel()
    private lazy var scoreContentView = makeBackgroundView()
    private lazy var progressContentView = makeBackgroundView()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension TestProgressView {
    func setProgress(progress: String) {
        progressContent.attributedText = progress.attributed(with: .contentAttr)
    }
    
    func setScore(score: String) {
        scoreContent.attributedText = score.attributed(with: .contentAttr)
    }
}

// MARK: Private
private extension TestProgressView {
    func initialize() {
        scoreContentView.addSubview(scoreContent)
        progressContentView.addSubview(progressContent)
        backgroundColor = UIColor(integralRed: 249, green: 205, blue: 106)
        layer.cornerRadius = 12.scale
    }
    
    static let contentAttr = TextAttributes()
        .font(Fonts.SFProRounded.bold(size: 18.scale))
        .lineHeight(25.2.scale)
        .textColor(UIColor(integralRed: 31, green: 31, blue: 31))
        .textAlignment(.center)
}

// MARK: Make constraints
private extension TestProgressView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scoreTitle.topAnchor.constraint(equalTo: topAnchor, constant: 12.scale),
            scoreTitle.leadingAnchor.constraint(equalTo: scoreContentView.leadingAnchor),
            scoreTitle.trailingAnchor.constraint(equalTo: scoreContentView.trailingAnchor),
            scoreTitle.bottomAnchor.constraint(equalTo: scoreContentView.topAnchor, constant: -4.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressTitle.topAnchor.constraint(equalTo: topAnchor, constant: 12.scale),
            progressTitle.leadingAnchor.constraint(equalTo: progressContentView.leadingAnchor),
            progressTitle.trailingAnchor.constraint(equalTo: progressContentView.trailingAnchor),
            progressTitle.bottomAnchor.constraint(equalTo: progressContentView.topAnchor, constant: -4.scale)
        ])
        
        NSLayoutConstraint.activate([
            scoreContentView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24.scale),
            scoreContentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.scale),
            scoreContentView.rightAnchor.constraint(equalTo: progressContentView.leftAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            scoreContent.leadingAnchor.constraint(equalTo: scoreContentView.leadingAnchor, constant: 16.scale),
            scoreContent.trailingAnchor.constraint(equalTo: scoreContentView.trailingAnchor, constant: -16.scale),
            scoreContent.topAnchor.constraint(equalTo: scoreContentView.topAnchor, constant: 10.scale),
            scoreContent.bottomAnchor.constraint(equalTo: scoreContentView.bottomAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressContentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.scale),
            progressContentView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressContent.leadingAnchor.constraint(equalTo: progressContentView.leadingAnchor, constant: 16.scale),
            progressContent.trailingAnchor.constraint(equalTo: progressContentView.trailingAnchor, constant: -16.scale),
            progressContent.topAnchor.constraint(equalTo: progressContentView.topAnchor, constant: 10.scale),
            progressContent.bottomAnchor.constraint(equalTo: progressContentView.bottomAnchor, constant: -10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TestProgressView {
    func makeBackgroundView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12.scale
        view.backgroundColor = .white
        addSubview(view)
        return view
    }
    
    func makeTitleLabel(title: String) -> UILabel {
        let view = UILabel()
        let attr = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 14.scale))
            .lineHeight(19.6.scale)
            .textColor(UIColor(integralRed: 31, green: 31, blue: 31))
            .textAlignment(.center)
        view.numberOfLines = 1
        view.attributedText = title.attributed(with: attr)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContentLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

private extension TextAttributes {
    static let contentAttr = TextAttributes()
        .font(Fonts.SFProRounded.bold(size: 18.scale))
        .lineHeight(25.2.scale)
        .textColor(UIColor(integralRed: 31, green: 31, blue: 31))
        .textAlignment(.center)
}
