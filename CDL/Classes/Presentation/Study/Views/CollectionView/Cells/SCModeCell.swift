//
//  SCModeCell.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 31.01.2021.
//

import UIKit

final class SCModeCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    private lazy var stackView = makeStackView()
    private lazy var tryNow = makePaddingLabel()
    private lazy var iconContainer = makeImageContainer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension SCModeCell {
    func setup(mode: SCEMode) {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        if mode.mode == .today {
            stackView.addArrangedSubview(tryNow)
        }
        
        stackView.addArrangedSubview(label)
        
        imageView.image = UIImage(named: mode.image)
        
        label.attributedText = mode.title.attributed(with: .nameAttrs)
    }
}

// MARK: Private
private extension SCModeCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension SCModeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale),
            stackView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16.scale),
            stackView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            iconContainer.heightAnchor.constraint(equalToConstant: 32.scale),
            iconContainer.widthAnchor.constraint(equalTo: iconContainer.heightAnchor),
            iconContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.scale),
            iconContainer.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24.scale),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SCModeCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 12.scale
        view.backgroundColor = UIColor(integralRed: 232, green: 234, blue: 237)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor(integralRed: 245, green: 245, blue: 245)
        view.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }
    
    func makePaddingLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.topInset = 4.scale
        view.bottomInset = 4.scale
        view.textAlignment = .center
        view.layer.cornerRadius = 7.scale
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(integralRed: 249, green: 205, blue: 106)
        view.font = Fonts.SFProRounded.bold(size: 10.scale)
        view.textColor = UIColor(integralRed: 31, green: 31, blue: 31)
        view.text = "TRY ME!"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 77.scale).isActive = true
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 8.scale
        container.addSubview(view)
        return view
    }
    
    func makeImageContainer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 7.scale
        view.backgroundColor = UIColor(integralRed: 60, green: 75, blue: 159)
        view.clipsToBounds = true
        contentView.addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let nameAttrs = TextAttributes()
        .textColor(UIColor.black)
        .font(Fonts.SFProRounded.semiBold(size: 18.scale))
        .lineHeight(25.scale)
}
