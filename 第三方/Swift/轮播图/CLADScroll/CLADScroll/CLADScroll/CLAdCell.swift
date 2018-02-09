//
//  CLAdCell.swift
//  CLADScroll
//
//  Created by Darren on 16/8/27.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit
typealias cellLableClickClosure = (HomeAdModel) -> Void

class CLAdCell: UICollectionViewCell {
    
    var lableClickClosure:cellLableClickClosure?
    
    var modelArray:Array<HomeAdModel> = [] {
        didSet{
            let model = modelArray[0]
            titleBtn1.setTitle(model.Title2, forState: .Normal)
            contentLable1.text = model.Title
            
            let model2 = modelArray[1]
            titleBtn2.setTitle(model2.Title2, forState: .Normal)
            contentLable2.text = model2.Title
        }
    }
    
    private lazy var titleBtn1 = UIButton()
    private lazy var titleBtn2 = UIButton()
    private lazy var contentLable1 = UILabel()
    private lazy var contentLable2 = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleBtn1.frame = CGRectMake(10, 15, 30, 15)
        titleBtn1.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        titleBtn1.layer.cornerRadius = 3
        titleBtn1.layer.borderWidth = 1
        titleBtn1.layer.borderColor = UIColor.orangeColor().CGColor
        titleBtn1.titleLabel?.font = UIFont.systemFontOfSize(10)
        self.contentView.addSubview(titleBtn1)
        
        titleBtn2.frame = CGRectMake(10, 35, 30, 15)
        titleBtn2.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        titleBtn2.layer.cornerRadius = 3
        titleBtn2.layer.borderWidth = 1
        titleBtn2.layer.borderColor = UIColor.orangeColor().CGColor
        titleBtn2.titleLabel?.font = UIFont.systemFontOfSize(10)
        self.contentView.addSubview(titleBtn2)
        
        contentLable1.frame = CGRectMake(CGRectGetMaxX(titleBtn1.frame)+5, 15, self.contentView.frame.size.width-CGRectGetMaxX(titleBtn1.frame)+5, 15)
        contentLable1.font = UIFont.systemFontOfSize(12)
        contentLable1.userInteractionEnabled = true
        contentLable1.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(CLAdCell.clickContentLable1)))

        self.contentView.addSubview(contentLable1)
        contentLable2.frame = CGRectMake(CGRectGetMaxX(titleBtn1.frame)+5, 35, self.contentView.frame.size.width-CGRectGetMaxX(titleBtn1.frame)+5, 15)
        contentLable2.font = UIFont.systemFontOfSize(12)
        contentLable2.userInteractionEnabled = true
        contentLable2.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(CLAdCell.clickContentLable2)))

        self.contentView.addSubview(contentLable2)
        
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func clickContentLable1(){
        let model = modelArray[0]
        lableClickClosure!(model)
    }
    @objc private func clickContentLable2(){
        let model = modelArray[1]
        lableClickClosure!(model)
    }

}
