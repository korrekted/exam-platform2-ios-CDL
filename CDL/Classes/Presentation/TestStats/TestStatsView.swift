//
//  TestStatsView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 11.02.2021.
//

import UIKit

class TestStatsView: UIView {
    lazy var tableView = makeTableView()
    lazy var titleLabel = makeTitleLabel()
    lazy var navigationView = makeNavigationView()
    lazy var nextTestButton = makeBottomButton()
    lazy var tryAgainButton = makeBottomButton()
    private lazy var stackView = makeStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: Public
extension TestStatsView {
    func configureAddingButtons(isNextEnabled: Bool) {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        let attr = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 18.scale))
            .textColor(UIColor(integralRed: 31, green: 31, blue: 31))
            .textAlignment(.center)
        
        
        tryAgainButton.setAttributedTitle("TestStats.TryAgain".localized.attributed(with: attr), for: .normal)
        nextTestButton.setAttributedTitle("TestStats.NextTest".localized.attributed(with: attr), for: .normal)
        
        tryAgainButton.backgroundColor = UIColor(integralRed: 232, green: 234, blue: 237)
        nextTestButton.backgroundColor = UIColor(integralRed: 249, green: 205, blue: 106)
        
        stackView.addArrangedSubview(tryAgainButton)
        stackView.addArrangedSubview(nextTestButton)
        
        nextTestButton.isHidden = !isNextEnabled
        
        let bottomOffset = ScreenSize.isIphoneXFamily ? 170.scale : 140.scale
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomOffset, right: 0)
    }
}

// MARK: Private
private extension TestStatsView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 242, green: 245, blue: 252)
    }
}

// MARK: Make constraints
private extension TestStatsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: 125.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -20.scale),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TestStatsView {
    func makeTableView() -> TestStatsTableView {
        let view = TestStatsTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.separatorStyle = .none
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "Question.Close"), for: .normal)
        view.tintColor = .black
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Fonts.SFProRounded.regular(size: 20.scale)
        view.textAlignment = .center
        view.textColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNavigationView() -> NavigationBar {
        let view = NavigationBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(integralRed: 41, green: 55, blue: 137)
        view.rightAction.setImage(UIImage(named: "General.Close"), for: .normal)
        view.rightAction.tintColor = UIColor(integralRed: 245, green: 245, blue: 245)
        addSubview(view)
        return view
    }
    
    func makeBottomButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12.scale
        view.heightAnchor.constraint(equalToConstant: 53.scale).isActive = true
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 8.scale
        addSubview(view)
        return view
    }
}
