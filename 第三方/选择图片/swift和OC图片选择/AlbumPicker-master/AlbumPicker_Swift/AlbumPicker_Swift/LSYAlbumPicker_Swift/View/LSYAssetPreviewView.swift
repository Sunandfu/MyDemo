//
//  LSYAssetPreviewView.swift
//  AlbumPicker
//
//  Created by okwei on 15/8/6.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary
protocol LSYAssetPreviewNavBarDelegate:class{
    func selectButtonClick(selectButton:UIButton)->Void
    func backButtonClick(backButton:UIButton)->Void
}
protocol LSYAssetPreviewToolBarDelegate:class{
    func sendButtonClick(sendButton:UIButton)->Void
}
class LSYAssetPreviewNavBar: UIView {
    var selectButton:UIButton!{
        didSet{
            selectButton.setImage(UIImage(named: "AlbumPicker.bundle/FriendsSendsPicturesSelectBigNIcon@2x"), forState: UIControlState.Normal)
            selectButton.setImage(UIImage(named: "AlbumPicker.bundle/FriendsSendsPicturesSelectBigYIcon@2x"), forState: UIControlState.Selected)
            selectButton.selected = true
            selectButton.addTarget(self, action: #selector(LSYAssetPreviewNavBar.buttonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(selectButton)
        }
    }
    weak var delegate:LSYAssetPreviewNavBarDelegate!
    private var backButton:UIButton!{
        didSet{
            backButton.setImage(UIImage(named: "AlbumPicker.bundle/barbuttonicon_back"), forState: UIControlState.Normal)
            backButton.addTarget(self, action: #selector(LSYAssetPreviewNavBar.buttonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(backButton)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup();
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup();
    }
    private func setup(){
        self.selectButton = UIButton()
        self.backButton = UIButton()

    }
    func buttonClick(sender:UIButton){
        if sender == self.selectButton{
            if self.delegate != nil {
                self.delegate.selectButtonClick(sender)
            }
        }
        else if sender == self.backButton{
            self.delegate.backButtonClick(sender)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectButton.frame = CGRectMake(LSYSwiftDefine.ViewSize(self).width-60, (LSYSwiftDefine.ViewSize(self).height-40)/2, 60, 40)
        self.backButton.frame = CGRectMake(0, (LSYSwiftDefine.ViewSize(self).height-40)/2, 40, 40)
    }
}
class LSYAssetPreviewToolBar: UIView {
    weak var delegate:LSYAssetPreviewToolBarDelegate!
    private var sendButton:LSYSendButton!{
        didSet{
            sendButton.setTitle("发送", forState: UIControlState.Normal)
            sendButton.addTarget(self, action: #selector(LSYAssetPreviewNavBar.buttonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(sendButton)
        }
    }
    func buttonClick(sender:UIButton){
        if sender == self.sendButton{
            if self.delegate != nil{
                self.delegate.sendButtonClick(sender)
            }
        }
    }
    func setSendNumber(number:Int){
        self.sendButton.setSendNumber(number)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }
    func setup(){
        self.sendButton = LSYSendButton()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.sendButton.frame = CGRectMake(LSYSwiftDefine.ViewSize(self).width-80, 0, 80, LSYSwiftDefine.ViewSize(self).height)
    }
}
//MARK:-
//MARK:LSYAssetPreviewItem
protocol LSYAssetPreviewItemDelegate:class{
    func hiddenBarControl()->Void
}

class LSYAssetPreviewItem: UIView {
    
    weak var delegate:LSYAssetPreviewItemDelegate!
    var asset:ALAsset!{
        didSet{
            assetImageView.image = UIImage(CGImage: asset.defaultRepresentation().fullResolutionImage().takeUnretainedValue())
            let imageViewHeight:CGFloat = (assetImageView.image?.size.height)! / (assetImageView.image?.size.width)! * previewScrollView.frame.size.width
            let imageViewWidth = previewScrollView.frame.size.width
            assetImageView.frame = CGRectMake(0, 0, imageViewWidth, imageViewHeight)
            assetImageView.center = CGPointMake(assetImageView.center.x, CGRectGetMidY(self.previewScrollView.frame))
        }
    }
    var previewScrollView:UIScrollView!{
        didSet{
            previewScrollView.center = CGPointMake(previewScrollView.center.x, CGRectGetMidY(self.frame))
            previewScrollView.delegate = self
            previewScrollView.showsHorizontalScrollIndicator = false
            previewScrollView.showsVerticalScrollIndicator = false
            previewScrollView.minimumZoomScale = 1.0
            previewScrollView.maximumZoomScale = 2.0
            self.addSubview(previewScrollView)
        }
    }
   
     var assetImageView:UIImageView!{
        didSet{
            self.previewScrollView.addSubview(assetImageView)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }
    private func setup(){
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LSYAssetPreviewItem.hiddenBar)))
        self.previewScrollView = UIScrollView(frame: CGRectMake(10, 0, LSYSwiftDefine.ViewSize(self).width-20, LSYSwiftDefine.ViewSize(self).height))
        self.assetImageView = UIImageView()
        
    }
    func hiddenBar(){
        if self.delegate != nil {
            self.delegate.hiddenBarControl()
        }
    }
}