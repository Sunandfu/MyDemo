//
//  ViewController.swift
//  RAMAnimatedTabBarDemo
//
//  Created by Alex Kalinkin on 11/18/14.
//  Copyright (c) 2014 Ramotion. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class ViewController: UIViewController {

    var index: NSInteger = 0
    override func viewDidLoad() {
        print("哈哈哈")
    }
    // PRAGMA: actions
    @IBAction func showBadgeHandelr(_: AnyObject) {
        // example for showing badges
        index += 1
        tabBarItem.badgeValue = "\(index)"
    }

    @IBAction func hideBadgeHandler(_: AnyObject) {
        tabBarItem.badgeValue = nil
    }
}
