//
//  ViewController.swift
//  BSCycleImagesViewSample
//
//  Created by 张亚东 on 16/5/15.
//  Copyright © 2016年 张亚东. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cycleImagesView: BSCycleImagesView! {
        didSet {
            cycleImagesView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cycleImagesView.timeInterval = 2
        
        var images: [UIImage] = []
        for i in 1...4 {
            let image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("\(i)", ofType: ".jpg")!)!
            images.append(image)
        }
        
        //set local images
        cycleImagesView.images = images
        
        //set image urls
//        cycleImagesView.imageURLs = ["http://img4.duitang.com/uploads/item/201403/31/20140331094819_dayKx.jpeg", "http://i1.17173cdn.com/9ih5jd/YWxqaGBf/forum/images/2014/08/05/201143hmymxmizwmqi86yi.jpg", "http://p1.image.hiapk.com/uploads/allimg/150413/7730-150413103526-51.jpg", "http://s9.knowsky.com/bizhi/l/55001-65000/2009529123133602476178.jpg"]
        
        cycleImagesView.imageDidSelectedClousure = { index in
            print(index)
        }
    }

}

