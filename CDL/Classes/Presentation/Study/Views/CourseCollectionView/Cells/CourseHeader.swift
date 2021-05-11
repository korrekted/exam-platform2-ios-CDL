//
//  CourseHeader.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 13.04.2021.
//

import UIKit

class CourseHeader: UICollectionReusableView {
    
    private lazy var imageView = makeImageView()
    private lazy var container = makeContainerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CourseHeader {
    func initialize() {
        backgroundColor = .clear
    }
    
}

// MARK: Make constraints
private extension CourseHeader {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 38.scale),
            container.leftAnchor.constraint(equalTo: leftAnchor),
            container.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.scale),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 24.scale),
            imageView.widthAnchor.constraint(equalTo: container.heightAnchor)
        ])
    }
}
// MARK: Lazy initialization
private extension CourseHeader {
    func makeContainerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderWidth = 2.scale
        view.layer.borderColor = StudyPalette.Course.addCourse.cgColor
        view.layer.cornerRadius = 12.scale
        addSubview(view)
        return view
    }
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Study.Add")
        view.tintColor = StudyPalette.Course.addCourse
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
