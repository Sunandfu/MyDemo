//
//  CollectionViewVideoCell.swift
//  Alerts&Pickers
//
//  Created by DmitriiBagrov on 16/10/2018.
//  Copyright © 2018 Supreme Apps. All rights reserved.
//

import UIKit

public final class CollectionViewVideoCell: CollectionViewCustomContentCell<UIImageView> {
    
    //MARK: Private Properties
    
    internal var videoIconImageView: UIImageView?
    
    private let videoIconMarginBottom: CGFloat = 15
    private let videoIconMarginLeft: CGFloat = 8.0
    
    internal var videoDurationLabel: UILabel?
    
    private let videoDurationLabelMarginBottom: CGFloat = 20.0
    private let videoDurationLabelMarginRight: CGFloat = 8.0
    private let videoDurationLabelHeight: CGFloat = 15.0
    
    private lazy var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 2
        return formatter
    }()
    
    internal var gradientBackgroundImageView: UIImageView?
    
    private let gradientBackgroundHeight: CGFloat = 16.0
    
    //MARK: Public Methods
    
    public override func setup() {
        super.setup()
        
        setupGradientBackground()
        setupVideoIcon()
        setupVideoDurationLabel()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        videoIconImageView?.frame = CGRect(origin: CGPoint(x: videoIconMarginLeft, y: bounds.maxY - videoIconMarginBottom),
                                           size: videoIconImageView?.bounds.size ?? CGSize.zero)
        videoDurationLabel?.frame = CGRect(origin: CGPoint(x: (bounds.maxX - bounds.width / 2) - videoDurationLabelMarginRight, y: bounds.maxY - videoDurationLabelMarginBottom),
                                           size: CGSize(width: bounds.width / 2, height: videoDurationLabelHeight))
        gradientBackgroundImageView?.frame = CGRect(x: 0, y: bounds.maxY - gradientBackgroundHeight, width: bounds.width, height: gradientBackgroundHeight)
    }
    
    public func updateVideo(duration: TimeInterval) {
        videoDurationLabel?.text = durationFormatter.string(from: duration)
    }
    
}

//MARK: Private Extension CollectionViewVideoCell

private extension CollectionViewVideoCell {
    
    func setupVideoIcon() {
        let bundle = Bundle(for: CollectionViewVideoCell.self)
        videoIconImageView = UIImageView(image: UIImage(named: "video", in: bundle, compatibleWith: nil))
        addSubview(videoIconImageView!)
    }
    
    func setupVideoDurationLabel() {
        videoDurationLabel = UILabel(frame: CGRect.zero)
        videoDurationLabel?.textColor = UIColor.white
        videoDurationLabel?.font = UIFont.systemFont(ofSize: 10.0)
        videoDurationLabel?.textAlignment = .right
        
        addSubview(videoDurationLabel!)
    }
    
    func setupGradientBackground() {
        let bundle = Bundle(for: CollectionViewVideoCell.self)

        gradientBackgroundImageView = UIImageView(image: UIImage(named: "gradient_black_transparent", in: bundle, compatibleWith: nil))
        
        customContentView.addSubview(gradientBackgroundImageView!)
    }
    
}
