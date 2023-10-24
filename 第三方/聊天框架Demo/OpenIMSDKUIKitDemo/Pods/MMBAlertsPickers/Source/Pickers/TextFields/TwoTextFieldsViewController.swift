import UIKit

extension UIAlertController {
    
    /// Add two textField
    ///
    /// - Parameters:
    ///   - height: textField height
    ///   - hInset: right and left margins to AlertController border
    ///   - vInset: bottom margin to button
    ///   - textFieldOne: first textField
    ///   - textFieldTwo: second textField
    
    public func addTwoTextFields(height: CGFloat = 58, hInset: CGFloat = 0, vInset: CGFloat = 0, textFieldOne: TextField.Config?, textFieldTwo: TextField.Config?) {
        let textField = TwoTextFieldsViewController(height: height, hInset: hInset, vInset: vInset, textFieldOne: textFieldOne, textFieldTwo: textFieldTwo)
        set(vc: textField, height: height * 2 + 2 * vInset)
    }
}

final public class TwoTextFieldsViewController: UIViewController {
    
    fileprivate lazy var textFieldView: UIView = UIView()
    fileprivate lazy var textFieldOne: TextField = TextField()
    fileprivate lazy var textFieldTwo: TextField = TextField()
    
    fileprivate var height: CGFloat
    fileprivate var hInset: CGFloat
    fileprivate var vInset: CGFloat
    
    public init(height: CGFloat, hInset: CGFloat, vInset: CGFloat, textFieldOne configurationOneFor: TextField.Config?, textFieldTwo configurationTwoFor: TextField.Config?) {
        self.height = height
        self.hInset = hInset
        self.vInset = vInset
        super.init(nibName: nil, bundle: nil)
        view.addSubview(textFieldView)
        
        textFieldView.addSubview(textFieldOne)
        textFieldView.addSubview(textFieldTwo)
        
        textFieldView.frame.size.width = view.frame.width
        textFieldView.frame.size = CGSize(width: view.frame.width, height: height * 2)
        textFieldView.layer.masksToBounds = true
        textFieldView.layer.borderWidth = 1
        textFieldView.layer.borderColor = UIColor.lightGray.cgColor
        textFieldView.layer.cornerRadius = 8
        
        configurationOneFor?(textFieldOne)
        configurationTwoFor?(textFieldTwo)
        
        //preferredContentSize.height = height * 2 + vInset
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textFieldView.frame.size = .init(width: view.frame.width - hInset * 2.0,
                                         height: height * 2.0)
        textFieldView.center = view.center
        
        textFieldOne.frame.size = .init(width: textFieldView.frame.width,
                                        height: textFieldView.frame.height / 2.0)
        textFieldOne.center = .init(x: textFieldView.frame.width / 2.0,
                                    y: textFieldView.frame.height / 4.0)
        
        textFieldTwo.frame.size = .init(width: textFieldView.frame.width,
                                        height: textFieldView.frame.height / 2.0)
        textFieldTwo.center = .init(x: textFieldView.frame.width / 2.0,
                                    y: textFieldView.frame.height - textFieldView.frame.height / 4.0)
    }
}

