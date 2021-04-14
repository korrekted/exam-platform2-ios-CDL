//
//  StudyCollectionView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 30.01.2021.
//

import UIKit
import RxCocoa

final class StudyCollectionView: UICollectionView {
    lazy var selected = PublishRelay<StudyCollectionElement>()
    lazy var selectedCourse = BehaviorRelay<Course?>(value: nil)
    lazy var didTapAdd = PublishRelay<Void>()
    
    private lazy var sections = [StudyCollectionSection]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension StudyCollectionView {
    func setup(sections: [StudyCollectionSection]) {
        self.sections = sections
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension StudyCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section].elements[indexPath.row] {
        case .title(let title):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: SCTitleCell.self), for: indexPath) as! SCTitleCell
            cell.setup(title: title)
            return cell
        case .mode(let mode):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: SCModeCell.self), for: indexPath) as! SCModeCell
            cell.setup(mode: mode)
            return cell
        case .courses(let elements):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: SCCoursesCell.self), for: indexPath) as! SCCoursesCell
            cell.setup(
                elements: elements,
                selectedCourse: { [weak self] in self?.selectedCourse.accept($0) },
                didTapAdd: { [weak self] in self?.didTapAdd.accept(()) }
            )
            return cell
        case .trophy:
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: SCTrophyCollectionCell.self), for: indexPath) as! SCTrophyCollectionCell
            return cell
        }
    }
}

// MARK: UICollectionViewDelegate
extension StudyCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected.accept(sections[indexPath.section].elements[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        let width = 375.scale - contentInset.left - contentInset.right
        
        switch sections[indexPath.section].elements[indexPath.row] {
        case .title:
            return CGSize(width: width, height: 56.scale)
        case .mode(let mode):
            let height: CGFloat
            switch mode.mode {
            case .today:
                height = 180.scale
            case .ten:
                height = 150.scale
            case .missed:
                height = 150.scale
            case .random:
                height = 126.scale
            }
            let width = (collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right - layout.minimumLineSpacing) / 2
            return CGSize(width: width, height: height)
        case .courses:
            return CGSize(width: collectionView.bounds.width, height: 244.scale)
        case .trophy:
            return CGSize(width: width, height: 156.scale)
        }
    }
}

// MARK: Private
private extension StudyCollectionView {
    func initialize() {
        register(SCTitleCell.self, forCellWithReuseIdentifier: String(describing: SCTitleCell.self))
        register(SCModeCell.self, forCellWithReuseIdentifier: String(describing: SCModeCell.self))
        register(SCTrophyCollectionCell.self, forCellWithReuseIdentifier: String(describing: SCTrophyCollectionCell.self))
        register(SCCoursesCell.self, forCellWithReuseIdentifier: String(describing: SCCoursesCell.self))
        
        dataSource = self
        delegate = self
    }
}
