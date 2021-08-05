//
//  StickyGridCollectionViewLayout.swift
//  StickyGridCollectionViewController
//
//  Created by djiang on 28/07/21.
//

import UIKit

public class StickyGridCollectionViewLayout: UICollectionViewFlowLayout {
    public var stickyRowsCount = 0 {
        didSet {
            invalidateLayout()
        }
    }

    public var stickyColumnsCount = 0 {
        didSet {
            invalidateLayout()
        }
    }

    public func isSticky(at indexPath: IndexPath) -> Bool {
        return indexPath.item < stickyColumnsCount || indexPath.section < stickyRowsCount
    }

    private var allAttributes: [[UICollectionViewLayoutAttributes]] = []
    private var contentSize = CGSize.zero

    override public func prepare() {
        setupAttributes()
        updateStickyItemsPositions()

        let lastItemFrame = allAttributes.last?.last?.frame ?? .zero
        contentSize = CGSize(width: lastItemFrame.maxX, height: lastItemFrame.maxY)
    }

    private func setupAttributes() {
        allAttributes = []

        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0

        for row in 0..<rowsCount {
            var rowAttributes: [UICollectionViewLayoutAttributes] = []
            xOffset = 0

            for col in 0..<columnsCount(in: row) {
                let itemSize = itemSize(row: row, column: col)
                let indexPath = IndexPath(row: row, column: col)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral
                rowAttributes.append(attributes)

                xOffset += itemSize.width
            }

            yOffset += rowAttributes.last?.frame.height ?? 0.0
            allAttributes.append(rowAttributes)
        }
    }

    private func updateStickyItemsPositions() {
        for row in 0..<rowsCount {
            for col in 0..<columnsCount(in: row) {
                let attributes = allAttributes[row][col]

                if row < stickyRowsCount {
                    var frame = attributes.frame
                    frame.origin.y += collectionView!.contentOffset.y
                    attributes.frame = frame
                }

                if col < stickyColumnsCount {
                    var frame = attributes.frame
                    frame.origin.x += collectionView!.contentOffset.x
                    attributes.frame = frame
                }

                attributes.zIndex = zIndex(row: row, column: col)
            }
        }
    }

    private func zIndex(row: Int, column col: Int) -> Int {
        if row < stickyRowsCount && col < stickyColumnsCount {
            return ZOrder.staticItem
        } else if row < stickyRowsCount || col < stickyColumnsCount {
            return ZOrder.stickyItem
        } else {
            return ZOrder.commonItem
        }
    }
}

public extension StickyGridCollectionViewLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        for rowAttributes in allAttributes {
            for itemAttributes in rowAttributes where rect.intersects(itemAttributes.frame) {
                layoutAttributes.append(itemAttributes)
            }
        }

        return layoutAttributes
    }

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

extension StickyGridCollectionViewLayout {
    private var rowsCount: Int {
        return collectionView!.numberOfSections
    }

    private func columnsCount(in row: Int) -> Int {
        return collectionView!.numberOfItems(inSection: row)
    }

    private func itemSize(row: Int, column: Int) -> CGSize {
        guard let delegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout,
              let size = delegate.collectionView?(collectionView!, layout: self, sizeForItemAt: IndexPath(row: row, column: column))
        else {
            assertionFailure("Implement collectionView(_,layout:,sizeForItemAt: in UICollectionViewDelegateFlowLayout")
            return .zero
        }

        return size
    }
}

private extension IndexPath {
    init(row: Int, column: Int) {
        self = IndexPath(item: column, section: row)
    }
}

private enum ZOrder {
    static let commonItem = 0
    static let stickyItem = 1
    static let staticItem = 2
}
