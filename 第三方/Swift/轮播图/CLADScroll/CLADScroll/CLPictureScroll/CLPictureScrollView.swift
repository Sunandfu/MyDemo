//
//  CLPictureScrollView.swift
//  CLADScroll
//
//  Created by Darren on 16/8/27.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit
 typealias pictureClickClosure = (HomeAdModel) -> Void

class CLPictureScrollView: UIView {
    var CLMaxSections = 100
    let ID = "picturecell"
    var timer = NSTimer()
    var scrollSecond = 2.0
    var stopAotuScroll = Bool(){
        didSet{
            if stopAotuScroll == true {
                self.stopTimer()
            }
        }
    }
    var pageController = UIPageControl()

    var netPictureClickClosure:pictureClickClosure?
    
    var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewLayout())
    var adArray = [] as NSArray
    var localAdArray = [] as NSArray

    // 本地的图片
    static func showPictureViewWithLocal(rect:CGRect,dataArray:NSArray, cellClick:cellClickClosure) -> UIView {
        let adView:CLPictureScrollView = CLPictureScrollView.init(frame: rect)
        adView.showLocalAdDataWithLocalArray(dataArray,cellClick:cellClick)
        return adView
    }
    private func showLocalAdDataWithLocalArray(dataArray:NSArray, cellClick:cellClickClosure){
        localAdArray = dataArray
        // 创建collectionView
        self.setupCollectionView()
    }

    // 网络图片
    static func showNetPictureViewWithModel(rect:CGRect,dataArray:NSArray, cellClick:cellClickClosure) -> UIView {
        let adView:CLPictureScrollView = CLPictureScrollView.init(frame: rect)
        adView.showAdDataWithModelArray(dataArray,cellClick:cellClick)
        return adView
    }
    private func showAdDataWithModelArray(dataArray:NSArray, cellClick:cellClickClosure){
        netPictureClickClosure = cellClick
        adArray = dataArray
        // 创建collectionView
        self.setupCollectionView()
    }
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .Horizontal
        collectionView = UICollectionView(frame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), collectionViewLayout:layout)
        layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.pagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self;
        collectionView.backgroundColor = UIColor.whiteColor()
        self.addSubview(collectionView)
        
        collectionView.registerClass(CLPictureCell.self, forCellWithReuseIdentifier: ID)
        // 默认显示最中间的那组
        collectionView.scrollToItemAtIndexPath(NSIndexPath.init(forRow: 0, inSection: CLMaxSections/2), atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        
        let pageController = UIPageControl()
        pageController.frame = CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 40)
        var arrayCount = 0
        if adArray.count == 0 {   // 本地图片
            arrayCount = localAdArray.count
        }
        if localAdArray.count == 0 {   // 网络图片
            arrayCount = adArray.count
        }
        pageController.numberOfPages = arrayCount
        pageController.currentPageIndicatorTintColor = UIColor.redColor()
        pageController.pageIndicatorTintColor = UIColor.whiteColor()
        
        if localAdArray.count == 1 || adArray.count == 1 {
            
        } else {
            self.addSubview(pageController)
        }
        self.pageController = pageController
        
        if stopAotuScroll == false {
            self.starTimer()
        }
    }
    
    // MARK:- 开启定时器
    func starTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(scrollSecond, target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    // MARK:- 关闭定时器
    func stopTimer(){
        timer.invalidate()
    }
    
    @objc func nextPage(){
        // 1.马上显示回最中间那组的数据
        let currentIndexPathReset:NSIndexPath = self.resetIndexPath()
        // 2.计算出下一个需要展示的位置
        var nextItem:Int = currentIndexPathReset.item + 1
        var nextSection:Int = currentIndexPathReset.section
        
        if localAdArray.count==0 {
            if nextItem == adArray.count {
                nextItem = 0
                nextSection += 1
            }
        } else {
            if nextItem == localAdArray.count {
                nextItem = 0
                nextSection += 1
            }
        }
        
        let nextIndexPath = NSIndexPath.init(forItem: nextItem, inSection: nextSection)
        //3.通过动画滚动到下一个位置
        collectionView.scrollToItemAtIndexPath(nextIndexPath, atScrollPosition: .Left, animated: true)
    }
    
    func resetIndexPath() -> NSIndexPath{
        let itemArr = collectionView.indexPathsForVisibleItems() as NSArray
        // 当前正在展示的位置
        let currentIndexPath = itemArr.lastObject
        
        // 马上显示回最中间那组的数据
        let currentIndexPathReset:NSIndexPath = NSIndexPath.init(forItem: (currentIndexPath!.item), inSection: CLMaxSections/2)
        collectionView .scrollToItemAtIndexPath(currentIndexPathReset, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        return currentIndexPathReset
    }
    
}

//MARK : - UICollectionViewDataSource
extension CLPictureScrollView:UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return CLMaxSections
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if localAdArray.count != 0 {
            return localAdArray.count
        } else {
            return adArray.count
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ID, forIndexPath: indexPath) as! CLPictureCell
        if localAdArray.count != 0 {
            cell.localPictureStr = localAdArray[indexPath.row] as! String
        }
        
        // 网络图片
        if adArray.count != 0 {
            cell.model = adArray[indexPath.row] as! HomeAdModel
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 网络图片
        if adArray.count != 0 {
            let model = adArray[indexPath.row] as! HomeAdModel
            self.netPictureClickClosure!(model)
        }
    }
}

extension CLPictureScrollView:UIScrollViewDelegate{
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.stopTimer()
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if stopAotuScroll == false {
            self.starTimer()
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        var arrayCount = 0
        if adArray.count == 0 {   // 本地图片
            arrayCount = localAdArray.count
        }
        if localAdArray.count == 0 {   // 网络图片
            arrayCount = adArray.count
        }

        let page = Int(scrollView.contentOffset.x/scrollView.bounds.size.width+0.5)%(arrayCount)
        self.pageController.currentPage = page
    }
}

