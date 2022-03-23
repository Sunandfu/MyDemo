//
//  SFRunLoopView.swift
//  SwiftRunLoop
//
//  Created by lurich on 2022/1/18.
//

import Foundation
import UIKit

protocol SFFocusImageDelegate: NSObjectProtocol {
    
    func tap(_ index: Int)
    
    func loop(_ index: Int)
    
}

class SFRunLoopView: UIView, UIScrollViewDelegate {
    public enum SFPageContolAliment {
        case center         //中下(默认)
        case right          //右下
        case left           //左下
    }
    public enum SFPageStyle {
        case classic        // 系统自带经典样式（默认）
        case animated       // 动画效果(支持图片)
        case horizontal     // 水平动态滑块
        case none           // 不显示pagecontrol
    }
    public enum SFChangeMode {
        case loop           //轮播滚动(默认)
        case fade           //淡入淡出
    }
    
    // MARK: - 公开属性
    public var changeMode: SFChangeMode
    public var pageControlStyle: SFPageStyle
    public var pageControlAliment: SFPageContolAliment
    /// 仅在animated模式下支持图片
    public var currentPageDotImage: UIImage?
    public var pageDotImage: UIImage?
    public var currentPageDotColor: UIColor
    public var pageDotColor: UIColor
    public var pageControlDotSize: CGSize
    public var pageOffset: CGPoint
    /// 时间必须大于1秒
    public var time: Double
    public var showPageControl: Bool
    public var hidesForSinglePage: Bool
    public weak var delegate: SFFocusImageDelegate?
    
    
    // MARK: - 私有属性
    private var viewArray: Array = [UIView]()
    private var scrollView: UIScrollView
    private var currView: UIView
    private var otherView: UIView
    private var currIndex: Int
    private var nextIndex: Int
    private var timer: Timer?
    private var pageControl: UIView?
    
    override init(frame: CGRect) {
        changeMode = .loop
        pageControlStyle = .classic
        pageControlAliment = .center
        currentPageDotColor = .white
        pageDotColor = .lightGray
        pageControlDotSize = CGSize(width: 8, height: 8)
        pageOffset = CGPoint(x: 0, y: 5)
        time = 5.0
        showPageControl = true
        hidesForSinglePage = true
        
        currIndex = 0
        nextIndex = 0
        
        self.currView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size))
        self.currView.clipsToBounds = true
        self.otherView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size))
        self.otherView.clipsToBounds = true
        self.scrollView = UIScrollView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size))
        self.scrollView.scrollsToTop = false
        self.scrollView.isPagingEnabled = true
        self.scrollView.bounces = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        super.init(frame: frame)
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.currView)
        self.scrollView.addSubview(self.otherView)
        self.scrollView.delegate = self
        self.scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageClick)))
    }
    
    convenience init(frame: CGRect, del: SFFocusImageDelegate) {
        self.init(frame: frame)
        self.delegate = del
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadViews(_ views: Array<UIView>) {
        if views.count == 0 {
            return
        }
        self.viewArray = views
        setViewForArray()
    }
    
    public func getImageViews(_ urls: Array<String>, bounds: CGRect) -> Array<UIView> {
        var views = [UIView]()
        for url in urls {
            let imgView = UIImageView(frame: bounds)
            if let Url = URL(string: url), let data = NSData(contentsOf: Url) {
                imgView.image = UIImage(data: data as Data)
                views.append(imgView)
            }
        }
        return views
    }
    
    private func getShowView(backView: UIView) -> UIView {
        return backView.viewWithTag(1438) ?? backView
    }
    
    private func replaceView(backView: UIView, addView: UIView) {
        for view in backView.subviews {
            view.removeFromSuperview()
        }
        addView.tag = 1438
        backView.addSubview(addView)
    }
    
    private func layoutAllViews() {
        self.scrollView.contentInset = .zero
        self.scrollView.frame = self.bounds
        setScrollViewContentSize()
        
        var size = CGSize.zero
        if self.pageControl is SFPageControl {
            let pageControl = self.pageControl as! SFPageControl
            size = pageControl.animatedPageSize()
        } else if self.pageControl is SFSliderPageControl {
            let pageControl = self.pageControl as! SFSliderPageControl
            size = pageControl.sliderPageSize()
        } else if self.pageControl is UIPageControl {
            let pageControl = self.pageControl as! UIPageControl
            size = pageControl.size(forNumberOfPages: self.viewArray.count)
            size.height = self.pageControlDotSize.height
        }
        var x = (self.bounds.size.width - size.width) * 0.5
        if self.pageControlAliment == .right {
            x = self.frame.size.width - size.width - 10
        } else if self.pageControlAliment == .left {
            x = 10
        }
        let y = self.frame.size.height - 10
        var pageControlFrame = CGRect(x: x, y: y, width: size.width, height: size.height)
        pageControlFrame.origin.x -= self.pageOffset.x
        pageControlFrame.origin.y -= self.pageOffset.y
        self.pageControl?.frame = pageControlFrame
        self.pageControl?.isHidden = !self.showPageControl
    }
    
    private func setViewForArray() {
        setupPageControl()
        if self.currIndex >= self.viewArray.count {
            self.currIndex = self.viewArray.count - 1
        }
        replaceView(backView: self.currView, addView: self.viewArray[self.currIndex])
        layoutAllViews()
    }
    
    private func setScrollViewContentSize() {
        if self.viewArray.count > 1 {
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * 5.0, height: 0)
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width * 2.0, y: 0)
            self.currView.frame = CGRect(x: self.scrollView.frame.size.width * 2, y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)
            if self.changeMode == .fade {
                self.currView.frame = CGRect(x: 0, y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)
                self.otherView.frame = self.currView.frame
                self.otherView.alpha = 0
                self.insertSubview(self.currView, at: 0)
                self.insertSubview(self.otherView, at: 1)
            }
            startTimer()
        } else {
            self.scrollView.contentSize = .zero
            self.scrollView.contentOffset = .zero
            self.currView.frame = CGRect(x: 0, y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)
            stopTimer()
        }
    }
    
    private func changeCurrentPage(offsetX: CGFloat) {
        if offsetX < self.scrollView.frame.size.width * 1.5 {
            var index = self.currIndex - 1
            if index < 0 {
                index = self.viewArray.count - 1
            }
            changeCurrentPage(currentIndex: index)
        } else if offsetX > self.scrollView.frame.size.width * 2.5 {
            changeCurrentPage(currentIndex: (self.currIndex + 1) % self.viewArray.count)
        } else {
            changeCurrentPage(currentIndex: self.currIndex)
        }
    }
    
    private func changeToNext() {
        if self.changeMode == .fade {
            self.currView.alpha = 1
            self.otherView.alpha = 0
        }
        
        replaceView(backView: self.currView, addView: getShowView(backView: self.otherView))
        self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width * 2.0, y: 0.0)
        self.scrollView.layoutSubviews()
        self.currIndex = self.nextIndex
        self.changeCurrentPage(currentIndex: self.currIndex)
    }
    @objc func nextPage() {
        if self.changeMode == .fade {
            self.nextIndex = (self.currIndex + 1) % self.viewArray.count
            replaceView(backView: self.otherView, addView: self.viewArray[self.nextIndex])
            UIView.animate(withDuration: 0.9) {
                self.currView.alpha = 0
                self.otherView.alpha = 1
                self.currIndex = self.nextIndex
                self.changeCurrentPage(currentIndex: self.currIndex)
            } completion: { _ in
                self.currView.alpha = 1
                self.otherView.alpha = 0
                self.replaceView(backView: self.currView, addView: self.getShowView(backView: self.otherView))
                self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width * 2.0, y: 0.0)
                self.scrollView.layoutSubviews()
            }
        } else {
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.size.width * 3, y: 0), animated: true)
        }
    }
    
    @objc func imageClick() {
        self.delegate?.tap(self.currIndex)
    }
    // TODO: 设置PageControl
    private func setupPageControl() {
        self.pageControl?.removeFromSuperview()
        if (self.viewArray.count == 1 && self.hidesForSinglePage == true) || self.showPageControl == false {
            return
        }
        let indexOnPageControl = 0
        switch self.pageControlStyle {
            case .classic:
                let pageControl = UIPageControl()
                pageControl.numberOfPages = self.viewArray.count
                pageControl.currentPageIndicatorTintColor = self.currentPageDotColor
                pageControl.pageIndicatorTintColor = self.pageDotColor
                pageControl.isUserInteractionEnabled = false
                pageControl.currentPage = indexOnPageControl
                self.addSubview(pageControl)
                self.pageControl = pageControl
            case .animated:
                let pageControl = SFPageControl()
                pageControl.numberOfPages = self.viewArray.count
                pageControl.dotColor = self.currentPageDotColor
                pageControl.isUserInteractionEnabled = false
                pageControl.dotSize = pageControlDotSize
                if self.currentPageDotImage != nil {
                    pageControl.currentDotImage = currentPageDotImage
                }
                if self.pageDotImage != nil {
                    pageControl.dotImage = pageDotImage
                }
                pageControl.updateFrame()
                pageControl.currentPage = indexOnPageControl
                self.addSubview(pageControl)
                self.pageControl = pageControl
            case .horizontal:
                let pageControl = SFSliderPageControl()
                pageControl.pages = self.viewArray.count
                pageControl.currentPageColor = self.currentPageDotColor
                pageControl.normalPageColor = self.pageDotColor
                pageControl.isUserInteractionEnabled = false
                pageControl.startPage = indexOnPageControl
                pageControl.dotNomalSize = pageControlDotSize
                pageControl.dotBigSize = CGSize(width: pageControlDotSize.width * 2, height: pageControlDotSize.height)
                pageControl.updateColor()
                self.addSubview(pageControl)
                self.pageControl = pageControl
            
        default:
            break
        }
    }
    
    private func changeCurrentPage(currentIndex: Int) {
        if self.pageControl is SFPageControl {
            let pageControl = self.pageControl as! SFPageControl
            pageControl.currentPage = currentIndex
        } else if self.pageControl is SFSliderPageControl {
            let pageControl = self.pageControl as! SFSliderPageControl
            pageControl.currentPage = currentIndex
        } else if self.pageControl is UIPageControl {
            let pageControl = self.pageControl as! UIPageControl
            pageControl.currentPage = currentIndex
        }
    }
    
    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize == CGSize.zero {
            return
        }
        let offsetX = scrollView.contentOffset.x
        changeCurrentPage(offsetX: offsetX)
        
        if offsetX < self.scrollView.frame.size.width * 2 {
            if self.changeMode == .fade {
                self.currView.alpha = offsetX / self.scrollView.frame.size.width - 1
                self.otherView.alpha = 2 - offsetX / self.scrollView.frame.size.width
            } else {
                self.otherView.frame = CGRect(x: self.scrollView.frame.size.width, y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)
            }
            
            self.nextIndex = self.currIndex - 1
            if self.nextIndex < 0 {
                self.nextIndex = self.viewArray.count - 1
            }
            replaceView(backView: self.otherView, addView: self.viewArray[self.nextIndex])
            if offsetX <= self.scrollView.frame.size.width {
                changeToNext()
            }
        } else if offsetX > self.scrollView.frame.size.width * 2 {
            if self.changeMode == .fade {
                self.otherView.alpha = offsetX / self.scrollView.frame.size.width - 2
                self.currView.alpha = 3 - offsetX / self.scrollView.frame.size.width
            } else {
                self.otherView.frame = CGRect(x: self.currView.frame.origin.x + self.currView.frame.size.width, y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)
            }
            self.nextIndex = (self.currIndex + 1) % self.viewArray.count
            replaceView(backView: self.otherView, addView: self.viewArray[self.nextIndex])
            if offsetX >= self.scrollView.frame.size.width * 3 {
                changeToNext()
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if self.viewArray.count == 0 {
            return
        }
        self.delegate?.loop(self.currIndex)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.changeMode == .fade {
            return
        }
        let currPointInSelf = scrollView.convert(self.currView.frame.origin, to: self)
        if currPointInSelf.x >= -self.scrollView.frame.size.width / 2 && currPointInSelf.x <= self.scrollView.frame.size.width / 2 {
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.size.width * 2, y: 0), animated: true)
        } else {
            changeToNext()
        }
    }
    // MARK: - 定时器
    public func startTimer() {
        if self.viewArray.count <= 1 {
            return
        }
        stopTimer()
        self.timer = Timer.scheduledTimer(timeInterval: (self.time > 1.0 ? self.time : 5.0), target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
    }
    
    public func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    deinit {
        stopTimer()
    }
    
}
