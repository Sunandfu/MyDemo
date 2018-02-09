# RSPageControl
一个自定义的pageControl，可以将默认的小圆点换成图片，并设置其间距；可以响应小圆点的点击事件...

##效果图
![Mou icon](https://github.com/riversea2015/RSPageControl/blob/master/pageControl_1.png?raw=true)
![Mou icon](https://github.com/riversea2015/RSPageControl/blob/master/pageControl_3.gif?raw=true)

## 使用方法

将RSPageControl.h和RSPageControl.m 2个文件导入工程，在需要用到pageControl的控制器中导入头文件：
```objective-c
#import "RSPageControl.h"
```

如果需要响应小圆点的点击事件，需遵守协议：
```objective-c
RSPageControlDelegate
```

1.创建pageControl
```objective-c
    RSPageControl *pageControl = [[RSPageControl alloc] initWithFrame:CGRectMake(pX, pY, pWidth, pHeight) normalImage:[UIImage imageNamed:@"choice_carousel_default"] highlightedImage:[UIImage imageNamed:@"choice_carousel_current"] dotsNumber:4 dotLength:12 dotHeight:5 dotGap:30];
    pageControl.delegate = self; // 需要响应touch事件时，加上这一行
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
```

2.需要切换选中的小圆点时，给currentPage赋值(带注释的那一行)
```objective-c
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    NSInteger index = round(point.x/scrollView.frame.size.width);
    
    [self.pageControl setCurrentPage:index]; // 设置当前对应的圆点
}
```

3.点击小圆点时，执行此代理方法 - (void)rs_pageControlDidStopAtIndex:
```objective-c
- (void)rs_pageControlDidStopAtIndex:(NSInteger)index {
    NSLog(@"index:%ld", index);
    
    // 以下为切换图片的方法(由使用者自定义)
    CGFloat height = _scrollView.frame.size.height;
    CGFloat width = _scrollView.frame.size.width;
    CGFloat originX = _scrollView.frame.size.width*index;
    CGFloat originY = 0;
    
    CGRect rect = CGRectMake(originX, originY, width, height);
    
    [_scrollView scrollRectToVisible:rect animated:NO];
}
```
##作者信息：

he hai, hehai682@126.com

##License：

RSPageControl is available under the MIT license. See the LICENSE file for more info.
