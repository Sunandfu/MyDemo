//
//  ViewController.swift
//  SwiftRunLoop
//
//  Created by lurich on 2022/1/18.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let loopView = SFRunLoopView.init(frame: CGRect(x: 10, y: 100, width: self.view.frame.size.width - 20, height: 150))
        loopView.pageControlStyle = .animated
        loopView.currentPageDotImage = UIImage.init(named: "pageControlCurrentDot")
        loopView.pageDotImage = UIImage.init(named: "pageControlDot")
        self.view.addSubview(loopView)
        
        let imgArr = [
            "https://t7.baidu.com/it/u=963301259,1982396977&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=737555197,308540855&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=1297102096,3476971300&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=3655946603,4193416998&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=12235476,3874255656&fm=193&f=GIF",
        ]
        let views = loopView.getImageViews(imgArr, bounds: loopView.bounds)
        loopView.reloadViews(views)
        
        
    }


}

