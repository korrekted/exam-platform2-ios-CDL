//
//  TestView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//
import UIKit

final class TestView: UIView {
    lazy var bottomButton = makeBottomButton()
    lazy var nextButton = makeNextButton()
    lazy var tableView = makeTableView()
    lazy var gradientView = makeGradientView()
    lazy var navigationView = makeNavigationView()
    lazy var counter = makeCounterView()
    
    private var navigationHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Public
extension TestView {
    func setupBottomButton(for state: TestBottomButtonState) {
        switch state {
        case .confirm:
            bottomButton.setAttributedTitle("Question.Continue".localized.attributed(with: Self.buttonAttr), for: .normal)
        case .submit:
            bottomButton.setAttributedTitle("Question.Submit".localized.attributed(with: Self.buttonAttr), for: .normal)
        case .back:
            bottomButton.setAttributedTitle("Question.BackToStudying".localized.attributed(with: Self.buttonAttr), for: .normal)
        case .hidden:
            break
        }
        
        [bottomButton, gradientView].forEach {
            $0.isHidden = state == .hidden
        }
    }
    
    func test(isOne: Bool) {
        if !isOne {
            addSubview(counter)
            NSLayoutConstraint.activate([
                counter.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.scale),
                counter.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 36)
            ])
            
            tableView.contentInset = UIEdgeInsets(
                top: 35.scale,
                left: tableView.contentInset.left,
                bottom: tableView.contentInset.bottom,
                right: tableView.contentInset.right
            )
            
            navigationHeightConstraint?.constant = 167.scale
            navigationView.setNeedsDisplay()
        }
    }
}

// MARK: Private
private extension TestView {
    func initialize() {
        backgroundColor = .white
    }
    
    static let buttonAttr = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 18.scale))
        .textColor(UIColor(integralRed: 31, green: 31, blue: 31))
        .textAlignment(.center)
}

// MARK: Make constraints
private extension TestView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
        ])
        
        navigationHeightConstraint = navigationView.heightAnchor.constraint(equalToConstant: 125.scale)
        navigationHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.heightAnchor.constraint(equalToConstant: 177.scale),
            gradientView.leftAnchor.constraint(equalTo: leftAnchor),
            gradientView.rightAnchor.constraint(equalTo: rightAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomButton.heightAnchor.constraint(equalToConstant: 53.scale),
            bottomButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            bottomButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            bottomButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -59.scale)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: 40.scale),
            nextButton.widthAnchor.constraint(equalTo: nextButton.heightAnchor),
            nextButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.scale),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -59.scale)
        ])
        
    }
}

// MARK: Lazy initialization
private extension TestView {
    func makeTableView() -> QuestionTableView {
        let view = QuestionTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.contentInsetAdjustmentBehavior = .never
        addSubview(view)
        return view
    }
    
    func makeBottomButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12.scale
        view.backgroundColor = UIColor(integralRed: 249, green: 205, blue: 106)
        addSubview(view)
        return view
    }
    
    func makeNextButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Question.Next"), for: .normal)
        view.tintColor = .white
        view.backgroundColor = UIColor(integralRed: 41, green: 55, blue: 137)
        view.layer.cornerRadius = 7.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeGradientView() -> UIView {
        let view = UIView()
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor(integralRed: 241, green: 244, blue: 251).cgColor]
        gradientLayer.locations = [0, 0.65]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 195.scale))
        
        view.layer.mask = gradientLayer
        view.isUserInteractionEnabled = false
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNavigationView() -> NavigationBar {
        let view = NavigationBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(integralRed: 41, green: 55, blue: 137)
        view.leftAction.setImage(UIImage(named: "General.Pop"), for: .normal)
        view.leftAction.tintColor = UIColor(integralRed: 245, green: 245, blue: 245)
        view.rightAction.setImage(UIImage(named: "Question.Bookmark.Uncheck"), for: .normal)
        view.rightAction.tintColor = UIColor(integralRed: 245, green: 245, blue: 245)
        addSubview(view)
        return view
    }
    
    func makeCounterView() -> TestProgressView {
        let view = TestProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
