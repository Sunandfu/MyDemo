# SwiftRunLoop
一款功能强大的轮播视图的工具
添加轮播试图后
```
let loopView = SFRunLoopView.init(frame: CGRect(x: 10, y: 100, width: self.view.frame.size.width - 20, height: 150))
self.view.addSubview(loopView)
```

一行代码便可实现视图轮播
```
let imgArr = [
            "https://t7.baidu.com/it/u=963301259,1982396977&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=737555197,308540855&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=1297102096,3476971300&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=3655946603,4193416998&fm=193&f=GIF",
            "https://t7.baidu.com/it/u=12235476,3874255656&fm=193&f=GIF",
        ]
loopView.reloadViews(loopView.getImageViews(imgArr, bounds: loopView.bounds))
```

支持多种pageControl样式

![IMG_0046.jpg](https://upload-images.jianshu.io/upload_images/12555132-b97f81c4433a9f44.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![IMG_0045.jpg](https://upload-images.jianshu.io/upload_images/12555132-b25fdeddae165906.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![IMG_0044.jpg](https://upload-images.jianshu.io/upload_images/12555132-9c6e2d8b86b52377.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



还可支持图片样式
```
loopView.pageControlStyle = .animated
loopView.currentPageDotImage = UIImage.init(named: "pageControlCurrentDot")
loopView.pageDotImage = UIImage.init(named: "pageControlDot")
```
![IMG_0043.jpg](https://upload-images.jianshu.io/upload_images/12555132-1e3efb49d54dfcbc.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


