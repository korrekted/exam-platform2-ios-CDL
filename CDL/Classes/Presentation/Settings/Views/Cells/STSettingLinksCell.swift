//
//  STSettingLinksCell.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 16.04.2021.
//

import UIKit

final class STSettingLinksCell: UITableViewCell {
    var tapped: ((SettingsTableView.Tapped) -> Void)?
    
    lazy var changeStateView = makeChangeStateView()
    lazy var changeLanguageView = makeChangeLanguageView()
    lazy var changeTopicsView = makeChangeTopicsView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension STSettingLinksCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
    }
    
    @objc
    func didTap(sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else {
            return
        }
        
        switch tag {
        case 1:
            tapped?(.state)
        case 2:
            tapped?(.language)
        case 3:
            tapped?(.topic)
        default:
            break
        }
    }
}

// MARK: Make constraints
private extension STSettingLinksCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            changeStateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            changeStateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            changeStateView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            changeLanguageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            changeLanguageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            changeLanguageView.topAnchor.constraint(equalTo: changeStateView.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            changeTopicsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            changeTopicsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            changeTopicsView.topAnchor.constraint(equalTo: changeLanguageView.bottomAnchor, constant: 10.scale),
            changeTopicsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension STSettingLinksCell {
    func makeChangeStateView() -> STLinkView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        let view = STLinkView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.tag = 1
        view.label.attributedText = "Settings.State".localized.attributed(with: .attr)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeChangeLanguageView() -> STLinkView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        let view = STLinkView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.tag = 2
        view.label.attributedText = "Settings.Language".localized.attributed(with: .attr)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeChangeTopicsView() -> STLinkView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        let view = STLinkView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.tag = 3
        view.label.attributedText = "Settings.Topics".localized.attributed(with: .attr)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let attr = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 18.scale))
        .lineHeight(25.scale)
        .textColor(SettingsPalette.itemTitle)
}
