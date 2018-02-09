//
//  ViewController.swift
//  CLADScroll
//
//  Created by Darren on 16/8/27.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 竖直广告
        self.setupVerticalAdView()
        
        // 本地图片轮播
        self.setupLocalPicture()
        
        // 网络图片轮播
        self.setupNetPicture()
        
    }
    
    private func setupVerticalAdView(){
        // 初始化数值滚动广告的数据
        let model1:HomeAdModel = HomeAdModel(dict: [:])
        model1.Title2 = "最新"
        model1.Path = "345"
        model1.Title = "测试测测试测试测试测试测试测试测试测试试"
        let model2:HomeAdModel = HomeAdModel(dict: [:])
        model2.Title2 = "热门"
        model2.Path = "123"
        model2.Title = "哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"
        
        let array1 = [model1,model2]
        let array2 = [model1,model2]
        let array3 = [array1,array2]
        
        let adView = CLAdView.showAdView(CGRectMake(50, 50, self.view.frame.size.width-100, 60), dataArray: array3 as NSArray) { (model:HomeAdModel) in
            
            // 点击了广告把这条广告对应的模型传递过来
            print("竖直广告对应的模型  这里只打印部分信息===\(model.Title)")
        }
        self.view.addSubview(adView)

    }
    
    private func setupLocalPicture(){
        
        let lable = UILabel()
        lable.frame  = CGRectMake(0, 120,self.view.frame.size.width , 20)
        lable.textAlignment = .Center
        lable.text = "本地图片"
        self.view.addSubview(lable)
        
        let arrayLocal = ["1","2","3"]
        let localPic = CLPictureScrollView.showPictureViewWithLocal(CGRectMake(0, 150, self.view.frame.size.width, 200), dataArray: arrayLocal as NSArray, cellClick: { (model:HomeAdModel) in
        }) as! CLPictureScrollView
        localPic.stopAotuScroll = true
        self.view.addSubview(localPic)
    }
    
    private func setupNetPicture(){
        
        let lable = UILabel()
        lable.frame  = CGRectMake(0, 410,self.view.frame.size.width , 10)
        lable.textAlignment = .Center
        lable.text = "网络图片"
        self.view.addSubview(lable)

        
        let model1:HomeAdModel = HomeAdModel(dict: [:])
        model1.Path = "http://files.qiluzhaoshang.com//userheader/20160815/h2016081515514613355679328.png"
        let model2:HomeAdModel = HomeAdModel(dict: [:])
        model2.Path = "http://7fvaoh.com3.z0.glb.qiniucdn.com/image/151027/pktvp21vq.jpg-w720"
        let model3:HomeAdModel = HomeAdModel(dict: [:])
        model3.Path = "http://7fvaoh.com3.z0.glb.qiniucdn.com/image/151217/40yfp068l.jpg-w720"
        let arrayNet = [model1,model2,model3]
        let netPic = CLPictureScrollView.showNetPictureViewWithModel(CGRectMake(0, 430, self.view.frame.size.width, 200), dataArray: arrayNet as NSArray) { (model:HomeAdModel) in
            
            print("网络图片轮播图===\(model.Path)")

        }
        self.view.addSubview(netPic)
    }


}

