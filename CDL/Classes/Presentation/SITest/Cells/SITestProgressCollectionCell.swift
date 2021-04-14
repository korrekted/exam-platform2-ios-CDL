//
//  SITestProgressCollectionCell.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 08.04.2021.
//

import UIKit

class SITestProgressCollectionCell: UICollectionViewCell {
    
    private lazy var label = makeLabel()
    
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
extension SITestProgressCollectionCell {
    func setup(element: SIProgressElement) {
        var attr: TextAttributes = .attr
        
        if element.isSelected {
            attr = attr.textColor(UIColor(integralRed: 232, green: 234, blue: 237))
            backgroundColor = UIColor(integralRed: 41, green: 55, blue: 137)
        } else {
            attr = attr.textColor(UIColor(integralRed: 31, green: 31, blue: 31))
            backgroundColor = UIColor(integralRed: 232, green: 234, blue: 237)
        }
        
        label.attributedText = "\(element.index)".attributed(with: attr)
    }
}

// MARK: Private
private extension SITestProgressCollectionCell {
    func initialize() {
        layer.cornerRadius = 4.scale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension SITestProgressCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SITestProgressCollectionCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        contentView.addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let attr = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 18.scale))
        .lineHeight(25.scale)
        .textAlignment(.center)
}
