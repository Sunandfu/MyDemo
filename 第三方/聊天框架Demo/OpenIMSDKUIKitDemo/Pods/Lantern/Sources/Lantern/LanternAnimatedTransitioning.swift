//
//  LanternAnimatedTransitioning.swift
//  Lantern
//
//  Created by JiongXing on 2019/11/25.
//  Copyright © 2021 Shenzhen Hive Box Technology Co.,Ltd All rights reserved.
//

import UIKit

public protocol LanternAnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    var isForShow: Bool { get set }
    var lantern: Lantern? { get set }
    var isNavigationAnimation: Bool { get set }
}

private var isForShowKey = "isForShowKey"
private var lanternKey = "lanternKey"

extension LanternAnimatedTransitioning {
    
    public var isForShow: Bool {
        get {
            if let value = objc_getAssociatedObject(self, &isForShowKey) as? Bool {
                return value
            }
            return true
        }
        set {
            objc_setAssociatedObject(self, &isForShowKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public weak var lantern: Lantern? {
        get {
            objc_getAssociatedObject(self, &lanternKey) as? Lantern
        }
        set {
            objc_setAssociatedObject(self, &lanternKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public var isNavigationAnimation: Bool {
        get { false }
        set { }
    }
    
    public func fastSnapshot(with view: UIView) -> UIView? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImageView(image: image)
    }
    
    public func snapshot(with view: UIView) -> UIView? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImageView(image: image)
    }
}
