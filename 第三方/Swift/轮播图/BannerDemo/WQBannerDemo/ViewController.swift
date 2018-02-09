//
//  ViewController.swift
//  WQBannerDemo
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 wyq. All rights reserved.
//

import UIKit

class ViewController: UIViewController,WQBannerViewDelegate {

    var bannerView: WQBannerView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let dataArray: NSMutableArray = NSMutableArray.init(capacity: 0)
        var dic = NSDictionary.init(objects: ["http://pic01.babytreeimg.com/foto3/photos/2014/0211/68/2/4170109a41ca935610bf8_b.png","12"], forKeys: ["image_url","image_id"], count: 2)


        dataArray.addObject(dic)

        dic = NSDictionary.init(objects: ["http://pic01.babytreeimg.com/foto3/photos/2014/0127/19/9/4170109a267ca641c41ebb_b.png","13"], forKeys: ["image_url","image_id"],count: 2)
        dataArray.addObject(dic)

        dic = NSDictionary.init(objects: ["http://pic02.babytreeimg.com/foto3/photos/2014/0207/59/4/4170109a17eca86465f8a4_b.jpg","14"], forKeys: ["image_url","image_id"],count: 2)
        
        dataArray.addObject(dic)
        print(dataArray)


        if (self.bannerView != nil) {
            self.bannerView?.reloadBannerWithData(dataArray)
        }
        else {
            self.bannerView = WQBannerView.init(frame: CGRectMake(0, 50, self.view.frame.size.width, 140), direction: BannerViewScrollDirection.ScrollDirectionLandscape, images: dataArray)
            self.bannerView?.backgroundColor = UIColor.redColor()
            self.bannerView!.rollingDelayTime = 4.0
            self.bannerView!.delegate = self
            self.bannerView?.defaultpageColor = UIColor.redColor()
            self.bannerView?.selectpageColor = UIColor.blueColor()
            self.bannerView?.imageKey = "image_url"
            self.bannerView?.imageId = "image_id"
            self.bannerView?.setSquare(0)
            self.bannerView!.setPageControlStyle(BannerViewPageStyle.PageStyle_Middle)
            self.bannerView!.startDownloadImage()
            self.bannerView?.showClose(false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //WQBannerView->delegate

    func imageCachedDidFinish(bannerView: WQBannerView) {

        print("frame = %@",bannerView.frame)
        if bannerView == self.bannerView {
            if self.bannerView!.superview == nil {
                self.view!.addSubview(self.bannerView!)
            }
            self.bannerView!.startRolling()
        }
        else {
            self.view!.addSubview(bannerView)
            bannerView.startRolling()
        }


    }

    func bannerView_didSelectImageView_withData(bannerView: WQBannerView, index: NSInteger, bannerData: String, imageid: String) {

        print("\(index)+\(bannerData)+\(imageid)")

    }

    func bannerViewdidClosed(bannerView: WQBannerView) {

        if ((bannerView.superview) != nil)
        {
            bannerView.removeFromSuperview()
        }

    }


}

