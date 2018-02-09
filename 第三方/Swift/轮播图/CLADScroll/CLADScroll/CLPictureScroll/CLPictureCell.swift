//
//  CLPictureCell.swift
//  CLADScroll
//
//  Created by Darren on 16/8/27.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class CLPictureCell: UICollectionViewCell {
    
    var model = HomeAdModel(dict:[:]) {
        didSet{
            let url = NSURL(string:model.Path!)
            
            if let url = url {
//                pictureView.kf_setImageWithURL(url, placeholderImage: UIImage(named: ""), optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
//                })
                pictureView.image = UIImage.init(data: NSData.init(contentsOfURL: url)!)
            }
        }
    }
    var localPictureStr = String() {
        didSet{
            pictureView.image = UIImage(named: localPictureStr)
        }
    }
    private lazy var pictureView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pictureView.frame = self.bounds
        pictureView.userInteractionEnabled = true

        self.contentView.addSubview(pictureView)
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
