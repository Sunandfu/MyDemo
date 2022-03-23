//
//  SFPageControl.swift
//  SwiftRunLoop
//
//  Created by lurich on 2022/1/21.
//

import Foundation
import UIKit

class SFAnimatedDotView: UIView {
    var dotColor: UIColor {
        didSet {
            layer.borderColor = dotColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        dotColor = UIColor.white
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        layer.masksToBounds = true
        layer.cornerRadius = frame.size.width / 2.0
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeActivityState(_ active: Bool) {
        if active {
            animateToActiveState()
        } else {
            animateToDeactiveState()
        }
    }
    
    func animateToActiveState() {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveLinear) { [self] in
            self.backgroundColor = self.dotColor
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }
    }
    
    func animateToDeactiveState() {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveLinear) { [self] in
            self.backgroundColor = UIColor.clear
            self.transform = .identity
        }
    }
}

class SFPageControl: UIControl {
    var dotView: SFAnimatedDotView?
    var dotImage: UIImage? {
        didSet {
            if self.dotImage != nil {
                self.dotSize = self.dotImage!.size
            }
            self.dotView = nil
        }
    }
    var currentDotImage: UIImage? {
        didSet {
            self.dotView = nil
        }
    }
    var dotSize: CGSize
    var dotColor: UIColor? 
    var spacingBetweenDots: Double
    var numberOfPages: Int
    var currentPage: Int {
        willSet {
            if self.numberOfPages == 0 {
                return
            }
            change(activity: false, atIndex: self.currentPage)
        }
        didSet {
            if self.numberOfPages == 0 {
                return
            }
            change(activity: true, atIndex: self.currentPage)
        }
    }
    var dots: Array<UIView>
    
    override init(frame: CGRect) {
        dotView = SFAnimatedDotView()
        dotSize = CGSize(width: 8, height: 8)
        dotColor = UIColor.white
        spacingBetweenDots = 8.0
        numberOfPages = 0
        currentPage = 0
        dots = [UIView]()
        super.init(frame: frame)
        contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animatedPageSize() -> CGSize {
        CGSize(width: (self.dotSize.width + self.spacingBetweenDots) * Double(self.numberOfPages) - self.spacingBetweenDots, height: self.dotSize.height)
    }
    
    func updateDots() {
        if self.numberOfPages == 0 {
            return
        }
        for i in 0..<self.numberOfPages {
            var dot: UIView
            if i < self.dots.count {
                dot = self.dots[i]
            } else {
                dot = generateDotView()
            }
            updateDot(frame: dot, atIndex: i)
        }
        change(activity: true, atIndex: self.currentPage)
    }
    
    func updateFrame() {
        let requiredSize = animatedPageSize()
        self.frame = CGRect(origin: self.frame.origin, size: requiredSize)
        resetDotViews()
    }
    
    func updateDot(frame dot: UIView, atIndex index: Int) {
        let x = (self.dotSize.width + self.spacingBetweenDots) * Double(index) + (self.frame.size.width - animatedPageSize().width) / 2.0
        let y = (self.frame.size.height - self.dotSize.height) / 2.0
        dot.frame = CGRect(origin: CGPoint(x: x, y: y), size: self.dotSize)
    }
    
    func generateDotView() -> UIView {
        var dotView: UIView
        if self.dotView != nil {
            dotView = SFAnimatedDotView(frame: CGRect(origin: .zero, size: self.dotSize))
            if self.dotColor != nil {
                (dotView as! SFAnimatedDotView).dotColor = self.dotColor!
            }
        } else {
            dotView = UIImageView(frame: CGRect(origin: .zero, size: self.dotSize))
            (dotView as! UIImageView).image = self.dotImage
            dotView.contentMode = .scaleAspectFit
        }
        self.addSubview(dotView)
        self.dots.append(dotView)
        dotView.isUserInteractionEnabled = true
        return dotView
    }
    
    func change(activity active: Bool, atIndex index: Int) {
        if self.dotView != nil {
            let abstractDotView = self.dots[index] as! SFAnimatedDotView
            abstractDotView.changeActivityState(active)
        } else if (self.dotImage != nil && self.currentDotImage != nil) {
            let dotView = self.dots[index] as! UIImageView
            dotView.image = active ? self.currentDotImage : self.dotImage
        }
    }
    
    func resetDotViews() {
        for dotView in self.dots {
            dotView.removeFromSuperview()
        }
        self.dots.removeAll()
        updateDots()
    }
}
