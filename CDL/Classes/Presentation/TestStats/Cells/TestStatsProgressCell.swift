//
//  TestStatsProgressCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import UIKit

class TestStatsProgressCell: UITableViewCell {

    lazy var progressView = makeProgressView()
    lazy var percentLabel = makePercentLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TestStatsProgressCell {
    func setup(element: TestStatsProgressElement) {
        let progress = min(CGFloat(element.percent) / 100, 1)
        progressView.progress(progress: progress)
        percentLabel.text = "\(element.percent) %"
    }
}

// MARK: Private
private extension TestStatsProgressCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension TestStatsProgressCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25.scale),
            progressView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 150.scale),
            progressView.widthAnchor.constraint(equalTo: progressView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            percentLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            percentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TestStatsProgressCell {
    func makeProgressView() -> TestStatsProgressView {
        let view = TestStatsProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePercentLabel() -> UILabel {
        let view = UILabel()
        view.textAlignment = .center
        view.font = Fonts.SFProRounded.bold(size: 36.scale)
        view.textColor = UIColor(integralRed: 31, green: 31, blue: 31)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
