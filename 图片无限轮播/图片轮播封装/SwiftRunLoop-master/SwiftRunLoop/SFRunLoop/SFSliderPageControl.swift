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
    var pages: Int = 0
    var startPage: Int = 0
    var dotAlpha: CGFloat = 0.5
    var dotMargin: CGFloat = 6.0
    var dotNomalSize: CGSize = CGSize(width: 8, height: 8)
    var dotBigSize: CGSize = CGSize(width: 16, height: 8)
    var currentPageColor: UIColor = UIColor.white
    var normalPageColor: UIColor = UIColor.gray
    var currentPage: Int = 0 {
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
