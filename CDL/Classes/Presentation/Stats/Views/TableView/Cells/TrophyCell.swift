//
//  TrophyCell.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 31.03.2021.
//

import UIKit

class TrophyCell: UITableViewCell {
    
    lazy var trophyView = makeTrophyView()
    
    var didTapButton: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TrophyCell {
    @objc func didTap() {
        didTapButton?()
    }
}

// MARK: Make constraints
private extension TrophyCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            trophyView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trophyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trophyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trophyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

// MARK: Lazy initialization
private extension TrophyCell {
    func makeTrophyView() -> TrophyView {
        let view = TrophyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
