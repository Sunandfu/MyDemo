//
//  SFImageScroll.swift
//  swift版-无限滚动轮播图
//
//  Created by 小富 on 16/7/1.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

import UIKit
//枚举
enum ImageShowStayle:Int {
    case Location=0,Network
}
//Block
typealias BtnClickBlock = (NSInteger) -> Void

class SFImageScroll: UIView {
    //全局变量
    var imgArray:NSArray?         //图片数组
    var pageView:UIPageControl?   //分页
    var btnClicks:BtnClickBlock?  //block
    var myScroll:UIScrollView?
    var timer:NSTimer?            //计时器
    var scrollIndex:NSInteger?    //下表值
    var imgChaceDic:NSDictionary? //图片缓存
    /**
     *显示本地图片
     *rect:在父视图中的位置
     *array:加载的图片数组
     *btnClick:点击图片回调
     */
    static func ShowLocationImageScroll(rect:CGRect,array:NSArray,btnClick:BtnClickBlock) -> UIView {
        let selfImageScroll:SFImageScroll = SFImageScroll.init(frame: rect)
        selfImageScroll.ShowImageScrollWithImageArray(array, btnClick: btnClick, showStyle: .Location)
        return selfImageScroll
    }
    /**
     *显示网络图片
     *rect:在父视图中的位置
     *array:加载的图片数组--(网络图片地址)
     *btnClick:点击图片回调
     */
    static func ShowNetWorkImageScroll(rect:CGRect,array:NSArray,btnClick:BtnClickBlock) -> UIView {
        let selfImageScroll:SFImageScroll = SFImageScroll.init(frame: rect)
        selfImageScroll.ShowImageScrollWithImageArray(array, btnClick: btnClick, showStyle: .Network)
        return selfImageScroll
    }
    /**
     *清理网络缓存到内存中的图片
     */
    static func clearnNetImageChace() -> Void {
        let paths:NSString = NSHomeDirectory().stringByAppendingString("Library/Caches/Image")
        let fileManager:NSFileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(paths as String) {
            try! fileManager.removeItemAtPath(paths as String)
        }
        try! fileManager.createDirectoryAtPath(paths as String, withIntermediateDirectories: true, attributes: nil)
        
    }
    func clearNetImageChace() -> Void {
        SFImageScroll.clearnNetImageChace()
    }
    //控制显示
    func ShowImageScrollWithImageArray(array:NSArray,btnClick:BtnClickBlock,showStyle:ImageShowStayle) -> Void {
        imgArray = array
        btnClicks = btnClick
        myScroll = UIScrollView.init(frame: CGRectMake(0, 0,self.bounds.size.width, self.bounds.size.height))
        myScroll!.delegate = self
        myScroll!.pagingEnabled = true
        myScroll!.contentSize=CGSizeMake(self.bounds.size.width*CGFloat(array.count+2), 0)
        myScroll!.contentOffset=CGPointMake(self.bounds.size.width, 0)
        myScroll!.showsHorizontalScrollIndicator=false
        myScroll!.showsVerticalScrollIndicator=false
        self.addSubview(myScroll!)
        scrollIndex = 1
        for i in 0...array.count+1 {
            let btn:UIButton = UIButton.init(type: .Custom)
            btn.frame = CGRectMake(self.bounds.size.width*CGFloat(i+1), 0, self.bounds.size.width, self.bounds.size.height)
            btn.tag = 100+i
            if case .Location = showStyle {
                btn.setImage(UIImage.init(named: array[i>(array.count-1) ? 0 : i] as! String), forState: .Normal)
            } else {
                self.networkImageSettingWithString(array[i>(array.count-1) ? 0 : i] as! NSString, btn: btn)
            }
            btn.addTarget(self, action: #selector(SFImageScroll.btnClick(_:)), forControlEvents: .TouchUpInside)
            myScroll!.addSubview(btn)
        }
        let regitBtn:UIButton = UIButton.init(type: .Custom)
        regitBtn.frame = CGRectMake(self.bounds.size.width*CGFloat(array.count+1), 0, self.bounds.size.width, self.bounds.size.height)
        myScroll?.addSubview(regitBtn)
        
        let leftBtn:UIButton = UIButton.init(type: .Custom)
        leftBtn.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
        myScroll?.addSubview(leftBtn)
        if case .Location = showStyle {
            regitBtn.setImage(UIImage.init(named: array.firstObject as! String), forState: .Normal)
            leftBtn.setImage(UIImage.init(named: array.lastObject as! String), forState: .Normal)
        } else {
            self.networkImageSettingWithString(array.firstObject as! String, btn: regitBtn)
            self.networkImageSettingWithString(array.lastObject as! String, btn: leftBtn)
        }
        
        pageView = UIPageControl.init(frame: CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20))
        pageView?.numberOfPages = array.count
        pageView?.currentPage = 0
        pageView?.userInteractionEnabled = false
        pageView?.currentPageIndicatorTintColor = UIColor.greenColor()
        pageView?.pageIndicatorTintColor = UIColor.grayColor()
        self.addSubview(pageView!)
        self.startTime()
    }
    //MARK 按钮点击
    func btnClick(btn:UIButton) -> Void {
        if (btnClicks != nil) {
            btnClicks!(btn.tag-100)
        }
    }
    //开启定时器
    func startTime() -> Void {
        if timer==nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(SFImageScroll.scrollForTime(_:)), userInfo: nil, repeats: true)
        }
    }
    //MARK 添加滚动
    func scrollForTime(time:NSTimer) -> Void {
        scrollIndex = scrollIndex! + 1
        if scrollIndex==imgArray!.count+1 {
            myScroll!.setContentOffset(CGPointMake(self.bounds.size.width*CGFloat(scrollIndex!), 0), animated:true)
            scrollIndex = 1
            self.performSelector(#selector(SFImageScroll.scrollToInit), withObject: nil, afterDelay: 0.5)
        } else {
            myScroll!.setContentOffset(CGPointMake(self.bounds.size.width*CGFloat(scrollIndex!), 0), animated:true)
        }
        pageView!.currentPage = scrollIndex!-1
    }
    //回到原点
    func scrollToInit() -> Void {
        myScroll!.setContentOffset(CGPointMake(self.bounds.size.width*CGFloat(scrollIndex!), 0), animated:false)
    }
    // MARK 网络图片处理
    func networkImageSettingWithString(str:NSString,btn:UIButton) -> Void{
        let paths:NSString = NSHomeDirectory().stringByAppendingString("Library/Caches/Image")
        self.imgFileDataLocationSettingWithPath(paths)
            dispatch_async(dispatch_get_global_queue(0, 0), { 
                let data:NSData = NSData.init(contentsOfURL: NSURL.init(string: str as String)!)!
                let img:UIImage = UIImage.init(data: data)!
                dispatch_async(dispatch_get_main_queue(), { 
                    btn.setImage(img, forState: .Normal)
                })
            })
        
        
    }
    //处理缓存路径
    func imgFileDataLocationSettingWithPath(path:NSString) -> Void{
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(path as String) {
            try! fileManager.createDirectoryAtPath(path as String, withIntermediateDirectories: true, attributes: nil)
        }
        
    }

}
extension SFImageScroll:UIScrollViewDelegate{
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index:NSInteger = NSInteger(scrollView.contentOffset.x/320)
        if index == (imgArray!.count+1) {
            scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0)
            pageView!.currentPage = 0
            scrollIndex = 1
        } else if index == 0 {
            scrollView.contentOffset = CGPointMake(CGFloat(imgArray!.count)*self.bounds.size.width, 0)
            pageView!.currentPage = imgArray!.count-1
            scrollIndex = imgArray!.count
        } else {
            pageView!.currentPage=index-1
            scrollIndex=index
        }
        self.startTime()
    }
}

