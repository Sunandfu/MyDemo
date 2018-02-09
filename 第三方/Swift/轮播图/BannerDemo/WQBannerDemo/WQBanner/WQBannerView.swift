//
//  WQBannerView.swift
//  WQBannerDemo
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 wyq. All rights reserved.
//

import UIKit
//滚动的方式
enum BannerViewScrollDirection : Int {
    // 水平滚动
    case ScrollDirectionLandscape
    // 垂直滚动
    case ScrollDirectionPortait
}
//page显示位置
enum BannerViewPageStyle : Int {
    case PageStyle_None //不显示
    case PageStyle_Left//在左边显示
    case PageStyle_Right//在右边显示
    case PageStyle_Middle//在中间显示
}
//代理方法
protocol WQBannerViewDelegate {

    //图片下载完成后加到subview上的代理方法
    func imageCachedDidFinish(bannerView: WQBannerView)
    //选中力片的代理
    func bannerView_didSelectImageView_withData(bannerView: WQBannerView,index: NSInteger,bannerData: String,imageid: String)
    //close 左上角Ｘ按扭
    func bannerViewdidClosed(bannerView: WQBannerView)

}

let Banner_StartTag: NSInteger = 1000

class WQBannerView: UIView,UIScrollViewDelegate,
    SDWebImageManagerDelegate {

    //代理
    var delegate: WQBannerViewDelegate?
    // 存放所有需要滚动的图片URL NSString
    var imagesArray: NSArray?
    // scrollView滚动的方向
    var scrollDirection: BannerViewScrollDirection?
    //滚动的时间
    var rollingDelayTime: NSTimeInterval?
    //默认page分页的颜色
    var defaultpageColor: UIColor? {
        didSet{
            pageControl?.pageIndicatorTintColor = defaultpageColor
        }
    }
    //选中page分页的颜色
    var selectpageColor: UIColor? {
        didSet{
            pageControl?.currentPageIndicatorTintColor = selectpageColor
        }
    }
    //网络获取图片名字的key(必填)
    var imageKey: String?
    //网络获取图片名字的id(必填)
    var imageId: String?
    // 下载统计
    private var totalCount: NSInteger?
    private var pageControl: UIPageControl?//分页小点
    private var enableRolling: Bool? //是否滚动

    private var scrollView: UIScrollView?
    private var BannerCloseButton: UIButton? //关闭view的按钮
    private var totalPage: NSInteger?
    private var curPage: NSInteger?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.delegate = nil
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(WQBannerView.rollingScrollAction), object: nil)
        SDWebImageManager.sharedManager().cancelForDelegate(self)
    }

    convenience init(frame: CGRect,direction: BannerViewScrollDirection,images: NSArray){
        self.init(frame: frame)

        self.clipsToBounds = true
        self.imagesArray = images
        self.scrollDirection = direction
        self.totalPage = imagesArray!.count
        self.totalCount = self.totalPage
        // 显示的是图片数组里的第一张图片
        // 和数组是+1关系
        self.curPage = 1

        self.scrollView = UIScrollView(frame: self.bounds)
        self.scrollView!.backgroundColor = UIColor.clearColor()
        self.scrollView!.showsHorizontalScrollIndicator = false
        self.scrollView!.showsVerticalScrollIndicator = false
        self.scrollView!.pagingEnabled = true
        self.scrollView!.delegate = self
        self.addSubview(self.scrollView!)

        // 在水平方向滚动
        if scrollDirection == BannerViewScrollDirection.ScrollDirectionLandscape {
            self.scrollView!.contentSize = CGSizeMake(self.scrollView!.frame.size.width * 3, self.scrollView!.frame.size.height)
        }
        else if scrollDirection == BannerViewScrollDirection.ScrollDirectionPortait {
            self.scrollView!.contentSize = CGSizeMake(self.scrollView!.frame.size.width, self.scrollView!.frame.size.height * 3)
        }

        for i in 0 ..< 3 {
            let imageView: UIImageView = UIImageView(frame: self.scrollView!.bounds)
            imageView.userInteractionEnabled = true
            imageView.tag = Banner_StartTag + i
            let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WQBannerView.handleTap(_:)))
            imageView.addGestureRecognizer(singleTap)
            // 水平滚动
            if scrollDirection == BannerViewScrollDirection.ScrollDirectionLandscape {
                imageView.frame = CGRectOffset(imageView.frame, self.scrollView!.frame.size.width * CGFloat(i), 0)
            }
            // 垂直滚动
            else if scrollDirection == BannerViewScrollDirection.ScrollDirectionPortait {
                imageView.frame = CGRectOffset(imageView.frame, 0, self.scrollView!.frame.size.height * CGFloat(i))
            }
            
            self.scrollView!.addSubview(imageView)
        }

        self.pageControl = UIPageControl(frame: CGRectMake(5, frame.size.height - 15, 60, 15))
        self.pageControl!.numberOfPages = self.imagesArray!.count
        self.addSubview(self.pageControl!)
        self.pageControl!.currentPage = 0



    }

    func reloadBannerWithData(images: NSArray) {

        if (self.enableRolling != nil) {
            stopRolling()
        }
        self.imagesArray = images
        self.totalPage = self.imagesArray!.count
        self.totalCount = self.totalPage
        self.curPage = 1
        self.pageControl!.numberOfPages = self.totalPage!
        self.pageControl!.currentPage = 0
        self.startDownloadImage()
    }
    //下载图片方法
    func startDownloadImage() {

        //取消已加入的延迟线程
        if (self.enableRolling != nil) {
            NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(WQBannerView.rollingScrollAction), object: nil)
        }
        SDWebImageManager.sharedManager().cancelForDelegate(self)
        for i in 0 ..< self.imagesArray!.count {
            let dic: NSDictionary = self.imagesArray![i] as! NSDictionary
            let url: String = dic .objectForKey(imageKey!) as! String
            if url.isNotEmpty() {
                SDWebImageManager.sharedManager().downloadWithURL(NSURL(string: url)!, delegate: self)
            }
        }

    }
    /**
     设置图片是否圆角
     */
    func setSquare(asquare: CGFloat) {

        if (self.scrollView != nil) {
            self.scrollView!.layer.cornerRadius = asquare
            if asquare == 0 {
                self.scrollView!.layer.masksToBounds = false
            }
            else {
                self.scrollView!.layer.masksToBounds = true
            }

        }

    }
    //设置PageControl的位置传入enum
    func setPageControlStyle(pageStyle: BannerViewPageStyle) {

        if pageStyle == BannerViewPageStyle.PageStyle_Left {
            self.pageControl!.frame = CGRectMake(5, self.bounds.size.height - 15, 60, 15)
        }
        else if pageStyle == BannerViewPageStyle.PageStyle_Right {
            self.pageControl!.frame = CGRectMake(self.bounds.size.width - 5 - 60, self.bounds.size.height - 15, 60, 15)
        }
        else if pageStyle == BannerViewPageStyle.PageStyle_Middle {
            self.pageControl!.frame = CGRectMake((self.bounds.size.width - 60) / 2, self.bounds.size.height - 15, 60, 15)
        }
        else if pageStyle == BannerViewPageStyle.PageStyle_None {
            self.pageControl!.hidden = true
        }


    }
    //是否显示关完备按钮 YES －－显示 no --不显示
    func showClose(show: Bool) {

        if show {
            if (self.BannerCloseButton == nil) {
                self.BannerCloseButton = UIButton(type: .Custom)
                self.BannerCloseButton!.frame = CGRectMake(self.bounds.size.width - 40, 0, 40, 40)
                self.BannerCloseButton!.contentVerticalAlignment = .Top
                self.BannerCloseButton!.contentHorizontalAlignment = .Right
                self.BannerCloseButton!.addTarget(self, action: #selector(WQBannerView.closeBanner), forControlEvents: .TouchUpInside)
                self.BannerCloseButton!.setImage(UIImage(named: "banner_close"), forState: .Normal)
                self.BannerCloseButton!.exclusiveTouch = true
                self.addSubview(self.BannerCloseButton!)
            }
            self.BannerCloseButton!.hidden = false
        }
        else {
            if self.BannerCloseButton != nil {
                self.BannerCloseButton!.hidden = true
            }
        }

    }
    //关闭按钮的方法
    func closeBanner() {
        self.stopRolling()
        self.delegate?.bannerViewdidClosed(self)

    }

    //刷新ScrollView
    private func refreshScrollView() {

        let curimageUrls: NSArray = self.getDisplayImagesWithPageIndex(self.curPage!)

        for i in 0 ..< 3 {
            let imageView: UIImageView = (self.scrollView!.viewWithTag(Banner_StartTag + i) as! UIImageView)
            let dic: NSDictionary = curimageUrls[i] as! NSDictionary
            let url: String = dic .objectForKey(imageKey!) as! String
                //(dic["img_url"] as! String)
            if url.isNotEmpty() {
                imageView.setImageWithURL(NSURL(string: url)!, placeholderImage: nil)
            }
        }

        // 水平滚动
        if scrollDirection == BannerViewScrollDirection.ScrollDirectionLandscape {
            self.scrollView!.contentOffset = CGPointMake(self.scrollView!.frame.size.width, 0)
        }
        else if scrollDirection == BannerViewScrollDirection.ScrollDirectionPortait {
            self.scrollView!.contentOffset = CGPointMake(0, self.scrollView!.frame.size.height)
        }
        
        self.pageControl!.currentPage = self.curPage! - 1

    }
    //获取pageindex
    private func getPageIndex(index: NSInteger)->NSInteger {

        // value＝1为第一张，value = 0为前面一张
        var pageIndex: NSInteger = index
        if index == 0 {
            pageIndex = self.totalPage!
        }
        if index == self.totalPage! + 1 {
            pageIndex = 1
        }
        return pageIndex

    }

    private func getDisplayImagesWithPageIndex(pageIndex: NSInteger)->NSArray {

        let pre: Int = self.getPageIndex(self.curPage! - 1)
        let last: Int = self.getPageIndex(self.curPage! + 1)
        let images: NSMutableArray = NSMutableArray.init(capacity: 0)
        images.addObject(self.imagesArray![pre - 1])
        images.addObject(self.imagesArray![self.curPage!-1])
        images.addObject(self.imagesArray![last - 1])
        return images

    }

    //UIScrollViewDelegate

    func scrollViewDidScroll(aScrollView: UIScrollView) {
        let x: CGFloat = aScrollView.contentOffset.x
        let y: CGFloat = aScrollView.contentOffset.y
        //NSLog(@"did  x=%d  y=%d", x, y);
        //取消已加入的延迟线程
        if (self.enableRolling != nil) {
            NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(WQBannerView.rollingScrollAction), object: nil)
        }
        // 水平滚动
        if scrollDirection == BannerViewScrollDirection.ScrollDirectionLandscape {
            // 往下翻一张
            if x >= 2 * self.scrollView!.frame.size.width {
                curPage = self.getPageIndex(self.curPage! + 1)
                self.refreshScrollView()
            }
            if x <= 0 {
                curPage = self.getPageIndex(self.curPage! - 1)
                self.refreshScrollView()
            }
        }
        else if scrollDirection == BannerViewScrollDirection.ScrollDirectionPortait {
            // 往下翻一张
            if y >= 2 * self.scrollView!.frame.size.height {
                curPage = self.getPageIndex(self.curPage! + 1)
                self.refreshScrollView()
            }
            if y <= 0 {
                self.curPage! = self.getPageIndex(self.curPage! - 1)
                self.refreshScrollView()
            }

        }

    }

    func scrollViewDidEndDecelerating(aScrollView: UIScrollView) {
        // 水平滚动
        if scrollDirection == BannerViewScrollDirection.ScrollDirectionLandscape {
            self.scrollView!.contentOffset = CGPointMake(scrollView!.frame.size.width, 0)
        }
        else if scrollDirection == BannerViewScrollDirection.ScrollDirectionPortait {
            self.scrollView!.contentOffset = CGPointMake(0, self.scrollView!.frame.size.height)
        }

        if (self.enableRolling != nil) {
            //NSLog(@"scrollViewDidEndDecelerating performSelector");
            NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(WQBannerView.rollingScrollAction), object: nil)
            self.performSelector(#selector(WQBannerView.rollingScrollAction), withObject: nil, afterDelay: self.rollingDelayTime!, inModes: [NSRunLoopCommonModes])
        }
    }

    //mark Rolling


    //开始滚动
    func startRolling() {

        if !self.imagesArray!.isNotEmpty() || self.imagesArray!.count == 1 {
            return
        }
        self.stopRolling()
        self.enableRolling = true
        self.performSelector(#selector(WQBannerView.rollingScrollAction), withObject: nil, afterDelay: self.rollingDelayTime!)

    }
    //停止滚动
    func stopRolling() {

        self.enableRolling = false
        //取消已加入的延迟线程
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(WQBannerView.rollingScrollAction), object: nil)
        
    }

    //滚动方法
    func rollingScrollAction() {

        UIView.animateWithDuration(0.25, animations: {() -> Void in
            // 水平滚动
            if self.scrollDirection == BannerViewScrollDirection.ScrollDirectionLandscape {
                self.scrollView!.contentOffset = CGPointMake(1.99 * self.scrollView!.frame.size.width, 0)
            }
            else if self.scrollDirection == BannerViewScrollDirection.ScrollDirectionPortait {
                self.scrollView!.contentOffset = CGPointMake(0, 1.99 * self.scrollView!.frame.size.height)
            }

            //NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
            }, completion: {(finished: Bool) -> Void in
                if finished {
                    self.curPage = self.getPageIndex(self.curPage! + 1)
                    self.refreshScrollView()
                    if (self.enableRolling != nil) {
                        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(WQBannerView.rollingScrollAction), object: nil)
                        self.performSelector(#selector(WQBannerView.rollingScrollAction), withObject: nil, afterDelay: self.rollingDelayTime!, inModes: [NSRunLoopCommonModes])
                    }
                }
        })

    }

    //SDWebImageManager Delegate 图像下载完成后

    func webImageManager(imageManager: SDWebImageManager, didFinishWithImage image: UIImage) {
        self.totalCount! -= 1
        if self.totalCount == 0 {
            self.curPage = 1
            self.refreshScrollView()
            self.delegate?.imageCachedDidFinish(self)

        }
    }

    //mark action 点击事件
    func handleTap(tap: UITapGestureRecognizer) {

        self.delegate?.bannerView_didSelectImageView_withData(self, index: self.curPage!-1, bannerData: self.imagesArray![self.curPage!-1].objectForKey(imageKey!) as! String, imageid: self.imagesArray![self.curPage!-1].objectForKey(imageId!) as! String)

    }


}
