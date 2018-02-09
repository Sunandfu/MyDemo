//
//  CLAdView.swift
//  CLADScroll
//
//  Created by Darren on 16/8/27.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit
typealias cellClickClosure = (HomeAdModel) -> Void

class CLAdView: UIView {
    var CLMaxSections = 100
    let ID = "adcell"
    var timer = NSTimer()
    var scrollSecond = 2.0
    
    var adClickClosure:cellClickClosure?

    var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewLayout())
    var adArray = [] as NSArray
    
    static func showAdView(rect:CGRect,dataArray:NSArray, cellClick:cellClickClosure) -> UIView {

        let adView:CLAdView = CLAdView.init(frame: rect)
        adView.showAdDataWithModelArray(dataArray,cellClick:cellClick)
        return adView
    }
    
    private func showAdDataWithModelArray(dataArray:NSArray, cellClick:cellClickClosure){
        adClickClosure = cellClick
        adArray = dataArray
        // 创建collectionView
        self.setupCollectionView()
    }
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        collectionView = UICollectionView(frame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), collectionViewLayout:layout)
        layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.pagingEnabled = true
        collectionView.scrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self;
        collectionView.backgroundColor = UIColor.whiteColor()
        self.addSubview(collectionView)
        
        collectionView.registerClass(CLAdCell.self, forCellWithReuseIdentifier: ID)
        // 默认显示最中间的那组
        collectionView.scrollToItemAtIndexPath(NSIndexPath.init(forRow: 0, inSection: CLMaxSections/2), atScrollPosition: UICollectionViewScrollPosition.Top, animated: false)
        
        self.starTimer()
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
        
        if nextItem == adArray.count {
            nextItem = 0
            nextSection += 1
        }
        
        let nextIndexPath = NSIndexPath.init(forItem: nextItem, inSection: nextSection)
        //3.通过动画滚动到下一个位置
        collectionView.scrollToItemAtIndexPath(nextIndexPath, atScrollPosition: .Top, animated: true)
    }
    
    func resetIndexPath() -> NSIndexPath{
        let itemArr = collectionView.indexPathsForVisibleItems() as NSArray
        // 当前正在展示的位置
        let currentIndexPath = itemArr.lastObject

        // 马上显示回最中间那组的数据
        let currentIndexPathReset:NSIndexPath = NSIndexPath.init(forItem: (currentIndexPath!.item), inSection: CLMaxSections/2)
        collectionView .scrollToItemAtIndexPath(currentIndexPathReset, atScrollPosition: UICollectionViewScrollPosition.Top, animated: false)
        return currentIndexPathReset
    }

}

//MARK : - UICollectionViewDataSource
extension CLAdView:UICollectionViewDelegate,UICollectionViewDataSource {
func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return CLMaxSections
}
func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return adArray.count
}
func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ID, forIndexPath: indexPath) as! CLAdCell
    cell.modelArray = adArray[indexPath.row] as! Array<HomeAdModel>
    cell.lableClickClosure = {(model:HomeAdModel) in
        self.adClickClosure!(model)
    }
    return cell
}
}


