import Foundation

import UIKit

protocol CollectionViewCustomContentCellDelegate: class {
    func collectionViewCustomContentCell<T>(cell: CollectionViewCustomContentCell<T>, didTapOnSelection button: UIButton)
}

public class CollectionViewCustomContentCell<CustomContentView: UIView>: UICollectionViewCell {
    
    weak var delegate: CollectionViewCustomContentCellDelegate?
    
    lazy var customContentView: CustomContentView = {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        return $0
    }(CustomContentView())
    
    internal let inset: CGFloat = 6
    
    public let selectionElement: UIButton = UIButton.selectionButton(size: CGSize(width: 28, height: 28))
    
    private var selectionCenter: CGPoint = .zero {
        didSet {
            if selectionCenter != oldValue {
                setNeedsLayout()
            }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public var showSelectionCircles: Bool = true {
        didSet {
            if showSelectionCircles != oldValue {
                updateSelectionAppearance()
                selectionElement.isHidden = !showSelectionCircles
            }
        }
    }
    
    public func setup() {
        backgroundColor = .clear
        
        let contentView: UIView = UIView()
        contentView.addSubview(customContentView)
        backgroundView = contentView
        self.addSubview(selectionElement)
        
        setupSelectionButton()
    }
    
    public func updateSelectionIndex(isSelected: Bool, with index: Int) {
        selectionElement.isSelected = isSelected
        selectionElement.setTitle(String(index), for: .selected)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        customContentView.frame = contentView.bounds
        customContentView.layer.cornerRadius = 12
        
        updateSelectionAppearance()
    }
    
    func updateSelectionAppearance() {
        updateSelectionLayout()
        
        //TODO: check for selection on reuse
    }
    
    func createView(_ block: (UIView) -> ()) -> UIView {
        let view = UIView()
        block(view)
        return view
    }
    
    func updateSelectionLayout() {
        selectionElement.center = self.selectionCenter
    }
    
    override public func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let photoLayoutAttributes = layoutAttributes as? PhotoLayout.Attributes {
            self.selectionCenter = photoLayoutAttributes.selectionCenter
        }
        layoutIfNeeded()
    }
    
    private func setupSelectionButton() {
        selectionElement.addTarget(self, action: #selector(didTapSelection(with:)), for: .touchUpInside)
    }
    
    @objc func didTapSelection(with sender: UIButton) {
        delegate?.collectionViewCustomContentCell(cell: self, didTapOnSelection: sender)
    }
    
    
}
