import UIKit

class ItemWithImage: UICollectionViewCell {
    
    static let identifier = String(describing: CurrencyTableViewCell.self)
    
    lazy var imageView: UIImageView = {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        return $0
    }(UIImageView())
    
    lazy var unselectedCircle: UIView = {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.masksToBounds = false
        return $0
    }(UIView())
    
    lazy var selectedCircle: UIView = {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.masksToBounds = false
        return $0
    }(UIView())
    
    lazy var selectedPoint: UIView = {
        $0.backgroundColor = UIColor(hex: 0x007AFF)
        return $0
    }(UIView())
    
    fileprivate let inset: CGFloat = 8
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    fileprivate func setup() {
        backgroundColor = .clear
        
        let unselected: UIView = UIView()
        unselected.addSubview(imageView)
        unselected.addSubview(unselectedCircle)
        backgroundView = unselected
        
        let selected: UIView = UIView()
        selected.addSubview(selectedCircle)
        selected.addSubview(selectedPoint)
        selectedBackgroundView = selected
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    func layout() {
        imageView.frame = contentView.frame
        updateAppearance(forCircle: unselectedCircle)
        updateAppearance(forCircle: selectedCircle)
        updateAppearance(forPoint: selectedPoint)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.frame.size = size
        layout()
        return size
    }
    
    func updateAppearance(forCircle view: UIView) {
        view.frame.size = CGSize(width: 28, height: 28)
        view.frame.origin.x = imageView.bounds.width - unselectedCircle.bounds.width - inset
        view.frame.origin.y = inset
        
        view.dlgpicker_setupRoundCorners()
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.layer.shadowPath = UIBezierPath(roundedRect: unselectedCircle.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: unselectedCircle.bounds.width / 2, height: unselectedCircle.bounds.width / 2)).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func updateAppearance(forPoint view: UIView) {
        view.frame.size = CGSize(width: unselectedCircle.frame.width - unselectedCircle.layer.borderWidth * 2,
                                 height: unselectedCircle.frame.height - unselectedCircle.layer.borderWidth * 2)
        view.center = selectedCircle.center
        view.dlgpicker_setupRoundCorners()
    }
}
