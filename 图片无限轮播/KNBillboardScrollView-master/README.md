
# KNBillboardScrollView     如果能帮助到你。 是我的荣幸。 ～ 请给我点一个星星哦～    感谢各位

### 这是一个广告栏。实现无限循环播放图片，获取网络图片，实现本地存储。 接入了YYimage这个第三方库解决播放gif内存爆表的问题  


----
## 上一张效果图

![](https://github.com/krystalName/KNBillboardScrollView/blob/master/billboardView.gif)

## 讲解一点点实现说明. (需要了解详情。 请下载代码到本地观看)
-----
+ 首先。感谢YYImage 这个库。 解决了我使用gif 占用过多内存的问题!
1. 做无限循环播放的话。需要一个scrollView. 和uiimageView,还有pageControll
2. 只放两张图片。滑动的时候。更换图片。这样性能上面更佳优化。从而达到更佳的体验效果
3. 没有网络的时候。首先我会将一张占位图放到里面。做默认显示
4. 没有设置titls 的时候。我会隐藏下面的图片说明。
5. 如果图片总数为1张的时候。 pageControll我会设置为隐藏 
6. 如果标签总数比图片总数少的时候。我会设置空字符串。
7. 使用队列下载图片。保证广告栏使用的流畅性
8. 获取到网络图片。是一个NSSTRING 类型。转换成data类型。再转换成YYImage. 保存到本地文件夹。下次进来直接从文件夹中找。 当url不同时候。重新下载
缓存默认是打开的。 可以设置关闭。 （不过每次都要下载。 所以建议打开缓存）
----

## -------- 使用说明(可以用pod导入本组件) ----------

```ruby
pod 'KNSlidingView'
```

+ 获取本地图片的时候。 使用[YYImage imageNamed:@""] 作为创建数组的参数

## 使用代码
----- 
``` objc

  //定义两个数组。
    NSArray *imageArray = @[
                             [YYImage imageNamed:@"3.jpg"],
                            @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510747788301&di=1265b6a44927172a90f3bebcf088ab02&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F5243fbf2b2119313373b1edd6f380cd791238d67.jpg",
                             [YYImage imageNamed:@"2.gif"],
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510747412310&di=308b1b2e2d6ccb6a35796275fc185eaf&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01f90e593a4ad4a8012193a3dcf03d.gif"
                            ];
    
    NSArray *descArray = @[@"本地看星星",@"网络图片",@"本地gif图片",@"网络gif图片"];
    
    
    //创建广告栏
    _bollboadrView = [[KNBillboadrView alloc]initKNBillboadrViewWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 200) andImageArray:imageArray andDescArray:descArray andplaceholdImage:[UIImage imageNamed:@"KNBilboardDefalutImge.png"]];
    
    [_bollboadrView setPageColor:[UIColor redColor] andCurrentPageColor:[UIColor whiteColor]];
    //设置代理
    _bollboadrView.delegate = self;
    //设置分页控件的位置，默认为PositionBottomCenter
    _bollboadrView.KNPageCotrollPostion = KNPostionBottomLeft;
    //设置动画
    _bollboadrView.KNChangeMode = KNChangeModeFade;
    
    // 设置滑动时gif停止播放
    _bollboadrView.gifPlayMode = KNGifPlayModePauseWhenScroll;
    
    [self.view addSubview:_bollboadrView];
    
```
-----

## 第二种使用方式

``` objc
 //第二种方式创建广告栏。 图片数据暂时没有的情况下
  
    _bollboadrView = [[KNBillboadrView alloc]initKNBillboadrViewWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 200) andplaceholdImage:[UIImage imageNamed:@"KNBilboardDefalutImge.png"]];
     
       [_bollboadrView setBackgroundColor:[UIColor grayColor]];
    
    //设置代理
    _bollboadrView.delegate = self;
    _bollboadrView.KNPageCotrollPostion = KNPostionBottomLeft;
    [_bollboadrView setPageImage:[UIImage imageNamed:@"4"] andCurrentPageImage:[UIImage imageNamed:@"5"]];
    _bollboadrView.time = 5.f;
    
    // 设置滑动时gif停止播放
    _bollboadrView.gifPlayMode = KNGifPlayModePauseWhenScroll;
    
    [self.view addSubview:_bollboadrView];
    
    
    ///在获取到数据之后调用
     [_bollboadrView setImageArray:imageArray andDescArray:descArray];
     
```

