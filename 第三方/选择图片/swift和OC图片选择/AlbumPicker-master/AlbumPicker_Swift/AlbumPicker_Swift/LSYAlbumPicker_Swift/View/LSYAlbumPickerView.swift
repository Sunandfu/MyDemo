//
//  LSYAlbumPickerView.swift
//  AlbumPicker
//
//  Created by okwei on 15/8/5.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary
//MARK:- LSYAlbumPickerCell
class LSYAlbumPickerCell: UICollectionViewCell {
    var model:LSYAlbumModel!{
        didSet{
            if model.assetType == ALAssetTypeVideo {
                self.bottomView.hidden = false
                self.bottomView.interval = model.asset.valueForProperty(ALAssetPropertyDuration).doubleValue
            }
            else{
                self.bottomView.hidden = true
            }
            
            self.imageView.image = UIImage(CGImage: model.asset.thumbnail().takeUnretainedValue())
        }
    }
    private var imageView:UIImageView!{
        didSet{
            self.addSubview(imageView)
        }
    }
    private var statusView:UIImageView!{
        didSet{
            statusView.image = UIImage(named: "AlbumPicker.bundle/CardPack_Add_UnSelected@2x")
            self.addSubview(statusView)
        }
    }
    private var bottomView:LSYAlbumCellBottomView!{
        didSet{
            bottomView.backgroundColor = UIColor(red: 19.0/255.0, green: 9.0/255.0, blue: 9.0/255.0, alpha: 0.75)
            self.addSubview(bottomView)
        }
        
    }
    private func setup(){
        self.imageView = UIImageView()
        self.statusView = UIImageView()
        self.bottomView = LSYAlbumCellBottomView()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }
    func setupIsSelect(){
        if self.selected {
            self.statusView.image = UIImage(named:"AlbumPicker.bundle/FriendsSendsPicturesSelectYIcon@2x")
            UIView.animateWithDuration(0.15, delay: 0.0, options:UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.statusView.transform = CGAffineTransformMakeScale(0.8, 0.8)
                }, completion: { (finished) -> Void in
                    UIView.animateWithDuration(0.15, delay: 0.0, options:UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                        self.statusView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                        }, completion: { (finished) -> Void in
                            UIView.animateWithDuration(0.15, delay: 0.0, options:UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                                self.statusView.transform = CGAffineTransformIdentity;
                                }, completion: { (finished) -> Void in
                                    
                            })
                    })
            })
        }
        else {
            self.statusView.image = UIImage(named: "AlbumPicker.bundle/CardPack_Add_UnSelected@2x")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = CGRectMake(0, 0, LSYSwiftDefine.ViewSize(self).width, LSYSwiftDefine.ViewSize(self).height)
        self.statusView.frame = CGRectMake(LSYSwiftDefine.ViewSize(self).width-30, 0, 30, 30)
        self.bottomView.frame = CGRectMake(0, LSYSwiftDefine.ViewSize(self).height-20, LSYSwiftDefine.ViewSize(self).width, 20)
    }
}

//MARK:- LSYAlbumCellBottomView
//MARK: Video Tag
class LSYAlbumCellBottomView:UIView{
    var interval:Double = 0{
        didSet{
            var hour:Int = 0
            var minute :Int = 0
            var second :Int = 0
            hour = Int(interval/3600.00)
            minute = Int((interval - Double(3600*hour))/60.00)
            second = Int((interval - Double(3600*hour))%60)
            if hour > 0{
                self.videoTime.text = String(format:"%02d:%02d:%02d", arguments: [hour,minute,second])
            }
            else{
                self.videoTime.text = String(format:"%02d:%02d", arguments: [minute,second])
            }
        }
    }
    private var videoImage:UIImageView!{
        didSet{
            self.addSubview(videoImage)
        }
    }
    private var videoTime:UILabel!{
        didSet{
            videoTime.font = UIFont.systemFontOfSize(14)
            videoTime.textColor = UIColor.whiteColor()
            videoTime.textAlignment = NSTextAlignment.Right
            self.addSubview(videoTime)
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
        self.videoTime = UILabel()
        self.videoImage = UIImageView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.videoImage.frame = CGRectMake(0, 0, 20, LSYSwiftDefine.ViewSize(self).height)
        self.videoTime.frame = CGRectMake(LSYSwiftDefine.ViewOrigin(self.videoImage).x+LSYSwiftDefine.ViewSize(self.videoImage).width, 0, LSYSwiftDefine.ViewSize(self).width-LSYSwiftDefine.ViewSize(self.videoImage).width-5, LSYSwiftDefine.ViewSize(self).height)
    }
    
}
//MARK:- LSYPickerButtomView
protocol LSYPickerButtomViewDelegate:class {
    func previewButtonClick()
    func sendButtonClick()
}
class LSYPickerButtomView: UIView {
    weak var delegate:LSYPickerButtomViewDelegate!
    private var previewButton:UIButton!{
        didSet{
            previewButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            previewButton.setTitleColor(UIColor(red: 168.0/255.0, green: 168.0/255.0, blue: 168.0/255.0, alpha: 1), forState: UIControlState.Disabled)
            previewButton.titleLabel?.font = UIFont.systemFontOfSize(14.0)
            previewButton.setTitle("预览", forState: UIControlState.Normal)
            previewButton.addTarget(self, action: #selector(LSYPickerButtomView.buttonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(previewButton)
        }
    }
    private var sendButton:LSYSendButton!{
        didSet{
            sendButton.setTitle("发送", forState: UIControlState.Normal)
            sendButton.addTarget(self, action: #selector(LSYPickerButtomView.buttonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(sendButton)
        }
    }
    //不能声明私有的方法，否则Selector找不到该方法
    func buttonClick(sender:UIButton){
        if sender == self.previewButton {
            if delegate != nil {
                delegate.previewButtonClick()
            }
        }
        else if sender == self.sendButton {
            if delegate != nil {
                delegate.sendButtonClick()
            }
        }
    }
    func setSendNumber(number:Int){
        self.sendButton.setSendNumber(number)
        if number == 0{
            self.previewButton.enabled = false
        }
        else{
            self.previewButton.enabled = true
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
        self.backgroundColor = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1)
        self.previewButton = UIButton.init(type: UIButtonType.System)
        self.sendButton = LSYSendButton()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.previewButton.frame = CGRectMake(0, 0, 60, LSYSwiftDefine.ViewSize(self).height)
        self.sendButton.frame = CGRectMake(LSYSwiftDefine.ViewSize(self).width-80, 0, 80, LSYSwiftDefine.ViewSize(self).height)
    }
}
//MARK:- LSYSendButton
class LSYSendButton: UIButton {
    
    private var numbersLabel:UILabel!{
        didSet{
            numbersLabel.textColor = UIColor.whiteColor()
            numbersLabel.textAlignment = NSTextAlignment.Center
            numbersLabel.font = UIFont.boldSystemFontOfSize(14.0)
            self.addSubview(numbersLabel)
        }
    }
    private var numbersView:UIView!{
        didSet{
            numbersView.frame = CGRectMake(0, 12, 20, 20)
            numbersView.backgroundColor = UIColor(red: 9.0/255.0, green: 187.0/255.0, blue: 7.0/255.0, alpha: 1)
            numbersView.layer.cornerRadius = 10.0
            numbersView.clipsToBounds = true
            self.addSubview(numbersView)
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
    func setSendNumber(number:Int) {
        if number == 0{
            self.enabled = false
            self.isHiddenNumber(true)
        }
        else{
            self.enabled = true
            self.isHiddenNumber(false)
        }
        self.numbersLabel.text = "\(number)"
        UIView.animateWithDuration(0.1, delay: 0.0, options:UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.numbersView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        }) { (finished) -> Void in
            UIView.animateWithDuration(0.1, delay: 0.0, options:.AllowUserInteraction, animations: { () -> Void in
                self.numbersView.transform = CGAffineTransformMakeScale(1.2, 1.2)
                }) { (finished) -> Void in
                    UIView.animateWithDuration(0.1, delay: 0.0, options:UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                        self.numbersView.transform = CGAffineTransformIdentity
                        }) { (finished) -> Void in
                            
                    }
            }
        }
    }
    private func isHiddenNumber(hidden:Bool){
        self.numbersView.hidden = hidden
        self.numbersLabel.hidden = hidden
    }
    private func setup(){
        self.setTitleColor(UIColor(red: 9.0/255.0, green: 187.0/255.0, blue: 7.0/255.0 , alpha: 1), forState: UIControlState.Normal)
        self.setTitleColor(UIColor(red: 182.0/255.0, green: 225.0/255.0, blue: 187.0/255.0, alpha: 1), forState: UIControlState.Disabled)
        self.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        numbersView = UIView()
        numbersLabel = UILabel()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.numbersLabel.frame = CGRectMake(0, 12, 20, 20)
    }
}