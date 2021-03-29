//
//  AnswerView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//
import UIKit
import RxCocoa

final class AnswerView: UIView {
    private lazy var answerLabel = makeAnswerLabel()
    private lazy var imageView = makeImageView()
    private let tapGesture = UITapGestureRecognizer()
    private var labelBottomConstraint: NSLayoutConstraint?
    
    var state: State = .initial {
        didSet {
            setState(state: state)
        }
    }
        
    private override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension AnswerView {
    enum State {
        case initial, correct, error, warning, selected
    }
    
    func setAnswer(answer: String, image: URL?) {
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .lineHeight(20.scale)
        
        if let imageUrl = image {
            do {
                try imageView.image = UIImage(data: Data(contentsOf: imageUrl))
                needUpdateConstraints()
            } catch {
                
            }
        }
        
        answerLabel.attributedText = answer.attributed(with: attrs)
    }
    
    var didTap: Signal<Void> {
        tapGesture.rx.event
            .map { _ in () }
            .asSignal(onErrorSignalWith: .empty())
    }
}

// MARK: Private
private extension AnswerView {
    func initialize() {
        layer.cornerRadius = 12.scale
        addGestureRecognizer(tapGesture)
        state = .initial
    }
    
    func setState(state: State) {
        switch state {
        case .initial:
            layer.borderColor = UIColor(integralRed: 232, green: 234, blue: 237).cgColor
            backgroundColor = .white
            answerLabel.textColor = Self.blackTextColor
            layer.borderWidth = 2.scale
        case .selected:
            layer.borderColor = UIColor(integralRed: 41, green: 55, blue: 137).cgColor
            backgroundColor = .white
            answerLabel.textColor = Self.blackTextColor
            layer.borderWidth = 2.scale
        case .correct:
            backgroundColor = UIColor(integralRed: 143, green: 207, blue: 99)
            answerLabel.textColor = Self.whiteTextColor
            layer.borderWidth = 0
        case .error:
            backgroundColor = UIColor(integralRed: 241, green: 104, blue: 91)
            answerLabel.textColor = Self.whiteTextColor
            layer.borderWidth = 0
        case .warning:
            let warningColor = UIColor(integralRed: 143, green: 207, blue: 99)
            backgroundColor = warningColor.withAlphaComponent(0.2)
            answerLabel.textColor = Self.blackTextColor
            layer.borderWidth = 2.scale
            layer.borderColor = warningColor.cgColor
        }
    }
    
    static let blackTextColor = UIColor(integralRed: 31, green: 31, blue: 31)
    static let whiteTextColor = UIColor(integralRed: 245, green: 245, blue: 245)
}

// MARK: Make constraints
private extension AnswerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            answerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            answerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            answerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale)
        ])
        
        labelBottomConstraint = answerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale)
        labelBottomConstraint?.isActive = true
    }
    
    func needUpdateConstraints() {
        labelBottomConstraint?.isActive = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 124.scale),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15.scale),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44.scale),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44.scale)
        ])
        
        labelBottomConstraint = imageView.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 10.scale)
        labelBottomConstraint?.isActive = true
    }
}

// MARK: Lazy initialization
private extension AnswerView {
    func makeAnswerLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
