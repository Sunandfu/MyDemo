//
//  PickerCustomizableButton.swift
//  Alerts&Pickers
//
//  Created by DmitriiBagrov on 19/10/2018.
//  Copyright © 2018 Supreme Apps. All rights reserved.
//

import UIKit

enum PickerButtonState: String {
    case normal
    case selected
    case hightlited
    
    static func state(byUIKit state: UIControl.State) -> PickerButtonState {
        switch state {
        case .normal:
            return .normal
        case .selected:
            return .selected
        case [.selected, .highlighted]:
            return .selected
        default:
            return .normal
        }
    }
}

class PickerCustomizableButton: UIButton {
    
    //MARK: Private Priperties
    
    private var backgroundColorStateStorage: [PickerButtonState: UIColor] = [:]
    
    //MARK: Public Properties
    
    func setBackgroundColor(_ color: UIColor, state: UIControl.State) {
        backgroundColorStateStorage[PickerButtonState.state(byUIKit: state)] = color
        updateBackgroundColor()
    }
    
    //MARK: Public Methods
    
    override var isSelected: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
    
    override var isHighlighted: Bool {
        set {
            backgroundColor = UIColor.white
            updateBackgroundColor()
        }
        get {
            return super.isHighlighted
        }
    }
    
    //MARK: Private Methods
    
    private func updateBackgroundColor() {
        self.backgroundColor = backgroundColorStateStorage[PickerButtonState.state(byUIKit: state)] ?? UIColor.clear
    }
    
}
