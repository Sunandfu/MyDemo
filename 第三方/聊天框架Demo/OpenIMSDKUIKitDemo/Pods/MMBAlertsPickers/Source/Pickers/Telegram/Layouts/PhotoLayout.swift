import UIKit

protocol PhotoLayoutDelegate: class {
    
    func collectionView(_ collectionView: UICollectionView, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
}


class PhotoLayout: UICollectionViewLayout {
    
    class Attributes: UICollectionViewLayoutAttributes {
        
        public var selectionCenter: CGPoint {
           return self.selectionCenterFor(visibleArea: self.visibleArea)
        }
        
        public var selectionSize: CGSize = CGSize(width: 28, height: 28)
        
        public var selectionInset: CGFloat = 8.0
        
        public var selectionBorderWidth: CGFloat = 2.0
        
        public var visibleArea: CGRect = .zero
        
        private func selectionCenterFor(visibleArea area: CGRect) -> CGPoint {
            
            let y = bounds.minY + selectionSize.height / 2.0 + selectionInset
            
            let visibleAreaMaxX: CGFloat = area.isNull ? 0.0 : area.maxX
            let areaMaxX = min(visibleAreaMaxX, bounds.maxX)
            
            let minX = bounds.minX + selectionSize.width / 2.0 + selectionInset
            let desiredX = bounds.minX + areaMaxX - selectionSize.width / 2.0 - selectionInset
            
            let x = max(minX, desiredX)
            
            let centerPoint = CGPoint(x: x, y: y)
            return centerPoint
        }
        
        override func copy() -> Any {
            let copy = super.copy() as! PhotoLayout.Attributes
            copy.selectionSize = self.selectionSize
            copy.selectionInset = self.selectionInset
            copy.selectionBorderWidth = self.selectionBorderWidth
            copy.visibleArea = self.visibleArea
            return copy
        }
        
        var duplicate: PhotoLayout.Attributes {
            return copy() as! PhotoLayout.Attributes
        }
        
    }
    
    weak var delegate: PhotoLayoutDelegate!
    
    public var lineSpacing: CGFloat = 6
    
    enum Mode: Int {
        case normal
        case hidingFirstItem
    }
    
    /// When you change it you're responsible to call layout invalidation.
    public var mode: Mode = .normal
    
    fileprivate var previousAttributes = [Attributes]()
    fileprivate var currentAttributes = [Attributes]()
    
    fileprivate var contentSize: CGSize = .zero
    public var selectedCellIndexPath: IndexPath?
    
    private var insertingIndexPaths: [IndexPath] = []
    private var removalIndexPaths: [IndexPath] = []
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override public var collectionView: UICollectionView {
        return super.collectionView!
    }
    
    public var proposedItemHeight: CGFloat {
        return collectionView.bounds.height - (inset.top + inset.bottom)
    }
    
    public func prepareForInsertion(_ indexPaths: [IndexPath]) {
        self.insertingIndexPaths = indexPaths
    }
    
    public func prepareForRemoval(_ indexPaths: [IndexPath]) {
        self.removalIndexPaths = indexPaths
    }
    
    private var inset: UIEdgeInsets {
        return collectionView.contentInset
    }
    
    private var numberOfSections: Int {
        return collectionView.numberOfSections
    }
    
    private func numberOfItems(inSection section: Int) -> Int {
        return collectionView.numberOfItems(inSection: section)
    }
    
    override func prepare() {
        super.prepare()
        
        previousAttributes = currentAttributes
        
        contentSize = .zero
        
        currentAttributes = []
        
        var xOffset: CGFloat = 0
        if numberOfItems(inSection: 0) > 0 && mode == .hidingFirstItem {
            xOffset = -delegate.collectionView(collectionView, sizeForItemAtIndexPath: IndexPath(item: 0, section: 0)).width - lineSpacing
        }
        
        let height = self.proposedItemHeight
        
        for item in 0 ..< numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let size = delegate.collectionView(collectionView, sizeForItemAtIndexPath: indexPath)
            
            let frame = CGRect(origin: .init(x: xOffset, y: 0.0), size: size)
            
            let attributes = Attributes(forCellWith: indexPath)
            attributes.frame = frame
            
            if item == 0, mode == .hidingFirstItem {
                attributes.alpha = 0.0
            }
            else {
                attributes.alpha = 1.0
            }
            
            attributes.visibleArea = collectionView.bounds.intersection(frame)
            
            currentAttributes.append(attributes)
            
            contentSize.width = max(contentSize.width, frame.maxX)
            xOffset += size.width + lineSpacing
        }
        
        contentSize.height = height
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        insertingIndexPaths = []
        removalIndexPaths = []
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if insertingIndexPaths.contains(itemIndexPath) {
            return attributesForInsertionItem(at: itemIndexPath)
        }
        return previousAttributes[itemIndexPath.item]
    }
    
    private func attributesForInsertionItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = currentAttributes[indexPath.item].duplicate
        attributes.alpha = 0.0
        attributes.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        attributes.frame.origin.y -= self.collectionView.bounds.size.height
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return currentAttributes[indexPath.item]
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if removalIndexPaths.contains(itemIndexPath) {
            let attributes = currentAttributes[itemIndexPath.item].duplicate
            attributes.alpha = 0.0
            attributes.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            attributes.frame.origin.y -= self.collectionView.bounds.size.height
            return attributes
        }
        return layoutAttributesForItem(at: itemIndexPath)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return currentAttributes.filter { rect.intersects($0.frame) }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if newBounds.height != collectionView.bounds.height {
            return true
        }
        return false
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard let selectedCellIndexPath = selectedCellIndexPath else {
            return proposedContentOffset
        }
        
        var finalContentOffset = proposedContentOffset
        
        if let itemFrame = layoutAttributesForItem(at: selectedCellIndexPath)?.frame {
            let width = collectionView.bounds.size.width
            
            let contentLeft = proposedContentOffset.x
            let contentRight = contentLeft + width
            
            let itemLeft = itemFrame.origin.x
            let itemRight = itemLeft + itemFrame.size.width
            
            if itemRight > contentRight {
                finalContentOffset = CGPoint(x: contentLeft + (itemRight - contentRight) + lineSpacing, y: -inset.top)
            } else if itemLeft < contentLeft {
                finalContentOffset = CGPoint(x: contentLeft - (contentLeft - itemLeft) - lineSpacing, y: -inset.top)
            }
            Log(finalContentOffset)
        }
        
        return finalContentOffset
    }
    
    public func updateVisibleArea(_ area: CGRect, itemAt indexPath: IndexPath, cell: UICollectionViewCell) {
        
        let attributes = currentAttributes[indexPath.item]
        if attributes.visibleArea != area {
            attributes.visibleArea = area
            cell.apply(currentAttributes[indexPath.item])
        }
    }
}

