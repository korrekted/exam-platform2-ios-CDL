//
//  TopicsCollectionView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 22.04.2021.
//

import UIKit

protocol TopicsCollectionViewDelegate: class {
    func topicsCollectionViewDidChangeSelection()
}

final class TopicsCollectionView: UICollectionView {
    weak var topicsCollectionViewDelegate: TopicsCollectionViewDelegate?
    
    lazy var elements = [TopicsCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension TopicsCollectionView {
    func setup(elements: [TopicsCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension TopicsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: TopicsCollectionCell.self), for: indexPath) as! TopicsCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension TopicsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        elements[indexPath.row].isSelected = !elements[indexPath.row].isSelected
        
        reloadItems(at: [indexPath])
        
        topicsCollectionViewDelegate?.topicsCollectionViewDidChangeSelection()
    }
}

// MARK: TopicsCollectionLayoutDelegate
extension TopicsCollectionView: TopicsCollectionLayoutDelegate {
    func topicsCollectionLayout(widthFor indexPath: IndexPath) -> CGFloat {
        return elements[indexPath.item].width(for: 120.scale) + 48.scale
    }
}

// MARK: Private
private extension TopicsCollectionView {
    func initialize() {
        register(TopicsCollectionCell.self, forCellWithReuseIdentifier: String(describing: TopicsCollectionCell.self))
        
        dataSource = self
        delegate = self
        
        if let topicsLayout = collectionViewLayout as? TopicsCollectionLayout {
            topicsLayout.delegate = self
        }
    }
}
