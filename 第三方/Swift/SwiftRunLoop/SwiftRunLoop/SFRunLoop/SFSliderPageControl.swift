//
//  SFSliderPageControl.swift
//  SwiftRunLoop
//
//  Created by lurich on 2022/1/21.
//

import Foundation
import UIKit

class SFSliderPageControl: UIView {
    var pageDots = [UIView]()
    var pages: Int
    var startPage: Int
    var dotAlpha: CGFloat
    var dotMargin: CGFloat
    var dotNomalSize: CGSize
    var dotBigSize: CGSize
    var currentPageColor: UIColor
    var normalPageColor: UIColor 
    var currentPage: Int {
        didSet {
            let dotNomalWidth = self.dotNomalSize.width, dotNomalHeight = self.dotNomalSize.height, dotBigWidth    = self.dotBigSize.width, dotBigHeight   = self.dotBigSize.height
            UIView.animate(withDuration: 1.0) {
                for i in 0..<self.pages {
                    if self.currentPage == i {
                        self.pageDots[i].frame = CGRect(x: CGFloat(i) * (dotNomalWidth + self.dotMargin), y: 0, width: dotBigWidth, height: dotBigHeight)
                        self.pageDots[i].backgroundColor = self.currentPageColor
                    } else {
                        if i < self.currentPage {
                            self.pageDots[i].frame = CGRect(x: CGFloat(i) * (dotNomalWidth + self.dotMargin), y: 0, width: dotNomalWidth, height: dotNomalHeight)
                        } else {
                            self.pageDots[i].frame = CGRect(x: (dotBigWidth - dotNomalWidth) + CGFloat(i) * (dotNomalWidth + self.dotMargin), y: 0, width: dotNomalWidth, height: dotNomalHeight)
                        }
                        self.pageDots[i].backgroundColor = self.normalPageColor
                    }
                }
            }
        }
    }
    override init(frame: CGRect) {
        dotNomalSize = CGSize(width: 8, height: 8)
        dotBigSize = CGSize(width: 16, height: 8)
        dotMargin = 6
        startPage = 0
        dotAlpha = 0.5
        currentPageColor = UIColor.white
        normalPageColor = UIColor.gray
        currentPage = 0
        pages = 0
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sliderPageSize() -> CGSize {
        CGSize(width: (self.dotNomalSize.width + self.dotMargin) * Double(pages) - self.dotMargin + self.dotBigSize.width - self.dotNomalSize.width, height: self.dotNomalSize.height)
    }
    
    func updateColor() {
        if pages == 0 {
            return
        }
        self.pageDots.removeAll()
        let dotNomalWidth = self.dotNomalSize.width, dotNomalHeight = self.dotNomalSize.height, dotBigWidth    = self.dotBigSize.width, dotBigHeight   = self.dotBigSize.height
        for i in 0..<self.pages {
            let dotView = UIView()
            if 0 == i {
                dotView.frame = CGRect(x: 0, y: 0, width: dotBigWidth, height: dotBigHeight)
                dotView.layer.cornerRadius = dotView.frame.size.height / 2.0
                dotView.alpha = self.dotAlpha
                dotView.backgroundColor = self.currentPageColor
            } else {
                dotView.frame = CGRect(x: (dotBigWidth - dotNomalWidth ) + CGFloat(i) * (self.dotMargin + dotNomalWidth), y: 0, width: dotNomalWidth, height: dotNomalHeight)
                dotView.layer.cornerRadius = dotView.frame.size.height / 2.0
                dotView.alpha = self.dotAlpha
                dotView.backgroundColor = self.normalPageColor
            }
            self.addSubview(dotView)
            self.pageDots.append(dotView)
        }
    }
}
