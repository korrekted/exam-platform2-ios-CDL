//
//  TopicsCollectionLayout.swift
//  CDL
//
//  Created by Andrey Chernyshev on 22.04.2021.
//

import UIKit

protocol TopicsCollectionLayoutDelegate: AnyObject {
    func topicsCollectionLayout(widthFor indexPath: IndexPath) -> CGFloat
}

final class TopicsCollectionLayout: UICollectionViewLayout {
    weak var delegate: TopicsCollectionLayoutDelegate?

    private lazy var cache = [UICollectionViewLayoutAttributes]()

    private var contentHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.top + insets.bottom)
    }

    private var contentWidth = CGFloat(0)

    override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else {
            return
        }
        
        let rowHeight = 120.scale
        let padding = 16.scale
        
        var row = 0
        
        let yOffset: [CGFloat] = [0, 136.scale, 272.scale]
        var xOffset: [CGFloat] = [0, 0, 0]
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let rowWidth = delegate?.topicsCollectionLayout(widthFor: indexPath) ?? 214.scale
            
            let frame = CGRect(x: xOffset[row],
                               y: yOffset[row],
                               width: rowWidth,
                               height: rowHeight)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            
            cache.append(attributes)
            
            contentWidth = max(contentWidth, frame.maxX)
            
            xOffset[row] = xOffset[row] + rowWidth + padding
            
            row = row + 1
            if row > 2 {
                row = 0
            }
        }
    }
  
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
  
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
