//
//  BSCycleImagesCollectionCell.swift
//  VehicleGroup
//
//  Created by 张亚东 on 16/5/4.
//  Copyright © 2016年 doyen. All rights reserved.
//

import UIKit

class BSCycleImagesCollectionCell: UICollectionViewCell {
    
    var cycleImage: UIImage! {
        didSet {
            imgView.image = cycleImage
        }
    }
    
    lazy var imgView: UIImageView = {
        let imgView: UIImageView = UIImageView(frame: self.bounds)
        imgView.contentMode = .ScaleAspectFill
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.frame = bounds
    }
}

extension BSCycleImagesCollectionCell {
    
    func setup() {
        addSubview(imgView)
    }
}
