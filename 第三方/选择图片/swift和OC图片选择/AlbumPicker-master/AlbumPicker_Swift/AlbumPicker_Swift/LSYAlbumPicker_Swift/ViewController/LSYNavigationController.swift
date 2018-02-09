//
//  LSYNavigationController.swift
//  AlbumPicker_Swift
//
//  Created by Labanotation on 15/8/10.
//  Copyright (c) 2015年 com.okwei. All rights reserved.
//

import Foundation
import UIKit
class LSYNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationBar.tintColor = UIColor.whiteColor()
    }
}