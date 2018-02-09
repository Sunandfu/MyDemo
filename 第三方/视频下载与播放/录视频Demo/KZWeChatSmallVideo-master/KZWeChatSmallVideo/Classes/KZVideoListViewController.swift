//
//  KZVideoListViewController.swift
//  KZWeChatSmallVideo
//
//  Created by HouKangzhu on 16/7/15.
//  Copyright © 2016年 侯康柱. All rights reserved.
//

import UIKit

class KZCircleCloseBtn: UIButton {
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.layer.backgroundColor = UIColor.whiteColor().CGColor
        self.layer.cornerRadius = self.bounds.width/2
        self.layer.masksToBounds = true
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetAllowsAntialiasing(context, true)
        CGContextSetStrokeColorWithColor(context, kzThemeBlackColor.CGColor)
        CGContextSetLineWidth(context, 1.0)
        CGContextSetLineCap(context, .Round);
        
        let selfCent = CGPointMake(self.bounds.width/2, self.bounds.height/2)
        let closeWidth:CGFloat = 8.0

        CGContextMoveToPoint(context, selfCent.x-closeWidth/2, selfCent.y - closeWidth/2)
        CGContextAddLineToPoint(context, selfCent.x + closeWidth/2, selfCent.y + closeWidth/2)
        
        CGContextMoveToPoint(context, selfCent.x-closeWidth/2, selfCent.y + closeWidth/2)
        CGContextAddLineToPoint(context, selfCent.x + closeWidth/2, selfCent.y - closeWidth/2)
        
        CGContextDrawPath(context, .Stroke)
    }
}

private class KZVideoListCell: UICollectionViewCell {
    
    private let thumImage:UIImageView = UIImageView()
    private var model:KZVideoModel? = nil
    private let closeBtn = KZCircleCloseBtn(type:.Custom)
    var deleteVideoBlock:((KZVideoModel) -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.thumImage.frame = CGRectMake(4, 4, self.bounds.width - 8, self.bounds.height - 8)
        self.thumImage.layer.cornerRadius = 8.0
        self.thumImage.layer.masksToBounds = true
        self.contentView.addSubview(self.thumImage)
        
        self.closeBtn.frame = CGRectMake(0, 0, 22, 22)
        self.closeBtn.addTarget(self, action: #selector(deleteAction), forControlEvents: .TouchUpInside)
        self.contentView.addSubview(self.closeBtn)
        self.closeBtn.hidden = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(newModel:KZVideoModel) {
        self.model = newModel
        self.thumImage.image = UIImage(contentsOfFile: newModel.totalThumPath!)
    }
    
    func setEdit(edit:Bool) {
        self.closeBtn.hidden = !edit
    }
    
    @objc func deleteAction() {
        self.deleteVideoBlock?(self.model!)
    }

}

private class KZAddNewVideoCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    func setupView() {
        let bgLayer = CALayer()
        bgLayer.frame = CGRectMake(4, 4, self.bounds.width - 8, self.bounds.height - 8)
        bgLayer.backgroundColor = UIColor ( red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3 ).CGColor
        bgLayer.cornerRadius = 8.0
        bgLayer.masksToBounds = true
        self.contentView.layer.addSublayer(bgLayer)
        
        let selfCent = CGPointMake(bgLayer.bounds.width/2, bgLayer.bounds.height/2)
        let len:CGFloat = 20
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, selfCent.x, selfCent.y - len)
        CGPathAddLineToPoint(path, nil, selfCent.x, selfCent.y + len)
        
        CGPathMoveToPoint(path, nil, selfCent.x - len, selfCent.y)
        CGPathAddLineToPoint(path, nil, selfCent.x + len, selfCent.y)
        
        let crossLayer = CAShapeLayer()
        crossLayer.fillColor = UIColor.clearColor().CGColor
        crossLayer.strokeColor = kzThemeGraryColor.CGColor
        crossLayer.lineWidth = 4.0
        crossLayer.path = path
        crossLayer.opacity = 1.0
        bgLayer.addSublayer(crossLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private var currentListVC:KZVideoListViewController? = nil

class KZVideoListViewController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {

    var selectBlock:((KZVideoListViewController,KZVideoModel) -> (Void))? = nil
    
    
    let actionView:UIView = UIView()
    private var collection:UICollectionView! = nil
    private let titleLabel:UILabel! = UILabel()
    
    private let leftBtn:KZCloseBtn = KZCloseBtn(type: .Custom)
    private let rightBtn = UIButton(type: .Custom)
    private let videoInfoLabel = UILabel()
    
    private var dataArr:[KZVideoModel]! = nil
    
    //MARK: - public Func
    func showAniamtion() {
        self.setupSupViews()
        currentListVC = self
        let keyWindow = UIApplication.sharedApplication().delegate?.window!
        self.actionView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.6, 1.6)
        self.actionView.alpha = 0.0
        keyWindow?.addSubview(self.actionView)
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: { 
            self.actionView.transform = CGAffineTransformIdentity
            self.actionView.alpha = 1.0
            }) { (finished) in
                
        }
        self.setupCollectionView()
    }
   private func closeAnimation() {
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.actionView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, self.actionView.bounds.width)
            self.actionView.alpha = 0.0
        }) { (finished) in
            self.actionView.removeFromSuperview()
            currentListVC = nil
        }
        
    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.clearColor()
//        self.setupSupViews()
//    }
    
    private func setupSupViews() {
        self.actionView.frame = viewFrame
        self.actionView.backgroundColor = kzThemeBlackColor
//        self.view.addSubview(self.actionView)
        
        self.titleLabel.frame = CGRectMake(0, 0, self.actionView.frame.width, 40)
        self.titleLabel.textColor = kzThemeGraryColor
        self.titleLabel.textAlignment = .Center
        self.titleLabel.font = UIFont.boldSystemFontOfSize(16.0)
        self.titleLabel.text = "小视频"
        self.actionView.addSubview(self.titleLabel)
        
        self.leftBtn.frame = CGRectMake(0, 0, 60, 40)
        self.leftBtn.color = kzThemeTineColor
        self.leftBtn.addTarget(self, action: #selector(closeViewAction), forControlEvents: .TouchUpInside)
        self.actionView.addSubview(self.leftBtn)
        self.leftBtn.setNeedsDisplay()

        self.rightBtn.frame = CGRectMake(self.actionView.frame.width - 60, 0, 60, 40)
        self.rightBtn.setTitle("编辑", forState: .Normal)
        self.rightBtn.setTitle("完成", forState: .Selected)
        self.rightBtn.setTitleColor(kzThemeTineColor, forState: .Normal)
        self.rightBtn.setTitleColor(kzThemeTineColor, forState: .Selected)
        self.rightBtn.addTarget(self, action: #selector(editVideosAction), forControlEvents: .TouchUpInside)
        self.actionView.addSubview(self.rightBtn)
        
    }

    private func setupCollectionView() {
        self.dataArr = KZVideoUtil.getSortVideoList()
        
        let itemWidth = (self.actionView.frame.width - 40)/3
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSizeMake(itemWidth, itemWidth/3*2)
        layout.sectionInset = UIEdgeInsetsMake(10, 8, 10, 8)
        self.collection = UICollectionView(frame: CGRectMake(0, self.titleLabel.frame.maxY, self.actionView.frame.width, self.actionView.frame.height - self.titleLabel.frame.height), collectionViewLayout: layout)
        self.collection.delegate = self
        self.collection.dataSource = self
        self.collection.registerClass(KZVideoListCell.classForCoder(), forCellWithReuseIdentifier: "Cell")
        self.collection.registerClass(KZAddNewVideoCell.classForCoder(), forCellWithReuseIdentifier: "AddCell")
        self.collection.backgroundColor = UIColor.clearColor()
        self.actionView.addSubview(self.collection)
    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    func closeViewAction() {
        self.closeAnimation()
    }
    
    func editVideosAction() {
        self.rightBtn.selected = !self.rightBtn.selected
        self.collection.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.rightBtn.selected {
            return self.dataArr.count
        }
        else {
            return self.dataArr.count+1
        }
    }

   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.item == self.dataArr.count {
            let addCell = collectionView.dequeueReusableCellWithReuseIdentifier("AddCell", forIndexPath: indexPath)
            return addCell
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! KZVideoListCell
        let model = self.dataArr[indexPath.item]
        cell.setModel(model)
        cell.setEdit(self.rightBtn.selected)
        cell.deleteVideoBlock = { cellModel in
            
            let cellIndexPath = NSIndexPath(forItem: self.dataArr.indexOf(cellModel)!, inSection: 0)
            self.dataArr.removeAtIndex(cellIndexPath.item)
            collectionView.deleteItemsAtIndexPaths([cellIndexPath])
            KZVideoUtil.deletefile(model.totalVideoPath)
            
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == self.dataArr.count { // add NewVideo
            self.closeAnimation()
        }
        else {
            self.selectBlock?(self, self.dataArr[indexPath.item])
            self.closeAnimation()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
