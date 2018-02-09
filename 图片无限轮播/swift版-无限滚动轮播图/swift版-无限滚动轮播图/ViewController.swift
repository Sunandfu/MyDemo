//
//  ViewController.swift
//  swift版-无限滚动轮播图
//
//  Created by 小富 on 16/7/1.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //网络资源
        let imageArray:NSArray = ["http://tupian.enterdesk.com/2012/1025/gha/1/ebterdesk%20%2810%29.jpg","http://d.3987.com/qingzang_140909/007.jpg","http://d.3987.com/mrzr_131022/007.jpg"]
        
        let imageScroll = SFImageScroll.ShowNetWorkImageScroll(CGRectMake(0, 20, self.view.frame.size.width, 200), array: imageArray) { (tagValue) in
            print("点击了图片==\(tagValue)")
        }
        self.view.addSubview(imageScroll)
        
        //本地资源
        let imageArray2:NSArray = ["111.jpg","222.jpg","333.jpg"]
        
        let imageScroll2 = SFImageScroll.ShowLocationImageScroll(CGRectMake(0, 270, self.view.frame.size.width, 200), array: imageArray2) { (tagValue) in
            print("点击了图片==\(tagValue)")
        }
        self.view.addSubview(imageScroll2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

