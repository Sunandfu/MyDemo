
import UIKit

class UnderlineTextField: UITextField {
    
    let underline: UIView = {
        let v = UIView()
        v.backgroundColor = DemoUI.color_0089FF
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(underline)
        underline.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
